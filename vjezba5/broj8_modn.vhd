library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity broj is
    generic (
        MIN_VALUE: std_logic_vector(7 downto 0) := x"03";
        MAX_VALUE: std_logic_vector(7 downto 0) := x"0D"
    );
    port (
		clk_25m: in std_logic;
		btn_down, btn_up, btn_center: in std_logic;
		led: out std_logic_vector(7 downto 0)
    );
end broj;

architecture x of broj is
    signal R: std_logic_vector(7 downto 0);
    signal clk: std_logic;

begin
    upravljac: entity upravljac
    port map (
		Clk_key => btn_down,
		AddrA_key => '0',
		AddrB_key => '0',
		ALUOp_key => '0',
		clk_25m => clk_25m,
		AddrA => open,
		AddrB => open,
		ALUOp => open,
		Clk => clk
    );
	
    process(clk, btn_up, btn_center)
    begin
		if btn_up = '1' then
			if rising_edge(clk) then
				R <= R + 1;
			end if;
			
			if btn_center = '1' or R < MIN_VALUE or R >= MAX_VALUE then
				R <= MIN_VALUE;
			end if;
		end if;
    end process;

    led <= R;
end x;
