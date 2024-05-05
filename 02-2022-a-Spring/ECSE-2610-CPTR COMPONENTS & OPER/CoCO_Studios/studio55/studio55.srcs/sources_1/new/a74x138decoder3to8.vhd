library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
