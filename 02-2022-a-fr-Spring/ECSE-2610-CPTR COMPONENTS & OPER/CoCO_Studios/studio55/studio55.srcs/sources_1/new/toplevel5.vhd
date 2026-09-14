library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel5 is
    Port ( sw : in STD_LOGIC_VECTOR (15 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           btnL : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnR : in STD_LOGIC);
end toplevel5;

architecture Behavioral of toplevel5 is

component a74x138decoder3to8 is
    Port ( input : in STD_LOGIC_VECTOR (2 downto 0);
           g1 : in STD_LOGIC;
           g2a : in STD_LOGIC;
           g2b : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (7 downto 0));
end component a74x138decoder3to8;

component a74x148priorityencoder8to3 is
    Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (2 downto 0);
           enableout : out STD_LOGIC;
           groupselect : out STD_LOGIC);
end component a74x148priorityencoder8to3;

    signal s0: STD_LOGIC;
    signal s1: STD_LOGIC;
    signal s2: STD_LOGIC;
    signal s3: STD_LOGIC;
    signal s4: STD_LOGIC;
    signal s5: STD_LOGIC;
    signal s6: STD_LOGIC;
    signal s7: STD_LOGIC;
    
begin

    encoder: a74x148priorityencoder8to3 
        PORT MAP (
            input(0) => sw(0),
            input(1) => sw(1),
            input(2) => sw(2),
            input(3) => sw(3),
            input(4) => sw(4),
            input(5) => sw(5),
            input(6) => sw(6),
            input(7) => sw(7),
            enable => sw(8),
            output(0) => LED(0),
            output(1) => LED(1),
            output(2) => LED(2),
            enableout => LED(3),
            groupselect => LED(4));
    
    decoder: a74x138decoder3to8
        PORT MAP (
            g1 => sw(10),
            g2a => sw(11),
            g2b => sw(12),
            input(0) => sw(13),
            input(1) => sw(14),
            input(2) => sw(15),
            output(0) => LED(8),
            output(1) => LED(9),
            output(2) => LED(10),
            output(3) => LED(11),
            output(4) => LED(12),
            output(5) => LED(13),
            output(6) => LED(14),
            output(7) => LED(15));
            
    decoder2: a74x138decoder3to8
        PORT MAP (
            g1 => '1',
            g2a => '0',
            g2b => '0',
            input(0) => btnR,
            input(1) => btnC,
            input(2) => btnL,
            output(0) => s0,
            output(1) => s1,
            output(2) => s2,
            output(3) => s3,
            output(4) => s4,
            output(5) => s5,
            output(6) => s6,
            output(7) => s7);

    LED(6) <= (NOT(s2 AND s3 AND s4 AND s5 AND s6));

end Behavioral;
