# pblock0.v — Clock Connection Check

Source: `optical-receiver/clkchk/pblock0.v` (1836 lines). Method and limitations:
[clk_chk_summary.md](clk_chk_summary.md).

`pblock0` is a pure distribution level — no clock generation. It holds the peripheral
subsystem, the PCIe endpoint and the USB2 controller.

---

## 1. Clock ports

### Clock inputs — from `chip_core`
```
L335  aclk                    <-- ungated global, used by pcie_ep_top (see F1)
L483  pclk                    <-- ungated global, used by pcie_ep_top (see F1)
L336  aclk_peri0_p            L484  pclk_peri0_p        L383  clk_xtal_peri0_p
L337  aclk_usb2_p             L485  pclk_usb2_p         L384  clk_xtal_usb2_p
L381  clk_usb_ref_p           L382  clk_usb_suspend_p
L351  clk_bsspi0_p            L352  clk_espi_ahb_p      L353  clk_eth1_p
L354  clk_fsi_p               L365  clk_ltpi_p          L368  clk_peci_p
L369  clk_peri_can_p          L370  clk_peri_jtagm_p    L372  clk_sgpio_p
L355-360  clk_i2c0_p .. clk_i2c5_p
L361-364  clk_i3c0_p .. clk_i3c3_p
L373-375  clk_spi0_p, clk_spi1_p, clk_spi2_p
L376-380  clk_uart0_p .. clk_uart3_p, clk_uart_dbg_p
L403  hclk_fwspi0_p
L366  clk_mvdm                L367  clk_pbmc            L371  clk_pmmbi
L424  in_xtal_clk
L429  int_fpll_clk_div4       L430  int_fpll_clk_div6
L388  ep0_pcie_clkn           L389  ep0_pcie_clkp       L390  ep0_pcie_freerun_clk
L425  int_espi_slave_clk_i    L4    eth1_clk_rxphy_i
L519  ptest_clk_scan_en
`ifdef FPGA_SOURCE  L30-34  in_apll_clk, in_fpll0_clk, in_mpll0_clk, in_mpll1_clk, in_rtc_clk
```

### Clock outputs — generated inside `peri0_subsys`
```
L62 clk_bsspi0    L63 clk_espi_ahb   L64 clk_fsi      L65 clk_ltpi
L66 clk_peci      L67 clk_sgpio      L68 clk_spi0     L69 clk_spi1
L70 clk_spi2      L71 clk_ufs        L72 clk_xtal_peri0
L104 hclk_fwspi0  L5 eth1_clk_tx_o   L83 ep0_CLKREQ_OUT_N
```
All except `clk_ltpi` are dropped by `chip_core` — see summary finding **X6**.

### Clock pads
```
L22   inout  PAD_ESPI_MASTER_CLK   (`ifdef FPGA_SOURCE)
L565  inout  PAD_REF_CLK
```

**No port exists for `aclk_pcie_ep_p`, `pclk_pcie_ep_p`, `clk_pcie_ep_p`,
`clk_xtal_pcie_ep_p` or `aclk_usb_p`** — the clkgen branches built for PCIe EP never reach
this block. See **F1**.

---

## 2. Per-instance clock connections

### `peri0_subsys u_peri0_subsys` — L769
```
inputs, all on their own clkgen branch:
L1048  .aclk_peri0_p          (aclk_peri0_p)
L1199  .pclk_peri0_p          (pclk_peri0_p)
L1166  .clk_xtal_peri0_p      (clk_xtal_peri0_p)
L1139  .clk_bsspi0_p          (clk_bsspi0_p)
L1140  .clk_espi_ahb_p        (clk_espi_ahb_p)
L1141  .clk_eth1_p            (clk_eth1_p)
L1142  .clk_fsi_p             (clk_fsi_p)
L1143-L1148  .clk_i2c0_p .. .clk_i2c5_p
L1149-L1152  .clk_i3c0_p .. .clk_i3c3_p
L1153  .clk_ltpi_p            (clk_ltpi_p)
L1154  .clk_peci_p            (clk_peci_p)
L1155  .clk_peri_can_p        (clk_peri_can_p)
L1156  .clk_peri_jtagm_p      (clk_peri_jtagm_p)
L1157  .clk_sgpio_p           (clk_sgpio_p)
L1158-L1160  .clk_spi0_p, .clk_spi1_p, .clk_spi2_p
L1161-L1165  .clk_uart0_p .. .clk_uart3_p, .clk_uart_dbg_p
L1169  .hclk_fwspi0_p         (hclk_fwspi0_p)
L1190  .in_xtal_clk           (in_xtal_clk)
L1195  .int_fpll_clk_div4     (int_fpll_clk_div4)
L1196  .int_fpll_clk_div6     (int_fpll_clk_div6)
L1029  .eth1_clk_rxphy_i      (eth1_clk_rxphy_i)
L1191  .int_espi_slave_clk_i  (int_espi_slave_clk_i)
L1026  .PAD_REF_CLK           (PAD_REF_CLK)
L1036  .ptest_clk_scan_en     (ptest_clk_scan_en)     <- real DFT signal, routed
outputs:
L789   .eth1_clk_tx_o         (eth1_clk_tx_o)
L842-L852  .clk_bsspi0, .clk_espi_ahb, .clk_fsi, .clk_ltpi, .clk_peci, .clk_sgpio,
           .clk_spi0, .clk_spi1, .clk_spi2, .clk_ufs, .clk_xtal_peri0
L858   .hclk_fwspi0           (hclk_fwspi0)
`ifdef FPGA_SOURCE  L772 .PAD_ESPI_MASTER_CLK, L780-784 in_apll/fpll0/mpll0/mpll1/rtc_clk
```
**This instance is fully and correctly wired** — every clock comes from its dedicated clkgen
branch. It is the model the other blocks should follow.

### `pcie_ep_top u_pcie_ep_top` — L1286
```
L1442  .aclk                  (aclk)     <-- ungated global, see F1
L1527  .pclk                  (pclk)     <-- ungated global, see F1
L1459  .clk_mvdm              (clk_mvdm) <-- driven by clk_vdm_p at chip_core, see F2
L1460  .clk_pbmc              (clk_pbmc)
L1461  .clk_pmmbi             (clk_pmmbi)
L1464  .ep0_pcie_clkn         (ep0_pcie_clkn)
L1465  .ep0_pcie_clkp         (ep0_pcie_clkp)
L1466  .ep0_pcie_freerun_clk  (ep0_pcie_freerun_clk)
L1341  .ep0_CLKREQ_OUT_N      (ep0_CLKREQ_OUT_N)
```
The PCIe reference-clock path (`ep0_pcie_clkp/clkn/freerun_clk`) is complete all the way to
the pad. Note the contrast with the RC side in `pblock1`, where the equivalent nets are
undriven at `chip_core`.

### `usb_top2 u_usb_top2` — L1693
```
L1783  .clk_axi        (aclk_usb2_p)
L1784  .clk_apb        (pclk_usb2_p)
L1785  .clk_xtal       (clk_xtal_usb2_p)
L1786  .clk_ref        (clk_usb_ref_p)
L1787  .clk_suspend    (clk_usb_suspend_p)
L1790  .clk_test_pa    (1'b0)             <-- DFT tied off
L1801  .clk_test_bp    (1'b0)             <-- DFT tied off
L1695  .clk_uphy_480M  ()                 <-- output dangling
```
**Correctly wired to its own branch** — all five functional clocks come from the USB2 clkgen
branch. This is the direct counter-example to `u_usb_subsys` (USB3) in `pblock1`, which uses
none of its branch. Whatever was done here was not done there.

---

## 3. Clock domain summary

| Domain | Consumers |
|---|---|
| `aclk_peri0_p` / `pclk_peri0_p` / `clk_xtal_peri0_p` | `u_peri0_subsys` |
| ~30 peripheral leaf clocks `*_p` | `u_peri0_subsys` |
| `aclk_usb2_p` / `pclk_usb2_p` / `clk_xtal_usb2_p` / `clk_usb_ref_p` / `clk_usb_suspend_p` | `u_usb_top2` |
| **`aclk` / `pclk` (ungated global)** | **`u_pcie_ep_top`** |
| `clk_mvdm` / `clk_pbmc` / `clk_pmmbi` | `u_pcie_ep_top` |
| `ep0_pcie_clkp/clkn/freerun_clk` | `u_pcie_ep_top` |

---

## 4. Findings

**F1 — `u_pcie_ep_top` runs on the ungated global `aclk`/`pclk`. (L1442, L1527)**
`clkgen_top` generates `aclk_pcie_ep_p`, `pclk_pcie_ep_p`, `clk_pcie_ep_p` and
`clk_xtal_pcie_ep_p` for this block, and all four are dropped at `chip_core` — `pblock0` has
no port for any of them. The PCIe EP source-select, divider, bypass, OCC and stop-enable
registers therefore do nothing, and a write to the global `reg_aclk_stop_en` /
`reg_pclk_stop_en` stops PCIe EP along with the rest of the SoC.

Fixing this needs three edits, not one: add the ports to `pblock0`, connect them at
`chip_core`, and change L1442/L1527 to use them.

Note the inconsistency *within this file*: `u_usb_top2` two instances away uses its full
branch (`aclk_usb2_p`, `pclk_usb2_p`, `clk_xtal_usb2_p`, `clk_usb_ref_p`,
`clk_usb_suspend_p`), and `u_peri0_subsys` uses all ~30 of its leaf clocks. Only PCIe EP was
left on the global clocks.

**F2 — `.clk_mvdm(clk_mvdm)` is correct here, but its driver upstream is not. (L1459)**
Nothing is wrong on this side. At `chip_core.v:5032` the `clk_mvdm` port of this instance is
connected to `clk_vdm_p` (missing the `m`), an undeclared and undriven net, while the
correctly generated `clk_mvdm_p` goes nowhere. The typo is in the AUTO_TEMPLATE at
chip_core.v:4660, so it will regenerate. Summary finding **X3**.

**F3 — Eleven generated clocks leave this block and are dropped. (L842-852, L858)**
`clk_bsspi0`, `clk_espi_ahb`, `clk_fsi`, `clk_peci`, `clk_sgpio`, `clk_spi0`, `clk_spi1`,
`clk_spi2`, `clk_ufs`, `clk_xtal_peri0`, `hclk_fwspi0` — all declared as `pblock0` outputs,
all left unconsumed at `chip_core`. Only `clk_ltpi` is used (→ `ltpi_system_top`).
`chip_top` also holds every SPI / eSPI / SGPIO clock pad input-only with `oen=1`, so if these
are meant to drive pads the path is missing at both ends. Summary finding **X6**.

**F4 — `u_usb_top2.clk_uphy_480M` output left open. (L1695)**
The 480 MHz UTMI PHY clock is not observed. Probably intentional, but if any other block needs
a 480 MHz reference this is where it would come from.

**F5 — USB2 DFT clocks tied to `1'b0`. (L1790, L1801)**
`.clk_test_pa(1'b0)`, `.clk_test_bp(1'b0)`. Consistent with the tie-off pattern seen
throughout the design (summary finding **X4**) — noted for completeness, not necessarily a
defect.
