LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY instr_memory IS
	GENERIC(
		max_bytes : INTEGER := 4096	--1024 instr * 32 bits = 32768 instr bits, 1 byte/row = 4096 rows
	);
	PORT (
		clock: in std_logic;
		pc_im: IN std_logic_vector(31 downto 0);
		instr : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END instr_memory;

ARCHITECTURE arch OF instr_memory IS
	TYPE MEM IS ARRAY(max_bytes-1 downto 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	    SIGNAL im_block : MEM; --This is replaced by real instruction memory during simulation

BEGIN
	mem_process: PROCESS (clock)
	BEGIN
		if clock'event and clock = '0' then
			--This assembles the full instruction (little endian)
			instr <= im_block(to_integer(unsigned(pc_im))+3)(7 downto 0) & im_block(to_integer(unsigned(pc_im))+2)(7 downto 0) & im_block(to_integer(unsigned(pc_im))+1)(7 downto 0) & im_block(to_integer(unsigned(pc_im)))(7 downto 0);
		end if;	
	END PROCESS;
END arch;
