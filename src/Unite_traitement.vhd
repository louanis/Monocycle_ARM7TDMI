use library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        clk      : in std_logic_vector;
        rst      : in std_logic;
        regWr    : in std_logic;
        RW       : in std_logic_vector(3 downto 0);
        RA       : in std_logic_vector(3 downto 0);
        RB       : in std_logic_vector(3 downto 0);
        ALUSrc   : in std_logic;
        ALUCtr   : in std_logic_vector(1 downto 0);
        MemWr    : in std_logic_vector;
        MemToReg : in std_logic;
        Immediat : in std_logic_vector(7 downto 0)
        
    );
end ALU;

architecture RTL of ALU is
    signal BusA, BusB, BusW, Imm_ext, SortieMux, ResAlu : std_logic_vector(32 downnto 0);
    signal s_N, s_Z : std_logic;
begin

    banc_reg : entity work.RegisterARM(RTL)
    port map(
        CLK   => CLK,
        Reset => RST,
        W     => BusW,
        RA    => RA,
        RB    => RB,
        RW    => RW,
        WE    => RegWr,
        A     => BusA,
        B     => BusB
    ); 

    imm_extend : entity work.Extend(RTL)
    generic map(
        N => 8
    )
    port (
        E => Immediat,
        S => Imm_ext
    );

    mux_alu : entity work.mux2v1(RTL)
    generic map(
        N => 32
    )
    port map(
        A   => BusB,
        B   => Imm_ext,
        COM => ALUSrc,
        S   => SortieMux
    );

    alu_cabl_mux: entity work.ALU(RTL)
    port map(
        OP => ALUCtr,
        A  => BusA,
        B  => SortieMux,
        S  => ResAlu,
        N  => s_N,
        Z  => s_Z
    )



    mux_toreg: entity work.mux2v1(RTL)




end RTL;