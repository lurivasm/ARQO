--------------------------------------------------------------------------------
-- Procesador MIPS segmentado curso Arquitectura 2018-19
-- Autores: Lucía Rivas Molina y Daniel Santo-Tomás
-- Asignatura: Arquitectura
-- Grupo de Prácticas:1312
-- Grupo de Teoría: 310
-- Práctica: 1
-- Ejercicio: 2
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
   port(
      Clk         : in  std_logic; -- Reloj activo flanco subida
      Reset       : in  std_logic; -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr      : out std_logic_vector(31 downto 0); -- Direccion
      IDataIn    : in  std_logic_vector(31 downto 0); -- Dato leido
      -- Data memory
      DAddr      : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn      : out std_logic;                     -- Habilitacion lectura
      DWrEn      : out std_logic;                     -- Habilitacion escritura
      DDataOut   : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn    : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processor;

architecture rtl of processor is 

  component alu
     port (
      OpA     : in  std_logic_vector (31 downto 0); -- Operando A
      OpB     : in  std_logic_vector (31 downto 0); -- Operando B
      Control : in  std_logic_vector ( 3 downto 0); -- Codigo de control=op. a ejecutar
      Result  : out std_logic_vector (31 downto 0); -- Resultado
      ZFlag   : out std_logic                       -- Flag Z
   );
  end component;
  
  component reg_bank
    port (
      Clk   : in std_logic; -- Reloj activo en flanco de subida
      Reset : in std_logic; -- Reset asíncrono a nivel alto
      A1    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Rd1
      Rd1   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd1
      A2    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Rd2
      Rd2   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd2
      A3    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Wd3
      Wd3   : in std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
      We3   : in std_logic -- Habilitación de la escritura de Wd3
   ); 
  end component;
  
  component control_unit
    port (
      -- Entrada = codigo de operacion en la instruccion:
      OpCode  : in  std_logic_vector (5 downto 0);
      Funct : in std_logic_vector (5 downto 0);
      -- Seniales para el PC
      Branch : out  std_logic; -- 1=Ejecutandose instruccion branch
      Jump : out std_logic;   -- 1=Ejecutandose instruccion jump
      -- Seniales relativas a la memoria
      MemToReg : out  std_logic; -- 1=Escribir en registro la salida de la mem.
      MemWrite : out  std_logic; -- Escribir la memoria
      MemRead  : out  std_logic; -- Leer la memoria
      -- Seniales para la ALU
      ALUSrc : out  std_logic;                     -- 0=oper.B es registro, 1=es valor inm.
      ALUControl  : out  std_logic_vector (3 downto 0); -- Tipo operacion para control de la ALU
      -- Seniales para el GPR
      RegWrite : out  std_logic; -- 1=Escribir registro
      RegDst   : out  std_logic  -- 0=Reg. destino es rt, 1=rd
   );
  end component;

--Señales para instanciar la ALU
  signal aluMux : std_logic_vector(31 downto 0);  -- Salida del Multiplexor que determina que entra en op2 en la alu
  signal aluControlAUX : std_logic_vector(3 downto 0);  -- Señal auxiliar para la alu control
  signal aluOut :  std_logic_vector(31 downto 0); --Señal auxiliar para la salida de la alu
  signal ZAUX : std_logic ;  --Señal auxiliar para la bandera Z
  
--Señales para instanciar el banco de registros
  signal regMux : std_logic_vector(4 downto 0);  -- Salida del Multiplexor que determina qué entra en A3 en el banco de registros
  signal rd1AUX : std_logic_vector(31 downto 0);  --Señal auxiliar para la salida del registro 1 del banco de registros
  signal rd2AUX : std_logic_vector(31 downto 0);  --Señal auxiliar para la salida del registro 2 del banco de registros
  signal writedAUX : std_logic_vector(31 downto 0);  --Señal auxiliar para la entrada de datos del banco de registros
  
--Señales para instanciar la unidad de control
  signal regWriteAUX, branchAUX, JumpAUX, MemToRegAUX, MemWriteAUX, MemReadAUX, AluSrcAUX, RegDstAUX : std_logic ;
  
--Señal para el PC
  signal PCAUX : std_logic_vector(31 downto 0);
  signal s1, s2 : std_logic_vector(31 downto 0);	--Salidas de los multiplexores de las distintas opciones del pc
  signal extSigno : std_logic_vector(31 downto 0);   --Señal para la extension de signo del dato inmediato en el branch
  signal PCWrite : std_logic;     --Enable para la escritura del PC

--Señales para el registro IF/ID(a partir de ahora, registro 1)
  signal PC4_1,Inst1 : std_logic_vector(31 downto 0); 
  signal Write1 : std_logic;      --Enable de la actualización del registro

--Señales para el registro ID/EX(a partir de ahora, registro 2)
  signal RegWrite2,MemToReg2,Branch2,MemRead2,MemWrite2,RegDst2,AluSrc2 : std_logic;
  signal AluControl2 : std_logic_vector(3 downto 0);
  signal PC4_2,R1_2,R2_2,sigext2 : std_logic_vector(31 downto 0);
  signal Irs2, Irt2,Ird2: std_logic_vector(4 downto 0);

--Señales para el registro EX/MEM (a partir de ahora, registro 3)
  signal RegWrite3,MemToReg3,Branch3,MemRead3,MemWrite3 ,zero3: std_logic;
  signal BranchAdd3,aluout3,R2_3 : std_logic_vector(31 downto 0);
  signal R3_3 : std_logic_vector(4 downto 0);

--Señales para el registro MEM/WB(a partir de ahora, registro 4)
  signal RegWrite4, MemToReg4 : std_logic;
  signal MemData4,aluout4 : std_logic_vector(31 downto 0);
  signal R3_4 : std_logic_vector(4 downto 0);
  
--Señales para la unidad de Anticipación
  signal AnticiparA, AnticiparB : std_logic_vector(1 downto 0);
  signal muxA, muxB : std_logic_vector(31 downto 0);
  
--Señales para la unidad de detención de Riesgos
  signal nopcreator : std_logic;    --Señal que determina cuando hay que generar una burbuja en el procesador

--Señales para el correcto funcionamiento del branch
  signal ResetBr : std_logic; 

begin   
  u1 : alu port map (OpA => muxA, OpB => aluMux , Control => AluControl2,
                    Result => aluOut, ZFlag => ZAUX);
  
  u2 : reg_bank port map (Clk => Clk, Reset => Reset, A1 => Inst1(25 downto 21),
                          A2 => Inst1(20 downto 16), A3 => R3_4, Rd1 => rd1AUX,
                          Rd2 => rd2AUX, Wd3 => writedAUX, We3 => regWrite4);
                          
  u3 : control_unit port map (OpCode => Inst1(31 downto 26), Funct => Inst1(5 downto 0),
                              Branch => branchAUX, Jump => JumpAUX, MemToReg => MemToRegAUX,
                              MemWrite => MemWriteAUX, MemRead => MemReadAUX, ALUSrc => AluSrcAUX,
                              ALUControl => aluControlAUX, RegWrite => RegWriteAUX, RegDst => RegDstAUX);
  
--Implementamos los procesos que actualizan los registros en los sucesivos ciclos
--Registro IF/ID
process(Clk,Reset,Write1)
	begin
		if (Reset = '1') or (ResetBr = '1' and rising_edge(Clk)) then
			PC4_1 <= "00000000000000000000000000000000";
			Inst1 <= "00000000000000000000000000000000";
		elsif (Write1 = '1') and rising_edge(Clk) then 
			PC4_1 <= PCAUX +4;
			Inst1 <= IDataIn;
		else 
		  PC4_1 <= PC4_1;
			Inst1 <= Inst1;
		end if;
	end process;

--Registro ID/EX
process(Clk,Reset,nopcreator)
	begin
		if (Reset = '1') or (ResetBr = '1' and rising_edge(Clk)) then
			RegWrite2 <= '0';
			MemToReg2 <= '0';
			Branch2 <= '0';
			MemRead2 <= '0';
			MemWrite2 <= '0';
			RegDst2 <= '0';
			AluSrc2 <= '0';
			AluControl2 <= "0000";
			Irs2 <= "00000";
			Irt2 <= "00000";
			Ird2 <= "00000";
			PC4_2 <= "00000000000000000000000000000000";
			R1_2 <= "00000000000000000000000000000000";
			R2_2 <= "00000000000000000000000000000000";
			sigext2 <= "00000000000000000000000000000000";

		elsif (nopcreator = '1') and rising_edge(Clk) then 
			RegWrite2 <= '0';
			MemToReg2 <= '0';
			Branch2 <= '0';
			MemRead2 <= '0';
			MemWrite2 <= '0';
			RegDst2 <= '0';
			AluSrc2 <= '0';
			AluControl2 <= "0000";
			Irs2 <= Inst1(25 downto 21);
			Irt2 <= Inst1(20 downto 16);
			Ird2 <= Inst1(15 downto 11);
			PC4_2 <= PC4_1;
			R1_2 <= rd1AUX;
			R2_2 <= rd2AUX;
			sigext2 <= extSigno;
			
		elsif (nopcreator = '0') and rising_edge(Clk) then
		  RegWrite2 <= RegWriteAUX;
			MemToReg2 <= MemToRegAUX;
			Branch2 <= BranchAUX;
			MemRead2 <= MemReadAUX;
			MemWrite2 <= MemWriteAUX;
			RegDst2 <= RegDstAUX;
			AluSrc2 <= AluSrcAUX;
			AluControl2 <= aluControlAUX;
			Irs2 <= Inst1(25 downto 21);
			Irt2 <= Inst1(20 downto 16);
			Ird2 <= Inst1(15 downto 11);
			PC4_2 <= PC4_1;
			R1_2 <= rd1AUX;
			R2_2 <= rd2AUX;
			sigext2 <= extSigno;
		end if;
	end process;

--Registro EX/MEM 

process(Clk,Reset)
	begin
		if (Reset = '1') or (ResetBr = '1' and rising_edge(Clk)) then
			RegWrite3 <= '0';
			MemToReg3 <= '0';
			Branch3 <= '0';
			MemRead3 <= '0';
			MemWrite3 <= '0';
			zero3 <= '0';
			BranchAdd3 <= "00000000000000000000000000000000";
			R2_3 <= "00000000000000000000000000000000";
			R3_3 <= "00000";
			aluout3 <= "00000000000000000000000000000000";

		elsif rising_edge(Clk) then 
			RegWrite3 <= RegWrite2;
			MemToReg3 <= MemToReg2;
			Branch3 <= Branch2;
			MemRead3 <= MemRead2;
			MemWrite3 <= MemWrite2;
			zero3 <= ZAUX;
			BranchAdd3 <= (sigext2(29 downto 0) & "00") + PC4_2;
			R2_3 <= muxB;
			R3_3 <= regMux;
			aluout3 <= aluOut;
		end if;
	end process;

--Registro MEM/WB

process(Clk,Reset)
	begin
		if Reset = '1' then
			RegWrite4 <= '0';
			MemToReg4 <= '0';
			MemData4 <= "00000000000000000000000000000000";
			aluout4 <= "00000000000000000000000000000000";
			R3_4 <= "00000";
		elsif rising_edge(Clk) then 
			RegWrite4 <= RegWrite3;
			MemToReg4 <= MemToReg3;
			MemData4 <= DDataIn;
			aluout4 <= aluout3;
			R3_4 <= R3_3;
		end if;
	end process;
	
	--Unidad de anticipación
	process(RegWrite3, RegWrite4, R3_3, R3_4, Irs2, Irt2)
	  begin 
	     if ((RegWrite3 = '1') and (R3_3 /= 0) and (R3_3 = Irs2)) then
	       AnticiparA <= "10";
	     elsif ((RegWrite4 = '1') and (R3_4 /= 0) and (R3_4 = Irs2)) then
         AnticiparA <= "01"; 
       else 
        AnticiparA <= "00"; 
       end if;
	     
	     if ((RegWrite3 = '1') and (R3_3 /= 0) and (R3_3 = Irt2)) then
         AnticiparB <= "10"; 
       elsif ((RegWrite4 = '1') and (R3_4 /= 0) and (R3_4 = Irt2)) then
         AnticiparB <= "01"; 
       else 
        AnticiparB <= "00";
       end if;       
       
end process; 

--Unidad de detección de riesgos 
process(MemRead2,Irt2,Inst1)
  begin
    if ((MemRead2 = '1') and ((Irt2 = Inst1(25 downto 21)) or (Irt2 = Inst1(20 downto 16)))) then 
      PCWrite <= '0';
      Write1 <= '0';
      nopcreator <= '1';
   else 
      PCWrite <= '1';
      Write1 <= '1';
      nopcreator <= '0';
  end if;
end process;

--Implementamos las mejoras para el branch
  with (Branch3 and zero3) select
    ResetBr <= '1' when '1',
      '0' when others;
  
  --Implementamos el PC, con sus posibles salidas

  with Inst1(15) select												--Hacemos la extension de signo, utilizada en el branch y en instruciiones con dato inmediato  
			extSigno <= "0000000000000000" & Inst1(15 downto 0)  when '0',	     
						"1111111111111111" & Inst1(15 downto 0)  when others;


  with (Branch3 and zero3) select						--Si hay un branch,la direccion es la suma del PC + 4 con el dato dado
			s1 <= BranchAdd3 when '1',
			      PCAUX + 4 when others;

  with (JumpAUX) select
		s2 <= PC4_1(31 downto 28) & Inst1(25 downto 0) & "00" when '1',
			s1 when others;  
  		

  process(Clk,Reset)						--Proceso para  la implementacion del PC, con el reset activo a nivel alto
	begin
		if Reset = '1' then
			PCAUX <= "00000000000000000000000000000000";
		elsif (PCWrite = '1') and rising_edge(Clk) then 
			PCAUX <= s2;
		else 
		  PCAUX <= PCAUX;
		end if;
	end process;

  IAddr <= PCAUX;

 --Implementamos las salidas para la memoria de datos
 
 DAddr <= aluOut3;
 DRdEn <= MemRead3;
 DWrEn <= MemWrite3;
 DDataOut <= R2_3;

 --Implementamos el multiplexor del banco de registros

  with RegDst2 select
	  regMux <= Irt2 when '0',
	 	Ird2 when others;		
  		
 --Implementamos el multiplexor de la ALU
  
  with AluSrc2 select
	  aluMux <= muxB when '0',	
		sigext2 when others;
		
 --Multiplexor de AnticiparB para la ALU
  with AnticiparB select
    muxB <= R2_2 when "00",
            aluout3 when "10",
            writedAUX when others;
    
 --Multiplexor de AnticiparA para la ALU
  with AnticiparA select
    muxA <= R1_2 when "00",
            aluout3 when "10",
            writedAUX when others;
    
    
 	 
 --Implementamos el multiplexor de los datos a escribir en el banco de registros
 
  with MemToReg4 select
	  writedAUX <= MemData4 when '1',
		aluOut4 when others;
			
		

end architecture;
