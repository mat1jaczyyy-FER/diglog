library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity prijava is
    generic (
	C_jmbag: integer := 0036245680
    );
    port (
	clk_25m: in std_logic;
	led: out std_logic_vector(7 downto 0);
	sw: in std_logic_vector(3 downto 0);
	btn_up, btn_down, btn_left, btn_right, btn_center: in std_logic;
	rs232_tx: out std_logic
    );
end prijava;

architecture Behavioral of prijava is
    constant C_clk_freq: integer := 25;	-- clock frequency, in MHz
    constant C_baudrate: integer := 115200; -- in bits per second
    constant C_baud_init: std_logic_vector(15 downto 0) :=
      std_logic_vector(to_unsigned(
	C_baudrate * 2**10 / 1000 * 2**10 / C_clk_freq / 1000, 16));

    -- baud * 16 impulse generator
    signal R_baudrate: std_logic_vector(15 downto 0) := C_baud_init;
    signal R_baudgen: std_logic_vector(16 downto 0);

    -- transmit logic
    signal R_tx_tickcnt: std_logic_vector(3 downto 0);
    signal R_tx_phase: std_logic_vector(3 downto 0);
    signal R_tx_ser: std_logic_vector(8 downto 0) := (others => '1');

    -- JMBAG in ASCII
    type jmbag_type is array(0 to 31) of std_logic_vector(7 downto 0);

    function jmbag_to_ascii(jmbag: integer) return jmbag_type is
	variable r: jmbag_type;
	variable i, j: integer;
    begin
	i := 9;
	j := C_jmbag;
	while (i >= 0) loop
	    r(i) := x"30" + (j rem 10);
	    i := i - 1;
	    j := j / 10;
	end loop;
	r(10) := x"20";
	r(11) := x"30";
	r(12) := x"30";
	r(13) := x"30";
	r(14) := x"30";
	r(15) := x"20";
	r(16) := x"30";
	r(17) := x"30";
	r(18) := x"30";
	r(19) := x"30";
	r(20) := x"30";
	r(21) := x"0d";
	r(22) := x"0a";
	return r;
    end jmbag_to_ascii;
    
    signal M_jmbag: jmbag_type := jmbag_to_ascii(C_jmbag);
    signal R_pos: integer;
    signal R_cnt: std_logic_vector(25 downto 0);

begin

    rs232_tx <= R_tx_ser(0);
    led <= R_cnt(25 downto 18);

    process(clk_25m)
    begin
	if rising_edge(clk_25m) then
	    R_cnt <= R_cnt + 1;

	    -- initiate tx
	    if R_tx_phase = 0 and R_cnt(17 downto 0) = 0 then
		R_tx_phase <= x"1";
		R_tx_ser <= M_jmbag(R_pos) & '0';
		if R_pos >= 11 and R_pos <= 14 then
		    R_tx_ser(1) <= sw(14 - R_pos);
		end if;
		if R_pos = 16 then
		    R_tx_ser(1) <= btn_up;
		end if;
		if R_pos = 17 then
		    R_tx_ser(1) <= btn_down;
		end if;
		if R_pos = 18 then
		    R_tx_ser(1) <= btn_left;
		end if;
		if R_pos = 19 then
		    R_tx_ser(1) <= btn_right;
		end if;
		if R_pos = 20 then
		    R_tx_ser(1) <= btn_center;
		end if;
		if R_pos = 22 then
		    R_pos <= 0;
		else
		    R_pos <= R_pos + 1;
		end if;
	    end if;

	    -- baud generator
	    R_baudgen <= ('0' & R_baudgen(15 downto 0)) + ('0' & R_baudrate);

	    -- tx logic
	    if R_tx_phase /= x"0" and R_baudgen(16) = '1' then
		R_tx_tickcnt <= R_tx_tickcnt + 1;
		if R_tx_tickcnt = x"f" then
		    R_tx_ser <= '1' & R_tx_ser(8 downto 1);
		    R_tx_phase <= R_tx_phase + 1;
		end if;
	    end if;
	end if;
    end process;
end Behavioral;
