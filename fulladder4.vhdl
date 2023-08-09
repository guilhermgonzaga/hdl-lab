library ieee;
use ieee.std_logic_1164.all;

entity fulladder4 is
	port (
		a, b : in std_ulogic_vector(3 downto 0);
		cin  : in std_ulogic;
		sum  : out std_ulogic_vector(3 downto 0);
		cout : out std_ulogic
	);
end entity;

architecture structural of fulladder4 is
	signal carry: std_ulogic_vector(2 downto 0);
begin
	fa0: entity work.fulladder1(dataflow)
		port map (a => a(0), b => b(0), cin => '0', sum => sum(0), cout => carry(0));

	fa1: entity work.fulladder1(dataflow)
		port map (a => a(1), b => b(1), cin => carry(0) , sum => sum(1), cout => carry(1));

	fa2: entity work.fulladder1(dataflow)
		port map (a => a(2), b => b(2), cin => carry(1) , sum => sum(2), cout => carry(2));

	fa3: entity work.fulladder1(dataflow)
		port map (a => a(3), b => b(3), cin => carry(2) , sum => sum(3), cout => cout);

end architecture;
