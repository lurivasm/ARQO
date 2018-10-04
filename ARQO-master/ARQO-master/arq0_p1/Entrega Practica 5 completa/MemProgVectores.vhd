----------------------------------------------------------------------
-- Fichero: MemProgVectores.vhd
-- Descripci�n:Memoria de programa para el MIPS
-- Fecha �ltima modificaci�n: 18/04/2017

-- Autores: Luc�a Rivas Molina y Daniel Santo-Tom�s
-- Asignatura: E.C. 1� doble grado
-- Grupo de Pr�cticas: 2102
-- Grupo de Teor�a: 210
-- Pr�ctica: 5
-- Ejercicio: 1
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgVectores is
	port (
		MemProgAddr : in std_logic_vector(31 downto 0); -- Direcci�n para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- C�digo de operaci�n
	);
end MemProgVectores;

architecture Simple of MemProgVectores is

begin

	LecturaMemProg: process(MemProgAddr)
	begin
		-- La memoria devuelve un valor para cada direcci�n.
		-- Estos valores son los c�digos de programa de cada instrucci�n,
		-- estando situado cada uno en su direcci�n.
		case MemProgAddr is
		-------------------------------------------------------------
		-- S�lo introducir cambios desde aqu�	

			-- Por cada instrucci�n en .text, agregar una l�nea del tipo:
			-- when DIRECCION => MemProgData <= INSTRUCCION;
			-- Por ejemplo, si la posici�n 0x00000000 debe guardarse la instrucci�n con c�digo m�quina 0x20010004, poner:
			when X"00000000" => MemProgData <= X"20100000" ;
			when X"00000004" => MemProgData <= X"8c112000" ;
			when X"00000008" => MemProgData <= X"02318820" ;
			when X"0000000C" => MemProgData <= X"02318820" ;
		   when X"00000010" => MemProgData <= X"0211482a" ;
			when X"00000014" => MemProgData <= X"11200008" ;
			when X"00000018" => MemProgData <= X"8e0a201c" ;
			when X"0000001C" => MemProgData <= X"014a5020" ;
			when X"00000020" => MemProgData <= X"014a5020" ;
			when X"00000024" => MemProgData <= X"8e0b2004" ;
			when X"00000028" => MemProgData <= X"016a6020" ;
			when X"0000002C" => MemProgData <= X"ae0c2034" ;
			when X"00000030" => MemProgData <= X"22100004" ;
			when X"00000034" => MemProgData <= X"08000004" ;
			when X"00000038" => MemProgData <= X"0800000e";
		-- Hasta aqu�	
		---------------------------------------------------------------------	
			
			when others => MemProgData <= X"00000000"; -- Resto de memoria vac�a
		end case;
	end process LecturaMemProg;

end Simple;

