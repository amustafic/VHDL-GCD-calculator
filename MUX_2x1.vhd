library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_2x1 is
  -- generic width
	GENERIC (WIDTH : positive := 16);
	PORT ( sel  : in std_logic;
	       rst			: in std_logic;
			   InA   : in std_logic_vector(WIDTH-1 Downto 0);
			   InB  	: in std_logic_vector(WIDTH-1 Downto 0);
			   output			  : out	std_logic_vector(WIDTH-1 Downto 0));
end mux_2x1;

ARCHITECTURE good1 OF MUX_2x1 IS
begin
	process(sel, rst, InA, InB)
	begin
		if rst = '1' then
			output <= (others => '0');
		elsif sel = '0' then
			output <= InA;
		else
			output <= InB;
		end if;
	end process;
end good1;