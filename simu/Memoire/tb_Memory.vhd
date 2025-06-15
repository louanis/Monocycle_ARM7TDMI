library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Memory is
end entity;

architecture sim of tb_Memory is

    -- Signals for DUT
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal dataIn  : std_logic_vector(31 downto 0) := (others => '0');
    signal dataOut : std_logic_vector(31 downto 0);
    signal addr    : std_logic_vector(5 downto 0) := (others => '0');
    signal wrEn    : std_logic := '0';

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- DUT instantiation
    DUT: entity work.memoire_data
        port map (
            clk     => clk,
            rst     => rst,
            dataIn  => dataIn,
            dataOut => dataOut,
            addr    => addr,
            wrEn    => wrEn
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset pulse
        wait for 20 ns;
        rst <= '0';

        -- Wait one cycle and check value at preloaded address 32
        wait for clk_period;
        addr <= std_logic_vector(to_unsigned(32, 6));
        wait for 5 ns; -- async read
        assert dataOut = x"00000001"
        report "Expected initial value 1 at address 32"
        severity error;

        -- Write a value to address 5
        addr   <= std_logic_vector(to_unsigned(5, 6));
        dataIn <= x"DEADBEEF";
        wrEn   <= '1';
        wait for clk_period;
        wrEn   <= '0';

        -- Change address, confirm value not yet read
        addr <= std_logic_vector(to_unsigned(5, 6));
        wait for 5 ns;
        assert dataOut = x"DEADBEEF"
        report "Expected value DEADBEEF at address 5"
        severity error;

        -- Write another value to address 10
        addr   <= std_logic_vector(to_unsigned(10, 6));
        dataIn <= x"12345678";
        wrEn   <= '1';
        wait for clk_period;
        wrEn <= '0';

        -- Read back address 10
        addr <= std_logic_vector(to_unsigned(10, 6));
        wait for 5 ns;
        assert dataOut = x"12345678"
        report "Expected value 12345678 at address 10"
        severity error;

        wait for 20 ns;
        report "Simulation completed successfully." severity note;
        wait;
    end process;

end architecture;
