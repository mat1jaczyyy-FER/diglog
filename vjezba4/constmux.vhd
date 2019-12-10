library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity constmux is
    port (
		addr: in std_logic;
		reg, switches: in std_logic_vector(3 downto 0);
		result: out std_logic_vector(3 downto 0)
    );
end constmux;

architecture behavioral of constmux is

begin
    with addr select
    result <=
	    reg      when '0',
		switches when '1';
end;

