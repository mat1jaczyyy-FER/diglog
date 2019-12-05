library ieee;
use ieee.std_logic_1164.all;

entity slova is
    port (
		btn_down, btn_left, btn_center, btn_up, btn_right: in std_logic;
		rs232_tx: out std_logic;
		clk_25m: in std_logic;
		led: out std_logic_vector(7 downto 0);
		sw: in std_logic_vector(3 downto 0)
    );
end slova;

architecture behavioral of slova is
    signal code: std_logic_vector(7 downto 0);
    signal slova: std_logic_vector(7 downto 0);
    signal brojke: std_logic_vector(7 downto 0);
    signal buttons: std_logic_vector(4 downto 0);

begin
	buttons <= btn_down & btn_left & btn_center & btn_up & btn_right;

    with buttons select
    slova <=
		"00000000" when "00000",
		"00000000" when "10000",
		"01000100" when "01000",
		"01101111" when "00100",
		"01101101" when "00010",
		"01101001" when "00001",
		"01001101" when "11000",
		"01100001" when "10100",
		"01110100" when "10010",
		"01101001" when "10001",
		"--------" when others;
	
	with sw(0) select
	code <=
		slova when '0',
		brojke when '1';

    led <= code;

    serializer: entity serial_tx port map (
		byte_in => code,
		clk => clk_25m,
		ser_out => rs232_tx
    );
	
	brojke_serializer: entity brojke port map (
		dm_down => btn_down,
		dm_left => btn_left,
		dm_center => btn_center,
		dm_right => btn_right,
		dm_up => btn_up,
		dm_code => brojke
	);
end;