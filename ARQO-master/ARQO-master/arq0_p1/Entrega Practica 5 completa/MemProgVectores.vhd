----------------------------------------------------------------------
-- Fichero: MemProgVectores.vhd
-- Descripción:Memoria de programa para el MIPS
-- Fecha última modificación: 18/04/2017

-- Autores: Lucía Rivas Molina y Daniel Santo-Tomás
-- Asignatura: E.C. 1º doble grado
-- Grupo de Prácticas: 2102
-- Grupo de Teoría: 210
-- Práctica: 5
-- Ejercicio: 1
----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgVectores is
	port (
		MemProgAddr : in std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- Código de operación
	);
end MemProgVectores;

architecture Simple of MemProgVectores is

begin

	LecturaMemProg: process(MemProgAddr)
	begin
		-- La memoria devuelve un valor para cada dirección.
		-- Estos valores son los códigos de programa de cada instrucción,
		-- estando situado cada uno en su dirección.
		case MemProgAddr is
		-------------------------------------------------------------
		-- Sólo introducir cambios desde aquí	

			-- Por cada instrucción en .text, agregar una línea del tipo:
			-- when DIRECCION => MemProgData <= INSTRUCCION;
			-- Por ejemplo, si la posición 0x00000000 debe guardarse la instrucción con código máquina 0x20010004, poner:
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
		-- Hasta aquí	
		---------------------------------------------------------------------	
			
			when others => MemProgData <= X"00000000"; -- Resto de memoria vacía
		end case;
	end process LecturaMemProg;

end Simple;

