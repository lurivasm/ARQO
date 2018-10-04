----------------------------------------------------------------------
-- Fichero: RegsMIPS.vhd
-- Descripci�n:Banco de registros a usar en la futura implementacion de un microprocesador
-- Fecha �ltima modificaci�n: 14/03/2017

-- Autores: Luc�a Rivas Molina y Daniel Santo-Tom�s
-- Asignatura: E.C. 1� doble grado
-- Grupo de Pr�cticas: 2102
-- Grupo de Teor�a: 210
-- Pr�ctica: 3
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity RegsMIPS is
	port (
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset as�ncrono a nivel bajo
		Wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada a escribir
		A1 : in std_logic_vector(4  downto 0); -- Direcci�n de lectura 1
		A2 : in std_logic_vector(4 downto 0); -- Direcci�n de lectura 2
		A3 : in std_logic_vector(4 downto 0); -- Direcci�n de escritura
		We3 : in std_logic ; --Se�al de habilitaci�n de la escritura
		Rd1 : out std_logic_vector(31 downto 0); -- Salida de lectura 1
		Rd2 : out std_logic_vector(31 downto 0) -- Salida de lectura 2
	); 
end RegsMIPS;

architecture Practica of RegsMIPS is

	-- Tipo para almacenar los registros
	type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);

	-- Esta es la se�al que contiene los registros. El acceso es de la
	-- siguiente manera: regs(i) acceso al registro i, donde i es
	-- un entero. Para convertir del tipo std_logic_vector a entero se
	-- hace de la siguiente manera: conv_integer(slv), donde
	-- slv es un elemento de tipo std_logic_vector

	-- Registros inicializados a '0' 
	
	signal regs : regs_t;

begin  
------------------------------------------------------
	-- Escritura del registro 
------------------------------------------------------

		process(NRst,Clk)
			begin
				if NRst = '0' then                          --Si el reset se activa,se ponene todos los registros a 0
					for i in 0 to 31 loop              
						regs(i) <=(others => '0') ;
					end loop;
				elsif rising_edge(Clk) then
					if We3 = '1' then										--La escritura solo funciona con el enable activado
						if (conv_integer(A3) /= 0) then           -- Nos aseguramos de que el registro de direcci�n 0 sea 0
							regs(conv_integer(A3)) <= Wd3 ;
						end if;
					end if;
				end if;
			end process;		
					
	------------------------------------------------------
	-- Lectura del registros
	------------------------------------------------------
	
		Rd1 <= regs(conv_integer(A1));  -- Asignamos a la salida 1 el registro correspondiente a la direcci�n dada por A1
		Rd2 <= regs(conv_integer(A2));  -- Asignamos a la salida 1 el registro correspondiente a la direcci�n dada por A2
	
	

end Practica;

