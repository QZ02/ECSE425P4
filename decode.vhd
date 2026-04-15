library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
port(
	clock : in std_logic;
	reset : in std_logic;
	IR : in std_logic_vector(31 downto 0);
	PC: in std_logic_vector(31 downto 0);
	WB: in std_logic_vector(31 downto 0); --write-back data to register from WB stage
	rd: in std_logic_vector(4 downto 0); --received from write back stage
	Areg:out std_logic_vector(4 downto 0);	--sent to registers
	Breg:out std_logic_vector(4 downto 0);	--sent to registers
	Imm: out std_logic_vector(31 downto 0);	--sent to execute stage
	IR_out: out std_logic_vector(31 downto 0);	--instruction copy for next stage
	NPC : out std_logic_vector(31 downto 0)	--PC copy for next stage
);
end decode;

architecture arch of decode is
signal cycle_num: INTEGER := 0;
	begin
	process(clock, reset)
	begin
		if (clock'event and clock = '1') then
			if cycle_num > 0 then
				--R,I,S,B types instructions
				if IR(6 downto 0) = "0110011" or IR(6 downto 0) = "0010011" or IR(6 downto 0) = "0000011" or IR(6 downto 0) = "0100011" or IR(6 downto 0) = "1100011" then
					Areg <= IR(19 downto 15);
				end if;
				--R,S,B type instructions
				if IR(6 downto 0) = "0110011" or IR(6 downto 0) = "0100011" or IR(6 downto 0) = "1100011" then
					Breg <= IR(24 downto 20);
				end if;
				--I-type instructions	
				if IR(6 downto 0) = "0010011" or IR(6 downto 0) = "0000011" then
					if IR(31)='1' then
						Imm <= "11111111111111111111" & IR(31 downto 20);
					else
						Imm <= "00000000000000000000" & IR(31 downto 20);
					end if;
				end if;
				--S-type instructions
				if IR(6 downto 0) = "0100011" then
					if IR(31)='1' then
						Imm <= "11111111111111111111" & IR(31 downto 25) & IR(11 downto 7);
					else
						Imm <= "00000000000000000000" & IR(31 downto 25) & IR(11 downto 7);
					end if;
				end if;
				--U-type instructions
				if IR(6 downto 0) = "0110111" or IR(6 downto 0) = "0010111" then
					Imm <= IR(31 downto 12) & "000000000000";
				end if;
				--J-type instruction
				if (IR(6 downto 0) = "1101111" or IR(6 downto 0) = "1100111") then --J-type
					Imm <= IR(31) & IR(19 downto 12) & IR(20) & IR(30 downto 21) & "000000000000";
				end if;
			end if;
			cycle_num <= cycle_num + 1;
		end if;
	end process;
	NPC <= PC;
	IR_out <= IR;
end arch;