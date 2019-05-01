library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity datapath1 is
  generic (width : positive := 16);
    port(    
      clk   :in std_logic;
      rst   :in std_logic;
      x     :in  std_logic_vector(WIDTH-1 downto 0);
      y     :in  std_logic_vector(WIDTH-1 downto 0);
      output:out std_logic_vector(WIDTH-1 downto 0);
      
      
     done          : out std_logic;
     --control signals
      x_sel , y_sel :in std_logic;
      x_en, y_en, output_en, output_en2 : in std_logic;
           
      x_lt_y,x_ne_y :out std_logic );
  end datapath1;
  
architecture good_datapath1 of datapath1 is 
  signal  mux_x_out, mux_y_out     : std_logic_vector(width-1 downto 0);
  signal  reg_x_out, reg_y_out    : std_logic_vector(width-1 downto 0);
  signal add1_out, add2_out                         : std_logic_vector(width-1 downto 0);
    signal mux_add_left_out, mux_add_right_out : std_logic_vector(width-1 downto 0);
 Signal temp_output : std_logic_vector(WIDTH-1 Downto 0);

  signal xregout, yregout : std_logic_vector(WIDTH-1 Downto 0);
  signal xsubout, ysubout : std_logic_vector(WIDTH-1 Downto 0);
  
  
  signal temp : std_logic_vector(WIDTH-1 Downto 0);
--  
 constant C1 : std_logic_vector(width-1 downto 0) := std_logic_vector(to_unsigned(1, width));
  constant C3 : std_logic_vector(width-1 downto 0) := std_logic_vector(to_unsigned(3, width));

component reg
    generic (width    :     positive := 32);
    port(clk, rst, enable : in  std_logic;
         input        : in  std_logic_vector(width-1 downto 0);
         output       : out std_logic_vector(width-1 downto 0));
  end component;

  component mux_2x1
    generic (width       :     positive := 16);
    port(
			sel  : in  std_logic;
			rst           : in  std_logic;
	inA, inB     : in  std_logic_vector(width-1 downto 0);
          output         : out std_logic_vector(width-1 downto 0));
  end component; 
  
  
  component sub
    
    generic (
    width  :     positive := 16);
  port (
  rst			     : in std_logic;
    ina    : in  std_logic_vector(width-1 downto 0);
    inb    : in  std_logic_vector(width-1 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end component;
    
    
    
    component comp 
  generic (
    width :     positive := 16);
  port (
         rst			     : in std_logic;
    inx   : in  std_logic_vector(width-1 downto 0);
    iny   : in  std_logic_vector(width-1 downto 0);
    x_lt_y    : out std_logic;
    x_ne_y    : out std_logic);
end component;

  
begin 

-- MUX for either x or y
  U_MUX_X : mux_2x1 generic map (width) port map ( x_sel,rst,x, xsubout, mux_x_out);
  U_MUX_Y : mux_2x1 generic map (width) port map ( y_sel,rst,y, ysubout, mux_y_out);
    -- same with Regx and regY
  U_REG_X : reg generic map (width) port map (clk, rst, x_en, mux_x_out, xregout);
 U_REG_Y : reg generic map (width) port map (clk, rst, y_en, mux_y_out, yregout);
   -- each sub is for specific input, y or x
  U_SUBx : sub generic map (width) port map(rst, xregout, yregout, xsubout);
  U_SUBy : sub generic map (width) port map ( rst, Yregout, Xregout, ysubout);
  U_comp : comp generic map (width) port map ( rst, xregout, yregout, x_lt_y, x_ne_y);
  U_REGOUT:  reg generic map (width) port map (clk, rst, output_en, xregout, temp);
    output<= temp;
    done <= output_en2; 
     
      end good_datapath1;
