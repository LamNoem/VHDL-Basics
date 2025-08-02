-- Author: Session 201, Group 2, Noemie Lamontagne, Sharisse Ji

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------ STATE MACHINE ENTITY -------------
Entity State_Machine IS Port
(
	-- INPUTS: global clock, global sync reset signal, sm clock signal, NS crossing requests, EW crossing requests, Offline switch
	clk_input, reset, CLK_EN, blink, req_ns, req_ew, OFFLINE: IN std_logic; 
	output1, output2	, output3				: OUT std_logic;	-- output red, amber, and green segments to NS (digit 2) respectively
	output4, output5, output6					: OUT std_logic;	-- output red, amber, and green segments to EW (digit 1) respectively
	reg_clr_ns, reg_clr_ew                	: OUT std_logic;  -- clear holding register for NS and EW respectively
	state                                 	: OUT std_logic_vector(3 downto 0); -- 4 bit current state number (binary)
	ns_green, ew_green                		: OUT std_logic	-- NS crossing display (NS is solid green) and EW crossing display (EW is solid green)
 );
END ENTITY;
 

------ HOLDING REGISTER ARCHITECTURE --------
 Architecture SM of State_Machine is
 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12 , S13, S14, S15);   -- list all the STATE_NAMES 

 SIGNAL current_state, next_state	:  STATE_NAMES;     														-- two signals of type STATE_NAMES, control the MOORE machine
 

 BEGIN

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------
-- REGISTER SECTION PROCESS
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN		-- only consider signals when global clock is at the rising edge
		IF (reset = '1') THEN				-- if the reset signal is "on"
			current_state <= S0;				-- go back to the first state, s0
		ELSIF (CLK_EN = '1') THEN			-- otherwise
			current_state <= next_state; 	-- progress to the next state (next state is defined in transition_section)
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS (MOORE MACHINE)
-- Describes how to move between states using sequential logic
-- Unless otherwise stated with if-else statements, the state machine will move from n state to n+1 state (at s15 will go back to s0)

Transition_Section: PROCESS (OFFLINE, req_ns, req_ew, current_state) 

BEGIN
  CASE current_state IS
        WHEN S0 =>
				-- If EW request is made and there has not been a NS request
				if (req_ew = '1' AND (req_ns = '0')) then
					next_state <= S6; -- jump to S6 immediately
					
				-- Otherwise
				else 	
					next_state <= S1; -- set the next state to Sn+1 which is S1
				end if;

         WHEN S1 =>
				-- If EW request is made and there has not been a EW request
				if (req_ew = '1' AND (req_ns = '0')) then
					next_state <= S6; -- jump to S6 immediately
				
				-- Otherwise
				else 	
					next_state <= S2; -- set the next state to Sn+1 which is S2
				end if;

         WHEN S2 =>		
				next_state <= S3; 	-- set the next state to Sn+1, S3
				
         WHEN S3 =>		
				next_state <= S4; 	-- set the next state to Sn+1, S4

         WHEN S4 =>		
				next_state <= S5; 	-- set the next state to Sn+1, S5

         WHEN S5 =>		
				next_state <= S6; 	-- set the next state to Sn+1, S6
				
         WHEN S6 =>		
				next_state <= S7; 	-- set the next state to Sn+1, S7
				
         WHEN S7 =>		
				next_state <= S8; 	-- set the next state to Sn+1, S8
				
			WHEN S8 =>
				-- If NS request is made and there has not been an EW request
				if (req_ns = '1' AND (req_ew = '0')) then
					next_state <= s14; -- jump to state 14
					
				-- Otherwise
				else 
					next_state <= S9; -- set the next state to Sn+1, S9
				end if;
				
			WHEN S9 =>
				-- If NS request is made and there has not been an EW request		
				if (req_ns = '1' AND (req_ew = '0')) then
					next_state <= s14;-- jump to state 14
				
				-- Otherwise
				else 
					next_state <= S10;-- set the next state to Sn+1, S10
				end if;
				
			WHEN S10 =>		
				next_state <= S11;	-- set the next state to Sn+1, S11
					
			WHEN S11 =>		
				next_state <= S12;	-- set the next state to Sn+1, S12
					
			WHEN S12 =>		
				next_state <= S13;	-- set the next state to Sn+1, S13
					
			WHEN S13 =>		
				next_state <= S14;	-- set the next state to Sn+1, S14
				
			WHEN S14 =>		
				next_state <= S15;	-- set the next state to Sn+1, S15
					
			WHEN S15 =>	
				-- If offline switch is on
				if (OFFLINE = '1') then
					next_state <= S15; -- do not move to the next state, stay in state 15 until Offline = '0' (switch turned off)
				
				-- Otherwise
				else
					next_state <= S0; -- offline mode is off so go back to S0, continuing the cycle
				end if;
		
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS  (MOORE MACHINE)
-- Describes the outputs for each state

-- output 1,4 is for segment a red
-- output 2,5 is for segment g amber
-- output 3,6 is for segment d green

-- Sensitivty list (inputs): blink, OFFLINE, current_state

Decoder_Section: PROCESS (blink, OFFLINE, current_state) 

BEGIN
     CASE current_state IS
	      ------- STATE 0 -------
         WHEN S0 =>		
			output1 <= '0';  --  NS is not red
			output2 <= '0';  --  NS is not amber
			output3 <=blink; --  NS is blinking green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "0000";
			
			------- STATE 1 -------
         WHEN S1 =>		
			output1 <= '0';  --  NS is not red
			output2 <= '0';  --  NS is not amber
			output3 <=blink; --  NS is blinking green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "0001";			
			
			------- STATE 2 -------
         WHEN S2 =>		
			output1 <= '0'; -- NS is not red
			output2 <= '0'; -- NS is not amber
			output3 <= '1'; -- NS is solid green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '1'; -- NS is solid green (crossing signal displayed)
			ew_green <= '0'; -- EW is not solid green (no crossing signal)
			
			state <= "0010";
			
			------- STATE 3 -------
         WHEN S3 =>		
			output1 <= '0'; -- NS is not red
			output2 <= '0'; -- NS is not amber
			output3 <= '1'; -- NS is solid green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '1'; -- NS is solid green (crossing signal displayed)
			ew_green <= '0'; -- EW is not solid green (no crossing signal)
			
			state <= "0011";
			
			------- STATE 4 -------
         WHEN S4 =>		
			output1 <= '0'; -- NS is not red
			output2 <= '0'; -- NS is not amber
			output3 <= '1'; -- NS is solid green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '1'; -- NS is solid green (crossing signal displayed)
			ew_green <= '0'; -- EW is not solid green (no crossing signal)
			
			state <= "0100";
			
			------- STATE 5 -------
         WHEN S5 =>		
			output1 <= '0'; -- NS is not red
			output2 <= '0'; -- NS is not amber
			output3 <= '1'; -- NS is solid green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '1'; -- NS is solid green (crossing signal displayed)
			ew_green <= '0'; -- EW is not solid green (no crossing signal)
			
			state <= "0101";
			
			------- STATE 6 -------
         WHEN S6 =>		
			output1 <= '0'; -- NS is not red
			output2 <= '1'; -- NS is amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '1'; -- CLEAR NS crossing request 
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "0110";
			
			------- STATE 7 -------
         WHEN S7 =>		
			output1 <= '0'; -- NS is not red
			output2 <= '1'; -- NS is amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '1'; -- EW is red
			output5 <= '0'; -- EW is not amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "0111";
			
			------- STATE 8 -------
			WHEN S8 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red 
			output5 <= '0'; -- EW is not amber
			output6 <= blink; -- EW is blinking green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "1000";
			
			------- STATE 9 -------
			WHEN S9 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red 
			output5 <= '0'; -- EW is not amber
			output6 <= blink; -- EW is blinking green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "1001";
			
			------- STATE 10 -------
			WHEN S10 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red 
			output5 <= '0'; -- EW is not amber
			output6 <= '1'; -- EW is solid green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '1'; -- EW is solid green (crossing signal displayed)
			
			state <= "1010";
			
			------- STATE 11 -------			
			WHEN S11 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red 
			output5 <= '0'; -- EW is not amber
			output6 <= '1'; -- EW is solid green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '1'; -- EW is solid green (crossing signal displayed)
			
			state <= "1011";
			
			------- STATE 12 -------
			WHEN S12 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red 
			output5 <= '0'; -- EW is not amber
			output6 <= '1'; -- EW is solid green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '1'; -- EW is solid green (crossing signal displayed)
			
			state <= "1100";
			
			------- STATE 13 -------
			WHEN S13 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red 
			output5 <= '0'; -- EW is not amber
			output6 <= '1'; -- EW is solid green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '1'; -- EW is solid green (crossing signal displayed)
			
			state <= "1101";
			
			------- STATE 14 -------
			WHEN S14 =>		
			output1 <= '1'; -- NS is red
			output2 <= '0'; -- NS is not amber
			output3 <= '0'; -- NS is not green
			
			output4 <= '0'; -- EW is not red
			output5 <= '1'; -- EW is amber
			output6 <= '0'; -- EW is not green
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '1'; -- CLEAR EW crossing request
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
			
			state <= "1110";
			
			------- STATE 15 -------
			WHEN S15 =>		
			
			reg_clr_ns <= '0'; -- no NS clearing signal
			reg_clr_ew <= '0'; -- no EW clearing signal
			
			ns_green <= '0'; -- NS is not solid green (no cross signal)
			ew_green <= '0'; -- EW is not solid green (no cross signal)
						
			state <= "1111"; 
			
			if ( OFFLINE = '1') then
				output1 <= blink; -- NS is red blinking
				output2 <= '0'; 	-- NS is not amber
				output3 <= '0'; 	-- NS is not green
				
				output4 <= '0';   -- EW is not red
				output5 <= blink; -- EW is amber blinking
				output6 <= '0';	-- EW is not green
			else
				output1 <= '1'; -- NS is red
				output2 <= '0'; -- NS is not amber
				output3 <= '0'; -- NS is not green
			
				output4 <= '0'; -- EW is not red
				output5 <= '1'; -- EW is amber
				output6 <= '0'; -- EW is not green
				
			end if;
        
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;