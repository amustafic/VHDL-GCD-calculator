library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
    generic (
        WIDTH : positive := 8);
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        x      : in  std_logic_vector(WIDTH-1 downto 0);
        y      : in  std_logic_vector(WIDTH-1 downto 0);
        go     : in  std_logic;
        done   : out std_logic;
       
        output : out std_logic_vector(WIDTH-1 downto 0));
end gcd;


architecture FSMD of gcd is


  type STATE_TYPE is (START, WAIT_0, WAIT_1, INIT, LOOP_COND,
                      LOOP_BODY, OUTPUT_RESULT);
  signal state : STATE_TYPE;

  signal  tmpx, tmpy : Std_logic_vector(width-1 downto 0);

  
begin  -- FSM_D1
process (clk, rst)
  begin
    if (rst = '1') then
      state  <= START;
      done   <= '0';
      output <= (others => '0');
      tmpy <= (others => '0');
      tmpx <= (others => '0');

    elsif (clk = '1' and clk'event) then
	
	case state is

     when START =>

          done <= '0';

          if (go = '0') then
            state <= WAIT_1;
          else
            state <= START;
          end if;

   when wait_1 =>
	       done <= '0';
          
          if (go = '1') then
            state <= INIT;
          else
            state <= WAIT_1;
          end if;
		  
    when INIT =>
		 tmpX <=x;
		 tmpY <=y;
     state <= LOOP_COND;
	 
  when LOOP_COND =>

          if (tmpx  /= tmpY) then
            state <= LOOP_BODY;
          else
            state <= OUTPUT_RESULT;
          end if;
		  
	 when LOOP_BODY =>
         
      if (tmpx <= tmpy) then
tmpy <= std_logic_vector(unsigned(tmpy)-unsigned(tmpx));
		  
		  else 
		  tmpx <= std_logic_vector(unsigned(tmpx)-unsigned(tmpy));
		  end if;

          state <= LOOP_COND;	  
	

when OUTPUT_RESULT =>
          output <= std_logic_vector(tmpX);
          state  <= WAIT_0;

when WAIT_0 =>

          done <= '1';

          if (go = '0') then
            state <= WAIT_1;
          else
            state <= WAIT_0;
          end if;

        when others => null;
      end case;

		  
	end if;	  
		  

end process;
end FSMD;



architecture FSM_D1 of gcd is

  signal data_out : std_logic_vector(Width-1 downto 0);  
    signal i_sel, x_sel, y_sel, add_sel               : std_logic;
        signal i_ld, x_ld, y_ld, n_ld, result_ld :  std_logic;
        signal i_le_n  :   std_logic;
signal x_lt_y, x_ne_y, x_en, y_en, output_en, output_en2: std_logic;
  signal output_ld : std_logic;  
  
  SIGNAL Data_Done       : std_logic;
	SIGNAL Data_Output     : std_logic_vector(WIDTH-1 downto 0);
  
begin  -- FSM_D1
output <= data_output;

U_CTRL : entity work.ctrl1
		port map (clk => clk,
				  rst => rst,
				  go => go,
				  x_sel  => x_sel,
				  y_sel => y_sel,
				  x_en => x_en,
				  y_en => y_en,
				  output_en => output_en,
				  output_en2 => output_en2,-- this is done			  
				  x_lt_y =>  x_lt_y,
				  x_ne_y =>  x_ne_y);


	U_DP : entity work.datapath1
		generic map (width => width)
		port map (
		  clk => clk,
		  rst => rst,
			x => x,
			y => y,
			done => data_done,
			output => data_output,
			x_sel => x_sel,
			y_sel => y_sel,
			x_en => x_en,
			y_en=> y_en,
			output_en => output_en,
			output_en2 => output_en2,
			x_lt_y => x_lt_y,
			x_ne_y => x_ne_y);



done <= data_done;
end FSM_D1;

architecture FSM_D2 of gcd is

		signal data_out : std_logic_vector(Width-1 downto 0);  
		signal i_sel, x_sel, y_sel, add_sel               : std_logic;
      signal i_ld, x_ld, y_ld, n_ld, result_ld :  std_logic;
      signal i_le_n  :   std_logic;
		signal x_lt_y, x_ne_y, x_en, y_en, output_en, output_en2: std_logic;
		signal output_ld : std_logic;  
  
		SIGNAL Data_Done       : std_logic;
		SIGNAL Data_Output     : std_logic_vector(WIDTH-1 downto 0);
  
		begin  
		output <= data_output;

		U_CTRL : entity work.ctrl2
		port map (clk => clk,
				  rst => rst,
				  go => go, 
				  x_sel  => x_sel,
				  y_sel => y_sel,
				  x_en => x_en,
				  y_en => y_en,
				  output_en => output_en,
				  output_en2 => output_en2,		  
				  x_lt_y =>  x_lt_y,
				  x_ne_y =>  x_ne_y);


		U_DP : entity work.datapath1
		generic map (width => width)
		port map (
		  clk => clk,
		  rst => rst,
			x => x,
			y => y,
			done => data_done,
			output => data_output,
			x_sel => x_sel,
			y_sel => y_sel,
			x_en => x_en,
			y_en=> y_en,
			output_en => output_en,
			output_en2 => output_en2,
			x_lt_y => x_lt_y,
			x_ne_y => x_ne_y);



	done <= data_done;
	end FSM_D2;

