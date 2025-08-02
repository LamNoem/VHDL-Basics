-- Author: Session 201, Group 2, Noemie Lamontagne, Sharisse Ji

library ieee;
use ieee.std_logic_1164.all;

------ HOLDING REGISTER ENTITY -------------
entity holding_register is port (
	clk					: in std_logic; -- external clock signal
	reset					: in std_logic; -- external reset signal
	register_clr		: in std_logic; -- clear holding register signal
	din					: in std_logic; -- external input
	dout					: out std_logic -- output signal
 );
end holding_register;

------ HOLDING REGISTER ARCHITECTURE --------
architecture circuit of holding_register is
	Signal sreg			: std_logic;

-- FUNCTION: 
-- Captures a signal (din), keeping it ON until it receives a clear signal (register_clr) from the state machine
-- A shift register with one DFF and dataflow logic to hold the signal until clear is received

-- Begin Synchronizer process
BEGIN

-- Sensitivity list: CLK
PROCESS (CLK) is
begin
	if (rising_edge(CLK)) then 													-- with each rising edge of the global clock
		sreg <= (NOT(register_clr OR reset )) AND ((din) OR (sreg)); 	-- return input/current register signal and opposite of clear register/reset signal
	end if; 																				-- do not use an else signal in order to hold the signal

end process;

	dout <= sreg;
	
end circuit;