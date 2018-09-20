----------------------------------------------------------------------
-- Fichero: ALUMIPS.vhd
-- Descripción:Unidad aritmético-lógica combinacional con dos entradas de datos,
-- una entrada de selección de operación, una salida de datos y una salida de estado (bandera Z)
-- Fecha última modificación: 14/03/2017

-- Autores: Lucía Rivas Molina y Daniel Santo-Tomás
-- Asignatura: E.C. 1º doble grado
-- Grupo de Prácticas: 2102
-- Grupo de Teoría: 210
-- Práctica: 3
-- Ejercicio: 1
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

		
entity ALUMIPS is 
	port (
		Op1 : in std_logic_vector (31 downto 0);	--Operador 1
		Op2 : in std_logic_vector (31 downto 0);	--Operador 2
		ALUControl : in std_logic_vector (2 downto 0);		--Entrada de control	
		Res : out std_logic_vector (31 downto 0);		--Salida con el resultado de la operación
		Z : out std_logic		--Bandera Z,se pone a 1 si el resultado es 0
		);
end ALUMIPS;


architecture ALUarch of ALUMIPS is
	signal slt, resta,aux: std_logic_vector (31 downto 0);		--Declaramos las señales auxiliares
	
	
	begin
		resta <= OP1 - OP2; 			--Declaramos la resta fuera del case posterior,ya que la usaremos tanto para la operación de resta como para el SLT
		Res <= aux;						--Señal necesaria para leer la salida y activar o no la bandera Z
																																									--El primer bit de slt se pone a 1 si
		slt <= (0 => '1',others => '0') when ((Op1(31) = '1') and (Op2(31) = '0')) else 													--Op1 es negativo y Op2 es positivo o
		       (0 => '1',others => '0') when ((Op1(31) = '0') and (Op2(31) = '0') and (resta(31)='1')) else						--Op1 y Op2 son negativos y la resta es negativa o	
				 (0 => '1',others => '0') when ((Op1(31) = '1') and (Op2(31) = '1') and (resta(31)='1')) else (others =>'0');	--Op1 y Op2 son positivos y la resta es positiva.
																																									--El resto de casoso es 0.					
		process (ALUControl,OP1,OP2,resta,slt)
			begin 
				case ALUControl is
					when "000" => aux <= OP1 AND OP2;					--A cada codigo de funcion le asociamos la funcion pedida
					when "001" => aux <= OP1 or OP2;
					when "010" => aux <= OP1 + OP2;
					when "101" => aux <= OP1 nor OP2;
					when "110" => aux <= resta;
					when "111" => aux <= slt;
					when others => aux <= (others=> '0');
			end case;
		end process;
		
		Z <= '1' when (aux = 0) else '0';  --Comprobamos la salida para activar o no la bandera Z

end ALUarch;








