library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_driver1 is
    Port ( inputs : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (6 downto 0));
end display_driver1;

architecture Behavioral of display_driver1 is

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
"0001001" when x"0" ,--H
"0000110" when x"1" ,--E
"1000111" when x"2" ,--L
"1000111" when x"3" ,--L
"1000000" when x"4" ,--O
"1111111" when x"5" ,-- 
"1000011" when x"6" ,--W(left)
"1100001" when x"7" ,--W(right)
"1000000" when x"8" ,--O
"0101111" when x"9" ,--r
"1000111" when x"A" ,--L
"0100001" when x"B" ,--d
"0111111" when x"C" ,---
"0111111" when x"D" ,---
"0111111" when x"E" ,---
"0111111" when others;---

end Behavioral;
