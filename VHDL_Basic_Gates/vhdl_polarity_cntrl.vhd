Library ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
ENTITY vhdl_polarity_cntrl IS
		PORT (
				POLARITY_CNTRL, IN_1, IN_2, IN_3, IN_4	:IN std_logic;
				OUT1, OUT2, OUT3, OUT4	: OUT std_logic
				);
END vhdl_polarity_cntrl;

ARCHITECTURE simple_gates OF vhdl_polarity_cntrl IS

BEGIN

OUT1 <= POLARITY_CNTRL XNOR IN_1;
OUT2 <= POLARITY_CNTRL XNOR IN_2;
OUT3 <= POLARITY_CNTRL XNOR IN_3;
OUT4 <= POLARITY_CNTRL XNOR IN_4;

END simple_gates;