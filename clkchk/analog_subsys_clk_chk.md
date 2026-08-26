# analog_subsys.sv — Clock Connection Check

Source: `optical-receiver/clkchk/analog_subsys.sv` (507 lines). Method and limitations:
[clk_chk_summary.md](clk_chk_summary.md).

`analog_subsys` owns the four PLL macros in the ASIC build. In the FPGA build the PLLs are
replaced by a board MMCM (`clk_wiz_main`). This is the root of the clock tree: everything
`clkgen_top` distributes ultimately comes from here or from the xtal.

Note the port naming — the PLL outputs are `pll_ck_*` and the references are `fref_ck_*`.
Neither contains the string `clk`, so a plain `grep clk` misses the entire PLL interface.

---

## 1. Clock ports

### Inputs
```
L?    int_xtal_clkin        <- chip_top int_xtal_clkin_mux; the PLL reference
L?    pclk                  <- APB register clock
L?    test_clk              <- PLL DFT clock; chip_top drives 1'b0 (see F2)
L?    CLK_25M               <- SAR ADC clock; chip_top drives 1'b0 (see F1)
`ifdef FPGA_SOURCE
L178  fpga_clk1_in          <- IBUFDS1 in chip_top
L179  fpga_clk2_in          <- IBUFDS2 in chip_top
L180  fpga_clk3_in          <- IBUFDS3 in chip_top
`endif
```

### Outputs
```
L98-101   pll_ck_armpll, pll_ck_dfipll, pll_ck_fpll, pll_ck_mpll     (ASIC; from u_pll_top)
`ifdef FPGA_SOURCE
L167-171  in_apll_clk[3:0], in_fpll0_clk[3:0], in_mpll0_clk[3:0], in_mpll1_clk[3:0], in_rtc_clk
`endif
```

---

## 2. FPGA build (`` `ifdef FPGA_SOURCE ``) — L207-258

### `clk_wiz_main main_pll` — L232
```
L243  .clk_in1   (int_xtal_clkin)
L235  .clk_out1  (clk_out1)     //  25 MHz
L236  .clk_out2  (clk_out2)     //  25 MHz, 90 deg
L237  .clk_out3  (clk_out3)     //  50 MHz
L238  .clk_out4  (clk_out4)     //  40 MHz
L239  .clk_out5  (clk_out5)     // 125 MHz
L240  .clk_out6  (clk_out6)     //  62.5 MHz
L241  .clk_out7  (clk_out7)     //  31.25 MHz
```

### Fan-out assignments — L246-258
```
in_apll_clk[0]  = clk_out1        (25 MHz)
in_apll_clk[1]  = clk_out3        (50 MHz)
in_apll_clk[2]  = clk_out5        (125 MHz)
in_apll_clk[3]  = fpga_clk3_in    (board)
in_fpll0_clk[0] = clk_out2        (25 MHz, 90 deg)
in_fpll0_clk[1] = clk_out4        (40 MHz)
in_fpll0_clk[2] = clk_out6        (62.5 MHz)
in_fpll0_clk[3] = clk_out7        (31.25 MHz)
in_mpll0_clk    = {3'b0, fpga_clk1_in}
in_mpll1_clk    = {3'b0, fpga_clk2_in}
in_rtc_clk      = clk_out1        (25 MHz)
```

All seven MMCM outputs are used, and every bit of the four output buses is assigned. Clean.

Two things worth recording because they affect how FPGA timing correlates to silicon:
- `in_rtc_clk` is **25 MHz**, not 32.768 kHz. This matches `rtc_top #(.ClkRtcFreqHz(25_000_000))`
  in `sys_ctrl.v:1911`, so the FPGA build is self-consistent — but see the `sys_ctrl` report
  F4 for whether the ASIC `clk_rtc` is also 25 MHz.
- `in_mpll0_clk` and `in_mpll1_clk` carry a single board clock each in bit 0 with bits 3:1
  tied to zero, whereas `in_apll_clk` and `in_fpll0_clk` carry four distinct frequencies.
  Anything that selects `in_mpll0_clk[3:1]` in `clkgen_top` gets a constant zero in emulation.

---

## 3. ASIC build (`` `else ``) — L262-401

### `pll_top u_pll_top` — L274
```
references, all four tied to the same xtal:
L333  .fref_ck_armpll  (int_xtal_clkin)    // Templated
L334  .fref_ck_dfipll  (int_xtal_clkin)    // Templated
L335  .fref_ck_fpll    (int_xtal_clkin)    // Templated
L336  .fref_ck_mpll    (int_xtal_clkin)    // Templated
outputs:
L296  .pll_ck_armpll   (pll_ck_armpll)
L297  .pll_ck_dfipll   (pll_ck_dfipll)
L298  .pll_ck_fpll     (pll_ck_fpll)
L299  .pll_ck_mpll     (pll_ck_mpll)
L300-303  .pll_cka_armpll/dfipll/fpll/mpll   ()   <-- all dangling, see F3
L288-291  .mo_rdy_clk_armpll/dfipll/fpll/mpll ()  <-- all dangling, see F4
L280-283  .mo_lock_det_*                      ()  <-- all dangling, see F4
L292-295  .mo_rdy_shift_gain_*                ()
L276-279  .dbg_out_*                          ()
APB + DFT:
L338  .pclk       (pclk)
L350  .test_clk   (test_clk)      <-- chip_top drives 1'b0, see F2
L351  .test_mode  (test_mode)
L352  .test_rst   (test_rst)
L353  .test_se    (test_se)
L354-364  .test_si1/2/3_{armpll,dfipll,fpll,mpll}
```
The four `pll_ck_*` outputs go to `chip_top` and back down into `chip_core`:
`pll_ck_armpll` → `in_armpll_clk` (AP), `pll_ck_mpll` → `in_mpll_clk` (sys_ctrl),
`pll_ck_fpll` → `in_fpll_clk` (sys_ctrl), `pll_ck_dfipll` → `in_dfipll_clk` (**dropped**, see
summary finding **X2**).

### `common_apb_sep #(.NUM_SLAVES(16), .TOTAL_SIZE_BYTES(4096)) u_common_apb_sep` — L387
No clock ports — combinational APB address decoder. See **F5** for a non-clock issue with its
placement.

---

## 4. Always-present instances (outside the `` `ifdef ``)

### `IGEN_DCT_TN12FFCLL_A0_wrapper` — L421
```
L445  .pclk  (pclk)
```

### `SAR_ADC_TOP_wrapper` — L476
```
L510  .pclk     (pclk)
L521  .CLK_25M  (CLK_25M)     <-- chip_top drives 1'b0, see F1
```

---

## 5. Findings

**F1 — The SAR ADC has no conversion clock. (L521 + chip_top.v:2832)**
```
analog_subsys.sv:521   .CLK_25M (CLK_25M)      <- real input port, reaches the ADC wrapper
chip_top.v:2832        .CLK_25M (1'b0)         <- driven with a constant
```
Nothing is wrong on this side; the input is wired correctly to the ADC. The tie-off is one
level up. `int_xtal` (the 25 MHz xtal) is in scope at chip_top.v:2832 and is the obvious
intended source. Summary finding **X5**.

**F2 — `test_clk` into the PLLs is tied to `1'b0`. (L350 + chip_top.v:2858)**
The PLL DFT clock is a real port here and `chip_top` drives it with a constant. Combined with
the same pattern on `clkgen_top` (`sys_ctrl.v:1780-1787`, all eight `ptest_*` inputs zeroed)
and on the DDR PHY (`chip_core.v:4514-4521`), the result is that **DFT clock control reaches
the peripheral blocks but stops at all three places that own a clock source**. Note that
`test_mode`, `test_rst`, `test_se` and all twelve `test_si*` pins *are* real routed signals
here — only the clock is tied off, which is the one that matters for scan shift. Summary
finding **X4**.

**F3 — All four `pll_cka_*` outputs dangling. (L300-303)**
`.pll_cka_armpll()`, `.pll_cka_dfipll()`, `.pll_cka_fpll()`, `.pll_cka_mpll()` — tied off by
the AUTO_TEMPLATE `.pll_cka\(.*\) ()` at L266. If `pll_cka` is a second phase or a
complementary output the PLL is designed to drive, leaving all four open is worth confirming
with the macro datasheet; if it is genuinely unused, fine.

**F4 — PLL lock and ready status all discarded. (L280-291)**
`.mo_lock_det_{armpll,dfipll,fpll,mpll}()` and `.mo_rdy_clk_{armpll,dfipll,fpll,mpll}()` are
all left open, tied off by the `.mo_\(.*\) ()` template at L264.

This is the one to look at hardest. Nothing anywhere in this design observes whether the PLLs
have locked. `clkgen_top` will happily switch `aclk`/`pclk` onto `in_mpll_clk` or
`in_fpll_clk` on an APB write with no lock interlock, and no reset sequencer can wait for
lock. If `mo_lock_det_*` is meant to feed a status register or gate the clock mux, that path
is missing entirely. (The register bank exists — `u_common_apb_sep` splits a 4 KB window 16
ways for the four PLL register blocks — so a lock-status bit would have somewhere to live.)

**F5 — Non-clock, but severe: the APB decoder is inside the `` `else `` branch. (L387, inside L260-405)**
`u_common_apb_sep` is the only driver of `prdata_analog`, `pready_analog`, `pslverr_analog`
and `psel_analog_gp`, and it sits inside `` `else `` of `` `ifdef FPGA_SOURCE ``. In the FPGA
build it is not instantiated, so those three `analog_subsys` outputs have no driver at all and
`psel_analog_gp` is undriven — meaning an APB access to the analog window hangs the bus in
emulation. `IGEN_DCT_TN12FFCLL_A0_wrapper` and `SAR_ADC_TOP_wrapper` are instantiated
unconditionally (L421, L476) and their `*_prdata_out` / `*_pready_out` / `*_pslverr_out`
signals go nowhere in that build.

Outside the scope of a clock check, but it is in the same `` `ifdef `` region and would be
caught by the same review pass.
