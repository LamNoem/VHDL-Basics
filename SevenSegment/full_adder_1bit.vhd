LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity full_adder_1bit is
	PORT
	(
		INPUT_A 						: in std_logic;
		INPUT_B 						: in std_logic;
		CARRY_IN						: in std_logic;
		FULL_ADDER_SUM_OUTPUT	: out std_logic;
		FULL_ADDER_CARRY_OUTPUT	: out std_logic
	);
end full_adder_1bit;

ARCHITECTURE gates OF full_adder_1bit is

BEGIN

FULL_ADDER_SUM_OUTPUT <= ((INPUT_B) XOR (INPUT_A)) XOR (CARRY_IN);
FULL_ADDER_CARRY_OUTPUT <= (INPUT_B AND INPUT_A) OR (CARRY_IN AND (INPUT_B XOR INPUT_A));


END gates;