library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity broj is
    port (
		clk_25m: in std_logic;
		btn_down, btn_left: in std_logic;
		sw: in std_logic_vector(3 downto 0);
		led: out std_logic_vector(7 downto 0)
    );
end broj;

architecture x of broj is
    signal R, delta: std_logic_vector(31 downto 0);

begin
	R <= R + delta when rising_edge(clk_25m) and btn_left = '1';

    delta <= x"0000000" & sw;

    led <= R(31 downto 24) when btn_down = '0' else R(23 downto 16);
end x;
