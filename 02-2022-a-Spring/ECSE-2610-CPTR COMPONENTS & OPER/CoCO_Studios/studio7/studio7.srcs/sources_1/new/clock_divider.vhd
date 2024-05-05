library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity clock_divider is
    Port ( clk : in STD_LOGIC;
           m_clk : out STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

signal count: STD_LOGIC_VECTOR(25 downto 0);
begin
process(clk)
    begin
    if (clk'event and clk='1') then
        count <= count+1;
    end if;
end process;
m_clk <= count(24);

end Behavioral;
