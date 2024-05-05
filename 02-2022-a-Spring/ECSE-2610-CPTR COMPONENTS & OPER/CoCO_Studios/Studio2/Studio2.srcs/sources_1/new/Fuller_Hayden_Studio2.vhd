----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2022 12:17:14 PM
-- Design Name: 
-- Module Name: Fuller_Hayden_Studio2 - Behavioral
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

entity Fuller_Hayden_Studio2 is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           leds : out STD_LOGIC_VECTOR (3 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           disp : out STD_LOGIC_VECTOR (6 downto 0)
           );
end Fuller_Hayden_Studio2;

    architecture Behavioral of Fuller_Hayden_Studio2 is

begin

anodes(0) <= '1';
anodes(1) <= '1';
anodes(2) <= '1';
anodes(3) <= '0';

leds(0) <= input(0);
leds(1) <= input(1);
leds(2) <= input(2);
leds(3) <= input(3);

with input select disp <=
--bcdefg
"1000000" when "0000",
"1111001" when "0001",
"0100100" when "0010",
"0110000" when "0011",
"0011001" when "0100",
"0010010" when "0101",
"0000010" when "0110",
"1111000" when "0111",
"0000000" when "1000",
"0010000" when "1001",
"0001000" when "1010",
"0000011" when "1011",
"1000110" when "1100",
"0100001" when "1101",
"0000110" when "1110",
"0001110" when "1111",
"1111111" when others;


end Behavioral;
