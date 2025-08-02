-- Author: Session 201, Group 2, Noemie Lamontagne, Sharisse Ji

library ieee;
use ieee.std_logic_1164.all;

------ SYNCHRONIZER ENTITY -------------
entity synchronizer is port (
	clk			: in std_logic;			-- external clock signal
	reset			: in std_logic := '0'; 	-- external reset signal
	din			: in std_logic;			-- external input
	dout			: out std_logic			-- returns a synchronized signal
  );
end synchronizer;
 

------ SYNCHRONIZER ARCHITECTURE --------
architecture circuit of synchronizer is
	Signal sreg	: std_logic_vector(1 downto 0); -- two stage shift register (two registers in series) 
	

-- FUNCTION: 	
-- the synchronizer takes an external input and clock signal
--	the synchronizer uses two registers staged in series with a common clock to synchronize the signals
-- the synchronizer will be used for several major components to create a SYNCHRONOUS design

-- Begin Synchronizer process
BEGIN

-- Sensitivity list: CLK
PROCESS (CLK) is 
begin

	if (rising_edge(CLK)) then -- with each rising edge of the clock
		if(RESET = '1') then
			sreg <= "00"; 			-- reset sreg to "00" when provided a reset signal
			
		else
			sreg(1) <= din; 		-- set the first  DFF of shift register ("bit" 1) to external input signal
			sreg(0) <= sreg(1); 	-- set the second DFF of shift register ("bit" 0) to the output of previous one
			
		end if;
	else
	end if;

end process;

	dout <= sreg(0); -- return output of second DFF
	
end circuit;