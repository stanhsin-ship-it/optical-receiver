# pblock1.v — Clock Connection Check

Source: `optical-receiver/clkchk/pblock1.v` (1596 lines). Method and limitations:
[clk_chk_summary.md](clk_chk_summary.md).

`pblock1` is a distribution level — no clock generation. It holds the second peripheral
subsystem, the VGA/display subsystem, the USB3 subsystem and the PCIe root complex.

---

## 1. Clock ports

### Clock inputs — from `chip_core`
```
L336  aclk               <-- ungated global, used by pcie_rc_top AND usb_subsys (see F1, F2)
L418  pclk               <-- ungated global, used by pcie_rc_top
L366  clk_xtal           <-- ungated global, used by usb_subsys as ref_clk
L337  aclk_peri1_p       L419  pclk_peri1_p        L367  clk_xtal_peri1_p
L338  aclk_vga_p         L420  pclk_vga_p          L368  clk_xtal_vga_p
L358  clk_cap_p          L359  clk_dp_aux_p        L360  clk_dp_phy_ref_p
L361  clk_dp_sys_p       L362  clk_eth0_p          L363  clk_jpeg_p
L364  clk_pbus_p         L365  clk_sdma_p
L3    m2m_utmi_clk       L4    m2m_pipe_pclk       L515  suspend_clk     <-- all UNDRIVEN upstream
L457  rc_pcie_clkn       L458  rc_pcie_clkp        L459  rc_pcie_freerun_clk  <-- all UNDRIVEN upstream
L369-371  ddc2_clk_in_gfx, ddc2_clk_in_vga0, ddc2_clk_in_vga1
L375-377  ddc_clk_in_gfx,  ddc_clk_in_vga0,  ddc_clk_in_vga1
L445  ptest_scan_dc_clk  L516  test_clk
`ifdef FPGA_SOURCE  L393-397  in_apll_clk, in_fpll0_clk, in_mpll0_clk, in_mpll1_clk, in_rtc_clk
```

### Clock outputs
```
L46 clk_cap   L47 clk_pbus   L48 clk_xtal_vga           (from u_vga_subsys; dropped at chip_core)
L62 dac_out_clk
L68-70  ddc2_clk_out_gfx, ddc2_clk_out_vga0, ddc2_clk_out_vga1
L74-76  ddc_clk_out_gfx,  ddc_clk_out_vga0,  ddc_clk_out_vga1
L88-96  en_ddc_clk_*, en_ddcb_clk_*
L80 emmc_clk   L81 emmc_clk2card_on   L244 sd_clk   L245 sd_clk2card_on
L175 rc0_CLKREQ_OUT_N   L192 reg_clk_mux_ctrl_n0
```

### Clock pads
```
L568  inout  PAD_EMMCCLK
L593  inout  PAD_SDIOCLK
```

**No port exists for `aclk_pcie_rc_p`, `pclk_pcie_rc_p`, `clk_pcie_rc_p`,
`clk_xtal_pcie_rc_p`, `aclk_usb_p`, `pclk_usb_p`, `clk_xtal_usb_p`, `clk_ref_p` or
`clk_suspend_p`** — nine clkgen branches built for PCIe RC and USB3 never reach this block.
There are also no MSHC clock ports, despite `clkgen_top` generating ten of them.

---

## 2. Per-instance clock connections

### `peri1_subsys u_peri1_subsys` — L647
```
L754   .aclk_peri1_p        (aclk_peri1_p)
L767   .pclk_peri1_p        (pclk_peri1_p)
L758   .clk_xtal_peri1_p    (clk_xtal_peri1_p)
L756   .clk_eth0_p          (clk_eth0_p)
L757   .clk_sdma_p          (clk_sdma_p)
L745   .eth0_clk_rxphy_i    (eth0_clk_rxphy_i)
L657   .eth0_clk_tx_o       (eth0_clk_tx_o)
L668   .emmc_clk            (emmc_clk)          <- generated inside, see F4
L669   .emmc_clk2card_on    (emmc_clk2card_on)
L728   .sd_clk              (sd_clk)            <- generated inside, see F4
L729   .sd_clk2card_on      (sd_clk2card_on)
L792   .ptest_scan_dc_clk   (ptest_scan_dc_clk) <- real DFT signal, routed
L821   .test_clk            (test_clk)
`ifdef FPGA_SOURCE  L649-653  in_apll/fpll0/mpll0/mpll1/rtc_clk
```
Correctly wired to its own branch.

### `pb1_io_top u_pb1_io_top` — L885
```
L1045  .pclk               (pclk)
L925   .PAD_SDIOCLK        (PAD_SDIOCLK)     L931  .PAD_EMMCCLK  (PAD_EMMCCLK)
L887   .int_sdioclk_i      ()                L893  .int_emmcclk_i ()
L983   .int_sdioclk_o      (1'b0)            L995  .int_emmcclk_o (1'b0)
L984   .int_sdioclk_oen    (1'b1)            L996  .int_emmcclk_oen (1'b1)
```
Both SD/eMMC clock pads are held input-only (`oen=1`) with the receiver left open, while
`peri1_subsys` generates `emmc_clk` and `sd_clk` and exports them out of `pblock1`. See **F4**.

### `vga_subsys u_vga_subsys` — L1058
```
L1199  .aclk_vga_p         (aclk_vga_p)
L1228  .pclk_vga_p         (pclk_vga_p)
L1207  .clk_xtal_vga_p     (clk_xtal_vga_p)
L1201  .clk_cap_p          (clk_cap_p)
L1202  .clk_dp_aux_p       (clk_dp_aux_p)
L1203  .clk_dp_phy_ref_p   (clk_dp_phy_ref_p)
L1204  .clk_dp_sys_p       (clk_dp_sys_p)
L1205  .clk_jpeg_p         (clk_jpeg_p)
L1206  .clk_pbus_p         (clk_pbus_p)
L1233  .ptest_scan_dc_clk  (ptest_scan_dc_clk)
L1268  .test_clk           (test_clk)
L1223-1227  in_apll_clk, in_fpll0_clk, in_mpll0_clk, in_mpll1_clk, in_rtc_clk
outputs:  L1071 .clk_cap  L1072 .clk_pbus  L1073 .clk_xtal_vga  L1180 .dac_out_clk
DDC I2C clock pins: L1086-1094 out, L1208-1216 in, L1098-1106 enables
```
Correctly wired to its own branch — all eight functional clocks come from the VGA clkgen
branch.

### `usb_subsys u_usb_subsys` — L1330
```
L1415  .clk_apb                       (aclk)        <-- APB clock on the AXI clock, see F2
L1416  .clk_axi                       (aclk)        <-- ungated global, see F1
L1417  .ref_clk                       (clk_xtal)    <-- ungated global, see F1
L1479  .suspend_clk                   (suspend_clk)     <-- UNDRIVEN upstream
L1449  .ud31_utmi_clk                 (m2m_utmi_clk)    <-- UNDRIVEN upstream
L1450  .ud31_pipe_pclk                (m2m_pipe_pclk)   <-- UNDRIVEN upstream
L1480  .uh31_utmi_clk                 ({m2m_utmi_clk, clk_u31phy_utmi_pb, clk_u31phy_utmi_pa})
L1477  .uh31_pipe_pclk                ({m2m_pipe_pclk, clk_u31phy_pipe_pb, clk_u31phy_pipe_pa})
L1451  .ud31_ram_clk_in               (ud31_ram_clk_out)   <- output looped back to input
L1476  .uh31_ram_clk_in               (uh31_ram_clk_out)   <- output looped back to input
L1375  .ud31_ram_clk_out              (ud31_ram_clk_out)
L1396  .uh31_ram_clk_out              (uh31_ram_clk_out)
L1384  .clk_u31phy_utmi_pa            (clk_u31phy_utmi_pa)
L1385  .clk_u31phy_pipe_pa            (clk_u31phy_pipe_pa)
L1390  .clk_u31phy_utmi_pb            (clk_u31phy_utmi_pb)
L1391  .clk_u31phy_pipe_pb            (clk_u31phy_pipe_pb)
L1452  .ud31_dft_core_pipe_pclk_div2  (1'b0)        <-- DFT tied off
L1478  .uh31_dft_core_pipe_pclk_div2  ({3'b0})      <-- DFT tied off
L1376  .ud31_pipe_mx_pclk             ()            <-- dangling
L1377  .ud31_pipe_mx_pclk_ready       ()            <-- dangling
L1380  .ud31_ltssm_clk_state          ()            <-- dangling
L1401  .uh31_ltssm_clk_state          ()            <-- dangling
L1402  .uh31_pipe_mx_pclk             ()            <-- dangling
L1403  .uh31_pipe_mx_pclk_ready       ()            <-- dangling
L1404  .reg_clk_mux_ctrl_n0           (reg_clk_mux_ctrl_n0[1:0])
`ifdef FPGA_SOURCE / `ifdef ULPI_INF
L1333  .ulpi_clk                      (ulpi_clk)    <-- undeclared in this file
```
**This is the most problematic instance in the file.** See F1, F2, F3.

### `pcie_rc_top u_pcie_rc_top` — L1498
```
L1559  .aclk                  (aclk)                 <-- ungated global, see F1
L1591  .pclk                  (pclk)                 <-- ungated global, see F1
L1601  .rc0_pcie_clkn         (rc_pcie_clkn)         <-- UNDRIVEN upstream, see F3
L1602  .rc0_pcie_clkp         (rc_pcie_clkp)         <-- UNDRIVEN upstream, see F3
L1603  .rc0_pcie_freerun_clk  (rc_pcie_freerun_clk)  <-- UNDRIVEN upstream, see F3
L1539  .rc0_CLKREQ_OUT_N      (rc0_CLKREQ_OUT_N)
```

---

## 3. Clock domain summary

| Domain | Consumers |
|---|---|
| `aclk_peri1_p` / `pclk_peri1_p` / `clk_xtal_peri1_p` / `clk_eth0_p` / `clk_sdma_p` | `u_peri1_subsys` |
| `aclk_vga_p` / `pclk_vga_p` / `clk_xtal_vga_p` + 5 display leaf clocks | `u_vga_subsys` |
| **`aclk` (ungated global)** | **`u_pcie_rc_top`, `u_usb_subsys` (both AXI *and* APB)** |
| **`pclk` (ungated global)** | **`u_pcie_rc_top`, `u_pb1_io_top`** |
| **`clk_xtal` (ungated global)** | **`u_usb_subsys.ref_clk`** |
| `m2m_utmi_clk`, `m2m_pipe_pclk`, `suspend_clk` | `u_usb_subsys` — **no driver upstream** |
| `rc_pcie_clkp/clkn/freerun_clk` | `u_pcie_rc_top` — **no driver upstream** |

---

## 4. Findings

**F1 — `u_pcie_rc_top` and `u_usb_subsys` run on the ungated global clocks. (L1416, L1417, L1559, L1591)**
`clkgen_top` generates nine branches for these two blocks — `aclk_pcie_rc_p`,
`pclk_pcie_rc_p`, `clk_pcie_rc_p`, `clk_xtal_pcie_rc_p`, `aclk_usb_p`, `pclk_usb_p`,
`clk_xtal_usb_p`, `clk_ref_p`, `clk_suspend_p` — and **none of them has a port on this
block**. All nine are dropped at `chip_core`. The per-block source-select, divider, bypass,
OCC and stop-enable registers for PCIe RC and USB3 therefore do nothing, and the global
`reg_aclk_stop_en` / `reg_pclk_stop_en` now gates PCIe RC and USB3 along with everything else.

The comparison that makes this unambiguous: `u_usb_top2` in `pblock0` (the USB2 controller)
is wired `.clk_axi(aclk_usb2_p)`, `.clk_apb(pclk_usb2_p)`, `.clk_xtal(clk_xtal_usb2_p)`,
`.clk_ref(clk_usb_ref_p)`, `.clk_suspend(clk_usb_suspend_p)` — the complete branch. The USB3
subsystem here uses none of its equivalent branch, even though `clkgen_top` builds it.

**F2 — `u_usb_subsys.clk_apb` is connected to `aclk`, not `pclk`. (L1415)**
```
L1415  .clk_apb  (aclk)
L1416  .clk_axi  (aclk)
```
Independent of the gating question in F1, the APB clock is connected to the **AXI** clock.
Every other APB slave in the design runs on `pclk`. Either this is a copy of the line below
it, or `usb_subsys` genuinely wants its APB synchronous to AXI — worth confirming against the
`usb_subsys` spec, because if the APB master driving it runs on `pclk` this is an
unsynchronized CDC on the register interface.

**F3 — Six clock inputs to this block have no driver at `chip_core`. (L3, L4, L457-459, L515)**
`m2m_utmi_clk`, `m2m_pipe_pclk`, `suspend_clk`, `rc_pcie_clkn`, `rc_pcie_clkp`,
`rc_pcie_freerun_clk` are all declared correctly here, but at `chip_core.v:5659-5660`,
`5800-5802` and `5858` each is connected to an undeclared net with no driver anywhere in the
file — implicit 1-bit wires sitting at `z`.

Consequences: the USB3 UTMI/PIPE/suspend clocks are dead, and the PCIe root complex has no
reference clock. For the RC clocks the fix is structural — the endpoint side has real
top-level ports (`pcie_clkp`/`pcie_clkn`/`pcie_freerun_clk` routed chip_top → chip_core →
pblock0), while the RC side has no matching `chip_core` ports at all. Summary finding **X2**.

**F4 — SD/eMMC: clocks generated in `peri1_subsys`, pads held input-only, and ten clkgen MSHC branches unused.**
Three things that should be reconciled:
- `u_peri1_subsys` generates `emmc_clk` (L668) and `sd_clk` (L728) and `pblock1` exports them.
- `u_pb1_io_top` holds `PAD_SDIOCLK` and `PAD_EMMCCLK` input-only — `.int_sdioclk_o(1'b0)`
  / `.int_sdioclk_oen(1'b1)` (L983-984), `.int_emmcclk_o(1'b0)` / `.int_emmcclk_oen(1'b1)`
  (L995-996) — with both receivers left open.
- `clkgen_top` generates `clk_mshc0_{aclk,bclk,cclk,hclk,tmclk}_p` and the same five for
  `mshc1`, and `pblock1` has no port for any of them.

So the MSHC controller is clocked by something internal to `peri1_subsys`, ten dedicated
clkgen branches are dead, and the exported card clocks never reach a pad. If SD/eMMC is meant
to work, at least the pad direction is wrong.

**F5 — Six USB3 clock-status outputs left dangling. (L1376, L1377, L1380, L1401, L1402, L1403)**
`ud31_pipe_mx_pclk`, `ud31_pipe_mx_pclk_ready`, `ud31_ltssm_clk_state`, `uh31_pipe_mx_pclk`,
`uh31_pipe_mx_pclk_ready`, `uh31_ltssm_clk_state`. These report PIPE clock-mux state and
readiness. Leaving `*_pclk_ready` unobserved is worth a second look — if software or the
link-training logic needs to know the PIPE clock has switched, that information is discarded
here.

**F6 — `ulpi_clk` is undeclared. (L1333)**
Inside `` `ifdef FPGA_SOURCE `` / `` `ifdef ULPI_INF ``. Single reference in the file, no
declaration — implicit undriven wire. Only affects ULPI emulation builds.

**F7 — RAM clocks looped output→input. (L1451, L1476)**
`.ud31_ram_clk_in(ud31_ram_clk_out)` and `.uh31_ram_clk_in(uh31_ram_clk_out)`. This is a
normal pattern for USB3 controllers that expose a gated RAM clock for the integrator to buffer
and return, but it means no buffer or gate is being inserted here. Confirm that is what the IP
expects rather than a placeholder.
