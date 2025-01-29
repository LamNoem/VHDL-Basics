library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
	); 
   end component;
	
  component segment7_mux port (
	clk			: in std_logic := '0';
	DIN2			: in std_logic_vector(6 downto 0);
	DIN1			: in std_logic_vector(6 downto 0);
	DOUT			:out std_logic_vector(6 downto 0);
	DIG2			:out std_logic;
	DIG1			:out std_logic
	);
	end component;
	
  component PB_Inverters port (
	pb_n : IN std_logic_vector(3 downto 0);
	pb : OUT std_logic_vector(3 downto 0)
	);
	end component;
	
	
  component hex_mux_SLP port (
	hex_num1		: in std_logic_vector(3 downto 0);
	hex_num0 	: in std_logic_vector(3 downto 0);
	mux_select	: in std_logic_vector(1 downto 0);
	hex_out		:out std_logic_vector(3 downto 0)
	);
	end component;
	
	component full_adder_4bit port (
		hex_1 						: in std_logic_vector(3 downto 0);
		hex_2 						: in std_logic_vector(3 downto 0);
		CARRY_IN4					: in std_logic; ---0
		SUM_OUTPUT4					: out std_logic_vector(3 downto 0);
		CARRY_OUTPUT4				: out std_logic
	);
	end component;
	
	component hex_mux port (
		hex_num3,hex_num2,hex_num1,hex_num0 : in std_logic_vector(3 downto 0);
		mux_select									: in std_logic;
		hex_out1, hex_out2						:out std_logic_vector(3 downto 0) --hex output
	);
	end component;
	
	
	
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A		: std_logic_vector(6 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);
	
	signal hex_A		: std_logic_vector(3 downto 0);
	signal hex_B		: std_logic_vector(3 downto 0);
	
	signal pb 			: std_logic_vector(3 downto 0);
	signal select_SLP : std_logic_vector(1 downto 0);
	signal led_SLP		: std_logic_vector(3 downto 0);
	
	signal signal_C 	: std_logic_vector (3 downto 0);
	
	signal SUM_4			: std_logic_vector(3 downto 0);
	signal CARRY_4					:  std_logic;
	
	signal A			: std_logic_vector(3 downto 0);
	signal B			: std_logic_vector(3 downto 0);
	
	signal select_mux : std_logic;

	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);
	select_SLP <= pb(1 downto 0);
	select_mux <= pb(2);
	
---seg7_data <= seg7_A;

--COMPONENT HOOKUP
--
--generate the seven segment coding

	--INST6: full_adder_4bit port map(hex_A, HEX_B, '0', SUM_4, CARRY_4);
	INST6: full_adder_4bit port map(hex_A, hex_B, '0', SUM_4, CARRY_4);
	signal_C <= CARRY_4 & "000";
	
	INST7: hex_mux port map(hex_B, HEX_A, signal_C, SUM_4, select_mux, B, A );

	--INST1: SevenSegment port map(hex_A, seg7_A);
	--INST2: SevenSegment port map(hex_B, seg7_B);
	
	--INST1: SevenSegment port map(SUM_4, seg7_A);
	--INST2: SevenSegment port map(signal_C, seg7_B);
	
	INST1: SevenSegment port map(A, seg7_A);
	INST2: SevenSegment port map(B, seg7_B);
	
	--- mux needed to choose what goes to seg7a and seg7b
	-- what is seg7 data
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1);
	INST4: PB_Inverters port map(pb_n, pb);
	--INST5: hex_mux_SLP port map(hex_B, hex_A, select_SLP, led_SLP);
	INST5: hex_mux_SLP port map(hex_B, hex_A, select_SLP, leds(3 downto 0));
 
end SimpleCircuit;



