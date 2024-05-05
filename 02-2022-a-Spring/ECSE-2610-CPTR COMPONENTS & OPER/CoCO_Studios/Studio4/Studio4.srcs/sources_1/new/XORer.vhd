----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2022 12:21:00 PM
-- Design Name: 
-- Module Name: XORer - Behavioral
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

entity XORer is
    Port ( in1 : in STD_LOGIC_VECTOR (3 downto 0);
           in2 : in STD_LOGIC_VECTOR (3 downto 0);
           o2 : out STD_LOGIC_VECTOR (3 downto 0));
end XORer;

architecture Behavioral of XORer is

begin
o2(0) <= in1(0) XOR in2(0);
o2(1) <= in1(1) XOR in2(1);
o2(2) <= in1(2) XOR in2(2);
o2(3) <= in1(3) XOR in2(3);

end Behavioral;
