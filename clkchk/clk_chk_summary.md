# clkchk — Clock Connection Check, Cross-File Summary

Files checked (all RTL in `optical-receiver/clkchk/`):

| File | Lines | Report |
|---|---|---|
| `chip_top.v`       | 2746 | [chip_top_clk_chk.md](chip_top_clk_chk.md) |
| `chip_core.v`      | 6229 | [chip_core_clk_chk.md](chip_core_clk_chk.md) |
| `analog_subsys.sv` |  507 | [analog_subsys_clk_chk.md](analog_subsys_clk_chk.md) |
| `sys_ctrl.v`       | 2180 | [sys_ctrl_clk_chk.md](sys_ctrl_clk_chk.md) |
| `pblock0.v`        | 1836 | [pblock0_clk_chk.md](pblock0_clk_chk.md) |
| `pblock1.v`        | 1596 | [pblock1_clk_chk.md](pblock1_clk_chk.md) |

## Method

For every file: extract each sub-module instantiation, then every port whose **port name or
connected net** matches `clk | clock | _ck_ | xtal | osc | refck`. Lines inside
`/* ... AUTO_TEMPLATE ... */` blocks are excluded — they are templates, not connections, and a
naive `grep clk` reports about 40 false hits per file from them. `reg_*_src_sel`,
`reg_*_byp_en`, `reg_*_stop_en` and `reg_div_dis_*` are excluded — APB control registers, not
clocks. Two automated cross-checks are then run per file:

1. **Undeclared-net check** — every net used in a clock port connection that has no
   `input`/`output`/`inout`/`wire`/`logic`/`reg` declaration and no `assign`. In Verilog these
   become implicit 1-bit wires; if the net appears exactly once, it has **no driver at all**.
2. **Dangling-driver check** — every clock net declared as a `wire` driven by one instance and
   referenced nowhere else.

Note the `_ck` naming (`pll_ck_mpll`, `fref_ck_armpll`, `PAD_LTPI_TX_CK_P`, `ddr4_ck_t`) does
not contain the string "clk". A plain `grep clk` misses all of it.

---

## The clock tree, as actually wired

```
                        PAD                     chip_top
  fpga_clk1/2/3_in_p/n --+-> IBUFDS ------------> fpga_clk1..3_in   (FPGA build)
  int_xtal_clkin  <------ chip_io_top XTAL pad
        |
        +-- int_xtal_clkin_mux --> analog_subsys.int_xtal_clkin --> pll_top.fref_ck_{arm,dfi,f,m}pll
        |                                                                  |
        +-- int_xtal ------------> chip_core.in_xtal_clk                   v
                                                                   pll_ck_armpll ---> chip_core.in_armpll_clk --> ap_subsys
                                                                   pll_ck_mpll   ---> chip_core.in_mpll_clk ----> sys_ctrl
                                                                   pll_ck_fpll   ---> chip_core.in_fpll_clk ----> sys_ctrl
                                                                   pll_ck_dfipll ---> chip_core.in_dfipll_clk -> (DROPPED, see X2)

  chip_core.u_sys_ctrl.u_clkgen_top  =  the only programmable clock generator
        |
        +-- aclk, pclk, clk_xtal, clk_rtc, int_fpll_clk_div4/6
        +-- 88 leaf clocks *_p  --> 66 routed to consumers
                                --> 22 generated and never consumed (see X1)
```

`chip_top` and `chip_core` are the only places where a clock crosses a hierarchy boundary
without going through `clkgen_top`.

---

## Cross-cutting findings

### X1 — 22 of the 88 clkgen leaf clocks are generated and never consumed

Verified in `chip_core.v` by counting references to each net connected to a `u_sys_ctrl` clock
output port, excluding the `u_sys_ctrl` instantiation itself. These 22 have exactly one
reference (the `wire` declaration) and no consumer:

| Group | Dangling nets |
|---|---|
| PCIe EP | `aclk_pcie_ep_p`, `pclk_pcie_ep_p`, `clk_pcie_ep_p`, `clk_xtal_pcie_ep_p` |
| PCIe RC | `aclk_pcie_rc_p`, `pclk_pcie_rc_p`, `clk_pcie_rc_p`, `clk_xtal_pcie_rc_p` |
| USB3 | `aclk_usb_p`, `pclk_usb_p`, `clk_xtal_usb_p`, `clk_ref_p`, `clk_suspend_p` |
| Cliptra | `aclk_cliptra_p`, `pclk_cliptra_p` |
| MSHC (eMMC/SD) | `clk_mshc0_{aclk,bclk,cclk,hclk,tmclk}_p`, `clk_mshc1_{aclk,bclk,cclk,hclk,tmclk}_p` |
| PCIe EP misc | `clk_mvdm_p` (see X3) |

Corroborating evidence from the port lists: `pblock0` has **no** `aclk_pcie_ep_p` /
`pclk_pcie_ep_p` / `clk_pcie_ep_p` / `aclk_usb_p` port at all, and `pblock1` has **no**
`aclk_pcie_rc_p` / `pclk_pcie_rc_p` / `clk_pcie_rc_p` / `clk_ref_p` / `clk_suspend_p` port.
The blocks that should consume these branches never had the ports created.

Instead those blocks take the **ungated global `aclk`/`pclk`** directly:

| Instance | File | What it gets | What clkgen made for it |
|---|---|---|---|
| `u_pcie_ep_top` | pblock0.v:1442,1527 | `.aclk(aclk)`, `.pclk(pclk)` | `aclk_pcie_ep_p`, `pclk_pcie_ep_p` |
| `u_pcie_rc_top` | pblock1.v:1559,1591 | `.aclk(aclk)`, `.pclk(pclk)` | `aclk_pcie_rc_p`, `pclk_pcie_rc_p` |
| `u_usb_subsys`  | pblock1.v:1415-1417 | `.clk_apb(aclk)`, `.clk_axi(aclk)`, `.ref_clk(clk_xtal)` | `aclk_usb_p`, `pclk_usb_p`, `clk_xtal_usb_p`, `clk_ref_p` |
| `u_dram_subsys` | chip_core.v:4482 | `.aclk_ddr_p(aclk)` | `aclk_ddr_p` |

**Consequence:** for these blocks the per-block source-select, divider, bypass, OCC and
stop-enable stages in `clkgen_top` do nothing. Writing `reg_aclk_pcie_ep_src_sel` or
`reg_clk_usb_ref_stop_en` has no effect on the hardware. Conversely, a write to the *global*
`reg_aclk_stop_en` / `reg_pclk_stop_en` now stops PCIe EP, PCIe RC, USB3 and DDR together.

For contrast, the blocks that **are** wired correctly: `u_peri0_subsys`, `u_peri1_subsys`,
`u_vga_subsys`, `u_usb_top2` (USB2), `u_ap_subsys`, `u_mcu_subsys`. Compare `u_usb_top2`
(pblock0.v:1783-1787) — `.clk_axi(aclk_usb2_p)`, `.clk_apb(pclk_usb2_p)`,
`.clk_xtal(clk_xtal_usb2_p)`, `.clk_ref(clk_usb_ref_p)`, `.clk_suspend(clk_usb_suspend_p)` —
with `u_usb_subsys` (USB3) two lines away in the other pblock, which uses none of its branch.

**Note on `.clk_apb(aclk)` at pblock1.v:1415** — even setting the gating question aside, the
USB3 subsystem's APB clock is connected to the **AXI** clock, not `pclk`. Every other APB
slave in the design runs on `pclk`. This one is worth confirming independently of X1.

### X2 — 9 clock nets in `chip_core.v` have no driver at all

These are used in port connections but never declared and never driven. Verilog makes them
implicit 1-bit wires; the receiving block sees `z`.

| Net | Line | Feeds | Notes |
|---|---|---|---|
| `clk_fast` | chip_core.v:3975 | `u_sys_ctrl` → `u_mbox_top` | **Mailbox has no clock.** |
| `clk_slow` | chip_core.v:3976 | `u_sys_ctrl` → `u_mbox_top` | **Mailbox has no clock.** |
| `DfiClk` | chip_core.v:4458 | `u_dram_subsys` | DDR DFI clock. See below. |
| `suspend_clk` | chip_core.v:5858 | `u_pblock1` → `u_usb_subsys` | USB3 suspend clock. |
| `m2m_utmi_clk` | chip_core.v:5659 | `u_pblock1` → `u_usb_subsys` | USB3 UTMI clock. |
| `m2m_pipe_pclk` | chip_core.v:5660 | `u_pblock1` → `u_usb_subsys` | USB3 PIPE clock. |
| `rc_pcie_clkp` | chip_core.v:5801 | `u_pblock1` → `u_pcie_rc_top` | PCIe RC refclk+. |
| `rc_pcie_clkn` | chip_core.v:5800 | `u_pblock1` → `u_pcie_rc_top` | PCIe RC refclk-. |
| `rc_pcie_freerun_clk` | chip_core.v:5802 | `u_pblock1` → `u_pcie_rc_top` | PCIe RC free-run clock. |

Each was confirmed by an independent whole-file search returning exactly one hit.

Three of these have an obvious intended source:

- **`DfiClk`** — `chip_core` has an `in_dfipll_clk` input (chip_core.v:605) driven by
  `pll_ck_dfipll` from `chip_top` (chip_top.v:2326), and that input is **used nowhere in
  chip_core**. `.DfiClk(in_dfipll_clk)` is almost certainly what was meant. As written the DFI
  PLL output is carried down two levels of hierarchy and then dropped, and the DDR subsystem's
  DFI clock floats.
- **`rc_pcie_clkp/clkn/freerun_clk`** — the EP side has real top-level ports
  (`pcie_clkp`/`pcie_clkn`/`pcie_freerun_clk`, 4 references each, routed
  chip_top → chip_core → pblock0). The RC side has the same three connections in
  `u_pblock1` but no matching `chip_core` ports were ever created. The RC PCIe reference clock
  never reaches the pad.
- **`clk_fast`/`clk_slow`** — this resolves the open question in the `sys_ctrl` report (F1
  there). The mailbox APB interfaces are driven from the `pclk` domain while the module is
  clocked by `clk_fast`/`clk_slow`; at `chip_core` level neither clock exists. `u_mbox_top`
  has no working clock in any build.

### X3 — `clk_mvdm_p` / `clk_vdm_p` name mismatch

```
chip_core.v:3886    .clk_mvdm_p   (clk_mvdm_p)     <- driven by u_sys_ctrl
chip_core.v:1567    wire clk_mvdm_p;               <- declared, never consumed
chip_core.v:5032    .clk_mvdm     (clk_vdm_p)      <- u_pblock0, net has no declaration
chip_core.v:4660                                   <- and the AUTO_TEMPLATE has the same typo
```

`clk_vdm_p` (no `m`) is undeclared and undriven. `u_pcie_ep_top`'s MVDM clock
(pblock0.v:1459) is therefore floating, while the correctly-generated `clk_mvdm_p` goes
nowhere. Because the typo is in the AUTO_TEMPLATE at chip_core.v:4660, re-running
`verilog-auto` will reproduce it — **fix the template, not just the expansion.**

Its two siblings are wired correctly: `.clk_pbmc(clk_pbmc_p)` and `.clk_pmmbi(clk_pmmbi_p)`
(chip_core.v:5033, 5037).

### X4 — DFT clock ports are tied to constants throughout

| Instance | File:line | Connection |
|---|---|---|
| `u_clkgen_top` | sys_ctrl.v:1780-1787 | all 8 `ptest_*` inputs `{1{1'b0}}`, `ptest_scan_out` dangling |
| `u_pufs_otpc_autoload_wrap` | sys_ctrl.v:2180 | `.scan_clk(1'b0)` |
| `u_analog_subsys` | chip_top.v:2858 | `.test_clk(1'b0)` → `u_pll_top.test_clk` |
| `u_pblock1` | chip_core.v:5859 | `.test_clk(1'b0)` |
| `u_usb_top2` | pblock0.v:1790, 1801 | `.clk_test_pa(1'b0)`, `.clk_test_bp(1'b0)` |
| `u_dram_subsys` | chip_core.v:4514-4521 | `.atpg_Pclk`, `.atpg_PllRefClk`, `.atpg_RDQSClk`, `.atpg_TxDllClk`, `.atpg_UcClk`, `.atpg_Asst_Clken` all `1'b0`; `.atpg_Asst_Clk()` dangling |
| `u_usb_subsys` | pblock1.v:1452, 1478 | `.ud31_dft_core_pipe_pclk_div2(1'b0)`, `.uh31_dft_core_pipe_pclk_div2({3'b0})` |

Meanwhile real DFT ports **do** exist and are routed: `ptest_scan_dc_clk` reaches
`u_peri1_subsys` (pblock1.v:792), `u_vga_subsys` (pblock1.v:1233) and `u_ap_subsys`
(chip_core.v:6171); `ptest_clk_scan_en` reaches `u_peri0_subsys` (pblock0.v:1036); `sys_ctrl`
has `scan_mode`/`scan_en`/`mbist_mode` inputs that go only to `u_rtc_top`.

So DFT clock control reaches the peripheral blocks but **stops at `clkgen_top`, `pll_top` and
the DDR PHY** — exactly the three places that own the clock sources. In scan mode the clock
muxes, dividers, OCC and bypass stages cannot be controlled, and `ptest_scan_out` /
`atpg_Asst_Clk` leave the chains open. If clkgen and the PLLs are meant to be outside the scan
chain this is fine but should be documented; otherwise it is a coverage hole at the root of
the tree.

### X5 — `CLK_25M` into the SAR ADC is tied to `1'b0`

```
chip_top.v:2832        .CLK_25M (1'b0)          -> analog_subsys
analog_subsys.sv:521   .CLK_25M (CLK_25M)       -> SAR_ADC_TOP_wrapper
```

`CLK_25M` is a real `analog_subsys` input that reaches the SAR ADC wrapper, and `chip_top`
drives it with a constant zero. The ADC has no conversion clock. `int_xtal` (the 25 MHz xtal)
is available at that point in `chip_top` and is the obvious intended source.

### X6 — Block-generated clocks exported and then dropped at `chip_core`

`peri0_subsys` and `vga_subsys` generate divided clocks, `pblock0`/`pblock1` export them, and
`chip_core` declares them as wires with no consumer:

- From `u_pblock0` (chip_core.v:4719-4729, 4761): `clk_bsspi0`, `clk_espi_ahb`, `clk_fsi`,
  `clk_peci`, `clk_sgpio`, `clk_spi0`, `clk_spi1`, `clk_spi2`, `clk_ufs`, `clk_xtal_peri0`,
  `hclk_fwspi0`
- From `u_pblock1` (chip_core.v:5338-5340): `clk_cap`, `clk_pbus`, `clk_xtal_vga`

Only `clk_ltpi` is actually consumed — it reaches `ltpi_system_top` (chip_core.v:6358). If the
rest are meant to drive IO pads (SPI SCK, eSPI, SGPIO), that routing is missing; if they are
observation-only, they should be explicitly tied off so lint stops reporting them.

### X7 — FPGA-only undriven clock nets

Lower priority — these only exist under `` `ifdef FPGA_USB `` / `` `ifdef ULPI_INF ``.

- `chip_top.v:2456-2470`, all undeclared and single-reference: `clk_pipe_up`, `clk_vhub0`,
  `clk_utmi_porta`, `clk_utmi_portc`, `clk_utmi_portd`, `clk_mac`, `clk_wiz_ulpi_clk_in1`,
  `clk_wiz_ulpi_clk_out1` … `clk_wiz_ulpi_clk_out7`. The matching `chip_core` ports **are**
  declared (chip_core.v inputs/outputs), so this is a missing `chip_top` wire block.
- `pblock1.v:1333` — `.ulpi_clk(ulpi_clk)`, undeclared, `` `ifdef ULPI_INF `` only.
- `chip_top.v:1449` declares `fpga_clk_xtal, fpga_clk1_in, fpga_clk2_in` but **omits
  `fpga_clk3_in`**, which IBUFDS3 drives at chip_top.v:1453 — it works as an implicit wire,
  but the asymmetry is accidental.
- `chip_top.v:1450` — `IBUFDS0` is commented out, so `fpga_clk_xtal` is declared and never
  driven, and `int_xtal_clkin_mux` (chip_top.v:1455) takes the raw single-ended pad
  `fpga_clk_in_p` instead of a differential buffer output.
- `chip_core.v:4357/4376` — `c0_ddr4_ui_clk_pre` is an undeclared implicit wire on a
  `dram_subsys` **output**; harmless, but it should be declared or explicitly left open.

---

## Priority

| # | Finding | Severity | Fix location |
|---|---|---|---|
| X2 | `clk_fast`/`clk_slow` undriven → mailbox dead | **Blocker** | chip_core.v:3975 |
| X2 | `DfiClk` undriven, `in_dfipll_clk` dropped | **Blocker** | chip_core.v:4458 |
| X2 | `rc_pcie_clk{p,n}`, `rc_pcie_freerun_clk` undriven | **Blocker** | chip_core ports + chip_top |
| X2 | `suspend_clk`, `m2m_utmi_clk`, `m2m_pipe_pclk` undriven | **Blocker** | chip_core.v:5659-5858 |
| X3 | `clk_vdm_p` typo → PCIe EP MVDM clock floating | **Blocker** | chip_core.v:4660 (template) |
| X5 | `CLK_25M` tied to `1'b0` → SAR ADC has no clock | **Blocker** | chip_top.v:2832 |
| X1 | 22 clkgen branches unused; 4 blocks on ungated `aclk`/`pclk` | **High** | pblock0/pblock1 port lists |
| X1 | `u_usb_subsys.clk_apb` connected to `aclk`, not `pclk` | **High** | pblock1.v:1415 |
| X4 | DFT clock control does not reach clkgen / PLL / DDR PHY | **High** | sys_ctrl.v:1666 template |
| X6 | 12 block-generated clocks dropped at chip_core | Medium | chip_core.v |
| X7 | FPGA-only undriven nets | Low | chip_top.v:2456 |

---

## What this check could not verify

No sub-module RTL is present in `clkchk/` — only the six files listed above. Everything
referenced by them (`clkgen_top`, `pll_top`, `peri0_subsys`, `peri1_subsys`, `usb_subsys`,
`pcie_ep_top`, `pcie_rc_top`, `dram_subsys`, `mbox_top`, `vga_subsys`, `mcu_subsys`,
`ap_subsys`, …) lives outside this directory. Therefore:

- **A clock port that AUTOINST never emitted is invisible to this check.** If a sub-module
  gained a clock port after `verilog-auto` was last run, the connection is simply absent from
  the instantiation and nothing here would flag it. The X1 finding — pblocks with no
  `aclk_pcie_ep_p` port at all — is exactly this failure mode caught from the other side.
- Port **directions** and **widths** on the sub-module side are unverified. A clock driven
  into an `output`, or a `[3:0]` bus onto a 1-bit port, would not be detected.
- Constant tie-offs are reported as written; whether a given `1'b0` is a deliberate DFT
  decision or an oversight cannot be determined from these files alone.

To close the gap: make the `verilog-library-directories` paths at sys_ctrl.v:2216-2218
resolvable, re-run `verilog-auto` on each file, and diff. Any port that appears or disappears
is a stale connection. Note X3 first — the typo is in the template, so a re-run will
regenerate it.
