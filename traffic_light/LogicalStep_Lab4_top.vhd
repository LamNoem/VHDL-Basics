-- Author: Session 201, Group 2, Noemie Lamontagne, Sharisse Ji

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

------ TOP LEVEL ENTITY -------------
ENTITY LogicalStep_Lab4_top IS
   PORT(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
--	sm_clkenable: out std_logic;
--	blink_signal: out std_logic; 
--	EW_a			: out std_logic;
--	EW_g			: out std_logic;
--	EW_d			: out std_logic;
--	
--	NS_a			: out std_logic;
--	NS_g			: out std_logic;
--	NS_d			: out std_logic;
	
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digit selectors
	seg7_char2  : out	std_logic							-- seg7 digit selectors
	);
END LogicalStep_Lab4_top;


------ TOP LEVEL ARCHITECTURE -------------
ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

	-- COMPONENT DECLARATIONS FROM OTHER FILES
   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	-- bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); -- bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic; 							-- output to the right 7 segment display (NS)
			 DIG1			: out	std_logic							-- output to the left 7 segment display (EW)
   );
   end component;
	
   component clock_generator port (
			sim_mode			: in boolean;		-- used to select the clocking frequency for the output signals "sm_clken" and "blink".
			reset				: in std_logic;	
         clkin      		: in  std_logic;	-- input used for counter and register clocking
			sm_clken			: out	std_logic; 	-- output used to enbale the sm to advance by 1 clk.
			blink		  		: out std_logic  	-- output used for blink signal (1/4 the rate of the sm_clken)
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	: out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	: out	std_logic_vector (3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				: out	std_logic;							 
			pb_n_filtered	: in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector (3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
			clk				: in std_logic;	-- external clock signal
			reset				: in std_logic; 	-- external reset signal
			din				: in std_logic;	-- external input
			dout				: out std_logic	-- returns a synchronized signal
  );
   end component; 
	
  component holding_register port (
			clk				: in std_logic; 	-- external clock signal
			reset				: in std_logic; 	-- external reset signal
			register_clr	: in std_logic; 	-- clear holding register signal
			din				: in std_logic; 	-- external input
			dout				: out std_logic 	-- output signal
  );
  end component;			
  
  component State_Machine Port(
			-- INPUTS: global clock, global sync reset signal, sm clock signal, NS crossing requests, EW crossing requests, Offline switch
			clk_input, reset, CLK_EN, blink, req_ns, req_ew, OFFLINE: IN std_logic; 
			output1, output2	, output3				: OUT std_logic;	-- output red, amber, and green segments to NS (digit 2) respectively
			output4, output5, output6					: OUT std_logic;	-- output red, amber, and green segments to EW (digit 1) respectively
			reg_clr_ns, reg_clr_ew                	: OUT std_logic;  -- clear holding register for NS and EW respectively
			state                                 	: OUT std_logic_vector(3 downto 0); -- 4 bit current state number (binary)
			ns_green, ew_green                		: OUT std_logic	-- NS crossing display (NS is solid green) and EW crossing display (EW is solid green)
	);
END component;

----------------------------------------------------------------------------------------------------
-- SIGNALS AT THE TOP LEVEL
	CONSTANT	sim_mode								: boolean := FALSE;  				-- set to FALSE for FPGA compiles, set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst	: std_logic;							-- global reset values controlled by pbs
	SIGNAL sm_clken, blink_sig					: std_logic;							-- state machine clock enable signal, blink signal for 7 segment display 
	SIGNAL pb_n_filtered, pb					: std_logic_vector(3 downto 0); 	-- pb signals 
	SIGNAL SYNCD_1, SYNCD_3						: std_logic;							-- syncrhonized crossing requests for holding register
	SIGNAL A2, G2, D2,A1, G1, D1				: std_logic;							-- on/off values for individual red, amber, green segments 
	SIGNAL NS_display                      : std_logic_vector(6 downto 0); 	-- 7 bit concatenated signal for 7 segment digit 2 (NS)
	SIGNAL EW_display								: std_logic_vector(6 downto 0); 	-- 7 bit concatenated signal for 7 segment digit 2 (EW)
	signal NS_REQ                          : std_logic;							-- NS crossing request signal
	signal EW_REQ                          : std_logic;							-- EW crossing request signal
	signal NS_REG_CLR                      : std_logic;							-- signal to clear NS holding register for NS crossing requests
	signal EW_REG_CLR                      : std_logic;							-- signal to clear EW holding register for EW crossing requests
	SIGNAL STATE_NUM                       : std_logic_vector(3 downto 0);	-- 4 bit signal for current state num in binary, to be displayed on leds 7-4
	SIGNAL OFFLINE                         : std_logic;							-- signal for state machine identifying if offline mode is on
	SIGNAL ns_green                        : std_logic;							-- led signal for when NS is solid green (crossing signal displayed)
	SIGNAL ew_green                        : std_logic;							-- led signal for when EW is solid green (crossing signal displayed)
	
	
-- BEGIN TOP LEVEL CIRCUIT
BEGIN
----------------------------------------------------------------------------------------------------
-- INSTANCES AT THE TOP LEVEL

-- PB_FILTERS: filter signals from pb inputs
INST0: pb_filters			port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);

-- PB_INVERTERS: change all pb inputs to active high instead of active low using filtered pb signals
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);

-- GENERAL SYNCHRONIZER: sets the synchronization reset signal for all following instances
INST2: synchronizer     port map (clkin_50,'0', rst, synch_rst);	

-- CLOCK GENERATOR: changes depending on simulation/compiling to FPGA, generates the clock and blink_sig for the State Machine 
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);

-- HOLDING REGISTER: Holds NS and EW crossing requests, only returning NS_REQ and EW_REQ when receiving a register clear signal from State Machine
INST4: holding_register port map(clkin_50, synch_rst, NS_REG_CLR, SYNCD_1, NS_REQ ); -- NS Holding Register (states 8 and 9)
INST5: holding_register port map(clkin_50, synch_rst, EW_REG_CLR, SYNCD_3, EW_REQ);  -- EW Holding Register (states 0 and 1)

-- PB SYNCHRONIZER: takes crossing requests for NS and EW (allowing it to skip states in the state machine depending on combination and timing)
INST6: synchronizer port map(clkin_50, synch_rst, pb(0), SYNCD_1); -- NS Synchronizer
INST7: synchronizer port map(clkin_50, synch_rst, pb(1), SYNCD_3); -- EW Synchronizer

-- STATE MACHINE: Main traffic controller logic, takes in global clock, sync reset, SM clock enable and blink signal from clock gnerator
--		Takes inputs for NS and EW crossing requests from the holding register
--		Takes inputs for offline mode from inst10
--		Outputs 6 signals controlling each light, 3 for NS and 3 for EW
-- 	Outputs a clear register signal for NS and EW, telling the holding register to release the crossing requests
--		Outputs the current state number for visualization on the leds
INST8: State_Machine Port MAP(clkin_50, synch_rst, sm_clken, blink_sig, NS_REQ, EW_REQ, OFFLINE, A2, G2, D2, A1, G1, D1, NS_REG_CLR, EW_REG_CLR, STATE_NUM, ns_green, ew_green);

-- Concatenate multiple segments for the Seven Segment Display
NS_display <= G2 & '0'& '0'& D2 & '0'& '0'& A2; -- NS is on Dig2 (right on FPGA)
EW_display <= G1 & '0'& '0'& D1 & '0'& '0'& A1; -- EW is on Dig1 (left  on FPGA)

-- SEVEN SEGMENT MULTIPLEXER: takes the concatenated signals and multiplexes them into the Seven Segment Display
INST9: segment7_mux port map(clkin_50, NS_display, EW_display, seg7_data, seg7_char2, seg7_char1);

-- OFFLINE SWITCH: causes NS to eventually move to blink ambexes them to the Seven Segment 
INST10: synchronizer port map(clkin_50, synch_rst, sw(0), OFFLINE);

-- LED OUTPUTS
leds(7 downto 4) <= STATE_NUM; -- show the current state number on left 4 leds in binary
leds(3) <= EW_REQ;	-- turn on led 3 if there is pending EW crossing request
leds(1) <= NS_REQ;	-- turn on led 1   there is pending NS crossing request

leds(2) <= ew_green; -- show if there is an EW crossing display signal (solid)
leds(0) <= ns_green; -- show if there is an NS crossing display signal (solid)		


----------------------------------------------------------
-- SIMULATION SIGNAL HOOK UP : for simulation use ONLY, comment out for FPGA compiles
--
--sm_clkenable <= sm_clken;
--blink_signal <= blink_sig;
--NS_a <= A2;
--NS_g <= G2;
--NS_d <= D2;
--
--EW_a <= A1;
--EW_g <= G1;
--EW_d <= D1;
-----------------------------------------------------------


END SimpleCircuit;
