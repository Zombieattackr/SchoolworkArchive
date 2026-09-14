----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 12:10:53 PM
-- Design Name: 
-- Module Name: alu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( clk : in STD_LOGIC;
           in1 : in STD_LOGIC_VECTOR (3 downto 0);
           in2 : in STD_LOGIC_VECTOR (3 downto 0);
           op : in STD_LOGIC_VECTOR (1 downto 0);
           cin : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (11 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           disp : out STD_LOGIC_VECTOR (6 downto 0));
end alu;

architecture Behavioral of alu is

    component function_select is
        Port ( Input0 : in  STD_LOGIC_VECTOR (3 downto 0);
               Input1 : in  STD_LOGIC_VECTOR (3 downto 0);
               Input2 : in  STD_LOGIC_VECTOR (3 downto 0);
               Input3 : in  STD_LOGIC_VECTOR (4 downto 0);
               control : in  STD_LOGIC_VECTOR (1 downto 0);
               Output : out  STD_LOGIC_VECTOR (4 downto 0));
    end component function_select;

    component Adder is
        Port ( in1 : in STD_LOGIC_VECTOR (3 downto 0);
               in2 : in STD_LOGIC_VECTOR (3 downto 0);
               cin : in STD_LOGIC;
               o3 : out STD_LOGIC_VECTOR (4 downto 0));
    end component Adder;
    
    component ANDer is
        Port ( in1 : in STD_LOGIC_VECTOR (3 downto 0);
               in2 : in STD_LOGIC_VECTOR (3 downto 0);
               o0 : out STD_LOGIC_VECTOR (3 downto 0));
    end component ANDer;
    
    component ORer is
        Port ( in1 : in STD_LOGIC_VECTOR (3 downto 0);
               in2 : in STD_LOGIC_VECTOR (3 downto 0);
               o1 : out STD_LOGIC_VECTOR (3 downto 0));
    end component ORer;
    
    component XORer is
        Port ( in1 : in STD_LOGIC_VECTOR (3 downto 0);
               in2 : in STD_LOGIC_VECTOR (3 downto 0);
               o2 : out STD_LOGIC_VECTOR (3 downto 0));
    end component XORer;
    
    component Fuller_Hayden_Studio2 is
        Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
               leds : out STD_LOGIC_VECTOR (3 downto 0);
               anodes : out STD_LOGIC_VECTOR (3 downto 0);
               disp : out STD_LOGIC_VECTOR (6 downto 0));
    end component Fuller_Hayden_Studio2;
    
    component LEDdisplay is
        PORT ( clk : IN STD_LOGIC;
               seg0,seg1,seg2,seg3 : IN STD_LOGIC_VECTOR(6 downto 0);
               seg : OUT STD_LOGIC_VECTOR(6  downto 0);
               an : OUT STD_LOGIC_VECTOR(3 downto 0));
    end component LEDdisplay;

    signal out0: STD_LOGIC_VECTOR (3 downto 0);
    signal out1: STD_LOGIC_VECTOR (3 downto 0);
    signal out2: STD_LOGIC_VECTOR (3 downto 0);
    signal out3: STD_LOGIC_VECTOR (4 downto 0);
    signal outf: STD_LOGIC_VECTOR (4 downto 0);
    signal sseg1: STD_LOGIC_VECTOR (6 downto 0);
    signal sseg2: STD_LOGIC_VECTOR (6 downto 0);
    
begin

    fsel: function_select
        PORT MAP ( 
            control => op,
            input0 => out0,
            input1 => out1,
            input2 => out2,
            input3 => out3,
            output => outf);


    Adder1: Adder
        PORT MAP (
            in1 => in1,
            in2 => in2,
            cin => cin,
            o3 => out3);
            
    Ander1: ANDer
        PORT MAP (
            in1 => in1,
            in2 => in2,
            o0 => out0);
    
    Orer1: ORer
        PORT MAP (
            in1 => in1,
            in2 => in2,
            o1 => out1);

    Xorer1: XORer
        PORT MAP (
            in1 => in1,
            in2 => in2,
            o2 => out2);
            
    DD1: Fuller_Hayden_Studio2
        PORT MAP (
            input(0) => outf(0),
            input(1) => outf(1),
            input(2) => outf(2),
            input(3) => outf(3),
            disp(0) => sseg1(0),
            disp(1) => sseg1(1),
            disp(2) => sseg1(2),
            disp(3) => sseg1(3),
            disp(4) => sseg1(4),
            disp(5) => sseg1(5),
            disp(6) => sseg1(6));
    DD2: Fuller_Hayden_Studio2
        PORT MAP (
            input(0) => outf(4),
            input(1) => '0',
            input(2) => '0',
            input(3) => '0',
            disp(0) => sseg2(0),
            disp(1) => sseg2(1),
            disp(2) => sseg2(2),
            disp(3) => sseg2(3),
            disp(4) => sseg2(4),
            disp(5) => sseg2(5),
            disp(6) => sseg2(6));

    LEDd: LEDdisplay
        PORT MAP (
            clk => clk,
            seg0 => sseg1,
            seg1 => sseg2,
            seg2(0) => '1',
            seg2(1) => '1',
            seg2(2) => '1',
            seg2(3) => '1',
            seg2(4) => '1',
            seg2(5) => '1',
            seg2(6) => '1',
            seg3(0) => '1',
            seg3(1) => '1',
            seg3(2) => '1',
            seg3(3) => '1',
            seg3(4) => '1',
            seg3(5) => '1',
            seg3(6) => '1',
            seg => disp,
            an => anodes);
end Behavioral;
