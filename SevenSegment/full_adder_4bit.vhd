LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity full_adder_4bit is
	PORT
	(
		hex_1 						: in std_logic_vector(3 downto 0);
		hex_2 						: in std_logic_vector(3 downto 0);
		CARRY_IN4					: in std_logic; ---0
		SUM_OUTPUT4					: out std_logic_vector(3 downto 0);
		CARRY_OUTPUT4				: out std_logic
	);
end full_adder_4bit;

ARCHITECTURE gates OF full_adder_4bit is


  component full_adder_1bit port (
		INPUT_A 						: IN std_logic;
		INPUT_B 						: IN std_logic;
		CARRY_IN						: in std_logic;
		FULL_ADDER_SUM_OUTPUT	: out std_logic;
		FULL_ADDER_CARRY_OUTPUT	: out std_logic
	);
	end component;
	
	
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	
	--signal hex_A		: std_logic_vector(3 downto 0);
	--signal hex_B		: std_logic_vector(3 downto 0);
	
	signal BUSA_B0 			: std_logic;
	signal BUSB_B0 			: std_logic;
	signal BUSA_B1 			: std_logic;
	signal BUSB_B1 			: std_logic;
	signal BUSA_B2 			: std_logic;
	signal BUSB_B2 			: std_logic;
	signal BUSA_B3 			: std_logic;
	signal BUSB_B3 			: std_logic;
	
	signal sum_out1			: std_logic;
	signal sum_out2			: std_logic;
	signal sum_out3			: std_logic;
	signal sum_out4			: std_logic;
	
	signal CARRY_out1			: std_logic;
	signal CARRY_out2			: std_logic;
	signal CARRY_out3			: std_logic;
	signal CARRY_out4			: std_logic;
	
-- Here the circuit begins

begin

	--hex_1 <= sw(3 downto 0);
	--hex_2 <= sw(7 downto 4);
	
--	BUSA_B0 <= hex_1(0);
--	BUSA_B1 <= hex_1(1);
--	BUSA_B2 <= hex_1(2);
--	BUSA_B3 <= hex_1(3);
--	
--	BUSA_B0 <= hex_2(0);
--	BUSA_B1 <= hex_2(1);
--	BUSA_B2 <= hex_2(2);
--	BUSA_B3 <= hex_2(3);
		
	
---seg7_data <= seg7_A;

--COMPONENT HOOKUP


--	INST1: full_adder_1bit port map(BUSA_B0, BUSB_B0, CARRY_IN4, sum_out1, CARRY_out1);
--	INST2: full_adder_1bit port map(BUSA_B1, BUSB_B1, CARRY_out1, sum_out2, CARRY_out2);
--	INST3: full_adder_1bit port map(BUSA_B2, BUSB_B2, CARRY_out2, sum_out3, CARRY_out3);
--	INST4: full_adder_1bit port map(BUSA_B3, BUSB_B3, CARRY_out3, sum_out4, CARRY_out4);
	
	INST1: full_adder_1bit port map(hex_1(0), hex_2(0), CARRY_IN4, sum_out1, CARRY_out1);
	INST2: full_adder_1bit port map(hex_1(1), hex_2(1), CARRY_out1, sum_out2, CARRY_out2);
	INST3: full_adder_1bit port map(hex_1(2), hex_2(2), CARRY_out2, sum_out3, CARRY_out3);
	INST4: full_adder_1bit port map(hex_1(3), hex_2(3), CARRY_out3, sum_out4, CARRY_out4);
	
	SUM_OUTPUT4 <= sum_out4 & sum_out3 & sum_out2 & sum_out1;
	CARRY_OUTPUT4 <= CARRY_out4;
 
end gates;

