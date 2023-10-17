library ieee;
use ieee.std_logic_1164.all;

entity serialtoparallel is
	generic (
		N: natural := 8
	);
	port (
		serial_in: in std_logic;
		clk: in std_logic;
		data_out: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture structural of serialtoparallel is
	signal din: std_logic_vector(N-1 downto 0) := (others => '0');
	signal dout: std_logic_vector(N-1 downto 0) := (others => '0');
begin

	reg: entity work.reg_n(behavioral)
		generic map (N => N)
		port map (clk => clk, data_in => din, data_out => dout);

	din(0) <= serial_in;
	din(N-1 downto 1) <= dout(N-2 downto 0);
	data_out <= dout;

end architecture;
