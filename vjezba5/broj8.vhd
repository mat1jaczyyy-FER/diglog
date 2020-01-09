library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity broj is
    port (
		clk_25m: in std_logic;
		btn_down: in std_logic;
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
	
	R <= R + 1 when rising_edge(clk);

    led <= R;
end x;
