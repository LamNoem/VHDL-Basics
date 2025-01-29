--library ieee;
--use ieee.std_logic_1164.all;
--
--entity hex_mux is
--port(
--	hex_num3,hex_num2,hex_num1,hex_num0 : in std_logic_vector(3 downto 0);
--	mux_select									: in std_logic_vector(1 downto 0);
--	hex_out									:out std_logic_vector(3 downto 0) --hex output
--);
--
--end hex_mux;
--
--architecture mux_logic of hex_mux is
--
--begin
---- for the multiplexing of four hex input buses
--	with mux_select(1 downto 0) select
--	hex_out <= hex_num0 when "00",
--				  hex_num1 when "01",
--				  hex_num2 when "10",
--				  hex_num3 when "11";
--
--end mux_logic;

library ieee;
use ieee.std_logic_1164.all;

entity hex_mux is
port(
	hex_num3,hex_num2,hex_num1,hex_num0 : in std_logic_vector(3 downto 0);
	mux_select									: in std_logic;
	hex_out1, hex_out2						:out std_logic_vector(3 downto 0) --hex output
);

end hex_mux;

architecture mux_logic of hex_mux is

begin
-- for the multiplexing of four hex input buses
	with mux_select select
	hex_out1 <= hex_num3 when '0',
				  hex_num1 when '1';
	with mux_select select			  
	hex_out2 <= hex_num2 when '0',
					hex_num0 when '1';
				  

end mux_logic;

