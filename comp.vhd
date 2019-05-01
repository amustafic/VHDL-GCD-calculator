

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMP is
	GENERIC (WIDTH : positive := 16);
	PORT ( rst			     : in std_logic;
			   InX, InY  	: in std_logic_vector(WIDTH-1 Downto 0);
			   x_lt_y    	: out std_logic;
			   x_ne_y			  : out std_logic
			   );
end COMP;

ARCHITECTURE good1 OF COMP IS
begin

  x_lt_y <= '0' when (rst = '1') 
  else '1' when (unsigned(InX) < unsigned(InY))
  else '0';
	x_ne_y <= '0' when (rst = '1') 
else '1' when (unsigned(InX) /= unsigned(InY)) 
	else '0';

end good1;
