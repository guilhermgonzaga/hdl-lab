library ieee;
use ieee.std_logic_1164.all;

entity shiftrotater is
	port (
		shift  : in std_ulogic;
		din    : in std_ulogic_vector(3 downto 0);
		desloc : in std_ulogic_vector(1 downto 0);
		dout   : out std_ulogic_vector(3 downto 0)
	);
end entity;

architecture structural of shiftrotater is
	signal sh1 : std_ulogic_vector(3 downto 0);
	signal sh2 : std_ulogic_vector(2 downto 0);
begin

	-- First level shifts by one
	mux2_00: entity work.mux2(dataflow)
		port map(din(0) => din(0), din(1) => din(3), sel => desloc(0), dout => sh1(0));

	mux2_01: entity work.mux2(dataflow)
		port map(din(0) => din(1), din(1) => din(0), sel => desloc(0), dout => sh1(1));

	mux2_02: entity work.mux2(dataflow)
		port map(din(0) => din(2), din(1) => din(1), sel => desloc(0), dout => sh1(2));

	mux2_03: entity work.mux2(dataflow)
		port map(din(0) => din(3), din(1) => din(2), sel => desloc(0), dout => sh1(3));

	-- Second level shifts by two
	mux2_10: entity work.mux2(dataflow)
		port map(din(0) => sh1(0), din(1) => sh1(2), sel => desloc(1), dout => sh2(0));

	mux2_11: entity work.mux2(dataflow)
		port map(din(0) => sh1(1), din(1) => sh1(3), sel => desloc(1), dout => sh2(1));

	mux2_12: entity work.mux2(dataflow)
		port map(din(0) => sh1(2), din(1) => sh1(0), sel => desloc(1), dout => sh2(2));

	mux2_13: entity work.mux2(dataflow)
		port map(din(0) => sh1(3), din(1) => sh1(1), sel => desloc(1), dout => dout(3));

	-- Finally change result to match operation
		dout(0) <= sh2(0) and not (shift and (desloc(0) or desloc(1)));
		dout(1) <= sh2(1) and not (shift and desloc(1));
		dout(2) <= sh2(2) and not (shift and desloc(0) and desloc(1));

end architecture;
