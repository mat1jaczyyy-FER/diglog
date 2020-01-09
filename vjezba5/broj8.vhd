library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity broj is
    port (
		btn_down: in std_logic;
		led: out std_logic_vector(7 downto 0)
    );
end broj;

architecture x of broj is
    signal R: std_logic_vector(7 downto 0);

begin
	R <= R + 1 when rising_edge(btn_down);

    led <= R;
end x;
