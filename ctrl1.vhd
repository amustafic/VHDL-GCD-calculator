library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CTRL1 is
	GENERIC (WIDTH : positive := 16);
	PORT ( clk, rst, go  : in std_logic;
	       x_sel, y_sel, x_en, y_en : out std_logic;	           
			 output_en		: out std_logic;
			 output_en2	: out std_logic;
			 x_lt_y     : in std_logic;
	       x_ne_y     : in std_logic
			   
			   );
end CTRL1;
architecture COntrol of CTRL1 is
  
  type state_type is (S0_Waitgo, S1_INIT, 
  S2_LOOP_CHECK, 
  S3_BODYX, S4_BODYY,
   DONE1, DONE2);
  signal state, next_state  : STATE_TYPE;
  
  begin
    
    process(clk, rst)
	begin
    if (rst = '1') then
      state <= S0_WAITGO;  
    elsif(clk'event and clk = '1') then
      state <= next_state;
    end if;
	end process;
	
	process(state, x_lt_y, x_ne_y, go)
	  
	  begin 
	  
		output_en2 <= '0';
	
	
  case state is
  
    when S0_waitgo =>
      if (go ='1') then
        
        x_sel <= '0';
        y_sel <= '0';   
        x_en  <= '1';
	    y_en  <= '1';
		output_en <= '0';
		 
       next_state <= S1_init;

  else 
    x_sel <='0';
    x_en <='0';
    y_sel <= '0';
    y_en <= '0';
    output_en <= '0';
    next_state <= S0_waitgo;
  end if;
  
  
when s1_init =>
   x_sel <= '0';
        y_sel <= '0';   
          x_en  <= '1';
          -- load values
	         y_en  <= '1';
	        output_en <= '0';
	        next_state <= s2_loop_check;
	   
	   
	   
	   
	   when s2_loop_check =>
	   if (x_ne_y = '0') then
	     -- IF THEY ARE EQUAL
	     x_sel<= '1';
	     y_sel<= '1';
	      x_en<= '0';
	      -- do not enable
           y_en<= '0';
           output_en <='0';
           next_state <= done1;
           
  elsif (x_lt_y = '1') then
				x_sel <= '1';
			     y_sel <= '1';
			     x_en  <= '0';
			     y_en  <= '0';
			     output_en <= '0';
        next_state <= s3_bodyx;
    else 
				x_sel <= '1';
			     y_sel <= '1';
			     x_en  <= '0';
			     y_en  <= '0';
			     output_en <= '0';
         next_state <= s4_bodyy;
      
    end if;
  when s3_bodyx =>
    
    x_sel <= '1';
    y_sel <= '1';
    x_en  <= '0';
	y_en  <= '1';
    output_en <='0';
    next_state <= s2_loop_check;
    
    when s4_bodyy =>
    -- just opposite enable config from bodyx
    x_sel <= '1';
    y_sel <= '1';
    x_en  <= '1';
	y_en  <= '0';
    output_en <='0';
    next_state <= s2_loop_check;
    
    -- CHANGE
    
when done1 =>
        
        		  x_sel <= '1';
			     y_sel <= '1';
			     x_en  <= '0';
			     y_en  <= '0';
		       output_en <= '1';
					next_state <= done2;
				
			when done2 =>
        
        if go = '0' then
           x_sel <= '1';
		     y_sel <= '1';
		     x_en  <= '0';
		     y_en  <= '0';
	         output_en <= '0';
          output_en2 <= '1';
					next_state <= S0_WAITGO;
				else
				   x_sel <= '1';
					y_sel <= '1';
					x_en  <= '0';
					y_en  <= '0';
					
					output_en <= '0';
					output_en2 <= '1';
					next_state <= done2;
					
					
				END IF;
				  
			when others =>
			  null;
			  end case;
  end process;
end control;

