----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2022 10:35:30 PM
-- Design Name: 
-- Module Name: studio5test - Behavioral
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

entity studio5test is
    Port ( input : in STD_LOGIC_VECTOR (2 downto 0);
           g1 : in STD_LOGIC;
           g2a : in STD_LOGIC;
           g2b : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (7 downto 0));
end studio5test;

architecture Behavioral of studio5test is

    
    component a74x138decoder3to8 is
            Port ( input : in STD_LOGIC_VECTOR (2 downto 0);
                   g1 : in STD_LOGIC;
                   g2a : in STD_LOGIC;
                   g2b : in STD_LOGIC;
                   output : out STD_LOGIC_VECTOR (7 downto 0));
        end component a74x138decoder3to8;
begin
    a738

end Behavioral;
