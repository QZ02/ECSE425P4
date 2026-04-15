library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
port(
	clock : in std_logic;
	reset : in std_logic;
	NPC: in std_logic_vector(31 downto 0);
	IR: in std_logic_vector(31 downto 0);
	A: in std_logic_vector(31 downto 0);--from registers
	B: in std_logic_vector(31 downto 0);--from registers
	Imm: in std_logic_vector(31 downto 0);--from decode
	ALU_out: out std_logic_vector(31 downto 0);--operation/function result
	IR_out: out std_logic_vector(31 downto 0);--copy instruction sent to next stage
	B_out: out std_logic_vector(31 downto 0); --conserve for load instructions
	condition: out std_logic --branch condition control bit 
);
end execute;

architecture arch of execute is
signal cycle_num: INTEGER := 0;
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if cycle_num > 1 then
			--"ALU" will handle R and I-type instructions (except for loads)
				if IR(6 downto 0) = "0110011" then --R-type
					if IR(14 downto 12) = "000" then --Check funct3
						if IR(31 downto 25) = "0000000" then --Check funct7
							ALU_out <= std_logic_vector(signed(A) + signed(B)); --A + B
						elsif IR(31 downto 25) = "0100000" then
							ALU_out <= std_logic_vector(signed(A) - signed(B));-- A - B
						end if;
					elsif IR(14 downto 12) = "100" then -- IR(14 DOWNTO 12) is funct3, "100" is A XOR B
						ALU_out <= A XOR B;
					elsif IR(14 downto 12) = "110" then -- "110" is A OR B
						ALU_out <= A OR B;
					elsif IR(14 downto 12) = "111" then --"111" is A AND B
						ALU_out <= A AND B;
					elsif IR(14 downto 12) = "001" then --001 is sll
						ALU_out <= std_logic_vector(shift_left(unsigned(A),to_integer(unsigned(B))));
					elsif IR(14 downto 12) = "101" then --0x5
						if IR(31 downto 25) = "0000000" then --Check funct7
							ALU_out <= std_logic_vector(shift_right(unsigned(A),to_integer(unsigned(B)))); --srl
						elsif IR(31 downto 25) = "0100000" then
							ALU_out <= std_logic_vector(shift_right(signed(A),to_integer(unsigned(B)))); --sra
						end if;
					end if;
				elsif IR(6 downto 0) = "0010011" then --I-type (no load)
					if IR(14 downto 12) = "000" then --addi
						ALU_out <= std_logic_vector(signed(A) + signed(Imm));
					elsif IR(14 downto 12) = "100" then --xori
						ALU_out <= A XOR Imm;
					elsif IR(14 downto 12) = "110" then --ori
						ALU_out <= A OR Imm;
					elsif IR(14 downto 12) = "111" then --andi
						ALU_out <= A AND Imm;
					elsif IR(14 downto 12) = "010" then --slti
						if signed(A) < signed(Imm) then
							ALU_out <= "00000000000000000000000000000001";
						else
							ALU_out <= "00000000000000000000000000000000";
						end if;
					end if;
				elsif IR(6 DOWNTO 0) = "0000011" or IR(6 DOWNTO 0) = "0100011" then --LW or SW
					ALU_out <= std_logic_vector(signed(A) + signed(Imm));
					B_out <= B;
				elsif IR(6 downto 0) = "1100011" then --Branch beq, bne, blt, bge
					ALU_out <= std_logic_vector(signed(NPC) + shift_left(signed(Imm), 1)); 
					if (IR(14 downto 12) = "000" AND (A = B)) OR (IR(14 downto 12) = "001" AND (A /= B)) OR (IR(14 downto 12) = "100" AND (A < B)) OR (IR(14 downto 12) = "101" AND (A >= B))then --VERIFY IF BRANCH CONDITION IS MET
						condition <= '1';
					else
						condition <= '0';
					end if;
				elsif IR(6 downto 0) = "0110111" then --LUI
					ALU_out <= Imm;
				end if;
			end if;
			cycle_num <= cycle_num + 1;	
		end if;
	end process;
	IR_out <= IR;
end arch;