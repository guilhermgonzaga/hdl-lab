library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity parking_lot is
	generic ( max: natural );

	port (
		a, b: in std_logic;
		clock, reset: in std_logic;

		ncars: out natural;
		full: out std_logic
	);
end entity;

architecture behavioral of parking_lot is

	type state_t is (initial, entering1, entering2, entering3, leaving1, leaving2, leaving3);
	signal curr_state, next_state: state_t := initial;
	signal aux_ncars: natural := 0;
	signal aux_full: std_logic := '0';

begin

	process (clock)
	begin
		if rising_edge(clock) then
			ncars <= aux_ncars;
			full <= aux_full;
			curr_state <= next_state;
		end if;
	end process;

	process(reset, a, b)
	begin
		if reset = '1' then
			aux_ncars <= 0;
			aux_full <= '0';
			next_state <= initial;
		else
			case curr_state is
				when initial =>

					if rising_edge(a) then
						next_state <= entering1;
					elsif rising_edge(b) then
						next_state <= leaving1;
					end if;

				when entering1 =>

					if rising_edge(b) then
						next_state <= entering2;
					elsif falling_edge(a) then
						next_state <= initial;
					end if;

				when entering2 =>

					if falling_edge(a) then
						next_state <= entering3;
					elsif falling_edge(b) then
						next_state <= entering1;
					end if;

				when entering3 =>

					if falling_edge(b) then
						aux_ncars <= aux_ncars + 1;
						if aux_ncars + 1 >= max then
							aux_full <= '1';
						else
							aux_full <= '0';
						end if;
						next_state <= initial;
					elsif rising_edge(a) then
						next_state <= entering2;
					end if;

				when leaving1 =>

					if rising_edge(a) then
						next_state <= leaving2;
					elsif falling_edge(b) then
						next_state <= initial;
					end if;

				when leaving2 =>

					if falling_edge(b) then
						next_state <= leaving3;
					elsif falling_edge(a) then
						next_state <= leaving1;
					end if;

				when leaving3 =>

					if falling_edge(a) then
						aux_ncars <= aux_ncars - 1;
						if aux_ncars - 1 >= max then
							aux_full <= '1';
						else
							aux_full <= '0';
						end if;
						next_state <= initial;
					elsif rising_edge(b) then
						next_state <= leaving2;
					end if;

			end case;
		end if;
	end process;

end architecture;
