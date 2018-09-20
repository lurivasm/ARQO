--------------------------------------------------------------------------------
-- Unidad de control principal del micro. Arq0 2018
-- Fecha última modificación:
-- Autores: Lucía Rivas Molina y Daniel Santo-Tomás
-- Asignatura: Arquitectura
-- Grupo de Prácticas: 3112
-- Grupo de Teoría: 310
-- Práctica: 1
-- Ejercicio: 1
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
   port (
      -- Entrada = codigo de operacion en la instruccion:
      OpCode  : in  std_logic_vector (5 downto 0);
      Funct : in std_logic_vector (5 downto 0);
      -- Seniales para el PC
      Branch : out  std_logic; -- 1=Ejecutandose instruccion branch
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
end control_unit;

architecture rtl of control_unit is

   -- Tipo para los codigos de operacion:
   subtype t_opCode is std_logic_vector (5 downto 0);

   -- Codigos de operacion para las diferentes instrucciones:
   constant OP_RTYPE  : t_opCode := "000000";
   constant OP_BEQ    : t_opCode := "000100";
   constant OP_SW     : t_opCode := "101011";
   constant OP_LW     : t_opCode := "100011";
   constant OP_LUI    : t_opCode := "001111";
   constant OP_ADDI   : t_opCode := "001000";

begin
  process(OpCode)
    begin
      if OpCode = "000010" then  -- Instucción j
        
      
      elsif OpCode = OP_BEQ then   --Instrucción beq
						MemToReg  <= '0';
						MemWrite  <= '0';
						MemRead <= '0';
						Branch <= '1';
						ALUControl <= "0001";
						ALUSrc <= '0';
						RegDst <= '0';
						RegWrite <= '0';
						
			elsif OpCode = OP_ADDI then   --Instrucción addi
						MemToReg  <= '0';
						MemWrite  <= '0';
						MemRead <= '0';
						Branch <= '0';
						ALUControl <= "0000";
						ALUSrc <= '1';
						RegDst <= '0';
						RegWrite <= '1';
						
			elsif OpCode = OP_LW then   --Instrucción lw
						MemToReg  <= '1';
						MemWrite  <= '0';
						MemRead <= '1';
						Branch <= '0';
						ALUControl <= "0000";
						ALUSrc <= '1';
						RegDst <= '0';
						RegWrite <= '1';
						
			elsif OpCode = OP_SW then   --Instrucción sw
						MemToReg  <= '0';
						MemWrite  <= '1';
						MemRead <= '0';
						Branch <= '0';
						ALUControl <= "0000";
						ALUSrc <= '1';
						RegDst <= '0';
						RegWrite <= '0';
						
						
					
        
        

end architecture;
