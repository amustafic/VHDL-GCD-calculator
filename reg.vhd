library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
  generic (width    :     positive := 32);
  port(clk, rst, enable : in  std_logic;
       input        : in  std_logic_vector(width-1 downto 0);
       output       : out std_logic_vector(width-1 downto 0));
end reg;

architecture bhv of reg is
begin
  process(clk, rst)
  begin
    if rst = '1' then
      output   <= (others => '0');
    elsif (clk = '1' and clk'event) then
      if (enable = '1') then
        output <= input;
      end if;
    end if;
  end process;
end bhv;
