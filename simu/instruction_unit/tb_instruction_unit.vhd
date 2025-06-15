-- filepath: d:\cours\VHDL\Projet\Monocycle_ARM7TDMI\simu\instruction_unit\tb_instruction_unit.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_instruction_unit is
end tb_instruction_unit;

architecture sim of tb_instruction_unit is
    -- Component declaration
    component instruction_unit
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            Offset   : in std_logic_vector(23 downto 0);
            nPCsel   : in std_logic;
            Instr    : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal Offset   : std_logic_vector(23 downto 0) := (others => '0');
    signal nPCsel   : std_logic := '0';
    signal Instr    : std_logic_vector(31 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: instruction_unit
        port map (
            clk    => clk,
            rst    => rst,
            Offset => Offset,
            nPCsel => nPCsel,
            Instr  => Instr
        );

    -- Clock process
    clk_process : process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- Normal increment (nPCsel = 0)
        nPCsel <= '0';
        Offset <= (others => '0');
        wait for clk_period * 3;

        -- Branch (nPCsel = 1, Offset = 2)
        nPCsel <= '1';
        Offset <= std_logic_vector(to_signed(2, 24));
        wait for clk_period;

        -- Normal increment again
        nPCsel <= '0';
        Offset <= (others => '0');
        wait for clk_period * 2;

        -- Branch with negative offset (nPCsel = 1, Offset = -1)
        nPCsel <= '1';
        Offset <= std_logic_vector(to_signed(-2, 24));
        wait for clk_period;

        -- Finish simulation
        wait;
    end process;

end architecture;