# sys_ctrl.v — Clock Connection Check

Source: `optical-receiver/clkchk/sys_ctrl.v` (2222 lines). Cross-file rollup:
[clk_chk_summary.md](clk_chk_summary.md).

Method: every sub-module instantiation was extracted, then every port whose **port name**
contains `clk`/`CLK` was listed with its connected net. Lines inside `/* ... AUTO_TEMPLATE ... */`
comment blocks were excluded (they are templates, not real connections). `reg_*_src_sel`,
`reg_*_byp_en`, `reg_*_stop_en`, `reg_div_dis_*` ports were excluded — they are APB control
registers, not clocks.

---

## 1. Clock ports of `sys_ctrl` itself

### Clock inputs
| Port | Width | Guard | Goes to |
|---|---|---|---|
| `in_apll_clk`  | [3:0] | `` `ifdef FPGA_SOURCE `` | `u_clkgen_top` |
| `in_fpll0_clk` | [3:0] | `` `ifdef FPGA_SOURCE `` | `u_clkgen_top` |
| `in_mpll0_clk` | [3:0] | `` `ifdef FPGA_SOURCE `` | `u_clkgen_top` |
| `in_mpll1_clk` | [3:0] | `` `ifdef FPGA_SOURCE `` | `u_clkgen_top` |
| `in_rtc_clk`   | 1     | `` `ifdef FPGA_SOURCE `` | `u_clkgen_top` |
| `in_mpll_clk`  | 1     | `` `else `` (ASIC) | `u_clkgen_top` |
| `in_fpll_clk`  | 1     | `` `else `` (ASIC) | `u_clkgen_top` |
| `in_xtal_clk`  | 1     | always | `u_clkgen_top` |
| `clk_fast`     | 1     | always | **`u_mbox_top` only — does not pass through clkgen_top** |
| `clk_slow`     | 1     | always | **`u_mbox_top` only — does not pass through clkgen_top** |

### Clock outputs
`aclk`, `pclk`, `clk_xtal`, `int_fpll_clk_div4`, `int_fpll_clk_div6`, plus **88 leaf clocks**
(`*_p`), all driven by `u_clkgen_top` and passed straight out.

`aclk`, `pclk`, `clk_xtal` are `output` ports *and* are read internally — legal Verilog, just
note the dual role.

### Internal-only clock net
`clk_rtc` — `wire`, driven by `u_clkgen_top`, consumed only by `u_rtc_top`. Correctly not exported.

---

## 2. Per-instance clock connections

### `clkgen_top u_clkgen_top` — L1669  *(the only clock generator)*
**Clock inputs**
```
L1671  .in_apll_clk        (in_apll_clk[3:0])     `ifdef FPGA_SOURCE
L1672  .in_fpll0_clk       (in_fpll0_clk[3:0])    `ifdef FPGA_SOURCE
L1673  .in_mpll0_clk       (in_mpll0_clk[3:0])    `ifdef FPGA_SOURCE
L1674  .in_mpll1_clk       (in_mpll1_clk[3:0])    `ifdef FPGA_SOURCE
L1675  .in_rtc_clk         (in_rtc_clk)           `ifdef FPGA_SOURCE
L1678  .in_mpll_clk        (in_mpll_clk)          `else (ASIC)
L1679  .in_fpll_clk        (in_fpll_clk)          `else (ASIC)
L1788  .in_xtal_clk        (in_xtal_clk)
L1782  .ptest_scan_dc_clk  ({1{1'b0}})            <-- TIED OFF
```
**Clock outputs** — 94 nets, all cross-checked against the `sys_ctrl` port/wire
declarations: **no missing declarations, no width mismatches.**
```
L1684  .int_fpll_clk_div6  (int_fpll_clk_div6)     -> sys_ctrl output
L1685  .int_fpll_clk_div4  (int_fpll_clk_div4)     -> sys_ctrl output
L1686  .aclk               (aclk)                  -> sys_ctrl output + internal
L1687  .pclk               (pclk)                  -> sys_ctrl output + internal
L1688  .clk_xtal           (clk_xtal)              -> sys_ctrl output + internal
L1689  .clk_rtc            (clk_rtc)               -> internal wire ONLY
L1690..L1777   88 x .<name>_p  (<name>_p)          -> sys_ctrl outputs, pass-through
```

### `sys_ctrl_DW_axi_wp u_sys_ctrl_DW_axi` — L709
```
L794   .aclk               (aclk)
```
Single AXI domain. Correct.

### `sec_DW_axi_x2p u_sec_DW_axi_x2p` — L1010
```
L1041  .aclk               (aclk)
L1067  .pclk               (pclk)
```
AXI→APB bridge, dual domain. Correct.

### `SYS_CTRL_DW_axi_x2p u_SYS_CTRL_DW_axi_x2p` — L1192
```
L1228  .aclk               (aclk)
L1254  .pclk               (pclk)
```
AXI→APB bridge, dual domain. Correct.

### `reg_top3_dbg reg_top3_dbg` — L1323
```
L1346  .pclk               (pclk)
L1353  .aclk_sys_ctrl      (aclk)
```

### `reg_top3_sec reg_top3_sec` — L1377
```
L1511  .pclk               (pclk)
L1513  .aclk_sys_ctrl      (aclk)
```

### `reg_clkgen_top u_reg_clkgen_top` — L1545
```
L1660  .pclk               (pclk)
```
Register file for clkgen. Single domain — correct.

### `rtc_top #(.ClkRtcFreqHz(25_000_000)) u_rtc_top` — L1911
```
L1919  .clk_apb            (pclk)
L1927  .clk_rtc            (clk_rtc)
```

### `mbox_top u_mbox_top` — L1959
```
L1972  .clk_fast           (clk_fast)
L1974  .clk_slow           (clk_slow)
```
**No APB clock port.** Its two APB slave interfaces are clocked by `clk_fast`/`clk_slow`.

### `timer_top u_timer_top` — L2014 (`timer_top_empty` at L2012 under `` `ifndef ADD_TIMER ``)
```
L2023  .clk_apb_i          (pclk)
L2031  .clk_timer_i        (clk_xtal)   // comment: "clkgen_top no longer emits clk_timer"
```

### `wdt_top #(.ClkWdtFreqHz(25000000)) u_wdt_top` — L2065 (`wdt_top_empty` at L2063 under `` `ifndef ADD_WDT ``)
```
L2084  .pclk_i             (pclk)
L2092  .clk_wdt_i          (clk_xtal)
```

### `pufs_otpc_autoload_wrap u_pufs_otpc_autoload_wrap` — L2143
```
L2171  .clk_apb            (pclk)
L2177  .clk_cyp            (pclk)
L2178  .clk_xtl            (clk_xtal)
L2180  .scan_clk           (1'b0)       <-- TIED OFF
L2145  .clk_xtl_busy       ()           <-- output left dangling (status, not a clock)
```

### `common_apb_sep #(.NUM_SLAVES(2)) u_common_apb_sep_puf_autold` — L2196
No clock ports — purely combinational APB splitter. Expected.

---

## 3. Clock domain summary

| Domain | Source | Consumers inside sys_ctrl |
|---|---|---|
| `aclk`  | clkgen_top | u_sys_ctrl_DW_axi, u_sec_DW_axi_x2p, u_SYS_CTRL_DW_axi_x2p, reg_top3_dbg, reg_top3_sec |
| `pclk`  | clkgen_top | u_sec_DW_axi_x2p, u_SYS_CTRL_DW_axi_x2p, reg_top3_dbg, reg_top3_sec, u_reg_clkgen_top, u_rtc_top(apb), u_timer_top(apb), u_wdt_top(apb), u_pufs(apb+cyp) |
| `clk_xtal` | clkgen_top (from `in_xtal_clk`) | u_timer_top, u_wdt_top, u_pufs(clk_xtl) |
| `clk_rtc`  | clkgen_top | u_rtc_top |
| `clk_fast` | **sys_ctrl port, external** | u_mbox_top |
| `clk_slow` | **sys_ctrl port, external** | u_mbox_top |

---

## 4. Findings to review

**F1 — `u_mbox_top` has no clock at all. RESOLVED — blocker. (L1959-1989)**
`fpsel_i`/`spsel_i` come from `psel_mbox` (out of `u_SYS_CTRL_DW_axi_x2p`, pclk domain), and
`fpaddr_i`/`spaddr_i`/`fpwdata_i`/`spwdata_i`/`fpstrb_i`/`spstrb_i` all come from
`paddr_sys_ctrl` / `pwdata_sys_ctrl` / `pstrb_sys_ctrl` (pclk domain). But `mbox_top` has no
APB clock port — it samples those with `clk_fast` and `clk_slow`.
Also `fpenable_i`/`fpwrite_i`/`spenable_i`/`spwrite_i` are top-level `sys_ctrl` inputs rather
than the local `penable_sys_ctrl`/`pwrite_sys_ctrl`, which suggests these were meant to be
driven from the fast/slow domains at the parent.

**Checked at the parent, and the answer is worse than a CDC question:** at
`chip_core.v:3975-3976` the `u_sys_ctrl` instance is connected as `.clk_fast(clk_fast)` and
`.clk_slow(clk_slow)`, and **neither net is declared or driven anywhere in `chip_core.v`** —
each appears exactly once in the whole file. They are implicit 1-bit wires sitting at `z`. The
mailbox has no working clock in any build. See [chip_core_clk_chk.md](chip_core_clk_chk.md) F1
and summary finding **X2**.
**Action:** drive `clk_fast`/`clk_slow` at `chip_core`. Once they exist, the original CDC
question still needs answering — if neither is `pclk`, the APB path into `mbox_top` is an
unsynchronized crossing unless the IP synchronizes internally.

**F2 — All DFT clock/scan ports on `u_clkgen_top` are hard-tied to constants. (L1780-1787)**
```
.ptest_scan_mode    ({1{1'b0}})
.ptest_scan_dc_mode ({1{1'b0}})
.ptest_scan_dc_clk  ({1{1'b0}})
.ptest_icg_mode     ({1{1'b0}})
.ptest_mbist_mode   ({1{1'b0}})
.ptest_occ_bypass   ({1{1'b0}})
.ptest_scan_in      ({1{1'b0}})
.ptest_scan_en      ({1{1'b0}})
.ptest_scan_out     ()
```
These come from the AUTO_TEMPLATE at L1666, which auto-ties every `ptest_*` input to zero.
Meanwhile `sys_ctrl` *does* have real `scan_mode`, `scan_en` and `mbist_mode` input ports —
per the AUTOINPUT comments those go only to `u_rtc_top`. So in scan mode the clkgen mux /
divider-gating / OCC / bypass / stop stages cannot be controlled, and `ptest_scan_out` is
dangling, breaking the scan chain through clkgen.
**Action:** if DFT is expected to reach clkgen_top, replace the template tie-offs with the real
`scan_mode`/`scan_en`/`mbist_mode` ports and a proper scan-chain hookup. If clkgen is
intentionally outside the scan chain, this is fine but should be documented.

**F3 — `u_pufs_otpc_autoload_wrap.scan_clk` tied to `1'b0`. (L2180)**
Same DFT question as F2, for the OTP controller.

**F4 — `rtc_top` is parameterized `ClkRtcFreqHz(25_000_000)` but is clocked by `clk_rtc`. (L1911, L1927)**
`clk_rtc` is a distinct clkgen output from `clk_xtal`, with its own `reg_clk_rtc_src_sel`,
`reg_clk_rtc_byp_en`, `reg_clk_rtc_stop_en` controls — so it is not necessarily the 25 MHz
xtal. `wdt_top` uses `ClkWdtFreqHz(25000000)` on `clk_xtal`, which is consistent; the RTC one
is worth confirming against the actual `clk_rtc` divider setting in `clkgen_top`.

**F5 — `u_pufs_otpc_autoload_wrap.clk_cyp` is tied to `pclk`. (L2177)**
If `clk_cyp` is meant to be an independent crypto/OTP clock, driving it from `pclk` means the
OTP crypto engine runs at APB rate and follows any `pclk` source-select / stop-enable change.
Confirm this is intended.

**F6 — `u_pufs_otpc_autoload_wrap.clk_xtl_busy` output is unconnected. (L2145)**
Not a clock, but it is the xtal-clock busy status. Confirm nothing needs to observe it (e.g.
before allowing `clk_xtal` source switch or stop).

**F7 — `in_rtc_clk` exists only under `` `ifdef FPGA_SOURCE ``. (L82, L1675)**
In the ASIC build there is no external RTC clock input, so `clk_rtc` must be derived entirely
inside `clkgen_top` from `in_xtal_clk` / the PLLs. Consistent between the port list and the
instantiation — just noting the ASIC/FPGA asymmetry.

**F8 — `clk_timer_i` sources `clk_xtal`, per comment "clkgen_top no longer emits clk_timer". (L2003, L2031)**
Timer and WDT now share `clk_xtal` with the PUF OTP controller. Any `reg_clk_xtal_stop_en` /
`reg_clk_xtal_src_sel` write stops or reslews the timer, watchdog and OTP together. Confirm
the watchdog is allowed to be stopped by an APB write to the clkgen registers — that is
usually something a WDT is required to survive.

---

## 5. What this check could *not* verify

None of the sub-module RTL files are present in `optical-receiver/clkchk/` (only
`sys_ctrl.v`, `chip_top.v`, `chip_core.v`, `pblock0.v`, `pblock1.v`, `analog_subsys.sv`).
The `verilog-library-directories` list at L2216-2218 points outside this directory. So:

- **Missing clock ports cannot be detected.** If a sub-module has a clock port that AUTOINST
  never emitted (e.g. because the instantiation was hand-edited or AUTO was last run against
  an older version of the sub-module), it would not show up here.
- Port **directions** and **widths** on the sub-module side are unverified.

To close that gap, re-run `verilog-auto` on `sys_ctrl.v` with the library paths resolvable and
diff the result — any port that appears or disappears is a stale connection.
