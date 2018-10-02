--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2018-19
-- Fecha �ltima modificaci�n:
-- Autores: Luc�a Rivas Molina y Daniel Santo-Tom�s
-- Asignatura: Arquitectura
-- Grupo de Pr�cticas: 3112
-- Grupo de Teor�a: 310
-- Pr�ctica: 1
-- Ejercicio: 1
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
      Reset : in std_logic; -- Reset as�ncrono a nivel alto
      A1    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd1
      Rd1   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd1
      A2    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd2
      Rd2   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd2
      A3    : in std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Wd3
      Wd3   : in std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
      We3   : in std_logic -- Habilitaci�n de la escritura de Wd3
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

--Se�ales para instanciar la ALU
  signal aluMux : std_logic_vector(31 downto 0);  -- Salida del Multiplexor que determina que entra en op2 en la alu
  signal aluControlAUX : std_logic_vector(3 downto 0);  -- Se�al auxiliar para la alu control
  signal aluOut :  std_logic_vector(31 downto 0); --Se�al auxiliar para la salida de la alu
  signal ZAUX : std_logic ;  --Se�al auxiliar para la bandera Z
  
--Se�ales para instanciar el banco de registros
  signal regMux : std_logic_vector(4 downto 0);  -- Salida del Multiplexor que determina qu� entra en A3 en el banco de registros
  signal rd1AUX : std_logic_vector(31 downto 0);  --Se�al auxiliar para la salida del registro 1 del banco de registros
  signal rd2AUX : std_logic_vector(31 downto 0);  --Se�al auxiliar para la salida del registro 2 del banco de registros
  signal writedAUX : std_logic_vector(31 downto 0);  --Se�al auxiliar para la entrada de datos del banco de registros
  
--Se�ales para instanciar la unidad de control
  signal regWriteAUX, branchAUX, JumpAUX, MemToRegAUX, MemWriteAUX, MemReadAUX, AluSrcAUX, RegDstAUX : std_logic ;
  
--Se�al para el PC
  signal PCres,PCAUX : std_logic_vector(31 downto 0);
  signal extSigno : std_logic_vector(31 downto 0);   --Se�al para la extension de signo del dato inmediato en el branch

begin   
  u1 : alu port map (OpA => rd1AUX, OpB => aluMux , Control => aluControlAUX,
                    Result => aluOut, ZFlag => ZAUX);
  
  u2 : reg_bank port map (Clk => Clk, Reset => Reset, A1 => IDataIn(25 downto 21),
                          A2 => IDataIn(20 downto 16), A3 => regMux, Rd1 => rd1AUX,
                          Rd2 => rd2AUX, Wd3 => writedAUX, We3 => regWriteAUX);
                          
  u3 : control_unit port map (OpCode => IDataIn(31 downto 26), Funct => IDataIn(5 downto 0),
                              Branch => branchAUX, Jump => JumpAUX, MemToReg => MemToRegAUX,
                              MemWrite => MemWriteAUX, MemRead => MemReadAUX, ALUSrc => AluSrcAUX,
                              ALUControl => aluControlAUX, RegWrite => RegWriteAUX, RegDst => RegDstAUX);
  
  --Implementamos el PC, con sus posibles salidas

  with IDataIn(15) select												--Hacemos la extension de signo, utilizada en el branch y en instruciiones con dato inmediato  
			extSigno <= "0000000000000000" & IDataIn(15 downto 0)  when '0',	     
						"1111111111111111" & IDataIn(15 downto 0)  when others;

  process(JumpAUX,branchAUX,ZAUX)
	begin
  		if JumpAUX = '1' then							-- Si hay un jump, la direccion es la dada por la instruccion
    			PCres <= PCAUX(31 downto 28) & IDataIn(25 downto 0) & "00";

  		elsif (branchAUX = '1') and (ZAUX = '1') then					--Si hay un branch,la direccion es la suma del PC + 4 con el dato dado
			PCres <= (extSigno(29 downto 0) & "00") + (PCAUX + 4);
  
  		else PCres <= PCAUX + 4;
  		end if;
	end process;

  process(Clk,Reset)
	begin
		if Reset = '1' then
			PCAUX <= "00000000000000000000000000000000";
		elsif rising_edge(Clk) then 
			PCAUX <= PCres;
		end if;
	end process;

  IAddr <= PCAUX;

 --Implementamos las salidas para la memoria de datos
 
 DAddr <= aluOut;
 DRdEn <= MemReadAUX;
 DWrEn <= MemWriteAUX;
 DDataOut <= rd2AUX;

 --Implementamos el multiplexor del banco de registros

  process(RegDstAUX)
	begin
  		if RegDstAUX = '0' then
			regMux <= IDataIn(20 downto 16);
  		else regMux <= IDataIn(15 downto 11);
  		end if;
  	end process;

 --Implementamos el multiplexor de la ALU
  
  process(ALUSrcAUX)
	begin
  		if ALUSrcAUX = '0' then
			aluMux <= rd2AUX;
 		else aluMux <= extSigno;
  		end if;
	end process;
 
 --Implementamos el multiplexor de los datos a escribir en el banco de registros
 
 process(MemToRegAUX)
	begin
		if MemToRegAUX = '1' then
			writedAUX <= DDataIn;
		else writedAUX <= aluOut;
		end if;
	end process;


end architecture;
