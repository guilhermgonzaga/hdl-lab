library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity alarm is
	generic (
		N: natural
	);
	port (
		sensors: in std_logic_vector(0 to N-1);
		key: in std_logic;
		clock: in std_logic;
		siren: out std_logic
	);
end entity;

architecture behavioral of alarm is

	type state_t is (s_disabled, s_initializing, s_enabled, s_triggered, s_alarm);
	signal curr_state, next_state : state_t;
	signal track_time : std_logic := '0';
	signal time_passed : natural range 0 to 30 := 0;

begin

	update: process (clock)
	begin
		if rising_edge(clock) then
			curr_state <= next_state;
		end if;
	end process;

	transition: process (key, sensors, time_passed)
	begin
		case curr_state is
			when s_disabled =>
				if key = '0' then
					siren <= '0';
					next_state <= s_disabled;
				else
					track_time <= '1';
					next_state <= s_initializing;
				end if;
			when s_initializing =>
				if key = '0' then
					track_time <= '0';
					next_state <= s_disabled;
				else
					if time_passed = 30 then
						track_time <= '0';
						next_state <= s_enabled;
					end if;
				end if;
			when s_enabled =>
				if key = '0' then
					next_state <= s_disabled;
				else
					if or_reduce(sensors) = '1' then
						track_time <= '1';
						next_state <= s_triggered;
					end if;
				end if;
			when s_triggered =>
				if key = '0' then
					track_time <= '0';
					next_state <= s_disabled;
				else
					if time_passed = 30 then
						track_time <= '0';
						siren <= '1';
						next_state <= s_alarm;
					end if;
				end if;
			when s_alarm =>
				if key = '0' then
					siren <= '0';
					next_state <= s_disabled;
				end if;
		end case;
	end process;

	timer: process (clock, track_time)
	begin
		if falling_edge(track_time) then
			time_passed <= 0;
		else
			if rising_edge(clock) and time_passed < 30 then
				time_passed <= time_passed + 1;
			end if;
		end if;
	end process;

end architecture;
