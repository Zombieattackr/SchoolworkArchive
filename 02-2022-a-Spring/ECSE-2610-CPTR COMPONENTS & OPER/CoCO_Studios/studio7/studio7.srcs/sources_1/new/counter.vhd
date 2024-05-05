library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity counter is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           load_n : in STD_LOGIC;
           initial : in STD_LOGIC_VECTOR (3 downto 0);
           clear_n : in STD_LOGIC;
           counter_output : out STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture Behavioral of counter is

signal counter_signal:std_logic_vector (3 downto 0) :="0000";

begin
process(clk)
    begin
    if clear_n='0' then
        counter_signal <= (others=>'0');
    elsif (clk'event and clk='1') then
        if load_n='0' then
            counter_signal<=initial;
        else
            if enable='1' then
                counter_signal<=counter_signal +1;
            else
                counter_signal<=counter_signal;
            end if;
        end if;
    end if;
    end process;
    counter_output <= counter_signal;
end Behavioral;
