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

process (clock, reset)
begin

	--IF
	
	--ID
	if cycle_num > 0 then
	
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

end arch;