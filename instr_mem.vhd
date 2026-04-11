LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY instr_memory IS
	GENERIC(
		max_bytes : INTEGER := 4096;	--1024 instr * 32 bits = 32768 instr bits, 1 byte/row = 4096 rows
		mem_delay : time := 1 ns; --1 cc delay
	);
	PORT (
		pc_im: IN INTEGER RANGE 0 TO max_bytes-1;
		instr : OUT STD_LOGIC_VECTOR(31 downto 0); 
	);
END instr_memory;

ARCHITECTURE rtl OF memory IS
	TYPE MEM IS ARRAY(max_instr-1 downto 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL im_block: MEM;

BEGIN
	mem_process: PROCESS (pc)
	BEGIN
		instr <= im_block(pc*8)(31 downto 0);
	END PROCESS;

END rtl;
