LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY registers IS
	PORT (
		clock: IN STD_LOGIC;
		storedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Comes from writeback stage
		destreg: IN STD_LOGIC_VECTOR (4 DOWNTO 0);	--Comes from writeback stage
		Areg:in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Comes from decode stage
		Breg:in STD_LOGIC_VECTOR (4 DOWNTO 0); --Comes from decode stage
		A: out STD_LOGIC_VECTOR (31 DOWNTO 0); --register A readdata sent to execute stage
		B: out STD_LOGIC_VECTOR (31 DOWNTO 0) --register B readdata sent to execute stage
	);
END registers;



architecture arch of registers is

TYPE reg_arr IS ARRAY(31 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
signal register_file : reg_arr;

signal cycle_num: INTEGER := 0;
	begin
	process(clock)
	begin
		if clock'event and clock = '0' then --READ FROM REGISTERS ON FALLING EDGE FOR NEW VALUES
			if cycle_num > 0 then
				A <= register_file(to_integer(unsigned(Areg)))(31 downto 0);
				B <= register_file(to_integer(unsigned(Breg)))(31 downto 0);
			end if;
		elsif clock'event and clock = '1' then	--WRITE TO REGISTERS ON RISING EDGE
			if cycle_num > 0 then	
				register_file(to_integer(unsigned(destreg)))(31 downto 0) <= storedata; --INSERT INSTRUCTION RESULT IN DESTINATION REGISTER
			end if;
			cycle_num <= cycle_num + 1;
		end if;
	end process;
end arch;