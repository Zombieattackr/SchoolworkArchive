library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity a74x148priorityencoder8to3 is
    Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (2 downto 0);
           enableout : out STD_LOGIC;
           groupselect : out STD_LOGIC);
end a74x148priorityencoder8to3;

architecture Behavioral of a74x148priorityencoder8to3 is
    
begin

    output(0) <= (NOT(
        (
            (NOT input(1)) AND (input(2)) AND (input(4)) AND (input(6)) AND (NOT enable)
        ) 
        OR (
            (NOT input(3)) AND (input(4)) AND (input(6)) AND (NOT enable)
        ) 
        OR (
            (NOT input(5)) AND (input(6)) AND (NOT enable)
        ) 
        OR (
            (NOT input(7)) AND (NOT enable)
        )
    ));
    output(1) <= (NOT(
        (
            (NOT input(2)) AND (input(4)) AND (input(5)) AND (NOT enable)
        ) 
        OR (
            (NOT input(3)) AND (input(4)) AND (input(5)) AND (NOT enable)
        ) 
        OR (
            (NOT input(6)) AND (NOT enable)
        ) 
        OR (
            (NOT input(7)) AND (NOT enable)
        )
    ));
    output(2) <= (NOT(
        (
            (NOT input(4)) AND (NOT enable)
        ) 
        OR (
            (NOT input(5)) AND (NOT enable)
        ) 
        OR (
            (NOT input(6)) AND (NOT enable)
        ) 
        OR (
            (NOT input(7)) AND (NOT enable)
        )
    ));
    
    enableout <= (NOT(input(0) AND input(1) AND input(2) AND input(3) AND input(4) AND input(5) AND input(6) AND input(7) AND (NOT enable)));
    groupselect <= (NOT((NOT(input(0) AND input(1) AND input(2) AND input(3) AND input(4) AND input(5) AND input(6) AND input(7) AND (NOT enable))) AND (NOT enable)));

end Behavioral;