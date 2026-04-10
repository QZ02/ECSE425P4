LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY instr_memory IS
	GENERIC(
		max_bytes : INTEGER := 4096;	--1024 instr * 32 bits = 32768 instr bits, 1 byte/row = 4096 rows
		mem_delay : time := 1 ns; --1 cc delay
		clock_period : time := 1 ns --1 GHz frequency
	);
	PORT (
		clock: IN STD_LOGIC;
		pc_im: IN INTEGER RANGE 0 TO max_bytes-1;
		fetch: IN STD_LOGIC;
		instr : OUT STD_LOGIC_VECTOR(31 downto 0); 
		waitrequest: OUT STD_LOGIC;
	);
END instr_memory;

ARCHITECTURE rtl OF memory IS
	TYPE MEM IS ARRAY(max_instr-1 downto 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL im_block: MEM;
	SIGNAL waitreq_reg: STD_LOGIC := '1';

BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			For i in 0 to ram_size-1 LOOP
				im_block(i) <= std_logic_vector(to_unsigned(i,8));
			END LOOP;
		end if;

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (fetch = '1') THEN
				instr <= im_block(pc*8)(31 downto 0);
			END IF;
	
		END IF;
	END PROCESS;

	--The waitrequest signal is used to vary response time in simulation
	waitreq_w_proc: PROCESS (fetch)
	BEGIN
		IF(fetch'event AND fetch = '1')THEN
			waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;

	waitrequest <= waitreq_reg;


END rtl;
