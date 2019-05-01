library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUB is
	GENERIC (WIDTH : positive := 16);
	PORT ( rst			     : in std_logic;
			   InA, InB  	: in std_logic_vector(WIDTH-1 Downto 0);
			   output			  : out	std_logic_vector(WIDTH-1 Downto 0));
end SUB;

ARCHITECTURE CONT OF SUB IS
begin
	process(rst, InA, InB)
	begin
		
		if (rst = '1') then
		  
		  output <= (others => '0');
		else
		 
		  output <= std_logic_vector(unsigned(InA) - unsigned(InB));
		end if ;	
		
	end process;
end CONT;