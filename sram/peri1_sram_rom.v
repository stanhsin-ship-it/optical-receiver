module peri1_sram_rom(/*AUTOARG*/
   // Outputs
   wready_top_peri0_sram, wready_s_sram_rom, wready_mem2sram,
   srecc3_intr, srecc2_intr, srecc1_intr, srecc0_intr,
   rvalid_top_peri0_sram, rvalid_s_sram_rom, rvalid_mem2sram,
   rresp_top_peri0_sram, rresp_s_sram_rom, rresp_mem2sram,
   rlast_top_peri0_sram, rlast_s_sram_rom, rlast_mem2sram,
   rid_top_peri0_sram, rid_s_sram_rom, rid_mem2sram,
   rdata_top_peri0_sram, rdata_s_sram_rom, rdata_mem2sram,
   bvalid_top_peri0_sram, bvalid_s_sram_rom, bvalid_mem2sram,
   bresp_top_peri0_sram, bresp_s_sram_rom, bresp_mem2sram,
   bid_top_peri0_sram, bid_s_sram_rom, bid_mem2sram,
   awready_top_peri0_sram, awready_s_sram_rom, awready_mem2sram,
   arready_top_peri0_sram, arready_s_sram_rom, arready_mem2sram,
   prdata_sram_ecc, pready_sram_ecc, pslverr_sram_ecc,
   // Inputs
   wvalid_top_peri0_sram, wvalid_s_sram_rom, wvalid_mem2sram,
   wstrb_top_peri0_sram, wstrb_s_sram_rom, wstrb_mem2sram,
   wlast_top_peri0_sram, wlast_s_sram_rom, wlast_mem2sram,
   wdata_top_peri0_sram, wdata_s_sram_rom, wdata_mem2sram,
   rready_top_peri0_sram, rready_s_sram_rom, rready_mem2sram,
   bready_top_peri0_sram, bready_s_sram_rom, bready_mem2sram,
   awvalid_top_peri0_sram, awvalid_s_sram_rom, awvalid_mem2sram,
   awuser_top_peri0_sram, awuser_s_sram_rom, awuser_mem2sram,
   awsize_top_peri0_sram, awsize_s_sram_rom, awsize_mem2sram,
   awprot_top_peri0_sram, awprot_s_sram_rom, awprot_mem2sram,
   awlock_top_peri0_sram, awlock_s_sram_rom, awlock_mem2sram,
   awlen_top_peri0_sram, awlen_s_sram_rom, awlen_mem2sram,
   awid_top_peri0_sram, awid_s_sram_rom, awid_mem2sram,
   awcache_top_peri0_sram, awcache_s_sram_rom, awcache_mem2sram,
   awburst_top_peri0_sram, awburst_s_sram_rom, awburst_mem2sram,
   awaddr_top_peri0_sram, awaddr_s_sram_rom, awaddr_mem2sram,
   arvalid_top_peri0_sram, arvalid_s_sram_rom, arvalid_mem2sram,
   aruser_top_peri0_sram, aruser_s_sram_rom, aruser_mem2sram,
   arsize_top_peri0_sram, arsize_s_sram_rom, arsize_mem2sram,
   arprot_top_peri0_sram, arprot_s_sram_rom, arprot_mem2sram,
   arlock_top_peri0_sram, arlock_s_sram_rom, arlock_mem2sram,
   arlen_top_peri0_sram, arlen_s_sram_rom, arlen_mem2sram,
   arid_top_peri0_sram, arid_s_sram_rom, arid_mem2sram, aresetn,
   arcache_top_peri0_sram, arcache_s_sram_rom, arcache_mem2sram,
   arburst_top_peri0_sram, arburst_s_sram_rom, arburst_mem2sram,
   araddr_top_peri0_sram, araddr_s_sram_rom, araddr_mem2sram, aclk,
   reg_rom_we, pclk, presetn, paddr_sram_ecc, psel_sram_ecc,
   penable_sram_ecc, pwrite_sram_ecc, pwdata_sram_ecc, pstrb_sram_ecc
   );


/*AUTO_LISP(setq verilog-auto-output-ignore-regexp
     (concat ".*addr_m_rom"
     ))*/


/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			aclk;			// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v, ...
input [31:0]		araddr_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [31:0]		araddr_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [31:0]		araddr_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [1:0]		arburst_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [1:0]		arburst_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [1:0]		arburst_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		arcache_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		arcache_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		arcache_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			aresetn;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v, ...
input [9:0]		arid_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [9:0]		arid_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [9:0]		arid_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [7:0]		arlen_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [7:0]		arlen_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [7:0]		arlen_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			arlock_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			arlock_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			arlock_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		arprot_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		arprot_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		arprot_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		arsize_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		arsize_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		arsize_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		aruser_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		aruser_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		aruser_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			arvalid_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			arvalid_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			arvalid_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [31:0]		awaddr_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [31:0]		awaddr_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [31:0]		awaddr_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [1:0]		awburst_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [1:0]		awburst_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [1:0]		awburst_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		awcache_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		awcache_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		awcache_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [9:0]		awid_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [9:0]		awid_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [9:0]		awid_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [7:0]		awlen_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [7:0]		awlen_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [7:0]		awlen_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			awlock_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			awlock_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			awlock_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		awprot_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		awprot_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		awprot_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		awsize_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		awsize_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [2:0]		awsize_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		awuser_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		awuser_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [3:0]		awuser_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			awvalid_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			awvalid_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			awvalid_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			bready_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			bready_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			bready_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			rready_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			rready_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			rready_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [127:0]		wdata_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [127:0]		wdata_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [127:0]		wdata_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			wlast_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			wlast_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			wlast_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [15:0]		wstrb_mem2sram;		// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [15:0]		wstrb_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input [15:0]		wstrb_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			wvalid_mem2sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			wvalid_s_sram_rom;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
input			wvalid_top_peri0_sram;	// To u_sram_DW_axi of peri1_sram_DW_axi_wp.v
// End of automatics

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			arready_mem2sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			arready_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			arready_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			awready_mem2sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			awready_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			awready_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [9:0]		bid_mem2sram;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [9:0]		bid_s_sram_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [9:0]		bid_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [1:0]		bresp_mem2sram;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [1:0]		bresp_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [1:0]		bresp_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			bvalid_mem2sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			bvalid_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			bvalid_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [127:0]		rdata_mem2sram;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [127:0]		rdata_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [127:0]		rdata_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [9:0]		rid_mem2sram;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [9:0]		rid_s_sram_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [9:0]		rid_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			rlast_mem2sram;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			rlast_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			rlast_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [1:0]		rresp_mem2sram;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [1:0]		rresp_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output [1:0]		rresp_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			rvalid_mem2sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			rvalid_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			rvalid_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output logic		srecc0_intr;		// From u_srecc_top0 of srecc_top.v
output logic		srecc1_intr;		// From u_srecc_top1 of srecc_top.v
output logic		srecc2_intr;		// From u_srecc_top2 of srecc_top.v
output logic		srecc3_intr;		// From u_srecc_top3 of srecc_top.v
output			wready_mem2sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			wready_s_sram_rom;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
output			wready_top_peri0_sram;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
// End of automatics

input			reg_rom_we;

// APB slave port for the SRAM ECC (srecc_top) register banks.  Declared by hand
// rather than left to AUTOINPUT/AUTOOUTPUT because paddr_sram_ecc is consumed at
// two different widths (32b by u_common_apb_sep_srecc, 10b by each u_srecc_topN),
// which AUTOINPUT cannot resolve on its own.  The port exists in both builds; the
// `else branch below terminates the response signals when ADD_SRAM_ECC is off.
input			pclk;
input			presetn;
input [31:0]		paddr_sram_ecc;
input			psel_sram_ecc;
input			penable_sram_ecc;
input			pwrite_sram_ecc;
input [31:0]		pwdata_sram_ecc;
input [3:0]		pstrb_sram_ecc;
output [31:0]		prdata_sram_ecc;
output			pready_sram_ecc;
output			pslverr_sram_ecc;

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [31:0]		araddr_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		araddr_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		araddr_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		araddr_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		araddr_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		arburst_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		arburst_m_sram0;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		arburst_m_sram1;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		arburst_m_sram2;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		arburst_m_sram3;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		arcache_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		arcache_m_sram0;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		arcache_m_sram1;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		arcache_m_sram2;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		arcache_m_sram3;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		arid_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		arid_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		arid_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		arid_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		arid_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		arlen_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		arlen_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		arlen_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		arlen_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		arlen_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arlock_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arlock_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arlock_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arlock_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arlock_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arprot_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arprot_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arprot_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arprot_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arprot_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arready_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic			arready_m_sram0;	// From u_srecc_top0 of srecc_top.v, ...
logic			arready_m_sram1;	// From u_srecc_top1 of srecc_top.v, ...
logic			arready_m_sram2;	// From u_srecc_top2 of srecc_top.v, ...
logic			arready_m_sram3;	// From u_srecc_top3 of srecc_top.v, ...
wire [2:0]		arsize_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arsize_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arsize_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arsize_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		arsize_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arvalid_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arvalid_m_sram0;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arvalid_m_sram1;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arvalid_m_sram2;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			arvalid_m_sram3;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		awaddr_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		awaddr_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		awaddr_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		awaddr_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [31:0]		awaddr_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		awburst_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		awburst_m_sram0;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		awburst_m_sram1;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		awburst_m_sram2;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		awburst_m_sram3;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		awcache_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		awcache_m_sram0;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		awcache_m_sram1;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		awcache_m_sram2;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [3:0]		awcache_m_sram3;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		awid_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		awid_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		awid_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		awid_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		awid_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		awlen_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		awlen_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		awlen_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		awlen_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [7:0]		awlen_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awlock_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awlock_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awlock_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awlock_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awlock_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awprot_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awprot_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awprot_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awprot_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awprot_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awready_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic			awready_m_sram0;	// From u_srecc_top0 of srecc_top.v, ...
logic			awready_m_sram1;	// From u_srecc_top1 of srecc_top.v, ...
logic			awready_m_sram2;	// From u_srecc_top2 of srecc_top.v, ...
logic			awready_m_sram3;	// From u_srecc_top3 of srecc_top.v, ...
wire [2:0]		awsize_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awsize_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awsize_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awsize_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [2:0]		awsize_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awvalid_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awvalid_m_sram0;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awvalid_m_sram1;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awvalid_m_sram2;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			awvalid_m_sram3;	// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [11:0]		bid_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic [11:0]		bid_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic [11:0]		bid_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic [11:0]		bid_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic [11:0]		bid_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire			bready_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			bready_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			bready_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			bready_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			bready_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		bresp_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic [1:0]		bresp_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic [1:0]		bresp_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic [1:0]		bresp_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic [1:0]		bresp_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire			bvalid_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic			bvalid_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic			bvalid_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic			bvalid_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic			bvalid_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
logic [31:0]		prdata_srecc0;		// From u_srecc_top0 of srecc_top.v
logic [31:0]		prdata_srecc1;		// From u_srecc_top1 of srecc_top.v
logic [31:0]		prdata_srecc2;		// From u_srecc_top2 of srecc_top.v
logic [31:0]		prdata_srecc3;		// From u_srecc_top3 of srecc_top.v
logic			pready_srecc0;		// From u_srecc_top0 of srecc_top.v
logic			pready_srecc1;		// From u_srecc_top1 of srecc_top.v
logic			pready_srecc2;		// From u_srecc_top2 of srecc_top.v
logic			pready_srecc3;		// From u_srecc_top3 of srecc_top.v
wire			psel_srecc0;		// From u_common_apb_sep_srecc of common_apb_sep.v
wire			psel_srecc1;		// From u_common_apb_sep_srecc of common_apb_sep.v
wire			psel_srecc2;		// From u_common_apb_sep_srecc of common_apb_sep.v
wire			psel_srecc3;		// From u_common_apb_sep_srecc of common_apb_sep.v
logic			pslverr_srecc0;		// From u_srecc_top0 of srecc_top.v
logic			pslverr_srecc1;		// From u_srecc_top1 of srecc_top.v
logic			pslverr_srecc2;		// From u_srecc_top2 of srecc_top.v
logic			pslverr_srecc3;		// From u_srecc_top3 of srecc_top.v
wire [127:0]		rdata_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic [127:0]		rdata_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic [127:0]		rdata_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic [127:0]		rdata_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic [127:0]		rdata_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire [11:0]		rid_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic [11:0]		rid_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic [11:0]		rid_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic [11:0]		rid_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic [11:0]		rid_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire			rlast_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic			rlast_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic			rlast_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic			rlast_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic			rlast_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire			rready_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			rready_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			rready_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			rready_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			rready_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [1:0]		rresp_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic [1:0]		rresp_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic [1:0]		rresp_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic [1:0]		rresp_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic [1:0]		rresp_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire			rvalid_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic			rvalid_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic			rvalid_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic			rvalid_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic			rvalid_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire [127:0]		wdata_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [127:0]		wdata_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [127:0]		wdata_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [127:0]		wdata_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [127:0]		wdata_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wlast_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wlast_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wlast_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wlast_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wlast_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wready_m_rom;		// From u_peri_axi128_rom of peri_axi128_rom.v
logic			wready_m_sram0;		// From u_srecc_top0 of srecc_top.v, ...
logic			wready_m_sram1;		// From u_srecc_top1 of srecc_top.v, ...
logic			wready_m_sram2;		// From u_srecc_top2 of srecc_top.v, ...
logic			wready_m_sram3;		// From u_srecc_top3 of srecc_top.v, ...
wire [15:0]		wstrb_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [15:0]		wstrb_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [15:0]		wstrb_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [15:0]		wstrb_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire [15:0]		wstrb_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wvalid_m_rom;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wvalid_m_sram0;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wvalid_m_sram1;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wvalid_m_sram2;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
wire			wvalid_m_sram3;		// From u_sram_DW_axi of peri1_sram_DW_axi_wp.v
// End of automatics




    /* peri1_sram_DW_axi_wp AUTO_TEMPLATE(
        .intr_forbid           (),
        .csysack               (),
        .cactive               (),
        .csysreq               (1'b1),

        .\(.*\)user_s.*        (@"(if (equal vl-dir \\"input\\") \\"4'b0\\"    \\"\\")"),

        .\(.*\)addr_m1         (\1addr_s_sram_rom[31:0]),
        .\(.*\)valid_m1        (\1valid_s_sram_rom),
        .\(.*\)id_m1           (\1id_s_sram_rom[9:0]),
        .\(.*\)len_m1          (\1len_s_sram_rom[7:0]),
        .\(.*\)size_m1         (\1size_s_sram_rom[2:0]),
        .\(.*\)burst_m1        (\1burst_s_sram_rom[1:0]),
        .\(.*\)lock_m1         (\1lock_s_sram_rom),
        .\(.*\)cache_m1        (\1cache_s_sram_rom[3:0]),
        .\(.*\)prot_m1         (\1prot_s_sram_rom[2:0]),
        .\(.*\)data_m1         (\1data_s_sram_rom[127:0]),
        .\(.*\)strb_m1         (\1strb_s_sram_rom[15:0]),
        .\(.*\)resp_m1         (\1resp_s_sram_rom[1:0]),
        .\(.*\)user_m1         (\1user_s_sram_rom[3:0]),
        .\(.*\)_m1             (\1_s_sram_rom[]),

        .\(.*\)addr_m2         (\1addr_mem2sram[31:0]),
        .\(.*\)valid_m2        (\1valid_mem2sram),
        .\(.*\)id_m2           (\1id_mem2sram[9:0]),
        .\(.*\)len_m2          (\1len_mem2sram[7:0]),
        .\(.*\)size_m2         (\1size_mem2sram[2:0]),
        .\(.*\)burst_m2        (\1burst_mem2sram[1:0]),
        .\(.*\)lock_m2         (\1lock_mem2sram),
        .\(.*\)cache_m2        (\1cache_mem2sram[3:0]),
        .\(.*\)prot_m2         (\1prot_mem2sram[2:0]),
        .\(.*\)data_m2         (\1data_mem2sram[127:0]),
        .\(.*\)strb_m2         (\1strb_mem2sram[15:0]),
        .\(.*\)resp_m2         (\1resp_mem2sram[1:0]),
        .\(.*\)user_m2         (\1user_mem2sram[3:0]),
        .\(.*\)_m2             (\1_mem2sram[]),

        .\(.*\)addr_m3         (\1addr_top_peri0_sram[31:0]),
        .\(.*\)valid_m3        (\1valid_top_peri0_sram),
        .\(.*\)id_m3           (\1id_top_peri0_sram[9:0]),
        .\(.*\)len_m3          (\1len_top_peri0_sram[7:0]),
        .\(.*\)size_m3         (\1size_top_peri0_sram[2:0]),
        .\(.*\)burst_m3        (\1burst_top_peri0_sram[1:0]),
        .\(.*\)lock_m3         (\1lock_top_peri0_sram),
        .\(.*\)cache_m3        (\1cache_top_peri0_sram[3:0]),
        .\(.*\)prot_m3         (\1prot_top_peri0_sram[2:0]),
        .\(.*\)data_m3         (\1data_top_peri0_sram[127:0]),
        .\(.*\)strb_m3         (\1strb_top_peri0_sram[15:0]),
        .\(.*\)resp_m3         (\1resp_top_peri0_sram[1:0]),
        .\(.*\)user_m3         (\1user_top_peri0_sram[3:0]),
        .\(.*\)_m3             (\1_top_peri0_sram[]),

        .\(.*\)addr_s1         (\1addr_m_sram0[31:0]),
        .\(.*\)valid_s1        (\1valid_m_sram0),
        .\(.*\)id_s1           (\1id_m_sram0[11:0]),
        .\(.*\)len_s1          (\1len_m_sram0[7:0]),
        .\(.*\)size_s1         (\1size_m_sram0[2:0]),
        .\(.*\)burst_s1        (\1burst_m_sram0[1:0]),
        .\(.*\)lock_s1         (\1lock_m_sram0),
        .\(.*\)cache_s1        (\1cache_m_sram0[3:0]),
        .\(.*\)prot_s1         (\1prot_m_sram0[2:0]),
        .\(.*\)data_s1         (\1data_m_sram0[127:0]),
        .\(.*\)strb_s1         (\1strb_m_sram0[15:0]),
        .\(.*\)resp_s1         (\1resp_m_sram0[1:0]),
        .\(.*\)_s1             (\1_m_sram0[]),

        .\(.*\)addr_s2         (\1addr_m_sram1[31:0]),
        .\(.*\)valid_s2        (\1valid_m_sram1),
        .\(.*\)id_s2           (\1id_m_sram1[11:0]),
        .\(.*\)len_s2          (\1len_m_sram1[7:0]),
        .\(.*\)size_s2         (\1size_m_sram1[2:0]),
        .\(.*\)burst_s2        (\1burst_m_sram1[1:0]),
        .\(.*\)lock_s2         (\1lock_m_sram1),
        .\(.*\)cache_s2        (\1cache_m_sram1[3:0]),
        .\(.*\)prot_s2         (\1prot_m_sram1[2:0]),
        .\(.*\)data_s2         (\1data_m_sram1[127:0]),
        .\(.*\)strb_s2         (\1strb_m_sram1[15:0]),
        .\(.*\)resp_s2         (\1resp_m_sram1[1:0]),
        .\(.*\)_s2             (\1_m_sram1[]),

        .\(.*\)addr_s3         (\1addr_m_sram2[31:0]),
        .\(.*\)valid_s3        (\1valid_m_sram2),
        .\(.*\)id_s3           (\1id_m_sram2[11:0]),
        .\(.*\)len_s3          (\1len_m_sram2[7:0]),
        .\(.*\)size_s3         (\1size_m_sram2[2:0]),
        .\(.*\)burst_s3        (\1burst_m_sram2[1:0]),
        .\(.*\)lock_s3         (\1lock_m_sram2),
        .\(.*\)cache_s3        (\1cache_m_sram2[3:0]),
        .\(.*\)prot_s3         (\1prot_m_sram2[2:0]),
        .\(.*\)data_s3         (\1data_m_sram2[127:0]),
        .\(.*\)strb_s3         (\1strb_m_sram2[15:0]),
        .\(.*\)resp_s3         (\1resp_m_sram2[1:0]),
        .\(.*\)_s3             (\1_m_sram2[]),

        .\(.*\)addr_s4         (\1addr_m_sram3[31:0]),
        .\(.*\)valid_s4        (\1valid_m_sram3),
        .\(.*\)id_s4           (\1id_m_sram3[11:0]),
        .\(.*\)len_s4          (\1len_m_sram3[7:0]),
        .\(.*\)size_s4         (\1size_m_sram3[2:0]),
        .\(.*\)burst_s4        (\1burst_m_sram3[1:0]),
        .\(.*\)lock_s4         (\1lock_m_sram3),
        .\(.*\)cache_s4        (\1cache_m_sram3[3:0]),
        .\(.*\)prot_s4         (\1prot_m_sram3[2:0]),
        .\(.*\)data_s4         (\1data_m_sram3[127:0]),
        .\(.*\)strb_s4         (\1strb_m_sram3[15:0]),
        .\(.*\)resp_s4         (\1resp_m_sram3[1:0]),
        .\(.*\)_s4             (\1_m_sram3[]),

        .\(.*\)addr_s5         (\1addr_m_rom[31:0]),
        .\(.*\)valid_s5        (\1valid_m_rom),
        .\(.*\)id_s5           (\1id_m_rom[11:0]),
        .\(.*\)len_s5          (\1len_m_rom[7:0]),
        .\(.*\)size_s5         (\1size_m_rom[2:0]),
        .\(.*\)burst_s5        (\1burst_m_rom[1:0]),
        .\(.*\)lock_s5         (\1lock_m_rom),
        .\(.*\)cache_s5        (\1cache_m_rom[3:0]),
        .\(.*\)prot_s5         (\1prot_m_rom[2:0]),
        .\(.*\)data_s5         (\1data_m_rom[127:0]),
        .\(.*\)strb_s5         (\1strb_m_rom[15:0]),
        .\(.*\)resp_s5         (\1resp_m_rom[1:0]),
        .\(.*\)_s5             (\1_m_rom[]),

        .dbg_.*                (),
        );
  */
    peri1_sram_DW_axi_wp u_sram_DW_axi(/*AUTOINST*/
				       // Outputs
				       .araddr_s1	(araddr_m_sram0[31:0]), // Templated
				       .araddr_s2	(araddr_m_sram1[31:0]), // Templated
				       .araddr_s3	(araddr_m_sram2[31:0]), // Templated
				       .araddr_s4	(araddr_m_sram3[31:0]), // Templated
				       .araddr_s5	(araddr_m_rom[31:0]), // Templated
				       .arburst_s1	(arburst_m_sram0[1:0]), // Templated
				       .arburst_s2	(arburst_m_sram1[1:0]), // Templated
				       .arburst_s3	(arburst_m_sram2[1:0]), // Templated
				       .arburst_s4	(arburst_m_sram3[1:0]), // Templated
				       .arburst_s5	(arburst_m_rom[1:0]), // Templated
				       .arcache_s1	(arcache_m_sram0[3:0]), // Templated
				       .arcache_s2	(arcache_m_sram1[3:0]), // Templated
				       .arcache_s3	(arcache_m_sram2[3:0]), // Templated
				       .arcache_s4	(arcache_m_sram3[3:0]), // Templated
				       .arcache_s5	(arcache_m_rom[3:0]), // Templated
				       .arid_s1		(arid_m_sram0[11:0]), // Templated
				       .arid_s2		(arid_m_sram1[11:0]), // Templated
				       .arid_s3		(arid_m_sram2[11:0]), // Templated
				       .arid_s4		(arid_m_sram3[11:0]), // Templated
				       .arid_s5		(arid_m_rom[11:0]), // Templated
				       .arlen_s1	(arlen_m_sram0[7:0]), // Templated
				       .arlen_s2	(arlen_m_sram1[7:0]), // Templated
				       .arlen_s3	(arlen_m_sram2[7:0]), // Templated
				       .arlen_s4	(arlen_m_sram3[7:0]), // Templated
				       .arlen_s5	(arlen_m_rom[7:0]), // Templated
				       .arlock_s1	(arlock_m_sram0), // Templated
				       .arlock_s2	(arlock_m_sram1), // Templated
				       .arlock_s3	(arlock_m_sram2), // Templated
				       .arlock_s4	(arlock_m_sram3), // Templated
				       .arlock_s5	(arlock_m_rom),	 // Templated
				       .arprot_s1	(arprot_m_sram0[2:0]), // Templated
				       .arprot_s2	(arprot_m_sram1[2:0]), // Templated
				       .arprot_s3	(arprot_m_sram2[2:0]), // Templated
				       .arprot_s4	(arprot_m_sram3[2:0]), // Templated
				       .arprot_s5	(arprot_m_rom[2:0]), // Templated
				       .arready_m1	(arready_s_sram_rom), // Templated
				       .arready_m2	(arready_mem2sram), // Templated
				       .arready_m3	(arready_top_peri0_sram), // Templated
				       .arsize_s1	(arsize_m_sram0[2:0]), // Templated
				       .arsize_s2	(arsize_m_sram1[2:0]), // Templated
				       .arsize_s3	(arsize_m_sram2[2:0]), // Templated
				       .arsize_s4	(arsize_m_sram3[2:0]), // Templated
				       .arsize_s5	(arsize_m_rom[2:0]), // Templated
				       .aruser_s1	(),		 // Templated
				       .aruser_s2	(),		 // Templated
				       .aruser_s3	(),		 // Templated
				       .aruser_s4	(),		 // Templated
				       .aruser_s5	(),		 // Templated
				       .arvalid_s1	(arvalid_m_sram0), // Templated
				       .arvalid_s2	(arvalid_m_sram1), // Templated
				       .arvalid_s3	(arvalid_m_sram2), // Templated
				       .arvalid_s4	(arvalid_m_sram3), // Templated
				       .arvalid_s5	(arvalid_m_rom), // Templated
				       .awaddr_s1	(awaddr_m_sram0[31:0]), // Templated
				       .awaddr_s2	(awaddr_m_sram1[31:0]), // Templated
				       .awaddr_s3	(awaddr_m_sram2[31:0]), // Templated
				       .awaddr_s4	(awaddr_m_sram3[31:0]), // Templated
				       .awaddr_s5	(awaddr_m_rom[31:0]), // Templated
				       .awburst_s1	(awburst_m_sram0[1:0]), // Templated
				       .awburst_s2	(awburst_m_sram1[1:0]), // Templated
				       .awburst_s3	(awburst_m_sram2[1:0]), // Templated
				       .awburst_s4	(awburst_m_sram3[1:0]), // Templated
				       .awburst_s5	(awburst_m_rom[1:0]), // Templated
				       .awcache_s1	(awcache_m_sram0[3:0]), // Templated
				       .awcache_s2	(awcache_m_sram1[3:0]), // Templated
				       .awcache_s3	(awcache_m_sram2[3:0]), // Templated
				       .awcache_s4	(awcache_m_sram3[3:0]), // Templated
				       .awcache_s5	(awcache_m_rom[3:0]), // Templated
				       .awid_s1		(awid_m_sram0[11:0]), // Templated
				       .awid_s2		(awid_m_sram1[11:0]), // Templated
				       .awid_s3		(awid_m_sram2[11:0]), // Templated
				       .awid_s4		(awid_m_sram3[11:0]), // Templated
				       .awid_s5		(awid_m_rom[11:0]), // Templated
				       .awlen_s1	(awlen_m_sram0[7:0]), // Templated
				       .awlen_s2	(awlen_m_sram1[7:0]), // Templated
				       .awlen_s3	(awlen_m_sram2[7:0]), // Templated
				       .awlen_s4	(awlen_m_sram3[7:0]), // Templated
				       .awlen_s5	(awlen_m_rom[7:0]), // Templated
				       .awlock_s1	(awlock_m_sram0), // Templated
				       .awlock_s2	(awlock_m_sram1), // Templated
				       .awlock_s3	(awlock_m_sram2), // Templated
				       .awlock_s4	(awlock_m_sram3), // Templated
				       .awlock_s5	(awlock_m_rom),	 // Templated
				       .awprot_s1	(awprot_m_sram0[2:0]), // Templated
				       .awprot_s2	(awprot_m_sram1[2:0]), // Templated
				       .awprot_s3	(awprot_m_sram2[2:0]), // Templated
				       .awprot_s4	(awprot_m_sram3[2:0]), // Templated
				       .awprot_s5	(awprot_m_rom[2:0]), // Templated
				       .awready_m1	(awready_s_sram_rom), // Templated
				       .awready_m2	(awready_mem2sram), // Templated
				       .awready_m3	(awready_top_peri0_sram), // Templated
				       .awsize_s1	(awsize_m_sram0[2:0]), // Templated
				       .awsize_s2	(awsize_m_sram1[2:0]), // Templated
				       .awsize_s3	(awsize_m_sram2[2:0]), // Templated
				       .awsize_s4	(awsize_m_sram3[2:0]), // Templated
				       .awsize_s5	(awsize_m_rom[2:0]), // Templated
				       .awuser_s1	(),		 // Templated
				       .awuser_s2	(),		 // Templated
				       .awuser_s3	(),		 // Templated
				       .awuser_s4	(),		 // Templated
				       .awuser_s5	(),		 // Templated
				       .awvalid_s1	(awvalid_m_sram0), // Templated
				       .awvalid_s2	(awvalid_m_sram1), // Templated
				       .awvalid_s3	(awvalid_m_sram2), // Templated
				       .awvalid_s4	(awvalid_m_sram3), // Templated
				       .awvalid_s5	(awvalid_m_rom), // Templated
				       .bid_m1		(bid_s_sram_rom[9:0]), // Templated
				       .bid_m2		(bid_mem2sram[9:0]), // Templated
				       .bid_m3		(bid_top_peri0_sram[9:0]), // Templated
				       .bready_s1	(bready_m_sram0), // Templated
				       .bready_s2	(bready_m_sram1), // Templated
				       .bready_s3	(bready_m_sram2), // Templated
				       .bready_s4	(bready_m_sram3), // Templated
				       .bready_s5	(bready_m_rom),	 // Templated
				       .bresp_m1	(bresp_s_sram_rom[1:0]), // Templated
				       .bresp_m2	(bresp_mem2sram[1:0]), // Templated
				       .bresp_m3	(bresp_top_peri0_sram[1:0]), // Templated
				       .bvalid_m1	(bvalid_s_sram_rom), // Templated
				       .bvalid_m2	(bvalid_mem2sram), // Templated
				       .bvalid_m3	(bvalid_top_peri0_sram), // Templated
				       .rdata_m1	(rdata_s_sram_rom[127:0]), // Templated
				       .rdata_m2	(rdata_mem2sram[127:0]), // Templated
				       .rdata_m3	(rdata_top_peri0_sram[127:0]), // Templated
				       .rid_m1		(rid_s_sram_rom[9:0]), // Templated
				       .rid_m2		(rid_mem2sram[9:0]), // Templated
				       .rid_m3		(rid_top_peri0_sram[9:0]), // Templated
				       .rlast_m1	(rlast_s_sram_rom), // Templated
				       .rlast_m2	(rlast_mem2sram), // Templated
				       .rlast_m3	(rlast_top_peri0_sram), // Templated
				       .rready_s1	(rready_m_sram0), // Templated
				       .rready_s2	(rready_m_sram1), // Templated
				       .rready_s3	(rready_m_sram2), // Templated
				       .rready_s4	(rready_m_sram3), // Templated
				       .rready_s5	(rready_m_rom),	 // Templated
				       .rresp_m1	(rresp_s_sram_rom[1:0]), // Templated
				       .rresp_m2	(rresp_mem2sram[1:0]), // Templated
				       .rresp_m3	(rresp_top_peri0_sram[1:0]), // Templated
				       .rvalid_m1	(rvalid_s_sram_rom), // Templated
				       .rvalid_m2	(rvalid_mem2sram), // Templated
				       .rvalid_m3	(rvalid_top_peri0_sram), // Templated
				       .wdata_s1	(wdata_m_sram0[127:0]), // Templated
				       .wdata_s2	(wdata_m_sram1[127:0]), // Templated
				       .wdata_s3	(wdata_m_sram2[127:0]), // Templated
				       .wdata_s4	(wdata_m_sram3[127:0]), // Templated
				       .wdata_s5	(wdata_m_rom[127:0]), // Templated
				       .wlast_s1	(wlast_m_sram0), // Templated
				       .wlast_s2	(wlast_m_sram1), // Templated
				       .wlast_s3	(wlast_m_sram2), // Templated
				       .wlast_s4	(wlast_m_sram3), // Templated
				       .wlast_s5	(wlast_m_rom),	 // Templated
				       .wready_m1	(wready_s_sram_rom), // Templated
				       .wready_m2	(wready_mem2sram), // Templated
				       .wready_m3	(wready_top_peri0_sram), // Templated
				       .wstrb_s1	(wstrb_m_sram0[15:0]), // Templated
				       .wstrb_s2	(wstrb_m_sram1[15:0]), // Templated
				       .wstrb_s3	(wstrb_m_sram2[15:0]), // Templated
				       .wstrb_s4	(wstrb_m_sram3[15:0]), // Templated
				       .wstrb_s5	(wstrb_m_rom[15:0]), // Templated
				       .wvalid_s1	(wvalid_m_sram0), // Templated
				       .wvalid_s2	(wvalid_m_sram1), // Templated
				       .wvalid_s3	(wvalid_m_sram2), // Templated
				       .wvalid_s4	(wvalid_m_sram3), // Templated
				       .wvalid_s5	(wvalid_m_rom),	 // Templated
				       // Inputs
				       .aclk		(aclk),
				       .araddr_m1	(araddr_s_sram_rom[31:0]), // Templated
				       .araddr_m2	(araddr_mem2sram[31:0]), // Templated
				       .araddr_m3	(araddr_top_peri0_sram[31:0]), // Templated
				       .arburst_m1	(arburst_s_sram_rom[1:0]), // Templated
				       .arburst_m2	(arburst_mem2sram[1:0]), // Templated
				       .arburst_m3	(arburst_top_peri0_sram[1:0]), // Templated
				       .arcache_m1	(arcache_s_sram_rom[3:0]), // Templated
				       .arcache_m2	(arcache_mem2sram[3:0]), // Templated
				       .arcache_m3	(arcache_top_peri0_sram[3:0]), // Templated
				       .aresetn		(aresetn),
				       .arid_m1		(arid_s_sram_rom[9:0]), // Templated
				       .arid_m2		(arid_mem2sram[9:0]), // Templated
				       .arid_m3		(arid_top_peri0_sram[9:0]), // Templated
				       .arlen_m1	(arlen_s_sram_rom[7:0]), // Templated
				       .arlen_m2	(arlen_mem2sram[7:0]), // Templated
				       .arlen_m3	(arlen_top_peri0_sram[7:0]), // Templated
				       .arlock_m1	(arlock_s_sram_rom), // Templated
				       .arlock_m2	(arlock_mem2sram), // Templated
				       .arlock_m3	(arlock_top_peri0_sram), // Templated
				       .arprot_m1	(arprot_s_sram_rom[2:0]), // Templated
				       .arprot_m2	(arprot_mem2sram[2:0]), // Templated
				       .arprot_m3	(arprot_top_peri0_sram[2:0]), // Templated
				       .arready_s1	(arready_m_sram0), // Templated
				       .arready_s2	(arready_m_sram1), // Templated
				       .arready_s3	(arready_m_sram2), // Templated
				       .arready_s4	(arready_m_sram3), // Templated
				       .arready_s5	(arready_m_rom), // Templated
				       .arsize_m1	(arsize_s_sram_rom[2:0]), // Templated
				       .arsize_m2	(arsize_mem2sram[2:0]), // Templated
				       .arsize_m3	(arsize_top_peri0_sram[2:0]), // Templated
				       .aruser_m1	(aruser_s_sram_rom[3:0]), // Templated
				       .aruser_m2	(aruser_mem2sram[3:0]), // Templated
				       .aruser_m3	(aruser_top_peri0_sram[3:0]), // Templated
				       .arvalid_m1	(arvalid_s_sram_rom), // Templated
				       .arvalid_m2	(arvalid_mem2sram), // Templated
				       .arvalid_m3	(arvalid_top_peri0_sram), // Templated
				       .awaddr_m1	(awaddr_s_sram_rom[31:0]), // Templated
				       .awaddr_m2	(awaddr_mem2sram[31:0]), // Templated
				       .awaddr_m3	(awaddr_top_peri0_sram[31:0]), // Templated
				       .awburst_m1	(awburst_s_sram_rom[1:0]), // Templated
				       .awburst_m2	(awburst_mem2sram[1:0]), // Templated
				       .awburst_m3	(awburst_top_peri0_sram[1:0]), // Templated
				       .awcache_m1	(awcache_s_sram_rom[3:0]), // Templated
				       .awcache_m2	(awcache_mem2sram[3:0]), // Templated
				       .awcache_m3	(awcache_top_peri0_sram[3:0]), // Templated
				       .awid_m1		(awid_s_sram_rom[9:0]), // Templated
				       .awid_m2		(awid_mem2sram[9:0]), // Templated
				       .awid_m3		(awid_top_peri0_sram[9:0]), // Templated
				       .awlen_m1	(awlen_s_sram_rom[7:0]), // Templated
				       .awlen_m2	(awlen_mem2sram[7:0]), // Templated
				       .awlen_m3	(awlen_top_peri0_sram[7:0]), // Templated
				       .awlock_m1	(awlock_s_sram_rom), // Templated
				       .awlock_m2	(awlock_mem2sram), // Templated
				       .awlock_m3	(awlock_top_peri0_sram), // Templated
				       .awprot_m1	(awprot_s_sram_rom[2:0]), // Templated
				       .awprot_m2	(awprot_mem2sram[2:0]), // Templated
				       .awprot_m3	(awprot_top_peri0_sram[2:0]), // Templated
				       .awready_s1	(awready_m_sram0), // Templated
				       .awready_s2	(awready_m_sram1), // Templated
				       .awready_s3	(awready_m_sram2), // Templated
				       .awready_s4	(awready_m_sram3), // Templated
				       .awready_s5	(awready_m_rom), // Templated
				       .awsize_m1	(awsize_s_sram_rom[2:0]), // Templated
				       .awsize_m2	(awsize_mem2sram[2:0]), // Templated
				       .awsize_m3	(awsize_top_peri0_sram[2:0]), // Templated
				       .awuser_m1	(awuser_s_sram_rom[3:0]), // Templated
				       .awuser_m2	(awuser_mem2sram[3:0]), // Templated
				       .awuser_m3	(awuser_top_peri0_sram[3:0]), // Templated
				       .awvalid_m1	(awvalid_s_sram_rom), // Templated
				       .awvalid_m2	(awvalid_mem2sram), // Templated
				       .awvalid_m3	(awvalid_top_peri0_sram), // Templated
				       .bid_s1		(bid_m_sram0[11:0]), // Templated
				       .bid_s2		(bid_m_sram1[11:0]), // Templated
				       .bid_s3		(bid_m_sram2[11:0]), // Templated
				       .bid_s4		(bid_m_sram3[11:0]), // Templated
				       .bid_s5		(bid_m_rom[11:0]), // Templated
				       .bready_m1	(bready_s_sram_rom), // Templated
				       .bready_m2	(bready_mem2sram), // Templated
				       .bready_m3	(bready_top_peri0_sram), // Templated
				       .bresp_s1	(bresp_m_sram0[1:0]), // Templated
				       .bresp_s2	(bresp_m_sram1[1:0]), // Templated
				       .bresp_s3	(bresp_m_sram2[1:0]), // Templated
				       .bresp_s4	(bresp_m_sram3[1:0]), // Templated
				       .bresp_s5	(bresp_m_rom[1:0]), // Templated
				       .bvalid_s1	(bvalid_m_sram0), // Templated
				       .bvalid_s2	(bvalid_m_sram1), // Templated
				       .bvalid_s3	(bvalid_m_sram2), // Templated
				       .bvalid_s4	(bvalid_m_sram3), // Templated
				       .bvalid_s5	(bvalid_m_rom),	 // Templated
				       .rdata_s1	(rdata_m_sram0[127:0]), // Templated
				       .rdata_s2	(rdata_m_sram1[127:0]), // Templated
				       .rdata_s3	(rdata_m_sram2[127:0]), // Templated
				       .rdata_s4	(rdata_m_sram3[127:0]), // Templated
				       .rdata_s5	(rdata_m_rom[127:0]), // Templated
				       .rid_s1		(rid_m_sram0[11:0]), // Templated
				       .rid_s2		(rid_m_sram1[11:0]), // Templated
				       .rid_s3		(rid_m_sram2[11:0]), // Templated
				       .rid_s4		(rid_m_sram3[11:0]), // Templated
				       .rid_s5		(rid_m_rom[11:0]), // Templated
				       .rlast_s1	(rlast_m_sram0), // Templated
				       .rlast_s2	(rlast_m_sram1), // Templated
				       .rlast_s3	(rlast_m_sram2), // Templated
				       .rlast_s4	(rlast_m_sram3), // Templated
				       .rlast_s5	(rlast_m_rom),	 // Templated
				       .rready_m1	(rready_s_sram_rom), // Templated
				       .rready_m2	(rready_mem2sram), // Templated
				       .rready_m3	(rready_top_peri0_sram), // Templated
				       .rresp_s1	(rresp_m_sram0[1:0]), // Templated
				       .rresp_s2	(rresp_m_sram1[1:0]), // Templated
				       .rresp_s3	(rresp_m_sram2[1:0]), // Templated
				       .rresp_s4	(rresp_m_sram3[1:0]), // Templated
				       .rresp_s5	(rresp_m_rom[1:0]), // Templated
				       .rvalid_s1	(rvalid_m_sram0), // Templated
				       .rvalid_s2	(rvalid_m_sram1), // Templated
				       .rvalid_s3	(rvalid_m_sram2), // Templated
				       .rvalid_s4	(rvalid_m_sram3), // Templated
				       .rvalid_s5	(rvalid_m_rom),	 // Templated
				       .wdata_m1	(wdata_s_sram_rom[127:0]), // Templated
				       .wdata_m2	(wdata_mem2sram[127:0]), // Templated
				       .wdata_m3	(wdata_top_peri0_sram[127:0]), // Templated
				       .wlast_m1	(wlast_s_sram_rom), // Templated
				       .wlast_m2	(wlast_mem2sram), // Templated
				       .wlast_m3	(wlast_top_peri0_sram), // Templated
				       .wready_s1	(wready_m_sram0), // Templated
				       .wready_s2	(wready_m_sram1), // Templated
				       .wready_s3	(wready_m_sram2), // Templated
				       .wready_s4	(wready_m_sram3), // Templated
				       .wready_s5	(wready_m_rom),	 // Templated
				       .wstrb_m1	(wstrb_s_sram_rom[15:0]), // Templated
				       .wstrb_m2	(wstrb_mem2sram[15:0]), // Templated
				       .wstrb_m3	(wstrb_top_peri0_sram[15:0]), // Templated
				       .wvalid_m1	(wvalid_s_sram_rom), // Templated
				       .wvalid_m2	(wvalid_mem2sram), // Templated
				       .wvalid_m3	(wvalid_top_peri0_sram)); // Templated

`ifdef ADD_SRAM_ECC
/*   common_apb_sep    AUTO_TEMPLATE(
       .paddr        (paddr_sram_ecc[]),
       .psel_s0      (psel_sram_ecc),
       .prdata_s0_g  ({prdata_srecc3[31:0], prdata_srecc2[31:0], prdata_srecc1[31:0], prdata_srecc0[31:0]}),
       .pready_s0_g  ({pready_srecc3, pready_srecc2, pready_srecc1, pready_srecc0}),
       .pslverr_s0_g ({pslverr_srecc3, pslverr_srecc2, pslverr_srecc1, pslverr_srecc0}),
       .psel_s0_gp   ({psel_srecc3, psel_srecc2, psel_srecc1, psel_srecc0}),
       .prdata_s0    (prdata_sram_ecc[]),
       .pready_s0    (pready_sram_ecc),
       .pslverr_s0   (pslverr_sram_ecc),
);
*/
common_apb_sep #(
                .NUM_SLAVES(4),              // Valid options: 2, 4, 8, 16, 32
                .TOTAL_SIZE_BYTES(4 * 1024)  // Total address space size (4KB)
) u_common_apb_sep_srecc (/*AUTOINST*/
			  // Outputs
			  .psel_s0_gp	({psel_srecc3, psel_srecc2, psel_srecc1, psel_srecc0}), // Templated
			  .prdata_s0	(prdata_sram_ecc[31:0]), // Templated
			  .pready_s0	(pready_sram_ecc),	 // Templated
			  .pslverr_s0	(pslverr_sram_ecc),	 // Templated
			  // Inputs
			  .paddr	(paddr_sram_ecc[31:0]),	 // Templated
			  .psel_s0	(psel_sram_ecc),	 // Templated
			  .prdata_s0_g	({prdata_srecc3[31:0], prdata_srecc2[31:0], prdata_srecc1[31:0], prdata_srecc0[31:0]}), // Templated
			  .pready_s0_g	({pready_srecc3, pready_srecc2, pready_srecc1, pready_srecc0}), // Templated
			  .pslverr_s0_g	({pslverr_srecc3, pslverr_srecc2, pslverr_srecc1, pslverr_srecc0})); // Templated

  /* srecc_top AUTO_TEMPLATE(
    .clk_axi_i(aclk),
    .rst_axi_ni(aresetn),
    .clk_apb_i(pclk),
    .rst_apb_ni(presetn),
    .test_en_i(1'b0),
    .apb_psel_i(psel_srecc0),
    .apb_penable_i(penable_sram_ecc),
    .apb_pwrite_i(pwrite_sram_ecc),
    .apb_paddr_i(paddr_sram_ecc[]),
    .apb_pwdata_i(pwdata_sram_ecc[]),
    .apb_pstrb_i(pstrb_sram_ecc[]),
    .apb_prdata_o(prdata_srecc0[]),
    .apb_pready_o(pready_srecc0),
    .apb_pslverr_o(pslverr_srecc0),
    .irq_out_o(srecc0_intr),
	.s_awaddr_i({16'b0, awaddr_m_sram0[15:0]}),
	.s_araddr_i({16'b0, araddr_m_sram0[15:0]}),
	.s_wstrb_i(wstrb_m_sram0[15:0]),
    .s_\(.*\)_o(\1_m_sram0[]),
    .s_\(.*\)_i(\1_m_sram0[]));
  */
    srecc_top #(
	.AxiDataW    (128),
        .AxiAddrW    (32),
        .AxiIdW      (12),
        .NumBanks    (4),
        .TotalDataBytes (64*1024),
        .MaxOutstanding (8),
        .ApbAddrW       (10)
    ) u_srecc_top0 (  /*AUTOINST*/
		    // Outputs
		    .apb_prdata_o	(prdata_srecc0[31:0]),	 // Templated
		    .apb_pready_o	(pready_srecc0),	 // Templated
		    .apb_pslverr_o	(pslverr_srecc0),	 // Templated
		    .irq_out_o		(srecc0_intr),		 // Templated
		    .s_awready_o	(awready_m_sram0),	 // Templated
		    .s_wready_o		(wready_m_sram0),	 // Templated
		    .s_bid_o		(bid_m_sram0[11:0]),	 // Templated
		    .s_bresp_o		(bresp_m_sram0[1:0]),	 // Templated
		    .s_bvalid_o		(bvalid_m_sram0),	 // Templated
		    .s_arready_o	(arready_m_sram0),	 // Templated
		    .s_rid_o		(rid_m_sram0[11:0]),	 // Templated
		    .s_rdata_o		(rdata_m_sram0[127:0]),	 // Templated
		    .s_rresp_o		(rresp_m_sram0[1:0]),	 // Templated
		    .s_rlast_o		(rlast_m_sram0),	 // Templated
		    .s_rvalid_o		(rvalid_m_sram0),	 // Templated
		    // Inputs
		    .clk_axi_i		(aclk),			 // Templated
		    .rst_axi_ni		(aresetn),		 // Templated
		    .clk_apb_i		(pclk),			 // Templated
		    .rst_apb_ni		(presetn),		 // Templated
		    .test_en_i		(1'b0),			 // Templated
		    .apb_psel_i		(psel_srecc0),		 // Templated
		    .apb_penable_i	(penable_sram_ecc),	 // Templated
		    .apb_pwrite_i	(pwrite_sram_ecc),	 // Templated
		    .apb_paddr_i	(paddr_sram_ecc[9:0]),	 // Templated
		    .apb_pwdata_i	(pwdata_sram_ecc[31:0]), // Templated
		    .apb_pstrb_i	(pstrb_sram_ecc[3:0]),	 // Templated
		    .s_awid_i		(awid_m_sram0[11:0]),	 // Templated
		    .s_awaddr_i		({16'b0, awaddr_m_sram0[15:0]}), // Templated
		    .s_awlen_i		(awlen_m_sram0[7:0]),	 // Templated
		    .s_awsize_i		(awsize_m_sram0[2:0]),	 // Templated
		    .s_awburst_i	(awburst_m_sram0[1:0]),	 // Templated
		    .s_awvalid_i	(awvalid_m_sram0),	 // Templated
		    .s_wdata_i		(wdata_m_sram0[127:0]),	 // Templated
		    .s_wstrb_i		(wstrb_m_sram0[15:0]),	 // Templated
		    .s_wlast_i		(wlast_m_sram0),	 // Templated
		    .s_wvalid_i		(wvalid_m_sram0),	 // Templated
		    .s_bready_i		(bready_m_sram0),	 // Templated
		    .s_arid_i		(arid_m_sram0[11:0]),	 // Templated
		    .s_araddr_i		({16'b0, araddr_m_sram0[15:0]}), // Templated
		    .s_arlen_i		(arlen_m_sram0[7:0]),	 // Templated
		    .s_arsize_i		(arsize_m_sram0[2:0]),	 // Templated
		    .s_arburst_i	(arburst_m_sram0[1:0]),	 // Templated
		    .s_arvalid_i	(arvalid_m_sram0),	 // Templated
		    .s_rready_i		(rready_m_sram0));	 // Templated

  /* srecc_top AUTO_TEMPLATE(
    .clk_axi_i(aclk),
    .rst_axi_ni(aresetn),
    .clk_apb_i(pclk),
    .rst_apb_ni(presetn),
    .test_en_i(1'b0),
    .apb_psel_i(psel_srecc1),
    .apb_penable_i(penable_sram_ecc),
    .apb_pwrite_i(pwrite_sram_ecc),
    .apb_paddr_i(paddr_sram_ecc[]),
    .apb_pwdata_i(pwdata_sram_ecc[]),
    .apb_pstrb_i(pstrb_sram_ecc[]),
    .apb_prdata_o(prdata_srecc1[]),
    .apb_pready_o(pready_srecc1),
    .apb_pslverr_o(pslverr_srecc1),
    .irq_out_o(srecc1_intr),
	.s_awaddr_i({16'b0, awaddr_m_sram1[15:0]}),
	.s_araddr_i({16'b0, araddr_m_sram1[15:0]}),
	.s_wstrb_i(wstrb_m_sram1[15:0]),
    .s_\(.*\)_o(\1_m_sram1[]),
    .s_\(.*\)_i(\1_m_sram1[]));
  */
    srecc_top #(
	.AxiDataW    (128),
        .AxiAddrW    (32),
        .AxiIdW      (12),
        .NumBanks    (4),
        .TotalDataBytes (64*1024),
        .MaxOutstanding (8),
        .ApbAddrW       (10)
    ) u_srecc_top1 (  /*AUTOINST*/
		    // Outputs
		    .apb_prdata_o	(prdata_srecc1[31:0]),	 // Templated
		    .apb_pready_o	(pready_srecc1),	 // Templated
		    .apb_pslverr_o	(pslverr_srecc1),	 // Templated
		    .irq_out_o		(srecc1_intr),		 // Templated
		    .s_awready_o	(awready_m_sram1),	 // Templated
		    .s_wready_o		(wready_m_sram1),	 // Templated
		    .s_bid_o		(bid_m_sram1[11:0]),	 // Templated
		    .s_bresp_o		(bresp_m_sram1[1:0]),	 // Templated
		    .s_bvalid_o		(bvalid_m_sram1),	 // Templated
		    .s_arready_o	(arready_m_sram1),	 // Templated
		    .s_rid_o		(rid_m_sram1[11:0]),	 // Templated
		    .s_rdata_o		(rdata_m_sram1[127:0]),	 // Templated
		    .s_rresp_o		(rresp_m_sram1[1:0]),	 // Templated
		    .s_rlast_o		(rlast_m_sram1),	 // Templated
		    .s_rvalid_o		(rvalid_m_sram1),	 // Templated
		    // Inputs
		    .clk_axi_i		(aclk),			 // Templated
		    .rst_axi_ni		(aresetn),		 // Templated
		    .clk_apb_i		(pclk),			 // Templated
		    .rst_apb_ni		(presetn),		 // Templated
		    .test_en_i		(1'b0),			 // Templated
		    .apb_psel_i		(psel_srecc1),		 // Templated
		    .apb_penable_i	(penable_sram_ecc),	 // Templated
		    .apb_pwrite_i	(pwrite_sram_ecc),	 // Templated
		    .apb_paddr_i	(paddr_sram_ecc[9:0]),	 // Templated
		    .apb_pwdata_i	(pwdata_sram_ecc[31:0]), // Templated
		    .apb_pstrb_i	(pstrb_sram_ecc[3:0]),	 // Templated
		    .s_awid_i		(awid_m_sram1[11:0]),	 // Templated
		    .s_awaddr_i		({16'b0, awaddr_m_sram1[15:0]}), // Templated
		    .s_awlen_i		(awlen_m_sram1[7:0]),	 // Templated
		    .s_awsize_i		(awsize_m_sram1[2:0]),	 // Templated
		    .s_awburst_i	(awburst_m_sram1[1:0]),	 // Templated
		    .s_awvalid_i	(awvalid_m_sram1),	 // Templated
		    .s_wdata_i		(wdata_m_sram1[127:0]),	 // Templated
		    .s_wstrb_i		(wstrb_m_sram1[15:0]),	 // Templated
		    .s_wlast_i		(wlast_m_sram1),	 // Templated
		    .s_wvalid_i		(wvalid_m_sram1),	 // Templated
		    .s_bready_i		(bready_m_sram1),	 // Templated
		    .s_arid_i		(arid_m_sram1[11:0]),	 // Templated
		    .s_araddr_i		({16'b0, araddr_m_sram1[15:0]}), // Templated
		    .s_arlen_i		(arlen_m_sram1[7:0]),	 // Templated
		    .s_arsize_i		(arsize_m_sram1[2:0]),	 // Templated
		    .s_arburst_i	(arburst_m_sram1[1:0]),	 // Templated
		    .s_arvalid_i	(arvalid_m_sram1),	 // Templated
		    .s_rready_i		(rready_m_sram1));	 // Templated

  /* srecc_top AUTO_TEMPLATE(
    .clk_axi_i(aclk),
    .rst_axi_ni(aresetn),
    .clk_apb_i(pclk),
    .rst_apb_ni(presetn),
    .test_en_i(1'b0),
    .apb_psel_i(psel_srecc2),
    .apb_penable_i(penable_sram_ecc),
    .apb_pwrite_i(pwrite_sram_ecc),
    .apb_paddr_i(paddr_sram_ecc[]),
    .apb_pwdata_i(pwdata_sram_ecc[]),
    .apb_pstrb_i(pstrb_sram_ecc[]),
    .apb_prdata_o(prdata_srecc2[]),
    .apb_pready_o(pready_srecc2),
    .apb_pslverr_o(pslverr_srecc2),
    .irq_out_o(srecc2_intr),
	.s_awaddr_i({16'b0, awaddr_m_sram2[15:0]}),
	.s_araddr_i({16'b0, araddr_m_sram2[15:0]}),
	.s_wstrb_i(wstrb_m_sram2[15:0]),
    .s_\(.*\)_o(\1_m_sram2[]),
    .s_\(.*\)_i(\1_m_sram2[]));
  */
    srecc_top #(
	.AxiDataW    (128),
        .AxiAddrW    (32),
        .AxiIdW      (12),
        .NumBanks    (4),
        .TotalDataBytes (64*1024),
        .MaxOutstanding (8),
        .ApbAddrW       (10)
    ) u_srecc_top2 (  /*AUTOINST*/
		    // Outputs
		    .apb_prdata_o	(prdata_srecc2[31:0]),	 // Templated
		    .apb_pready_o	(pready_srecc2),	 // Templated
		    .apb_pslverr_o	(pslverr_srecc2),	 // Templated
		    .irq_out_o		(srecc2_intr),		 // Templated
		    .s_awready_o	(awready_m_sram2),	 // Templated
		    .s_wready_o		(wready_m_sram2),	 // Templated
		    .s_bid_o		(bid_m_sram2[11:0]),	 // Templated
		    .s_bresp_o		(bresp_m_sram2[1:0]),	 // Templated
		    .s_bvalid_o		(bvalid_m_sram2),	 // Templated
		    .s_arready_o	(arready_m_sram2),	 // Templated
		    .s_rid_o		(rid_m_sram2[11:0]),	 // Templated
		    .s_rdata_o		(rdata_m_sram2[127:0]),	 // Templated
		    .s_rresp_o		(rresp_m_sram2[1:0]),	 // Templated
		    .s_rlast_o		(rlast_m_sram2),	 // Templated
		    .s_rvalid_o		(rvalid_m_sram2),	 // Templated
		    // Inputs
		    .clk_axi_i		(aclk),			 // Templated
		    .rst_axi_ni		(aresetn),		 // Templated
		    .clk_apb_i		(pclk),			 // Templated
		    .rst_apb_ni		(presetn),		 // Templated
		    .test_en_i		(1'b0),			 // Templated
		    .apb_psel_i		(psel_srecc2),		 // Templated
		    .apb_penable_i	(penable_sram_ecc),	 // Templated
		    .apb_pwrite_i	(pwrite_sram_ecc),	 // Templated
		    .apb_paddr_i	(paddr_sram_ecc[9:0]),	 // Templated
		    .apb_pwdata_i	(pwdata_sram_ecc[31:0]), // Templated
		    .apb_pstrb_i	(pstrb_sram_ecc[3:0]),	 // Templated
		    .s_awid_i		(awid_m_sram2[11:0]),	 // Templated
		    .s_awaddr_i		({16'b0, awaddr_m_sram2[15:0]}), // Templated
		    .s_awlen_i		(awlen_m_sram2[7:0]),	 // Templated
		    .s_awsize_i		(awsize_m_sram2[2:0]),	 // Templated
		    .s_awburst_i	(awburst_m_sram2[1:0]),	 // Templated
		    .s_awvalid_i	(awvalid_m_sram2),	 // Templated
		    .s_wdata_i		(wdata_m_sram2[127:0]),	 // Templated
		    .s_wstrb_i		(wstrb_m_sram2[15:0]),	 // Templated
		    .s_wlast_i		(wlast_m_sram2),	 // Templated
		    .s_wvalid_i		(wvalid_m_sram2),	 // Templated
		    .s_bready_i		(bready_m_sram2),	 // Templated
		    .s_arid_i		(arid_m_sram2[11:0]),	 // Templated
		    .s_araddr_i		({16'b0, araddr_m_sram2[15:0]}), // Templated
		    .s_arlen_i		(arlen_m_sram2[7:0]),	 // Templated
		    .s_arsize_i		(arsize_m_sram2[2:0]),	 // Templated
		    .s_arburst_i	(arburst_m_sram2[1:0]),	 // Templated
		    .s_arvalid_i	(arvalid_m_sram2),	 // Templated
		    .s_rready_i		(rready_m_sram2));	 // Templated

  /* srecc_top AUTO_TEMPLATE(
    .clk_axi_i(aclk),
    .rst_axi_ni(aresetn),
    .clk_apb_i(pclk),
    .rst_apb_ni(presetn),
    .test_en_i(1'b0),
    .apb_psel_i(psel_srecc3),
    .apb_penable_i(penable_sram_ecc),
    .apb_pwrite_i(pwrite_sram_ecc),
    .apb_paddr_i(paddr_sram_ecc[]),
    .apb_pwdata_i(pwdata_sram_ecc[]),
    .apb_pstrb_i(pstrb_sram_ecc[]),
    .apb_prdata_o(prdata_srecc3[]),
    .apb_pready_o(pready_srecc3),
    .apb_pslverr_o(pslverr_srecc3),
    .irq_out_o(srecc3_intr),
	.s_awaddr_i({16'b0, awaddr_m_sram3[15:0]}),
	.s_araddr_i({16'b0, araddr_m_sram3[15:0]}),
	.s_wstrb_i(wstrb_m_sram3[15:0]),
    .s_\(.*\)_o(\1_m_sram3[]),
    .s_\(.*\)_i(\1_m_sram3[]));
  */
    srecc_top #(
	.AxiDataW    (128),
        .AxiAddrW    (32),
        .AxiIdW      (12),
        .NumBanks    (4),
        .TotalDataBytes (64*1024),
        .MaxOutstanding (8),
        .ApbAddrW       (10)
    ) u_srecc_top3 (  /*AUTOINST*/
		    // Outputs
		    .apb_prdata_o	(prdata_srecc3[31:0]),	 // Templated
		    .apb_pready_o	(pready_srecc3),	 // Templated
		    .apb_pslverr_o	(pslverr_srecc3),	 // Templated
		    .irq_out_o		(srecc3_intr),		 // Templated
		    .s_awready_o	(awready_m_sram3),	 // Templated
		    .s_wready_o		(wready_m_sram3),	 // Templated
		    .s_bid_o		(bid_m_sram3[11:0]),	 // Templated
		    .s_bresp_o		(bresp_m_sram3[1:0]),	 // Templated
		    .s_bvalid_o		(bvalid_m_sram3),	 // Templated
		    .s_arready_o	(arready_m_sram3),	 // Templated
		    .s_rid_o		(rid_m_sram3[11:0]),	 // Templated
		    .s_rdata_o		(rdata_m_sram3[127:0]),	 // Templated
		    .s_rresp_o		(rresp_m_sram3[1:0]),	 // Templated
		    .s_rlast_o		(rlast_m_sram3),	 // Templated
		    .s_rvalid_o		(rvalid_m_sram3),	 // Templated
		    // Inputs
		    .clk_axi_i		(aclk),			 // Templated
		    .rst_axi_ni		(aresetn),		 // Templated
		    .clk_apb_i		(pclk),			 // Templated
		    .rst_apb_ni		(presetn),		 // Templated
		    .test_en_i		(1'b0),			 // Templated
		    .apb_psel_i		(psel_srecc3),		 // Templated
		    .apb_penable_i	(penable_sram_ecc),	 // Templated
		    .apb_pwrite_i	(pwrite_sram_ecc),	 // Templated
		    .apb_paddr_i	(paddr_sram_ecc[9:0]),	 // Templated
		    .apb_pwdata_i	(pwdata_sram_ecc[31:0]), // Templated
		    .apb_pstrb_i	(pstrb_sram_ecc[3:0]),	 // Templated
		    .s_awid_i		(awid_m_sram3[11:0]),	 // Templated
		    .s_awaddr_i		({16'b0, awaddr_m_sram3[15:0]}), // Templated
		    .s_awlen_i		(awlen_m_sram3[7:0]),	 // Templated
		    .s_awsize_i		(awsize_m_sram3[2:0]),	 // Templated
		    .s_awburst_i	(awburst_m_sram3[1:0]),	 // Templated
		    .s_awvalid_i	(awvalid_m_sram3),	 // Templated
		    .s_wdata_i		(wdata_m_sram3[127:0]),	 // Templated
		    .s_wstrb_i		(wstrb_m_sram3[15:0]),	 // Templated
		    .s_wlast_i		(wlast_m_sram3),	 // Templated
		    .s_wvalid_i		(wvalid_m_sram3),	 // Templated
		    .s_bready_i		(bready_m_sram3),	 // Templated
		    .s_arid_i		(arid_m_sram3[11:0]),	 // Templated
		    .s_araddr_i		({16'b0, araddr_m_sram3[15:0]}), // Templated
		    .s_arlen_i		(arlen_m_sram3[7:0]),	 // Templated
		    .s_arsize_i		(arsize_m_sram3[2:0]),	 // Templated
		    .s_arburst_i	(arburst_m_sram3[1:0]),	 // Templated
		    .s_arvalid_i	(arvalid_m_sram3),	 // Templated
		    .s_rready_i		(rready_m_sram3));	 // Templated
`else
    /* peri_axi128_sram AUTO_TEMPLATE(
      .aclk(aclk),
      .aresetn(aresetn),
      .csysack(),
      .cactive(),
      .csysreq(1'b1),
      .\(.*\)(\1_m_sram0[]));
  */
    peri_axi128_sram #(
        .SRAM_AXI_DW   (128),
        .SRAM_AXI_SW   (16),
        .SRAM_ADR_WIDTH(12)
    ) u_peri_axi128_sram0 (  /*AUTOINST*/
			   // Outputs
			   .awready		(awready_m_sram0), // Templated
			   .wready		(wready_m_sram0), // Templated
			   .bid			(bid_m_sram0[11:0]), // Templated
			   .bresp		(bresp_m_sram0[1:0]), // Templated
			   .bvalid		(bvalid_m_sram0), // Templated
			   .arready		(arready_m_sram0), // Templated
			   .rid			(rid_m_sram0[11:0]), // Templated
			   .rdata		(rdata_m_sram0[127:0]), // Templated
			   .rresp		(rresp_m_sram0[1:0]), // Templated
			   .rlast		(rlast_m_sram0), // Templated
			   .rvalid		(rvalid_m_sram0), // Templated
			   // Inputs
			   .aclk		(aclk),		 // Templated
			   .aresetn		(aresetn),	 // Templated
			   .awid		(awid_m_sram0[11:0]), // Templated
			   .awaddr		(awaddr_m_sram0[31:0]), // Templated
			   .awlen		(awlen_m_sram0[7:0]), // Templated
			   .awsize		(awsize_m_sram0[2:0]), // Templated
			   .awburst		(awburst_m_sram0[1:0]), // Templated
			   .awlock		(awlock_m_sram0), // Templated
			   .awcache		(awcache_m_sram0[3:0]), // Templated
			   .awprot		(awprot_m_sram0[2:0]), // Templated
			   .awvalid		(awvalid_m_sram0), // Templated
			   .wdata		(wdata_m_sram0[127:0]), // Templated
			   .wstrb		(wstrb_m_sram0[15:0]), // Templated
			   .wlast		(wlast_m_sram0), // Templated
			   .wvalid		(wvalid_m_sram0), // Templated
			   .bready		(bready_m_sram0), // Templated
			   .arid		(arid_m_sram0[11:0]), // Templated
			   .araddr		(araddr_m_sram0[31:0]), // Templated
			   .arlen		(arlen_m_sram0[7:0]), // Templated
			   .arsize		(arsize_m_sram0[2:0]), // Templated
			   .arburst		(arburst_m_sram0[1:0]), // Templated
			   .arlock		(arlock_m_sram0), // Templated
			   .arcache		(arcache_m_sram0[3:0]), // Templated
			   .arprot		(arprot_m_sram0[2:0]), // Templated
			   .arvalid		(arvalid_m_sram0), // Templated
			   .rready		(rready_m_sram0)); // Templated

    /* peri_axi128_sram AUTO_TEMPLATE(
      .aclk(aclk),
      .aresetn(aresetn),
      .csysack(),
      .cactive(),
      .csysreq(1'b1),
      .\(.*\)(\1_m_sram1[]));
  */
    peri_axi128_sram #(
        .SRAM_AXI_DW   (128),
        .SRAM_AXI_SW   (16),
        .SRAM_ADR_WIDTH(12)
    ) u_peri_axi128_sram1 (  /*AUTOINST*/
			   // Outputs
			   .awready		(awready_m_sram1), // Templated
			   .wready		(wready_m_sram1), // Templated
			   .bid			(bid_m_sram1[11:0]), // Templated
			   .bresp		(bresp_m_sram1[1:0]), // Templated
			   .bvalid		(bvalid_m_sram1), // Templated
			   .arready		(arready_m_sram1), // Templated
			   .rid			(rid_m_sram1[11:0]), // Templated
			   .rdata		(rdata_m_sram1[127:0]), // Templated
			   .rresp		(rresp_m_sram1[1:0]), // Templated
			   .rlast		(rlast_m_sram1), // Templated
			   .rvalid		(rvalid_m_sram1), // Templated
			   // Inputs
			   .aclk		(aclk),		 // Templated
			   .aresetn		(aresetn),	 // Templated
			   .awid		(awid_m_sram1[11:0]), // Templated
			   .awaddr		(awaddr_m_sram1[31:0]), // Templated
			   .awlen		(awlen_m_sram1[7:0]), // Templated
			   .awsize		(awsize_m_sram1[2:0]), // Templated
			   .awburst		(awburst_m_sram1[1:0]), // Templated
			   .awlock		(awlock_m_sram1), // Templated
			   .awcache		(awcache_m_sram1[3:0]), // Templated
			   .awprot		(awprot_m_sram1[2:0]), // Templated
			   .awvalid		(awvalid_m_sram1), // Templated
			   .wdata		(wdata_m_sram1[127:0]), // Templated
			   .wstrb		(wstrb_m_sram1[15:0]), // Templated
			   .wlast		(wlast_m_sram1), // Templated
			   .wvalid		(wvalid_m_sram1), // Templated
			   .bready		(bready_m_sram1), // Templated
			   .arid		(arid_m_sram1[11:0]), // Templated
			   .araddr		(araddr_m_sram1[31:0]), // Templated
			   .arlen		(arlen_m_sram1[7:0]), // Templated
			   .arsize		(arsize_m_sram1[2:0]), // Templated
			   .arburst		(arburst_m_sram1[1:0]), // Templated
			   .arlock		(arlock_m_sram1), // Templated
			   .arcache		(arcache_m_sram1[3:0]), // Templated
			   .arprot		(arprot_m_sram1[2:0]), // Templated
			   .arvalid		(arvalid_m_sram1), // Templated
			   .rready		(rready_m_sram1)); // Templated


    /* peri_axi128_sram AUTO_TEMPLATE(
      .aclk(aclk),
      .aresetn(aresetn),
      .csysack(),
      .cactive(),
      .csysreq(1'b1),
      .\(.*\)(\1_m_sram2[]));
  */
    peri_axi128_sram #(
        .SRAM_AXI_DW   (128),
        .SRAM_AXI_SW   (16),
        .SRAM_ADR_WIDTH(12)
    ) u_peri_axi128_sram2 (  /*AUTOINST*/
			   // Outputs
			   .awready		(awready_m_sram2), // Templated
			   .wready		(wready_m_sram2), // Templated
			   .bid			(bid_m_sram2[11:0]), // Templated
			   .bresp		(bresp_m_sram2[1:0]), // Templated
			   .bvalid		(bvalid_m_sram2), // Templated
			   .arready		(arready_m_sram2), // Templated
			   .rid			(rid_m_sram2[11:0]), // Templated
			   .rdata		(rdata_m_sram2[127:0]), // Templated
			   .rresp		(rresp_m_sram2[1:0]), // Templated
			   .rlast		(rlast_m_sram2), // Templated
			   .rvalid		(rvalid_m_sram2), // Templated
			   // Inputs
			   .aclk		(aclk),		 // Templated
			   .aresetn		(aresetn),	 // Templated
			   .awid		(awid_m_sram2[11:0]), // Templated
			   .awaddr		(awaddr_m_sram2[31:0]), // Templated
			   .awlen		(awlen_m_sram2[7:0]), // Templated
			   .awsize		(awsize_m_sram2[2:0]), // Templated
			   .awburst		(awburst_m_sram2[1:0]), // Templated
			   .awlock		(awlock_m_sram2), // Templated
			   .awcache		(awcache_m_sram2[3:0]), // Templated
			   .awprot		(awprot_m_sram2[2:0]), // Templated
			   .awvalid		(awvalid_m_sram2), // Templated
			   .wdata		(wdata_m_sram2[127:0]), // Templated
			   .wstrb		(wstrb_m_sram2[15:0]), // Templated
			   .wlast		(wlast_m_sram2), // Templated
			   .wvalid		(wvalid_m_sram2), // Templated
			   .bready		(bready_m_sram2), // Templated
			   .arid		(arid_m_sram2[11:0]), // Templated
			   .araddr		(araddr_m_sram2[31:0]), // Templated
			   .arlen		(arlen_m_sram2[7:0]), // Templated
			   .arsize		(arsize_m_sram2[2:0]), // Templated
			   .arburst		(arburst_m_sram2[1:0]), // Templated
			   .arlock		(arlock_m_sram2), // Templated
			   .arcache		(arcache_m_sram2[3:0]), // Templated
			   .arprot		(arprot_m_sram2[2:0]), // Templated
			   .arvalid		(arvalid_m_sram2), // Templated
			   .rready		(rready_m_sram2)); // Templated

    /* peri_axi128_sram AUTO_TEMPLATE(
      .aclk(aclk),
      .aresetn(aresetn),
      .csysack(),
      .cactive(),
      .csysreq(1'b1),
      .\(.*\)(\1_m_sram3[]));
  */
    peri_axi128_sram #(
        .SRAM_AXI_DW   (128),
        .SRAM_AXI_SW   (16),
        .SRAM_ADR_WIDTH(12)
    ) u_peri_axi128_sram3 (  /*AUTOINST*/
			   // Outputs
			   .awready		(awready_m_sram3), // Templated
			   .wready		(wready_m_sram3), // Templated
			   .bid			(bid_m_sram3[11:0]), // Templated
			   .bresp		(bresp_m_sram3[1:0]), // Templated
			   .bvalid		(bvalid_m_sram3), // Templated
			   .arready		(arready_m_sram3), // Templated
			   .rid			(rid_m_sram3[11:0]), // Templated
			   .rdata		(rdata_m_sram3[127:0]), // Templated
			   .rresp		(rresp_m_sram3[1:0]), // Templated
			   .rlast		(rlast_m_sram3), // Templated
			   .rvalid		(rvalid_m_sram3), // Templated
			   // Inputs
			   .aclk		(aclk),		 // Templated
			   .aresetn		(aresetn),	 // Templated
			   .awid		(awid_m_sram3[11:0]), // Templated
			   .awaddr		(awaddr_m_sram3[31:0]), // Templated
			   .awlen		(awlen_m_sram3[7:0]), // Templated
			   .awsize		(awsize_m_sram3[2:0]), // Templated
			   .awburst		(awburst_m_sram3[1:0]), // Templated
			   .awlock		(awlock_m_sram3), // Templated
			   .awcache		(awcache_m_sram3[3:0]), // Templated
			   .awprot		(awprot_m_sram3[2:0]), // Templated
			   .awvalid		(awvalid_m_sram3), // Templated
			   .wdata		(wdata_m_sram3[127:0]), // Templated
			   .wstrb		(wstrb_m_sram3[15:0]), // Templated
			   .wlast		(wlast_m_sram3), // Templated
			   .wvalid		(wvalid_m_sram3), // Templated
			   .bready		(bready_m_sram3), // Templated
			   .arid		(arid_m_sram3[11:0]), // Templated
			   .araddr		(araddr_m_sram3[31:0]), // Templated
			   .arlen		(arlen_m_sram3[7:0]), // Templated
			   .arsize		(arsize_m_sram3[2:0]), // Templated
			   .arburst		(arburst_m_sram3[1:0]), // Templated
			   .arlock		(arlock_m_sram3), // Templated
			   .arcache		(arcache_m_sram3[3:0]), // Templated
			   .arprot		(arprot_m_sram3[2:0]), // Templated
			   .arvalid		(arvalid_m_sram3), // Templated
			   .rready		(rready_m_sram3)); // Templated

    // No srecc_top instances in this build, so nothing drives the SRAM ECC APB
    // response.  Terminate it as an always-ready slave that reads back zero.
    assign prdata_sram_ecc  = 32'b0;
    assign pready_sram_ecc  = 1'b1;
    assign pslverr_sram_ecc = 1'b0;
`endif

wire [32:0] araddr_m_rom_tmp = {1'b0,araddr_m_rom[31:0]} - 32'h10000;
wire [32:0] awaddr_m_rom_tmp = {1'b0,awaddr_m_rom[31:0]} - 32'h10000;
    /* peri_axi128_rom AUTO_TEMPLATE(
    .aclk(aclk),
    .aresetn(aresetn),
    .csysack(),
    .cactive(),
    .csysreq(1'b1),
    .araddr(araddr_m_rom_tmp[31:0]),
    .awaddr(awaddr_m_rom_tmp[31:0]),
    .reg_rom_we		(reg_rom_we), 
    .\(.*\)(\1_m_rom[]));
  */
    peri_axi128_rom #(
        .ROM_AXI_DW   (128),
        .ROM_AXI_SW   (16),
        .ROM_ADR_WIDTH(17)
    ) u_peri_axi128_rom (  /*AUTOINST*/
			 // Outputs
			 .awready		(awready_m_rom), // Templated
			 .wready		(wready_m_rom),	 // Templated
			 .bid			(bid_m_rom[11:0]), // Templated
			 .bresp			(bresp_m_rom[1:0]), // Templated
			 .bvalid		(bvalid_m_rom),	 // Templated
			 .arready		(arready_m_rom), // Templated
			 .rid			(rid_m_rom[11:0]), // Templated
			 .rdata			(rdata_m_rom[127:0]), // Templated
			 .rresp			(rresp_m_rom[1:0]), // Templated
			 .rlast			(rlast_m_rom),	 // Templated
			 .rvalid		(rvalid_m_rom),	 // Templated
			 // Inputs
			 .aclk			(aclk),		 // Templated
			 .aresetn		(aresetn),	 // Templated
			 .reg_rom_we		(reg_rom_we),	 // Templated
			 .awid			(awid_m_rom[11:0]), // Templated
			 .awaddr		(awaddr_m_rom_tmp[31:0]), // Templated
			 .awlen			(awlen_m_rom[7:0]), // Templated
			 .awsize		(awsize_m_rom[2:0]), // Templated
			 .awburst		(awburst_m_rom[1:0]), // Templated
			 .awlock		(awlock_m_rom),	 // Templated
			 .awcache		(awcache_m_rom[3:0]), // Templated
			 .awprot		(awprot_m_rom[2:0]), // Templated
			 .awvalid		(awvalid_m_rom), // Templated
			 .wdata			(wdata_m_rom[127:0]), // Templated
			 .wstrb			(wstrb_m_rom[15:0]), // Templated
			 .wlast			(wlast_m_rom),	 // Templated
			 .wvalid		(wvalid_m_rom),	 // Templated
			 .bready		(bready_m_rom),	 // Templated
			 .arid			(arid_m_rom[11:0]), // Templated
			 .araddr		(araddr_m_rom_tmp[31:0]), // Templated
			 .arlen			(arlen_m_rom[7:0]), // Templated
			 .arsize		(arsize_m_rom[2:0]), // Templated
			 .arburst		(arburst_m_rom[1:0]), // Templated
			 .arlock		(arlock_m_rom),	 // Templated
			 .arcache		(arcache_m_rom[3:0]), // Templated
			 .arprot		(arprot_m_rom[2:0]), // Templated
			 .arvalid		(arvalid_m_rom), // Templated
			 .rready		(rready_m_rom));	 // Templated


endmodule
// Local Variables:
// verilog-library-directories:("." "./peri1_sram/"
// "../../../6_ip/SRAM_ECC/v1/1_rtl/top"
// "../../../6_ip/common_ip/common_apb_sep/1_rtl")
// verilog-auto-inst-param-value:t
// End:









 

