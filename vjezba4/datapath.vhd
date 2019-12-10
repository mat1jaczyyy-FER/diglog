library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity datapath is
    port (
		btn_left, btn_right, btn_center, btn_up, btn_down: in std_logic;
		sw: in std_logic_vector(3 downto 0);
		clk_25m: in std_logic;
		led: out std_logic_vector(7 downto 0)
    );
end datapath;

architecture behavioral of datapath is
    signal signal_addr_a, signal_addr_b: std_logic_vector(1 downto 0);
    signal signal_op: std_logic_vector(2 downto 0);
    signal signal_clk: std_logic;
    signal signal_reg, signal_alu_a, signal_alu_z, signal_alu_b: std_logic_vector(3 downto 0);

begin
    spoj_regfile: entity reg_file port map (
		AddrA => signal_addr_a,
		AddrB => signal_addr_b,
		AddrW => signal_addr_a,
		WE => '1',
		Clk => signal_clk,
		A => signal_alu_a,
		B => signal_reg,
		W => signal_alu_z
	);

    spoj_upravljac: entity upravljac port map (
		Clk_key => btn_up,
		AddrA_key => btn_left,
		AddrB_key => btn_right,
		ALUOp_key => btn_down,
		AddrA => signal_addr_a,
		AddrB => signal_addr_b,
		ALUOp => signal_op,
		Clk => signal_clk,
		clk_25m => clk_25m
    );
    
    spoj_alu: entity alu port map(
	    alu_a => signal_alu_a,
	    alu_b => signal_alu_b,
	    alu_op => signal_op,
	    alu_z => signal_alu_z
	);
	
    led <= signal_addr_a & signal_addr_b & signal_clk & signal_op when btn_center = '0' else signal_alu_a & signal_reg;
    
    with signal_addr_b select
    signal_alu_b <=
		sw         when "00",
	    signal_reg when others;
end;

