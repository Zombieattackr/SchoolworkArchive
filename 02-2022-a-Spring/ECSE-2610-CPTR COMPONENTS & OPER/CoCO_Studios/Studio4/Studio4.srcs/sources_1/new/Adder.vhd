----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 12:30:33 PM
-- Design Name: 
-- Module Name: Adder - Behavioral
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

entity Adder is
    Port ( in1 : in STD_LOGIC_VECTOR (3 downto 0);
           in2 : in STD_LOGIC_VECTOR (3 downto 0);
           cin : in STD_LOGIC;
           o3 : out STD_LOGIC_VECTOR (4 downto 0));
end Adder;

architecture Behavioral of Adder is

    component fullAdder is
        Port ( A : in STD_LOGIC;
               B : in STD_LOGIC;
               C : in STD_LOGIC;
               S : out STD_LOGIC; --SUM
               O : out STD_LOGIC); --OUTPUT CARRY
    end component fullAdder;
    
    signal c0: STD_LOGIC;
    signal c1: STD_LOGIC;
    signal c2: STD_LOGIC;
    
    
begin
    FA0: fullAdder
        PORT MAP (
            A => in1(0),
            B => in2(0),
            C => cin,
            S => o3(0),
            O => c0);
    FA1: fullAdder
        PORT MAP (
            A => in1(1),
            B => in2(1),
            C => c0,
            S => o3(1),
            O => c1);
    FA2: fullAdder
        PORT MAP (
            A => in1(2),
            B => in2(2),
            C => c1,
            S => o3(2),
            O => c2);
    FA3: fullAdder
        PORT MAP (
            A => in1(3),
            B => in2(3),
            C => c2,
            S => o3(3),
            O => o3(4));

end Behavioral;
