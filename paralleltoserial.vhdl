library ieee;
use ieee.std_logic_1164.all;

entity paralleltoserial is
	generic(
		N: natural := 8
	);
	port(
		data_in: in std_logic_vector(N-1 downto 0);
		serialize_load: in std_logic; -- 1 = serialize, 0 = load
		clk: in std_logic;
		serial_out: out std_logic
	);
end entity;

architecture structural of paralleltoserial is

	signal ffout: std_logic_vector(N-1 downto 0) := (others => '0');
	signal ffin: std_logic_vector(N-1 downto 0) := (others => '0');

begin

	reg: entity work.reg_n(behavioral)
		generic map (N => N)
		port map (clk => clk, data_in => ffin, data_out => ffout);

	genmux: for i in 1 to N-1 generate
		ffin(i) <= ffout(i-1) when serialize_load = '1'
		      else data_in(i) when serialize_load = '0';
	end generate;

	ffin(0) <= not serialize_load and data_in(0);
	serial_out <= ffout(N-1);

end architecture;
