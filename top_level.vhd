library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
		  clk50MHz : in  std_logic;
		  --rst      : in  std_logic;
        switch  : in  std_logic_vector(9 downto 0);
        button  : in  std_logic_vector(1 downto 0);
        led0    : out std_logic_vector(6 downto 0);
        led0_dp : out std_logic;
        led1    : out std_logic_vector(6 downto 0);
        led1_dp : out std_logic;
        led2    : out std_logic_vector(6 downto 0);
        led2_dp : out std_logic;
        led3    : out std_logic_vector(6 downto 0);
        led3_dp : out std_logic;
        led4    : out std_logic_vector(6 downto 0);
        led4_dp : out std_logic;
        led5    : out std_logic_vector(6 downto 0);
        led5_dp : out std_logic
        );
end top_level;

architecture STR of top_level is 

	component decoder7seg
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(6 downto 0));
    end component;
	 
	  component gcd 
			generic (
					WIDTH : positive := 8);
			 port (
				  clk    : in  std_logic;
				  rst    : in  std_logic;
				  go     : in  std_logic;
				  done   : out std_logic;
				  x      : in  std_logic_vector(WIDTH-1 downto 0);
				  y      : in  std_logic_vector(WIDTH-1 downto 0);
				  output : out std_logic_vector(WIDTH-1 downto 0));
		end component; 
		
	 signal s_output : std_logic_vector(7 downto 0);
	 signal input1 : std_logic_vector(7 downto 0);
    signal input2 : std_logic_vector(7 downto 0);
    signal go_dp   : std_logic;
	 
	 constant C0 : std_logic_vector(3 downto 0) := "0000";
	 
				
 begin 
	
	U_LED5 : decoder7seg port map (
        input  => s_output(7 downto 4),
        output => led5);

    U_LED4 : decoder7seg port map (
        input  => s_output(3 downto 0),
        output => led4);

    -- all other LEDs should display 0
    U_LED3 : decoder7seg port map (
        input  => C0,
        output => led3);

    U_LED2 : decoder7seg port map (
        input  => C0,
        output => led2);
    
    U_LED1 : decoder7seg port map (
        input  => C0,
        output => led1);

    U_LED0 : decoder7seg port map (
        input  => C0,
        output => led0);
		  
	  input1 <= "000" & switch(9 downto 5); 
	  input2 <= "000" & switch( 4 downto 0); 
	 
	U_GCD : gcd 
	generic map (
            WIDTH => 8)
        port map (
			  clk   => clk50MHz,
			  rst   => (not (button(0))), 
			  go    => (not (button(1))), 
			  done  => go_dp,
			  x     => input1, 
			  y     => input2, 
			  output => s_output); 
			  
  led5_dp <= go_dp; 
  led4_dp <= '1';   --changed from not sum(5)
  led3_dp <= '1';
  led2_dp <= '1';
  led1_dp <= '1';
  led0_dp <= '1';
	  
end STR; 

configuration top_level_cfg of top_level is
    for STR
        for U_GCD : gcd
            use entity work.gcd(FSMD);  -- change this line for other
                                                  -- architectures 
        end for;
    end for;
end top_level_cfg;