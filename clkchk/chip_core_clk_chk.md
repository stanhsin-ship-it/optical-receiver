# chip_core.v — Clock Connection Check

Source: `optical-receiver/clkchk/chip_core.v` (6229 lines). Method and limitations:
[clk_chk_summary.md](clk_chk_summary.md).

`chip_core` is the integration level: it instantiates `sys_ctrl` (which contains the only
clock generator) and distributes its 88 leaf clocks to the two pblocks, the AP, the MCU, the
DRAM subsystem and the fabrics. **This file carries the majority of the findings.**

---

## 1. Clock inputs to `chip_core`

| Port | Line | Source (chip_top) | Consumer |
|---|---|---|---|
| `in_xtal_clk` | — | `int_xtal` | `u_sys_ctrl`, `u_pblock0` |
| `in_mpll_clk` | — | `pll_ck_mpll` | `u_sys_ctrl` (ASIC) |
| `in_fpll_clk` | — | `pll_ck_fpll` | `u_sys_ctrl` (ASIC) |
| `in_armpll_clk` | — | `pll_ck_armpll` | `u_ap_subsys` (ASIC) |
| **`in_dfipll_clk`** | **605** | `pll_ck_dfipll` | **none — see F2** |
| `in_apll_clk[3:0]` etc. | — | MMCM (FPGA) | `u_sys_ctrl`, `u_pblock0`, `u_pblock1`, `u_ap_subsys` |
| `ltpi_refclk` | 1107 | top-level pad | `ltpi_system_top.ctrl_clk25_i` (L6367) |
| `pcie_clkp/clkn/freerun_clk` | 280-282 | top-level pads | `u_pblock0` EP side (L5054-5056) |
| `eth0_clk_ether_pll`, `eth1_clk_ether_pll` | — | top-level | eth |

---

## 2. Per-instance clock connections

### `sys_ctrl u_sys_ctrl` — L3809 *(contains `clkgen_top`)*
```
L3822  .aclk               (aclk)          <- generated here, fans out to 54 sites
L3823  .pclk               (pclk)          <- 9 sites
L3824  .clk_xtal           (clk_xtal)      <- 5 sites
L3920  .int_fpll_clk_div4  (int_fpll_clk_div4)
L3921  .int_fpll_clk_div6  (int_fpll_clk_div6)
L3837..L3933   88 leaf clocks *_p
L3975  .clk_fast           (clk_fast)      <-- UNDRIVEN, see F1
L3976  .clk_slow           (clk_slow)      <-- UNDRIVEN, see F1
L3979  .in_xtal_clk        (in_xtal_clk)
`ifdef FPGA_SOURCE  L3810-3814 in_apll/fpll0/mpll0/mpll1/rtc_clk
`else               L3817 .in_mpll_clk, L3818 .in_fpll_clk
```

### `chip_fabric u_chip_fabric` — L2817
```
L3079-L3099   .aclk, .aclk_m1, .aclk_m3..m8, .aclk_s3..s15   all (aclk)
```
21 AXI clock ports, all on the single global `aclk`. Correct for a synchronous fabric.

### `pcie_fabric u_pcie_fabric` — L3390
```
L3568-L3582   .aclk, .aclk_m2..m7, .aclk_s2..s9   all (aclk)
```
15 ports, all `aclk`. Correct.

### `pre_arbiter u_pre_arbiter` — L4035
```
L4190-L4195  .aclk, .aclk_m1..m5   (aclk)
L4238        .pclk                 (pclk)
```

### `dram_subsys u_dram_subsys` — L4344
```
L4458  .DfiClk             (DfiClk)        <-- UNDRIVEN, see F2
L4459  .DfiClk_Reset       (1'b1)
L4460  .PllBypClk          (1'b0)
L4482  .aclk_ddr_p         (aclk)          <-- ungated global aclk, see F3
L4569  .pclk_ddr_p         (pclk_ddr_p)    <-- correct branch
L4396  .atpg_Asst_Clk      ()              <-- dangling
L4514  .atpg_Asst_Clken    (1'b0)
L4515  .atpg_Pclk          (1'b0)
L4518  .atpg_PllRefClk     (1'b0)
L4519  .atpg_RDQSClk       (1'b0)
L4520  .atpg_TxDllClk      (1'b0)
L4521  .atpg_UcClk         (1'b0)
`ifdef FPGA_TPSVP1902
L4351 .ddr4_ck_c  L4352 .ddr4_ck_t  L4357 .ddr4_ui_clk_pre  L4363/4 .sys_clk_n/p
`else
L4370 .c0_ddr4_ck_c  L4371 .c0_ddr4_ck_t  L4376 .c0_ddr4_ui_clk_pre  L4382/3 .c0_sys_clk_n/p
`endif
```
Note the asymmetry at L4482 vs L4569: `pclk_ddr_p` uses its clkgen branch, `aclk_ddr_p` does
not. The `aclk_ddr_p` net *is* generated (L3839) and declared (L1219) — it just has no
consumer.

### `pblock0 u_pblock0` — L4666
```
L5001  .aclk                (aclk)              <-- for pcie_ep_top, see F3
L5149  .pclk                (pclk)              <-- for pcie_ep_top, see F3
L5002  .aclk_peri0_p        (aclk_peri0_p)
L5150  .pclk_peri0_p        (pclk_peri0_p)
L5049  .clk_xtal_peri0_p    (clk_xtal_peri0_p)
L5003  .aclk_usb2_p         (aclk_usb2_p)
L5151  .pclk_usb2_p         (pclk_usb2_p)
L5050  .clk_xtal_usb2_p     (clk_xtal_usb2_p)
L5047  .clk_usb_ref_p       (clk_usb_ref_p)
L5048  .clk_usb_suspend_p   (clk_usb_suspend_p)
L5017-L5046   clk_bsspi0_p, clk_espi_ahb_p, clk_eth1_p, clk_fsi_p, clk_i2c0..5_p,
              clk_i3c0..3_p, clk_ltpi_p, clk_peci_p, clk_peri_can_p, clk_peri_jtagm_p,
              clk_sgpio_p, clk_spi0..2_p, clk_uart0..3_p, clk_uart_dbg_p
L5032  .clk_mvdm            (clk_vdm_p)         <-- TYPO, UNDRIVEN, see F4
L5033  .clk_pbmc            (clk_pbmc_p)
L5037  .clk_pmmbi           (clk_pmmbi_p)
L5069  .hclk_fwspi0_p       (hclk_fwspi0_p)
L5090  .in_xtal_clk         (in_xtal_clk)
L5091  .int_espi_slave_clk_i(int_espi_slave_clk_i)
L5095  .int_fpll_clk_div4   (int_fpll_clk_div4)
L5096  .int_fpll_clk_div6   (int_fpll_clk_div6)
L5054  .ep0_pcie_clkn       (pcie_clkn)
L5055  .ep0_pcie_clkp       (pcie_clkp)
L5056  .ep0_pcie_freerun_clk(pcie_freerun_clk)
L5185  .ptest_clk_scan_en   (ptest_clk_scan_en)
outputs, all dropped (see F6):
L4719-L4729   clk_bsspi0, clk_espi_ahb, clk_fsi, clk_ltpi, clk_peci, clk_sgpio,
              clk_spi0, clk_spi1, clk_spi2, clk_ufs, clk_xtal_peri0
L4761  .hclk_fwspi0         (hclk_fwspi0)
```

### `pblock1 u_pblock1` — L5291
```
L5683  .aclk                 (aclk)             <-- for pcie_rc_top + usb_subsys, see F3
L5761  .pclk                 (pclk)
L5713  .clk_xtal             (clk_xtal)
L5684  .aclk_peri1_p         (aclk_peri1_p)
L5762  .pclk_peri1_p         (pclk_peri1_p)
L5714  .clk_xtal_peri1_p     (clk_xtal_peri1_p)
L5685  .aclk_vga_p           (aclk_vga_p)
L5763  .pclk_vga_p           (pclk_vga_p)
L5715  .clk_xtal_vga_p       (clk_xtal_vga_p)
L5705-L5712  clk_cap_p, clk_dp_aux_p, clk_dp_phy_ref_p, clk_dp_sys_p, clk_eth0_p,
             clk_jpeg_p, clk_pbus_p, clk_sdma_p
L5659  .m2m_utmi_clk         (m2m_utmi_clk)        <-- UNDRIVEN, see F1
L5660  .m2m_pipe_pclk        (m2m_pipe_pclk)       <-- UNDRIVEN, see F1
L5858  .suspend_clk          (suspend_clk)         <-- UNDRIVEN, see F1
L5800  .rc_pcie_clkn         (rc_pcie_clkn)        <-- UNDRIVEN, see F1
L5801  .rc_pcie_clkp         (rc_pcie_clkp)        <-- UNDRIVEN, see F1
L5802  .rc_pcie_freerun_clk  (rc_pcie_freerun_clk) <-- UNDRIVEN, see F1
L5788  .ptest_scan_dc_clk    (ptest_scan_dc_clk)
L5859  .test_clk             (1'b0)                <-- tied off
L5716-L5724  ddc/ddc2 clk_in: (1'b0) except vga0 which takes (vga_scl_i)
outputs, dropped (see F6):
L5338  .clk_cap  L5339  .clk_pbus  L5340  .clk_xtal_vga
```

### `mcu_subsys u_mcu_subsys` — L5949
```
L5988  .clk_cptra   (clk_cliptra_p)
L5999  .clk_xtal    (clk_xtal_cliptra_p)
```
Only 2 of the 4 Cliptra branches are used — `aclk_cliptra_p` and `pclk_cliptra_p` are
generated and dropped (see F5).

### `ap_subsys u_ap_subsys` — L6077
```
L6138  .aclk_ap_p          (aclk_ap_p)
L6167  .pclk_ap_p          (pclk_ap_p)
L6165  .clk_xtal_ap_p      (clk_xtal_ap_p)
L6163  .clk_dap_p          (clk_dap_p)
L6164  .clk_gic_p          (clk_gic_p)
L6166  .in_rtc_clk         (in_rtc_clk)
L6193  .clk_swjtag_tck     (int_jtag_tck)
L6171  .ptest_scan_dc_clk  (ptest_scan_dc_clk)
`ifdef FPGA_SOURCE L6078-6081 in_apll/fpll0/mpll0/mpll1  `else L6083 .in_armpll_clk
```
Fully wired to its own branch. This is the reference for how it should look.

### `debug_core debug_core` — L6211
```
L6231  .aclk  (aclk)
L6244  .pclk  (pclk)
```

### `ltpi_system_top ltpi_system_top` — L6300
```
L6367  .ctrl_clk25_i  (ltpi_refclk)
L6377  .pclk_i        (pclk)
L6358  .clk_ltpi      (clk_ltpi)      <- from u_pblock0, the only consumed pblock0 clock output
`ifdef FPGA_SOURCE  L6305-6310 LTPI_SCM/HPM_TX_CLK_DP/DN, L6335-6340 RX
`else               L6312/3 PAD_LTPI_TX_CK_N/P, L6343/4 PAD_LTPI_RX_CK_N/P
                    L6349 AVDD_LTPI_CLKGEN, L6352 AVSS_LTPI_CLKGEN
```

---

## 3. Findings

**F1 — Nine clock nets are used but never declared and never driven.**
Verilog silently creates implicit 1-bit wires; every one of these was confirmed by a
whole-file search returning exactly one hit, meaning no driver exists anywhere.

| Net | Line | Feeds | Impact |
|---|---|---|---|
| `clk_fast` | 3975 | `u_sys_ctrl` → `u_mbox_top` | **Mailbox has no clock in any build.** |
| `clk_slow` | 3976 | `u_sys_ctrl` → `u_mbox_top` | same |
| `DfiClk` | 4458 | `u_dram_subsys` | DDR DFI clock floats — see F2 |
| `suspend_clk` | 5858 | `u_pblock1` → `u_usb_subsys` | USB3 suspend clock floats |
| `m2m_utmi_clk` | 5659 | `u_pblock1` → `u_usb_subsys` | USB3 UTMI clock floats |
| `m2m_pipe_pclk` | 5660 | `u_pblock1` → `u_usb_subsys` | USB3 PIPE clock floats |
| `rc_pcie_clkp` | 5801 | `u_pblock1` → `u_pcie_rc_top` | PCIe RC refclk floats |
| `rc_pcie_clkn` | 5800 | `u_pblock1` → `u_pcie_rc_top` | PCIe RC refclk floats |
| `rc_pcie_freerun_clk` | 5802 | `u_pblock1` → `u_pcie_rc_top` | PCIe RC free-run clock floats |

The `clk_fast`/`clk_slow` result settles the open question raised in the `sys_ctrl` report:
the mailbox's APB interfaces are driven from the `pclk` domain while the module is clocked by
`clk_fast`/`clk_slow`, and at this level neither clock exists at all.

For the PCIe RC trio, compare the EP side: `pcie_clkp`/`pcie_clkn`/`pcie_freerun_clk` are
real `chip_core` ports with four references each, routed chip_top → chip_core → pblock0. The
RC side has the same three connections but the matching `chip_core` ports were never created.

**F2 — `in_dfipll_clk` enters and is dropped; `DfiClk` has no driver. (L605, L4458)**
`chip_top` routes `pll_ck_dfipll` into `chip_core.in_dfipll_clk` (chip_top.v:2326). Inside
this file `in_dfipll_clk` has exactly two references: the AUTOARG entry (L39) and the port
declaration (L605). Meanwhile `u_dram_subsys.DfiClk` is connected to the undeclared net
`DfiClk`. `.DfiClk(in_dfipll_clk)` is almost certainly the intent.

**F3 — Four blocks take the ungated global `aclk`/`pclk` instead of their clkgen branch.**

| Instance | Line | Gets | clkgen made for it |
|---|---|---|---|
| `u_dram_subsys` | 4482 | `.aclk_ddr_p(aclk)` | `aclk_ddr_p` (L3839, dangling) |
| `u_pblock0` → `u_pcie_ep_top` | 5001, 5149 | `.aclk(aclk)`, `.pclk(pclk)` | `aclk_pcie_ep_p`, `pclk_pcie_ep_p` |
| `u_pblock1` → `u_pcie_rc_top` | 5683, 5761 | `.aclk(aclk)`, `.pclk(pclk)` | `aclk_pcie_rc_p`, `pclk_pcie_rc_p` |
| `u_pblock1` → `u_usb_subsys` | 5683, 5713 | `.aclk(aclk)`, `.clk_xtal(clk_xtal)` | `aclk_usb_p`, `pclk_usb_p`, `clk_xtal_usb_p`, `clk_ref_p`, `clk_suspend_p` |

`pblock0` has no `aclk_pcie_ep_p` port and `pblock1` has no `aclk_pcie_rc_p` or `aclk_usb_p`
port, so this cannot be fixed at the connection level alone — the pblock port lists need the
branches added. Consequence: the per-block src-sel / divider / bypass / OCC / stop-enable
registers for PCIe EP, PCIe RC, USB3 and DDR-AXI do nothing, and the global
`reg_aclk_stop_en` / `reg_pclk_stop_en` now gates all four together. Summary finding **X1**.

**F4 — `clk_mvdm_p` / `clk_vdm_p` name mismatch, and the typo is in the template. (L4660, L5032)**
```
L1567  wire clk_mvdm_p;              // From u_sys_ctrl -- declared, never consumed
L3886  .clk_mvdm_p  (clk_mvdm_p)     // driven by u_sys_ctrl
L4660  .clk_mvdm    (clk_vdm_p)      // <- AUTO_TEMPLATE, missing the 'm'
L5032  .clk_mvdm    (clk_vdm_p)      // <- expansion, u_pblock0
```
`clk_vdm_p` is undeclared and undriven, so `u_pcie_ep_top`'s MVDM clock (pblock0.v:1459)
floats. Its two siblings are correct: `.clk_pbmc(clk_pbmc_p)` L5033, `.clk_pmmbi(clk_pmmbi_p)`
L5037. **Fix the AUTO_TEMPLATE at L4660** — patching only L5032 will be undone the next time
`verilog-auto` runs.

**F5 — 22 clkgen leaf clocks are generated and never consumed.**
Each has exactly one reference in this file (its `wire` declaration) after excluding the
`u_sys_ctrl` instantiation:
```
aclk_pcie_ep_p   pclk_pcie_ep_p   clk_pcie_ep_p   clk_xtal_pcie_ep_p
aclk_pcie_rc_p   pclk_pcie_rc_p   clk_pcie_rc_p   clk_xtal_pcie_rc_p
aclk_usb_p       pclk_usb_p       clk_xtal_usb_p  clk_ref_p       clk_suspend_p
aclk_cliptra_p   pclk_cliptra_p
clk_mshc0_aclk_p clk_mshc0_bclk_p clk_mshc0_cclk_p clk_mshc0_hclk_p clk_mshc0_tmclk_p
clk_mshc1_aclk_p clk_mshc1_bclk_p clk_mshc1_cclk_p clk_mshc1_hclk_p clk_mshc1_tmclk_p
clk_mvdm_p
```
The ten MSHC clocks deserve separate attention: `pblock1` exports `emmc_clk`/`sd_clk`
(generated inside `peri1_subsys`) and receives only `aclk_peri1_p`, `pclk_peri1_p`,
`clk_xtal_peri1_p`, `clk_eth0_p`, `clk_sdma_p`. So `clkgen_top` builds a complete
five-clock branch for each of two MSHC controllers and none of it is routed. Either
`peri1_subsys` divides its own MSHC clocks internally — in which case the clkgen branch is
dead silicon and its registers are misleading — or the routing is missing.

**F6 — Twelve block-generated clocks are exported and dropped here.**
```
from u_pblock0 (L4719-4729, 4761): clk_bsspi0, clk_espi_ahb, clk_fsi, clk_peci, clk_sgpio,
                                   clk_spi0, clk_spi1, clk_spi2, clk_ufs, clk_xtal_peri0,
                                   hclk_fwspi0
from u_pblock1 (L5338-5340):       clk_cap, clk_pbus, clk_xtal_vga
```
Each is declared as a `wire` "From u_pblockN" and referenced nowhere else. Only `clk_ltpi`
is consumed (→ `ltpi_system_top`, L6358). This lines up with chip_top holding all the SPI /
eSPI / SGPIO clock pads input-only with `oen=1` — if those peripherals are meant to source
their clock out to a pad, the whole path is missing, not just one connection.

**F7 — Six `xhci_*` clock wires are declared and never referenced at all.**
`xhci_ltssm_clk_state_swi`, `xhci_pipe_mx_pclk_swi`, `xhci_pipe_mx_pclk_ready_swi`,
`xhci_ram_clk_out_swi`, `xhci_ram_clk_gated_swi`, `xhci_ram_clk_gated_ram0_swi` — zero uses
beyond the declaration. Dead declarations, presumably left from a removed USB switch. Harmless
but should be deleted.

**F8 — `c0_ddr4_ui_clk_pre` is an undeclared implicit wire. (L4357, L4376)**
Both references are `dram_subsys` **outputs** in mutually exclusive `` `ifdef `` branches, so
nothing floats into logic. Still, it should be declared or explicitly left open — as an
implicit wire it is silently 1-bit.
