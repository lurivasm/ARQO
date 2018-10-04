----------------------------------------------------------------------
-- Fichero: MicroMIPS.vhd
-- Descripción: Microprocesador final instanciado con sus distintas partes
-- Fecha última modificación: 26/04/2017

-- Autores: Lucía Rivas Molina y Daniel Santo-Tomás
-- Asignatura: E.C. 1º doble grado
-- Grupo de Prácticas: 2102
-- Grupo de Teoría: 210
-- Práctica: 5
-- Ejercicio: 3
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity MicroMips is
	port (
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset activo a nivel bajo
		MemProgAddr : out std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
		MemProgData : in std_logic_vector(31 downto 0); -- Código de operación
		MemDataAddr : out std_logic_vector(31 downto 0); -- Dirección para la memoria de datos
		MemDataDataRead : in std_logic_vector(31 downto 0); -- Dato a leer en la memoria de datos
		MemDataDataWrite : out std_logic_vector(31 downto 0); -- Dato a guardar en la memoria de datos
		MemDataWE : out std_logic
	);
end MicroMIPS;


architecture arc of MicroMIPS is

	component ALUMips 
		port (
		Op1 : in std_logic_vector (31 downto 0);	--Operador 1
		Op2 : in std_logic_vector (31 downto 0);	--Operador 2
		ALUControl : in std_logic_vector (2 downto 0);		--Entrada de control	
		Res : out std_logic_vector (31 downto 0);		--Salida con el resultado de la operación
		Z : out std_logic		--Bandera Z,se pone a 1 si el resultado es 0
		);
	end component;
	
	component RegsMIPS 
		port ( 
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset asíncrono a nivel bajo
		Wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada a escribir
		A1 : in std_logic_vector(4  downto 0); -- Dirección de lectura 1
		A2 : in std_logic_vector(4 downto 0); -- Dirección de lectura 2
		A3 : in std_logic_vector(4 downto 0); -- Dirección de escritura
		We3 : in std_logic ; --Señal de habilitación de la escritura
		Rd1 : out std_logic_vector(31 downto 0); -- Salida de lectura 1
		Rd2 : out std_logic_vector(31 downto 0) -- Salida de lectura 2
	); 
	end component;
	
	component UnidadControl 
		port(
			OPCode : in  std_logic_vector (5 downto 0); -- OPCode de la instrucción
			Funct : in std_logic_vector(5 downto 0); -- Funct de la instrucción
			
			-- Señales para el PC
			Jump : out  std_logic;
			RegToPC : out std_logic;
			Branch : out  std_logic;
			PCToReg : out std_logic;
			
			-- Señales para la memoria
			MemToReg : out  std_logic;
			MemWrite : out  std_logic;
			
			-- Señales para la ALU
			ALUSrc : out  std_logic;
			ALUControl : out  std_logic_vector (2 downto 0);
			ExtCero : out std_logic;
			
			-- Señales para el GPR
			RegWrite : out  std_logic;
			RegDest : out  std_logic
			);
		end component;

	
	
	--Señales internas para instanciar la Unidad de Control
		signal PCSrcAUX, JumpAUX, RegtoPCAUX, BranchAUX, PCToRegAUX, MemTORegAUX, MemWriteAUX,
				 ALUSRcAUX, ExtCeroAUX, RegWriteAUX, RegDEstAUX: std_logic;		                
		signal ALUControlAUX: std_logic_vector(2 downto 0);
		signal OPCodeAUX : std_logic_vector(5 downto 0);
		signal FunctAUX : std_logic_vector(5 downto 0);
		

	--Señales internas para el PC	
		signal PCAUX, PCAUX4 : std_logic_vector(31 downto 0);				--Salida del PC y salida del PC +4
		signal ExtSigno,ExtSigno4:std_logic_vector(31 downto 0);	      --Extension de signo de los bits 15-0 de MemProgData,y lo mismo pero multiplicado por 4
		signal Mux1aAUX :std_logic_vector(31 downto 0);				      --Entrada A (cuando PCSrc = '1') del primer multiplexor
		signal Mux2bAUX :std_logic_vector(31 downto 0);				      --Entrada B (cuando Jump = '1')del segundo multiplexor
		signal s1,s2,s3: std_logic_vector(31 downto 0);
		
		
		
	--Señales para instanciar el banco de registros	
		signal Wd3AUX, Rd1AUX, Rd2AUX : std_logic_vector (31 downto 0);
		signal A1AUX, A2AUX, A3AUX :std_logic_vector (4 downto 0);			
		signal SalidaMuxRD: std_logic_vector (4 downto 0);                --Salida auxiliar del multiplexor controlado por RegDest
		signal SalidaMTR: std_logic_vector(31 downto 0);
		
		
		
	--Señales para la ALU	
		signal SalMux1ALU, SalMux2ALU: std_logic_vector(31 downto 0);     --Respecticas salidas de los Mux2a1 que preceden a la ALU
		signal Ext0 : std_logic_vector(31 downto 0);				      --Extension de cero de los bits 15-0 de MemProgData
		signal MemDataAddrAUX : std_logic_vector(31 downto 0);	          --Salida de la ALU (Res)
		signal ZAUX :std_logic;                                           --Bandera Z
	
	
	begin
						 
		
		u1 : ALUMips port map ( Op1 => Rd1AUX,	Op2 => SalMux2ALU, ALUControl => ALUControlAUX, 
								Res => MemDataAddrAUX, Z=> ZAUX);
								
								
		u2 : UnidadControl port map ( OPCode => OPCodeAUX,
									Funct => FunctAUX,
									Jump => JumpAUX,
									RegToPC => RegtoPCAUX,
									Branch => BranchAUX,
									PCToReg => PCToRegAUX,
									MemToReg => MemToRegAUX,
									MemWrite => MemWriteAUX,
									ALUSrc => ALUSRcAUX,
									ALUControl => ALUControlAUX,
									ExtCero => ExtCeroAUX,
									RegWrite => RegWriteAUX,
									RegDest => RegDEstAUX);
									
									
		u3 : RegsMips port map ( Clk => Clk, NRst => NRst, 
								 A1 => A1AUX, 
								 A2 => A2AUX,
								 A3 => A3AUX, 
								 Wd3 => Wd3AUX, We3 => RegWriteAUX,
								 Rd1 => RD1AUX, Rd2 => Rd2AUX);
										

	--Creación del PC con Reset asíncrono a nivel bajo 
			process(Clk,NRst)
				begin
					if NRst = '0' then
						PCAUX <= "00000000000000000000000000000000";
					elsif rising_edge(Clk) then 
						PCAUX <= s3;
					end if;
			end process;
		
		
		
	--Asignaciones para el PC
		with PCSrcAUX select									--Primer multiplexor
				s1 <= Mux1aAUX when '1',
						PCAUX4 when others;
			
		with JumpAUX select									--Segundo multiplexor
				s2 <= s1 when '0',
						Mux2bAUX when others;
			
		with RegtoPCAUX select								--Tercer multiplexor
				s3 <= RD1AUX when '1',
						s2 when others;
			
		with MemProgData(15) select												--ExtSigno: extensión en signo para la ALU y el PC  
			ExtSigno <= "0000000000000000" & MemProgData(15 downto 0)  when '0',	     
						"1111111111111111" & MemProgData(15 downto 0)  when others;
	
		ExtSigno4 <= ExtSigno(31 downto 2) & "00";									--ExtSigno4: multiplicada por 4
		PCAUX4 <= PCAUX + 4;
		Mux1aAUX <=(ExtSigno4 + (PCAUX4));											--Entrada del multiplexor 1 cuando PCSrc es 1
		Mux2bAUX <= (PCAUX4(31 downto 28) & MemProgData(25 downto 0) & "00");	--Entrada del multiplexor 2 cuando Jump es 0
		PCSrcAUX <= BranchAUX AND ZAUX;     	--Puerta AND de la bandera Z de la ALU y de Branch que controla el mux A del PC


	--Señales Unidad de control
		
		OPCodeAUX <=MemProgData(31 downto 26);
		FunctAUX <= MemProgData(5 downto 0);
		
		
		
	--Multiplexores y asignaciones para la ALU
		Ext0 <= "0000000000000000" & MemProgData(15 downto 0);   --Ext0:Extensión en cero para la ALU
		
		with ExtCeroAUX select                          --Multiplexor 2 a 1 con entrada de control Extcero
			SalMux1ALU <= Ext0 when '1',
						  ExtSigno when others;
						  
		with ALUSrcAUX select                           --Multiplexor 2 a 1 con entrada de control ALUSrc
			SalMux2ALU <= SalMux1ALU when '1',
						  Rd2AUX when others;
	
		
		
	--Multiplexores y asignaciones para el Banco de Registros
		
		A1AUX <= MemProgData(25 downto 21);
		A2AUX <= MemProgData(20 downto 16);
	
		with RegDEstAUX select										--Multiplexor 2 a 1 con entrada de control RegDest
			SalidaMuxRD <= MemProgData(20 downto 16) when '0',
						   MemProgData(15 downto 11) when others;
						   
		with PCToRegAUX select										--Multiplexor 2 a 1 con entrada de control PCToReg
			A3AUX <= SalidaMuxRD when '0',							-- que define la entrada A3 del Banco
					 "11111" when others;
		
		with MemToRegAUX select										--Multiplexor 2 a 1 con entrada de control MemToReg
			SalidaMTR <= MemDataDataRead when '1',
						 MemDataAddrAUX when others;
						 
		with PCToRegAUX select										--Multiplexor 2 a 1 con entrada de control PCToReg
			Wd3AUX <= SalidaMTR when '0',							-- que define la entrada Wd3 del Banco
					   PCAUX4 when others;

	
		
	--Salidas del Microprocesador
		MemDataWE <= MemWriteAUX;
		MemDataDataWrite <= Rd2AUX;
		MemProgAddr <= PCAUX;
		MemDataAddr <= MemDataAddrAUX;
	
	
	
end arc;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
