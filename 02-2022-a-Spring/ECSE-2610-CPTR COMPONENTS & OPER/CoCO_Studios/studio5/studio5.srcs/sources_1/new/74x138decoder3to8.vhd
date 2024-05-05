----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 08:33:53 PM
-- Design Name: 
-- Module Name: 74x138decoder3to8 - Behavioral
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

entity a74x138decoder3to8 is
    Port ( input : in STD_LOGIC_VECTOR (2 downto 0);
           g1 : in STD_LOGIC;
           g2a : in STD_LOGIC;
           g2b : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (7 downto 0));
end a74x138decoder3to8;

architecture Behavioral of a74x138decoder3to8 is
    
begin
    output(0) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (NOT input(0)) AND (NOT input(1)) AND (NOT input(2)));
    output(1) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (input(0)) AND (NOT input(1)) AND (NOT input(2)));
    output(2) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (NOT input(0)) AND (input(1)) AND (NOT input(2)));
    output(3) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (input(0)) AND (input(1)) AND (NOT input(2)));
    output(4) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (NOT input(0)) AND (NOT input(1)) AND (input(2)));
    output(5) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (input(0)) AND (NOT input(1)) AND (input(2)));
    output(6) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (NOT input(0)) AND (input(1)) AND (input(2)));
    output(7) <= NOT((g1 AND (NOT g2a) AND (NOT g2b)) AND (input(0)) AND (input(1)) AND (input(2)));

end Behavioral;
