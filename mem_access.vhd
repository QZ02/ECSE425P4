library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_access is
port(
	clock : in std_logic;
	reset : in std_logic;
	IR: in std_logic_vector(31 downto 0);
	A: in std_logic_vector(31 downto 0);
	B_in: in std_logic_vector(31 downto 0);
	ALU_in: in std_logic_vector(31 downto 0);
	cond_in: in std_logic;
	load_adr: out std_logic_vector(31 downto 0); --sent to data memory for load
	ALU_out: out std_logic_vector(31 downto 0); --sent forward to write back
	IR_out: out std_logic_vector(31 downto 0);	
	storedata: out std_logic_vector(31 downto 0); --sent to memory for store
	storeadr: out std_logic_vector(31 downto 0);	--sent to memory for store
	NPC: out std_logic_vector(31 downto 0);
	cond: out std_logic --sent back to IF
);
end mem_access;

architecture arch of mem_access is
signal cycle_num: INTEGER := 0;
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if cycle_num > 2 then
				if IR(6 downto 0) = "0110011" or IR(6 downto 0) = "0010011" then --R-type of I-type (no load)
					ALU_out <= ALU_in;
				elsif IR(6 downto 0) = "0000011" then --LW
					load_adr <= ALU_in;
				elsif IR(6 downto 0) = "0100011" then --SW
					storeadr <= ALU_in;
					storedata <= B_in;
				elsif IR(6 downto 0)= "0110111" then --LUI (saved to registers during writeback)
					 ALU_out <= ALU_in;
				elsif IR(6 downto 0) = "1100011" then --branch
					NPC <= ALU_in;
					cond <= cond_in;
				end if;
			end if;
			cycle_num <= cycle_num + 1;
		end if;
	end process;

	IR_out <= IR;
end arch;