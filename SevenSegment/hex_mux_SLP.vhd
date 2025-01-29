library ieee;
use ieee.std_logic_1164.all;

entity hex_mux_SLP is
port(
	hex_num1				: in std_logic_vector(3 downto 0);
	hex_num0										: in std_logic_vector(3 downto 0);
	mux_select									: in std_logic_vector(1 downto 0);
	hex_out										:out std_logic_vector(3 downto 0) --hex output
);

end hex_mux_SLP;

architecture mux_logic of hex_mux_SLP is

begin
-- for the multiplexing of four hex input buses
	with mux_select(1 downto 0) select
	hex_out <= (hex_num0 AND hex_num1) when "00",
				  (hex_num0 OR hex_num1) when "01",
				  (hex_num0 XOR hex_num1) when "10",
				  (hex_num0 XNOR hex_num1) when "11";

end mux_logic;