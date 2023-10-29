library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity washcontrol is
	port (
		inicia, cheia, tempo, vazia: in std_logic;
		clock: in std_logic;

		entrada_agua: out std_logic;
		aciona_motor: out std_logic;
		saida_agua: out std_logic
	);
end entity;

architecture behavioral of washcontrol is

	type state_t is (e_ociosa, e_enchendo, e_lavando, e_esvaziando);
	signal estado_atual, prox_estado : state_t := e_ociosa;

begin

	update: process (clock)
	begin
		if rising_edge(clock) then
			estado_atual <= prox_estado;
		end if;
	end process;

	transition: process (estado_atual, inicia, cheia, tempo, vazia)
	begin
		case estado_atual is
			when e_ociosa =>
				entrada_agua <= '0';
				aciona_motor <= '0';
				saida_agua <= '0';
				if rising_edge(inicia) then
					prox_estado <= e_enchendo;
				end if;

			when e_enchendo =>
				entrada_agua <= '1';
				aciona_motor <= '0';
				saida_agua <= '0';
				if rising_edge(cheia) then
					prox_estado <= e_lavando;
				end if;

			when e_lavando =>
				entrada_agua <= '0';
				aciona_motor <= '1';
				saida_agua <= '0';
				if rising_edge(tempo) then
					prox_estado <= e_esvaziando;
				end if;

			when e_esvaziando =>
				entrada_agua <= '0';
				aciona_motor <= '0';
				saida_agua <= '1';
				if rising_edge(vazia) then
					prox_estado <= e_ociosa;
				end if;
		end case;
	end process;

end architecture;
