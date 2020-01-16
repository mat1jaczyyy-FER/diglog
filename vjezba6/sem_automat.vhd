library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sem_automat is
    port(
		clk, vanjski_reset: in std_logic;
		aR, aY, aG, pR, pG: out std_logic
    );
end sem_automat;

architecture mix_moore_mealy of sem_automat is
    type sem_rom_type is array(0 to 7) of std_logic_vector(4 downto 0);
    constant moore_rom: sem_rom_type := (
		"01000",
		"00000",
		"01010",
		"10010",
		"10001",
		"10010",
		"11010",
		"00110",
		others => "-----" 
    );

    signal R_timer: std_logic_vector(7 downto 0);
    signal R_stanje: std_logic_vector(2 downto 0);

    signal mijenjaj_stanje: std_logic;
	signal novo_stanje: std_logic_vector(2 downto 0);
    signal moore_rom_out: std_logic_vector(4 downto 0);

begin
    process(clk, mijenjaj_stanje)
    begin
	if rising_edge(clk) then
	    if mijenjaj_stanje = '1' then
			R_timer <= 0;
	    else
			R_timer <= R_timer + 1;
	    end if;
	end if;
    end process;

	novo_stanje <=
		"000" when vanjski_reset = '1' and R_stanje /= 0 else
		"010" when R_stanje = 7 else
		R_stanje + 1;

    process(clk, mijenjaj_stanje)
    begin
		if rising_edge(clk) and mijenjaj_stanje = '1' then
			R_stanje <= novo_stanje;
		end if;
    end process;

    mijenjaj_stanje <= '1' when
		vanjski_reset = '1' or
		R_stanje = 0 or
		R_stanje = 1 or
		(R_stanje = 2 and R_timer = 4) or
		(R_stanje = 3 and R_timer = 3) or
		(R_stanje = 4 and R_timer = 8) or
		(R_stanje = 5 and R_timer = 4) or
		(R_stanje = 6 and R_timer = 3) or
		(R_stanje = 7 and R_timer = 13)
		else '0';

    moore_rom_out <= moore_rom(conv_integer(R_stanje));
    aR <= moore_rom_out(4);
    aY <= moore_rom_out(3);
    aG <= moore_rom_out(2);
    pR <= moore_rom_out(1);
    pG <= moore_rom_out(0);
end mix_moore_mealy;
