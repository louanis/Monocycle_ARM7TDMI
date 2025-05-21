-- filepath: c:\Users\yanis\Cours\3A\S6\VHDL S6\Projet\Monocycle_ARM7TDMI\Register.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register is
    port(
        CLK   : in std_logic;
        Reset : in std_logic;
        W     : in std_logic_vector(31 downto 0);
        RA    : in std_logic_vector(3 downto 0);
        RB    : in std_logic_vector(3 downto 0);
        RW    : in std_logic_vector(3 downto 0);
        WE    : in std_logic;
        A     : out std_logic_vector(31 downto 0);
        B     : out std_logic_vector(31 downto 0)
    );
end Register;

architecture rtl of Register is
    type reg_array is array (15 downto 0) of std_logic_vector(31 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    process(CLK, Reset)
    begin
        if Reset = '1' then
            regs <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            if WE = '1' then
                regs(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;

    A <= regs(to_integer(unsigned(RA)));
    B <= regs(to_integer(unsigned(RB)));
end rtl;