library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity topdown is
    Port ( clk : in STD_LOGIC;
           segments : out STD_LOGIC_VECTOR (6 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           enable : in STD_LOGIC;
           load : in STD_LOGIC;
           clear : in STD_LOGIC;
           initial : in STD_LOGIC_VECTOR (3 downto 0));
end topdown;

architecture Behavioral of topdown is
component clock_divider is
    Port ( clk : in STD_LOGIC;
           m_clk : out STD_LOGIC);
end component clock_divider;

component counter is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           load_n : in STD_LOGIC;
           initial : in STD_LOGIC_VECTOR (3 downto 0);
           clear_n : in STD_LOGIC;
           counter_output : out STD_LOGIC_VECTOR (3 downto 0));
end component counter;

component display_driver1 is
    Port ( inputs : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (6 downto 0));
end component display_driver1;

component display_driver2 is
    Port ( inputs : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (6 downto 0));
end component display_driver2;

component display_driver3 is
    Port ( inputs : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (6 downto 0));
end component display_driver3;

component display_driver4 is
    Port ( inputs : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (6 downto 0));
end component display_driver4;

component LEDdisplay IS
	PORT (
        clk : IN  STD_LOGIC;
		seg0,seg1,seg2,seg3 : IN  STD_LOGIC_VECTOR(6 downto 0);
        seg : OUT  STD_LOGIC_VECTOR(6  downto 0);
        an : OUT STD_LOGIC_VECTOR(3 downto 0));		  
end component LEDdisplay;

signal m_clk: STD_LOGIC;
signal cnt_out: STD_LOGIC_VECTOR (3 downto 0);
signal segs0: STD_LOGIC_VECTOR (6 downto 0);
signal segs1: STD_LOGIC_VECTOR (6 downto 0);
signal segs2: STD_LOGIC_VECTOR (6 downto 0);
signal segs3: STD_LOGIC_VECTOR (6 downto 0);

begin
    clkdiv: clock_divider
        PORT MAP (
            clk => clk,
            m_clk => m_clk);
    
    count: counter
        PORT MAP (
            clk => m_clk,
            enable => enable,
            load_n => load,
            initial => initial,
            clear_n => clear,
            counter_output => cnt_out);
    
    dd1: display_driver1
        PORT MAP (
            inputs => cnt_out,
            seg_out => segs0);
    
    dd2: display_driver2
        PORT MAP (
            inputs => cnt_out,
            seg_out => segs1);
    
    dd3: display_driver3
        PORT MAP (
            inputs => cnt_out,
            seg_out => segs2);
    
    dd4: display_driver4
        PORT MAP (
            inputs => cnt_out,
            seg_out => segs3);
    
    display: LEDdisplay
        PORT MAP (
            clk => clk,
            seg0 => segs0,
            seg1 => segs1,
            seg2 => segs2,
            seg3 => segs3,
            seg => segments,
            an => anodes);
end Behavioral;
