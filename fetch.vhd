library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
port(
	clock : in std_logic;
	reset : in std_logic;
	IR : in std_logic_vector(31 downto 0);
	branch: in std_logic;
	target_b: in std_logic_vector(31 downto 0);--This is new pc in case of branching, jump
	pc_out : out std_logic_vector(31 downto 0)
);
end fetch;


architecture arch of fetch is

signal cycle_num: INTEGER := 0;
begin
	process (clock, reset)
	begin
		if reset = '1' then
        pc_out <= "00000000000000000000000000000000";
		end if;
		if clock'event and clock = '1' then --Fetch instruction on rising edge
			if cycle_num > 0 then
				if branch /= '1' then --PC = PC + 4 if no branching
					pc_out <= std_logic_vector(unsigned(pc_in) + 4);
				else
					if cycle_num > 2 then --If we want to branch PC = target_b (Imm)
						pc_out <= target_b;--branch location destination here
					end if;
				end if;
			end if;
			cycle_num <= cycle_num + 1;
		end if;
	end process;
end arch;