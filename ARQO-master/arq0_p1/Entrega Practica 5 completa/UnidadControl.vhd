----------------------------------------------------------------------
-- Fichero: UnidadControl.vhd
-- Descripci�n: Unidad de Control para el microprocesador MIPS
-- Fecha �ltima modificaci�n: 2017-04-18

-- Autores: Luc�a Rivas ,Daniel Santo-Tom�s
-- Asignatura: E.C. 1� doble grado
-- Grupo de Pr�cticas: 2102
-- Grupo de Teor�a: 210
-- Pr�ctica: 5
-- Ejercicio: 2
----------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UnidadControl is 
	port(
		OPCode : in  std_logic_vector (5 downto 0); -- OPCode de la instrucci�n
		Funct : in std_logic_vector(5 downto 0); -- Funct de la instrucci�n
		
		-- Se�ales para el PC
		Jump : out  std_logic;
		RegToPC : out std_logic;
		Branch : out  std_logic;
		PCToReg : out std_logic;
		
		-- Se�ales para la memoria
		MemToReg : out  std_logic;
		MemWrite : out  std_logic;
		
		-- Se�ales para la ALU
		ALUSrc : out  std_logic;
		ALUControl : out  std_logic_vector (2 downto 0);
		ExtCero : out std_logic;
		
		-- Se�ales para el GPR
		RegWrite : out  std_logic;
		RegDest : out  std_logic
		);
end UnidadControl;



architecture comport of UnidadControl is
	begin
		
		process(OpCode,Funct)
			begin
				if OpCode = "000010" then     --Instrucci�n j
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "000";
						ALUSrc <= '0';
						RegDest <= '0';
						RegWrite <= '0';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '1';
						PCToReg <= '0';
						
				elsif OpCode = "000011" then   --Instrucci�n jal
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "000";
						ALUSrc <= '0';
						RegDest <= '0';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '1';
						PCToReg <= '1';
						
				elsif OpCode = "000100" then   --Instrucci�n beq
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '1';
						ALUControl <= "110";
						ALUSrc <= '0';
						RegDest <= '0';
						RegWrite <= '0';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
				elsif OpCode = "001000" then   --Instrucci�n addi
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "010";
						ALUSrc <= '1';
						RegDest <= '0';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
				elsif OpCode = "001100" then   --Instrucci�n andi
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "000";
						ALUSrc <= '1';
						RegDest <= '0';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '1';
						Jump <= '0';
						PCToReg <= '0';
						
				elsif OpCode = "001101" then   --Instrucci�n ori
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "001";
						ALUSrc <= '1';
						RegDest <= '0';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '1';
						Jump <= '0';
						PCToReg <= '0';
					
				elsif OpCode = "100011" then   --Instrucci�n lw
						MemToReg  <= '1';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "010";
						ALUSrc <= '1';
						RegDest <= '0';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
				elsif OpCode = "101011" then   --Instrucci�n sw
						MemToReg  <= '0';
						MemWrite  <= '1';
						Branch <= '0';
						ALUControl <= "010";
						ALUSrc <= '1';
						RegDest <= '0';
						RegWrite <= '0';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
				elsif OpCode = "001010" then   --Instrucci�n slt
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "111";
						ALUSrc <= '1';
						RegDest <= '0';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
				elsif (OpCode = "000000" )and(Funct = "001000") then	 --Instrucci�n jr
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUControl <= "000";
						ALUSrc <= '0';
						RegDest <= '0';
						RegWrite <= '0';
						RegToPC <= '1';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
						
				elsif (OpCode = "000000") and(Funct /= "001000")  then	 --Instrucciones tipo R 	
						MemToReg  <= '0';
						MemWrite  <= '0';
						Branch <= '0';
						ALUSrc <= '0';
						RegDest <= '1';
						RegWrite <= '1';
						RegToPC <= '0';
						ExtCero <= '0';
						Jump <= '0';
						PCToReg <= '0';
						
						if Funct = "100100" then 
							ALUControl <= "000";   --And
						
						elsif Funct = "100000" then 
							ALUControl <= "010";   --add
						
						elsif Funct = "100010" then 
							ALUControl <= "110";   --sub
						
						elsif Funct = "100111" then 
							ALUControl <= "101";   --nor
							
						elsif Funct = "100101" then 
							ALUControl <= "001";   --or
							
						elsif Funct = "101010" then 
							 ALUControl <= "111";   --slt
							 
						end if;
					end if;
			end process;
end comport;
























