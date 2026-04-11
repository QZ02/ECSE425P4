library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
generic(

);
port(
	clock : in std_logic;
	reset : in std_logic;
	instr : in std_logic_vector(31 downto 0);
	m_readdata : in std_logic_vector(31 downto 0);
	m_adr : out std_logic_vector (31 downto 0);
	m_read : out std_logic;
	m_write : out std_logic;
	m_writedata: out std_logic_vector(31 downto 0);
	m_writereq: out std_logic;
	pc : out integer:= 0;
);
end processor;


architecture arch of processor is

signal cycle_num: INTEGER := 0;
signal temp_pc: INTEGER := 0;
signal instr_reg: STD_LOGIC_VECTOR(31 downto 0);
signal branch: STD_LOGIC:='0';
--THE FOLLOWING SIGNALS ARE FOR INSTRUCTION BITS REGROUPING
signal opcode: STD_LOGIC_VECTOR(6 downto 0); --bits 0 to 6
signal rd:STD_LOGIC_VECTOR(4 downto 0); --rd, bits 7 to 11
signal imm12:STD_LOGIC_VECTOR(11 downto 0); --12 bit immediate value for type I,S,B
signal imm13:STD_LOGIC_VECTOR(12 downto 0); --13 bit immediate value for type B
signal funct3: STD_LOGIC_VECTOR(2 downto 0); --3 bit function identifier, bits 14 to 12
signal rs1: STD_LOGIC_VECTOR(5 downto 0); --source 1 bits 19 to 15
signal rs2: STD_LOGIC_VECTOR(5 downto 0); --source 2 bits 24 to 20
signal funct7: STD_LOGIC_VECTOR(7 downto 0); --7 bit function identifier, bits 31 to 25
signal imm32: STD_LOGIC_VECTOR(31 downto 0); --20 bit immediate value for type U, J


process (clock, reset)
begin

	--IF
	if branch = '0' then
		pc <= pc + 4;
	else
		pc <= pc + imm;--branch location destination here
	end if
	--ID
	if cycle_num > 0 then
		opcode <= instr(6 downto 0);
		if instr(6 downto 0) = "0110011" then --R-type
			rd <= instr(11 downto 7);
			funct3 <= instr(14 downto 12);
			rs1 <= instr(19 downto 15);
			rs2 <= instr(24 downto 20);
			funct7 <= instr(31 downto 25);
		elsif (instr(6 downto 0) = "0010011" or instr(6 downto 0) = "0000011") then --I-type
			rd <= instr(11 downto 7);
			funct3 <= instr(14 downto 12);
			rs1 <= instr(19 downto 15);
			imm12 <= instr(31 downto 20);
		elsif instr(6 downto 0) = "0100011" then --S-type (SW)
			imm12 <= instr(31 downto 25) & instr(11 downto 7);
			funct3 <= instr(14 downto 12);
			rs1 <= instr(19 downto 15);
			rs2 <= instr(24 downto 20);
		elsif instr(6 downto 0) = then --B-type
			imm12 <= instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8);
			funct3 <= instr(14 downto 12);
			rs1 <= instr(19 downto 15);
			rs2 <= instr(24 downto 20);
		elsif (instr(6 downto 0) = "1101111" or instr(6 downto 0) = "1100111") then --J-type
			rd <= instr(11 downto 7);
			imm32 <= instr(32) & instr(19 downto 12) & instr(19) & instr(30 downto 20)& "000000000000";	
		elsif (instr(6 downto 0) = "0110111" or instr(6 downto 0) = "0010111") then --U-type
			rd <= instr(11 downto 7);
			imm32 <= instr(31 downto 12) & "000000000000";
	end if;
	--EX
	if cycle_num > 1 then
	
	end if;
	--MEM
	if cycle_num > 2 then
	
	end if;
	--WB
	if cycle_num > 3 then
	
	end if;
	
	cycle_num = cycle_num + 1;
end process;


instr_reg <= instr;
end arch;
