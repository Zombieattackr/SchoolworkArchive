----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2022 01:12:26 PM
-- Design Name: 
-- Module Name: toplevel - Behavioral
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

entity toplevel is
    Port ( clk : in STD_LOGIC;
           cin : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (7 downto 0);
           leds : out STD_LOGIC_VECTOR (8 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           disp : out STD_LOGIC_VECTOR (6 downto 0));
end toplevel;

architecture Behavioral of toplevel is

    component fullAdder is
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               C : in STD_LOGIC;
               S : out STD_LOGIC; --SUM
               O : out STD_LOGIC); --OUTPUT CARRY
    end component fullAdder;
    
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
    
    signal c0: STD_LOGIC;
    signal c1: STD_LOGIC;
    signal c2: STD_LOGIC;
    signal c3: STD_LOGIC;
    signal s0: STD_LOGIC;
    signal s1: STD_LOGIC;
    signal s2: STD_LOGIC;
    signal s3: STD_LOGIC;
    signal sseg1: STD_LOGIC_VECTOR (6 downto 0);
    signal sseg2: STD_LOGIC_VECTOR (6 downto 0);
    
begin
    FA0: fullAdder
        PORT MAP (
            A => input(0),
            B => input(4),
            C => cin,
            S => s0,
            O => c0);
    FA1: fullAdder
        PORT MAP (
            A => input(1),
            B => input(5),
            C => c0,
            S => s1,
            O => c1);
    FA2: fullAdder
        PORT MAP (
            A => input(2),
            B => input(6),
            C => c1,
            S => s2,
            O => c2);
    FA3: fullAdder
        PORT MAP (
            A => input(3),
            B => input(7),
            C => c2,
            S => s3,
            O => c3);
            
    DD1: Fuller_Hayden_Studio2
        PORT MAP (
            input(0) => s0,
            input(1) => s1,
            input(2) => s2,
            input(3) => s3,
            leds(0) => leds(0),
            leds(1) => leds(1),
            leds(2) => leds(2),
            leds(3) => leds(3),
            --anodes(0) => 
            --anodes(1) => 
            --anodes(2) => 
            --anodes(3) => 
            disp(0) => sseg1(0),
            disp(1) => sseg1(1),
            disp(2) => sseg1(2),
            disp(3) => sseg1(3),
            disp(4) => sseg1(4),
            disp(5) => sseg1(5),
            disp(6) => sseg1(6));
    DD2: Fuller_Hayden_Studio2
        PORT MAP (
            input(0) => c3,
            input(1) => '0',
            input(2) => '0',
            input(3) => '0',
            leds(0) => leds(4),
            leds(1) => leds(5),
            leds(2) => leds(6),
            leds(3) => leds(7),
            --anodes(0) => 
            --anodes(1) => 
            --anodes(2) => 
            --anodes(3) => 
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
            seg2(0) => '0',
            seg2(1) => '0',
            seg2(2) => '0',
            seg2(3) => '0',
            seg2(4) => '0',
            seg2(5) => '0',
            seg2(6) => '0',
            seg3(0) => '0',
            seg3(1) => '0',
            seg3(2) => '0',
            seg3(3) => '0',
            seg3(4) => '0',
            seg3(5) => '0',
            seg3(6) => '0',
            seg => disp,
            an => anodes);

    leds(8) <= cin;
    
end Behavioral;
