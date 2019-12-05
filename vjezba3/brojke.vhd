library ieee;
use ieee.std_logic_1164.all;

entity brojke is
	port (
		dm_down, dm_left, dm_center, dm_up, dm_right: in std_logic;
		dm_code: out std_logic_vector(7 downto 0)
	);
end brojke;

architecture behavioral of brojke is
    signal buttons: std_logic_vector(4 downto 0);

begin
	buttons <= dm_down & dm_left & dm_center & dm_up & dm_right;

    with buttons select
    dm_code <=
        "00000000" when "00000",
		"00000000" when "10000",
		"00110011" when "01000",
		"00110110" when "00100",
		"00110101" when "00010",
		"00110010" when "00001",
		"00110100" when "11000",
		"00110101" when "10100",
		"00110110" when "10010",
		"00111000" when "10001",
        "--------" when others;
end;