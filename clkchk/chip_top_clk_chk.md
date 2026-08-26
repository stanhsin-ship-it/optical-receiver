# chip_top.v — Clock Connection Check

Source: `optical-receiver/clkchk/chip_top.v` (2746 lines). Method and limitations:
[clk_chk_summary.md](clk_chk_summary.md).

`chip_top` is the pad-level wrapper. It contains no clock generation of its own — it buffers
the board/pad clocks and hands them to `analog_subsys` (which owns the PLLs) and `chip_core`
(which owns `clkgen_top` via `sys_ctrl`).

---

## 1. Clock sources at the pad boundary

| Source | Line | Path |
|---|---|---|
| `int_xtal_clkin` | 1170 | from `u_chip_io_top` XTAL pad cell (`.int_xin_i`, L1642) |
| `fpga_clk1_in_p/n` | 1451 | `IBUFDS1` → `fpga_clk1_in` (FPGA only) |
| `fpga_clk2_in_p/n` | 1452 | `IBUFDS2` → `fpga_clk2_in` (FPGA only) |
| `fpga_clk3_in_p/n` | 1453 | `IBUFDS3` → `fpga_clk3_in` (FPGA only) |
| `ltpi_refclk` | 901 | top-level input, straight to `chip_core` (L2182) |
| `pcie_clkp/clkn/freerun_clk` | — | top-level inputs → `chip_core` (L2431-2433) |
| `eth0_clk_ether_pll`, `eth1_clk_ether_pll` | — | → `chip_core` (L2437, L2441) |

### The two xtal derivations

```
chip_top.v:1455   `ifdef FPGA_SOURCE  wire int_xtal_clkin_mux = fpga_clk_in_p;
chip_top.v:1457   `else               wire int_xtal_clkin_mux = int_xtal_clkin;
chip_top.v:1462   `ifdef FPGA_SOURCE  wire int_xtal = in_apll_clk[0];
chip_top.v:1464   `else               wire int_xtal = int_xtal_clkin;
```

- `int_xtal_clkin_mux` → `u_analog_subsys.int_xtal_clkin` (L2848) → the four PLL `fref_ck_*`
  reference inputs.
- `int_xtal` → `u_chip_core.in_xtal_clk` (L2329) → `sys_ctrl` → `clkgen_top`.

In the FPGA build `int_xtal` comes from `in_apll_clk[0]`, which `analog_subsys` assigns from
the MMCM's `clk_out1` (25 MHz) — so the emulation build's xtal is MMCM-derived, not the board
crystal. Consistent, just worth knowing when correlating timing between builds.

---

## 2. Per-instance clock connections

### `chip_rst_ctrl u_chip_rst_ctrl` — L1482
```
L1492  .clk    (clk_xtal)
L1493  .pclk   (pclk)
```
Reset controller on the xtal clock plus APB. Correct — reset logic must run on the
always-on clock, not a gated branch.

### `chip_io_top u_chip_io_top` — L1505
```
L2074  .pclk   (pclk)
```
Plus the IO-pad clock signals, all correctly paired as `_i` / `_o` / `_oen` triples:

| Pad | in | out | oen |
|---|---|---|---|
| `PAD_SPI0_CLK` (L1734) | `int_spi0_clk_i` () L1603 | `1'b0` L1998 | `1'b1` L1999 |
| `PAD_SPI1_CLK` (L1657) | `int_spi1_clk_i` () L1512 | `1'b0` L1818 | `1'b1` L1819 |
| `PAD_SPI2_CLK` (L1667) | `int_spi2_clk_i` () L1524 | `1'b0` L1840 | `1'b1` L1841 |
| `PAD_FWSPI_CLK` (L1726) | `int_fwspi_clk_i` () L1595 | `int_fwspi_clk_o` L1982 | `1'b0` L1983 |
| `PAD_ESPI_CLK` (L1703) | `int_espi_slave_clk_i` L1572 | `1'b0` L1936 | `1'b1` L1937 |
| `PAD_RMII_RCLKI` (L1688) | `eth1_clk_rxphy_i` L1557 | `1'b0` L1906 | `1'b1` L1907 |
| `PAD_RMII_RCLKO` (L1693) | () L1562 | `1'b0` L1916 | `1'b1` L1917 |
| `PAD_MSCLOCK` (L1707) | () L1576 | `1'b0` L1944 | `1'b1` L1945 |
| `PAD_SSCLOCK` (L1711) | () L1580 | `1'b0` L1952 | `1'b1` L1953 |
| `PAD_VGA_CLK` (L1769) | () L1638 | `1'b0` L2068 | `1'b1` L2069 |

Only two clock pads are actually driven or observed: `PAD_FWSPI_CLK` (output, `oen=0`) and
the two input-only pads `PAD_ESPI_CLK` and `PAD_RMII_RCLKI`. Every other clock pad is held
input-only (`oen=1`) with its input receiver left open. See summary finding **X6** — the
`peri0_subsys` block generates `clk_spi0/1/2`, `clk_sgpio`, `clk_espi_ahb` and they are
dropped at `chip_core`, which is consistent with these pads never being driven. If the SPI
masters are supposed to source SCK, both ends of that path are missing.

### `chip_core u_chip_core` — L2088
```
L2264  .pclk                  (pclk)
L2283  .clk_xtal              (clk_xtal)
L2328  .in_xtal_clk           (int_xtal)
`ifdef FPGA_SOURCE
L2317  .in_apll_clk           (in_apll_clk)
L2318  .in_fpll0_clk          (in_fpll0_clk)
L2319  .in_mpll0_clk          (in_mpll0_clk)
L2320  .in_mpll1_clk          (in_mpll1_clk)
L2321  .in_rtc_clk            (in_rtc_clk)
`else
L2323  .in_armpll_clk         (pll_ck_armpll)
L2324  .in_mpll_clk           (pll_ck_mpll)
L2325  .in_fpll_clk           (pll_ck_fpll)
L2326  .in_dfipll_clk         (pll_ck_dfipll)     <-- dropped inside chip_core, see X2
`endif
L2181  .ltpi_refclk           (ltpi_refclk)
L2431  .pcie_clkn             (pcie_clkn)
L2432  .pcie_clkp             (pcie_clkp)
L2433  .pcie_freerun_clk      (pcie_freerun_clk)
L2437  .eth0_clk_ether_pll    (eth0_clk_ether_pll)
L2441  .eth1_clk_ether_pll    (eth1_clk_ether_pll)
L2442  .eth1_clk_rxphy_i      (eth1_clk_rxphy_i)
L2443  .eth1_clk_tx_o         (eth1_clk_tx_o)
L2202  .PAD_SDIOCLK           (PAD_SDIOCLK)
L2208  .PAD_EMMCCLK           (PAD_EMMCCLK)
L2259  .dac_out_clk           (dac_out_clk)
L2295  .int_espi_slave_clk_i  (int_espi_slave_clk_i)
L2483  .emmc_clk              (emmc_clk)
L2484  .emmc_clk2card_on      (emmc_clk2card_on)
L2491  .sd_clk                (sd_clk)
L2492  .sd_clk2card_on        (sd_clk2card_on)
```
LTPI differential clock pads (both builds covered):
```
`ifdef FPGA_SOURCE                        `else
L2167  .LTPI_SCM_TX_CLK_DP                L2183  .PAD_LTPI_TX_CK_N
L2168  .LTPI_SCM_TX_CLK_DN                L2184  .PAD_LTPI_TX_CK_P
L2171  .LTPI_SCM_RX_CLK_DP                L2187  .PAD_LTPI_RX_CK_N
L2172  .LTPI_SCM_RX_CLK_DN                L2188  .PAD_LTPI_RX_CK_P
L2175  .LTPI_HPM_TX_CLK_DP                L2193  .AVDD_LTPI_CLKGEN
L2176  .LTPI_HPM_TX_CLK_DN                L2196  .AVSS_LTPI_CLKGEN (VSS)
L2179  .LTPI_HPM_RX_CLK_DP
L2180  .LTPI_HPM_RX_CLK_DN
```

DDR clock pads, both `FPGA_TPSVP1902` variants:
```
L2096 .ddr4_ck_c / L2097 .ddr4_ck_t / L2107 .sys_clk_n / L2108 .sys_clk_p
L2114 .c0_ddr4_ck_c / L2115 .c0_ddr4_ck_t / L2125 .c0_sys_clk_n / L2126 .c0_sys_clk_p
```

FPGA_USB block, L2456-2470 — see finding **F3** below.

### `analog_subsys u_analog_subsys` — L2752
```
L2847  .int_xtal_clkin  (int_xtal_clkin_mux)
L2849  .pclk            (pclk)
L2782  .pll_ck_armpll   (pll_ck_armpll)     outputs back to chip_core
L2783  .pll_ck_dfipll   (pll_ck_dfipll)
L2784  .pll_ck_fpll     (pll_ck_fpll)
L2785  .pll_ck_mpll     (pll_ck_mpll)
L2832  .CLK_25M         (1'b0)              <-- TIED OFF, see F1
L2858  .test_clk        (1'b0)              <-- TIED OFF, see X4
`ifdef FPGA_SOURCE
L2755-2759  .in_apll_clk / .in_fpll0_clk / .in_mpll0_clk / .in_mpll1_clk / .in_rtc_clk
L2761  .fpga_clk1_in    (fpga_clk1_in)
L2762  .fpga_clk2_in    (fpga_clk2_in)
L2763  .fpga_clk3_in    (fpga_clk3_in)
`endif
```

### `IBUFDS IBUFDS1 / IBUFDS2 / IBUFDS3` — L1451-1453 (FPGA only)
Differential input buffers for the three board clocks. See **F4**.

---

## 3. Findings

**F1 — `.CLK_25M(1'b0)` to `analog_subsys`. (L2832)**
`CLK_25M` is a real `analog_subsys` input that reaches `SAR_ADC_TOP_wrapper.CLK_25M`
(analog_subsys.sv:521). Driving it with a constant zero leaves the SAR ADC without a
conversion clock. `int_xtal` is in scope at this point and is the obvious intended source.
This is summary finding **X5**.

**F2 — `in_dfipll_clk` is delivered and then dropped. (L2326)**
`chip_top` correctly routes `pll_ck_dfipll` into `chip_core.in_dfipll_clk`. Inside
`chip_core` that input is never used, and `u_dram_subsys.DfiClk` (chip_core.v:4458) is
connected to an undeclared, undriven net. Nothing is wrong on the `chip_top` side — noting it
here so the two halves of the path are visible together. Summary finding **X2**.

**F3 — 14 undeclared, undriven clock nets in the `FPGA_USB` block. (L2456-2470)**
```
.clk_pipe_up(clk_pipe_up)               .clk_wiz_ulpi_clk_in1(clk_wiz_ulpi_clk_in1)
.clk_vhub0(clk_vhub0)                   .clk_wiz_ulpi_clk_out1..7(clk_wiz_ulpi_clk_out1..7)
.clk_utmi_porta(clk_utmi_porta)
.clk_utmi_portc(clk_utmi_portc)
.clk_utmi_portd(clk_utmi_portd)
.clk_mac(clk_mac)
```
Each appears exactly once in `chip_top.v` and has no declaration. The corresponding
`chip_core` ports *are* declared (`clk_mac`, `clk_utmi_port*`, `clk_vhub0`,
`clk_wiz_ulpi_clk_*` all exist there as inputs/outputs), so what is missing is a wire block
plus a driver in `chip_top`. FPGA_USB builds only.

**F4 — `IBUFDS0` commented out; `fpga_clk_xtal` declared but never driven. (L1449-1455)**
```
L1449  wire fpga_clk_xtal, fpga_clk1_in, fpga_clk2_in;
L1450  //IBUFDS IBUFDS0 (.O(fpga_clk_xtal), .IB(fpga_clk_in_n), .I(fpga_clk_in_p));
L1455  wire int_xtal_clkin_mux = fpga_clk_in_p;
```
With `IBUFDS0` disabled, `int_xtal_clkin_mux` takes the raw single-ended pad `fpga_clk_in_p`
instead of the differential buffer output, and `fpga_clk_xtal` is dead. Also note L1449
declares `fpga_clk1_in` and `fpga_clk2_in` but **not** `fpga_clk3_in`, which `IBUFDS3` drives
at L1453 — it works as an implicit 1-bit wire, but the omission looks accidental. FPGA only.

**F5 — Ten of thirteen clock IO pads are permanently input-only with the receiver open.**
See the table in §2. Not a defect on its own, but combined with **X6** (the `peri0_subsys`
SPI/eSPI/SGPIO clocks being dropped at `chip_core`) it suggests the peripheral clock-output
paths were never completed. Worth confirming against the pad list which of these are
genuinely input-only by design.
