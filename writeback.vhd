library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity writeback is
port(
	clock : in std_logic;
	reset : in std_logic;
	IR: in std_logic_vector(31 downto 0);
	ALU_in: in std_logic_vector(31 downto 0);
	LMD: in std_logic_vector(31 downto 0); --load data to store in register
	rd: out std_logic_vector(4 downto 0); --This is destination register
	regwritedata: out std_logic_vector(31 downto 0) --This is data sent to register
);
end writeback;


architecture arch of writeback is
signal cycle_num: INTEGER := 0;
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if cycle_num > 3 then 
				if IR(6 downto 0) = "0110011" or IR(6 downto 0) = "0010011" then
					regwritedata <= ALU_in;
				elsif IR(6 DOWNTO 0) = "0000011" then --LW
					regwritedata <= LMD; --send to registers
				elsif IR(6 DOWNTO 0) = "0110111" then --LUI
					regwritedata <= ALU_in; --send to registers
				end if;
				rd <= IR(11 downto 7); --also send to registers
			end if;
			cycle_num <= cycle_num + 1;
		end if;
	end process;
end arch;