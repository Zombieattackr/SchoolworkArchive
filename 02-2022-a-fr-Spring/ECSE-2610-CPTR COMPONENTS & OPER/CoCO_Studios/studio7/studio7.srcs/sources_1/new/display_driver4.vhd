library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_driver4 is
    Port ( inputs : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (6 downto 0));
end display_driver4;

architecture Behavioral of display_driver4 is

begin
-- middle
-- top left
-- bot left
-- bottom
-- bot right
-- top right
-- top
with inputs select
seg_out <=
"0001001" when x"3" ,--H
"0000110" when x"4" ,--E
"1000111" when x"5" ,--L
"1000111" when x"6" ,--L
"1000000" when x"7" ,--O
"1111111" when x"8" ,-- 
"1000011" when x"9" ,--W(left)
"1100001" when x"A" ,--W(right)
"1000000" when x"B" ,--O
"0101111" when x"C" ,--r
"1000111" when x"D" ,--L
"0100001" when x"E" ,--d
"0111111" when x"F" ,---
"0111111" when x"0" ,---
"0111111" when x"1" ,---
"0111111" when others;---

end Behavioral;
