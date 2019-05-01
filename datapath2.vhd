library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity datapath2 is
  generic (width : positive := 16);
    port(    
      clk   :in std_logic;
      rst   :in std_logic;
      x     :in  std_logic_vector(WIDTH-1 downto 0);
      y     :in  std_logic_vector(WIDTH-1 downto 0);
      output:out std_logic_vector(WIDTH-1 downto 0);
		
      done          : out std_logic;
      x_sel , y_sel :in std_logic;
      x_en, y_en, output_en, output_en2 : in std_logic;
      x_lt_y,x_ne_y :out std_logic );
  end datapath2;
  
architecture good_datapath2 of datapath2 is 
  signal  mux_x_out, mux_y_out     : std_logic_vector(width-1 downto 0);
  signal  reg_x_out, reg_y_out    : std_logic_vector(width-1 downto 0);
  signal add1_out, add2_out                         : std_logic_vector(width-1 downto 0);
    signal mux_add_left_out, mux_add_right_out : std_logic_vector(width-1 downto 0);
 Signal temp_output : std_logic_vector(WIDTH-1 Downto 0);

  signal xregout, yregout, out1, out2 : std_logic_vector(WIDTH-1 Downto 0);
  signal xsubout, ysubout : std_logic_vector(WIDTH-1 Downto 0);
  
  
  signal temp : std_logic_vector(WIDTH-1 Downto 0);
 signal tmp_x_lt_y: std_logic;
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


component Switch is
	GENERIC (WIDTH : positive := 16);
	PORT ( x_lt_y     : in std_logic;
			   In1, In2  	: in std_logic_vector(WIDTH-1 Downto 0);
			   Out1, Out2 : out	std_logic_vector(WIDTH-1 Downto 0));
end component;


  
begin 
  U_MUX_X : mux_2x1 generic map (width) port map ( x_sel,rst,x, xsubout, mux_x_out);
  U_MUX_Y : mux_2x1 generic map (width) port map ( y_sel,rst,y, xsubout, mux_y_out);
  U_REG_X : reg generic map (width) port map (clk, rst, x_en, mux_x_out, xregout);
  U_REG_Y : reg generic map (width) port map (clk, rst, y_en, mux_y_out, yregout);

  U_SUBx : sub generic map (width) port map(rst, out1, out2, xsubout);  
  U_comp : comp generic map (width) port map ( rst, xregout, yregout, tmp_x_lt_y, x_ne_y);
  x_lt_y <=tmp_x_lt_y;
  U_REGOUT:  reg generic map (width) port map (clk, rst, output_en, xregout, temp);
     U_Switch : switch generic map(width) port map (tmp_x_lt_y, xregout, yregout, out1, out2);
    
    output<= temp;
    done <= output_en2; 
     
     
     
      end good_datapath2;


