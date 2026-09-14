----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2022 12:21:26 PM
-- Design Name: 
-- Module Name: fuller_hayden_studio1 - Behavioral
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

entity fuller_hayden_studio1 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;
           ABgtCD : out STD_LOGIC;
           ABeqCD : out STD_LOGIC;
           ABltCD : out STD_LOGIC);
end fuller_hayden_studio1;

architecture Behavioral of fuller_hayden_studio1 is

begin
ABgtCD <= (A AND (NOT C)) OR ((NOT D) AND ((B AND (NOT C)) OR (B AND A)));
ABeqCD <= (NOT ((B OR D) AND (NOT (B AND D)))) AND (NOT ((A OR C) AND (NOT (A AND C))));
ABltCD <= (C AND (NOT A)) OR (((D AND C) AND (NOT B)) OR (((NOT A) AND (NOT B)) AND D));

end Behavioral;
