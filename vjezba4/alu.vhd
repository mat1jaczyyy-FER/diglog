library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu is
	port (
	   alu_a, alu_b: in std_logic_vector(3 downto 0);
	   alu_op: in std_logic_vector(2 downto 0);
	   alu_z: out std_logic_vector(3 downto 0)
	);
end alu;
	   
architecture behavioral of alu is
	signal mul: std_logic_vector(7 downto 0);

begin
	mul <= alu_a * alu_b;
	
	with alu_op select 
	alu_z <= 
	    mul(3 downto 0)      when "000",
	    alu_a XOR alu_b      when "001",
	    SHR(alu_a, alu_b)    when "010",
	    alu_a + alu_b        when "011",
	    alu_a OR alu_b       when "100",
	    alu_a - alu_b        when "101",
	    NOT (alu_a OR alu_b) when "110",
	    alu_a AND alu_b      when "111";
 
end;