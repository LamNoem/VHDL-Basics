-- Author: Session 201, Group 2, Noemie Lamontagne, Sharisse Ji

library ieee;
use ieee.std_logic_1164.all;

----- PB Inverter Entity 	----------
entity PB_inverters is port (
	rst_n				: in	std_logic;
	rst				: out std_logic;
 	pb_n_filtered	: in  std_logic_vector (3 downto 0);
	pb					: out	std_logic_vector (3 downto 0)							 
	); 
end PB_inverters;

----- PB Inverter Architecture ------
architecture ckt of PB_inverters is


begin
rst <= NOT(rst_n);			-- Invert the reset inputs
pb <= NOT(pb_n_filtered);  -- Invert the filtered pb_n inputs

end ckt;