module pcie_ep_top (
   wstrb_m_pmmbi, wdata_m_pmmbi, rdata_m_pmmbi,
   /*AUTOARG*/
   // Outputs
   wvalid_m_pmmbi, wvalid_m_pbmc, wvalid_m_h2bm, wstrb_m_pbmc,
   wstrb_m_h2bm, wlast_m_pmmbi, wlast_m_pbmc, wlast_m_h2bm,
   wdata_m_pbmc, wdata_m_h2bm, rready_m_pmmbi, rready_m_pbmc,
   rready_m_h2bm, pmmbi_s_w_fifo_rd_side_rd_addr_o,
   pmmbi_s_w_fifo_rd_side_pop_addr_g_o,
   pmmbi_s_r_fifo_wr_side_push_addr_g_o,
   pmmbi_s_r_fifo_wr_side_data_out_o,
   pmmbi_s_b_fifo_wr_side_push_addr_g_o,
   pmmbi_s_b_fifo_wr_side_data_out_o,
   pmmbi_s_aw_fifo_rd_side_rd_addr_o,
   pmmbi_s_aw_fifo_rd_side_pop_addr_g_o,
   pmmbi_s_ar_fifo_rd_side_rd_addr_o,
   pmmbi_s_ar_fifo_rd_side_pop_addr_g_o,
   pcie_ep_x2p_w_fifo_rd_side_rd_addr_i,
   pcie_ep_x2p_w_fifo_rd_side_pop_addr_g_i,
   pcie_ep_x2p_r_fifo_wr_side_push_addr_g_i,
   pcie_ep_x2p_r_fifo_wr_side_data_out_i,
   pcie_ep_x2p_b_fifo_wr_side_push_addr_g_i,
   pcie_ep_x2p_b_fifo_wr_side_data_out_i,
   pcie_ep_x2p_aw_fifo_rd_side_rd_addr_i,
   pcie_ep_x2p_aw_fifo_rd_side_pop_addr_g_i,
   pcie_ep_x2p_ar_fifo_rd_side_rd_addr_i,
   pcie_ep_x2p_ar_fifo_rd_side_pop_addr_g_i,
   pcie_ep0_s_w_fifo_rd_side_rd_addr_i,
   pcie_ep0_s_w_fifo_rd_side_pop_addr_g_i,
   pcie_ep0_s_r_fifo_wr_side_push_addr_g_i,
   pcie_ep0_s_r_fifo_wr_side_data_out_i,
   pcie_ep0_s_b_fifo_wr_side_push_addr_g_i,
   pcie_ep0_s_b_fifo_wr_side_data_out_i,
   pcie_ep0_s_aw_fifo_rd_side_rd_addr_i,
   pcie_ep0_s_aw_fifo_rd_side_pop_addr_g_i,
   pcie_ep0_s_ar_fifo_rd_side_rd_addr_i,
   pcie_ep0_s_ar_fifo_rd_side_pop_addr_g_i,
   pcie_ep0_m_w_fifo_wr_side_push_addr_g_o,
   pcie_ep0_m_w_fifo_wr_side_data_out_o,
   pcie_ep0_m_r_fifo_rd_side_rd_addr_o,
   pcie_ep0_m_r_fifo_rd_side_pop_addr_g_o,
   pcie_ep0_m_b_fifo_rd_side_rd_addr_o,
   pcie_ep0_m_b_fifo_rd_side_pop_addr_g_o,
   pcie_ep0_m_aw_fifo_wr_side_push_addr_g_o,
   pcie_ep0_m_aw_fifo_wr_side_data_out_o,
   pcie_ep0_m_ar_fifo_wr_side_push_addr_g_o,
   pcie_ep0_m_ar_fifo_wr_side_data_out_o,
   pbmc_s_w_fifo_rd_side_rd_addr_o,
   pbmc_s_w_fifo_rd_side_pop_addr_g_o,
   pbmc_s_r_fifo_wr_side_push_addr_g_o,
   pbmc_s_r_fifo_wr_side_data_out_o,
   pbmc_s_b_fifo_wr_side_push_addr_g_o,
   pbmc_s_b_fifo_wr_side_data_out_o, pbmc_s_aw_fifo_rd_side_rd_addr_o,
   pbmc_s_aw_fifo_rd_side_pop_addr_g_o,
   pbmc_s_ar_fifo_rd_side_rd_addr_o,
   pbmc_s_ar_fifo_rd_side_pop_addr_g_o,
   mvdm_m_w_fifo_wr_side_push_addr_g_o,
   mvdm_m_w_fifo_wr_side_data_out_o, mvdm_m_r_fifo_rd_side_rd_addr_o,
   mvdm_m_r_fifo_rd_side_pop_addr_g_o,
   mvdm_m_b_fifo_rd_side_rd_addr_o,
   mvdm_m_b_fifo_rd_side_pop_addr_g_o,
   mvdm_m_aw_fifo_wr_side_push_addr_g_o,
   mvdm_m_aw_fifo_wr_side_data_out_o,
   mvdm_m_ar_fifo_wr_side_push_addr_g_o,
   mvdm_m_ar_fifo_wr_side_data_out_o, irq_out_pmmbi, irq_out_pbmc,
   irq_out_mvdm, irq_out_h2bm, h2bm_s_w_fifo_rd_side_rd_addr_o,
   h2bm_s_w_fifo_rd_side_pop_addr_g_o,
   h2bm_s_r_fifo_wr_side_push_addr_g_o,
   h2bm_s_r_fifo_wr_side_data_out_o,
   h2bm_s_b_fifo_wr_side_push_addr_g_o,
   h2bm_s_b_fifo_wr_side_data_out_o, h2bm_s_aw_fifo_rd_side_rd_addr_o,
   h2bm_s_aw_fifo_rd_side_pop_addr_g_o,
   h2bm_s_ar_fifo_rd_side_rd_addr_o,
   h2bm_s_ar_fifo_rd_side_pop_addr_g_o, ep0_pcie_probe_bus,
   ep0_POWER_STATE_CHANGE_INTERRUPT, ep0_PHY_INTERRUPT_OUT,
   ep0_LOCAL_INTERRUPT, ep0_LINK_DOWN_RESET_OUT, ep0_HOT_RESET_OUT,
   ep0_FLR_IN_PROGRESS, ep0_CLKREQ_OUT_N, ep0_APTXP3, ep0_APTXP2,
   ep0_APTXP1, ep0_APTXP0, ep0_APTXN3, ep0_APTXN2, ep0_APTXN1,
   ep0_APTXN0, bready_m_pmmbi, bready_m_pbmc, bready_m_h2bm,
   awvalid_m_pmmbi, awvalid_m_pbmc, awvalid_m_h2bm, awsize_m_pmmbi,
   awsize_m_pbmc, awsize_m_h2bm, awprot_m_pbmc, awlock_m_pbmc,
   awlen_m_pmmbi, awlen_m_pbmc, awlen_m_h2bm, awid_m_pmmbi,
   awid_m_pbmc, awid_m_h2bm, awcache_m_pbmc, awburst_m_pmmbi,
   awburst_m_pbmc, awburst_m_h2bm, awaddr_m_pmmbi, awaddr_m_pbmc,
   awaddr_m_h2bm, arvalid_m_pmmbi, arvalid_m_pbmc, arvalid_m_h2bm,
   arsize_m_pmmbi, arsize_m_pbmc, arsize_m_h2bm, arprot_m_pbmc,
   arlock_m_pbmc, arlen_m_pmmbi, arlen_m_pbmc, arlen_m_h2bm,
   arid_m_pmmbi, arid_m_pbmc, arid_m_h2bm, arcache_m_pbmc,
   arburst_m_pmmbi, arburst_m_pbmc, arburst_m_h2bm, araddr_m_pmmbi,
   araddr_m_pbmc, araddr_m_h2bm,
   // Inputs
   wready_m_pmmbi, wready_m_pbmc, wready_m_h2bm, rvalid_m_pmmbi,
   rvalid_m_pbmc, rvalid_m_h2bm, rresp_m_pmmbi, rresp_m_pbmc,
   rresp_m_h2bm, rlast_m_pmmbi, rlast_m_pbmc, rlast_m_h2bm,
   rid_m_pmmbi, rid_m_pbmc, rid_m_h2bm, resetn_pmmbi, resetn_pbmc,
   resetn_mvdm, rdata_m_pbmc, rdata_m_h2bm, psel, presetn,
   pmmbi_s_w_fifo_rd_side_push_addr_g_i,
   pmmbi_s_w_fifo_rd_side_data_out_i,
   pmmbi_s_r_fifo_wr_side_rd_addr_i,
   pmmbi_s_r_fifo_wr_side_pop_addr_g_i,
   pmmbi_s_b_fifo_wr_side_rd_addr_i,
   pmmbi_s_b_fifo_wr_side_pop_addr_g_i,
   pmmbi_s_aw_fifo_rd_side_push_addr_g_i,
   pmmbi_s_aw_fifo_rd_side_data_out_i,
   pmmbi_s_ar_fifo_rd_side_push_addr_g_i,
   pmmbi_s_ar_fifo_rd_side_data_out_i, pclk,
   pcie_ep_x2p_w_fifo_rd_side_push_addr_g_o,
   pcie_ep_x2p_w_fifo_rd_side_data_out_o,
   pcie_ep_x2p_r_fifo_wr_side_rd_addr_o,
   pcie_ep_x2p_r_fifo_wr_side_pop_addr_g_o,
   pcie_ep_x2p_b_fifo_wr_side_rd_addr_o,
   pcie_ep_x2p_b_fifo_wr_side_pop_addr_g_o,
   pcie_ep_x2p_aw_fifo_rd_side_push_addr_g_o,
   pcie_ep_x2p_aw_fifo_rd_side_data_out_o,
   pcie_ep_x2p_ar_fifo_rd_side_push_addr_g_o,
   pcie_ep_x2p_ar_fifo_rd_side_data_out_o,
   pcie_ep0_s_w_fifo_rd_side_push_addr_g_o,
   pcie_ep0_s_w_fifo_rd_side_data_out_o,
   pcie_ep0_s_r_fifo_wr_side_rd_addr_o,
   pcie_ep0_s_r_fifo_wr_side_pop_addr_g_o,
   pcie_ep0_s_b_fifo_wr_side_rd_addr_o,
   pcie_ep0_s_b_fifo_wr_side_pop_addr_g_o,
   pcie_ep0_s_aw_fifo_rd_side_push_addr_g_o,
   pcie_ep0_s_aw_fifo_rd_side_data_out_o,
   pcie_ep0_s_ar_fifo_rd_side_push_addr_g_o,
   pcie_ep0_s_ar_fifo_rd_side_data_out_o,
   pcie_ep0_m_w_fifo_wr_side_rd_addr_i,
   pcie_ep0_m_w_fifo_wr_side_pop_addr_g_i,
   pcie_ep0_m_r_fifo_rd_side_push_addr_g_i,
   pcie_ep0_m_r_fifo_rd_side_data_out_i,
   pcie_ep0_m_b_fifo_rd_side_push_addr_g_i,
   pcie_ep0_m_b_fifo_rd_side_data_out_i,
   pcie_ep0_m_aw_fifo_wr_side_rd_addr_i,
   pcie_ep0_m_aw_fifo_wr_side_pop_addr_g_i,
   pcie_ep0_m_ar_fifo_wr_side_rd_addr_i,
   pcie_ep0_m_ar_fifo_wr_side_pop_addr_g_i,
   pbmc_s_w_fifo_rd_side_push_addr_g_i,
   pbmc_s_w_fifo_rd_side_data_out_i, pbmc_s_r_fifo_wr_side_rd_addr_i,
   pbmc_s_r_fifo_wr_side_pop_addr_g_i,
   pbmc_s_b_fifo_wr_side_rd_addr_i,
   pbmc_s_b_fifo_wr_side_pop_addr_g_i,
   pbmc_s_aw_fifo_rd_side_push_addr_g_i,
   pbmc_s_aw_fifo_rd_side_data_out_i,
   pbmc_s_ar_fifo_rd_side_push_addr_g_i,
   pbmc_s_ar_fifo_rd_side_data_out_i, mvdm_m_w_fifo_wr_side_rd_addr_i,
   mvdm_m_w_fifo_wr_side_pop_addr_g_i,
   mvdm_m_r_fifo_rd_side_push_addr_g_i,
   mvdm_m_r_fifo_rd_side_data_out_i,
   mvdm_m_b_fifo_rd_side_push_addr_g_i,
   mvdm_m_b_fifo_rd_side_data_out_i, mvdm_m_aw_fifo_wr_side_rd_addr_i,
   mvdm_m_aw_fifo_wr_side_pop_addr_g_i,
   mvdm_m_ar_fifo_wr_side_rd_addr_i,
   mvdm_m_ar_fifo_wr_side_pop_addr_g_i,
   h2bm_s_w_fifo_rd_side_push_addr_g_i,
   h2bm_s_w_fifo_rd_side_data_out_i, h2bm_s_r_fifo_wr_side_rd_addr_i,
   h2bm_s_r_fifo_wr_side_pop_addr_g_i,
   h2bm_s_b_fifo_wr_side_rd_addr_i,
   h2bm_s_b_fifo_wr_side_pop_addr_g_i,
   h2bm_s_aw_fifo_rd_side_push_addr_g_i,
   h2bm_s_aw_fifo_rd_side_data_out_i,
   h2bm_s_ar_fifo_rd_side_push_addr_g_i,
   h2bm_s_ar_fifo_rd_side_data_out_i, ep0_pcie_freerun_clk,
   ep0_pcie_clkp, ep0_pcie_clkn, ep0_APRXP0, ep0_APRXN0, clk_pmmbi,
   clk_pbmc, clk_mvdm, bvalid_m_pmmbi, bvalid_m_pbmc, bvalid_m_h2bm,
   bresp_m_pmmbi, bresp_m_pbmc, bresp_m_h2bm, bid_m_pmmbi, bid_m_pbmc,
   bid_m_h2bm, awready_m_pmmbi, awready_m_pbmc, awready_m_h2bm,
   arready_m_pmmbi, arready_m_pbmc, arready_m_h2bm, aresetn, aclk,
   ep0_perstn, vga0_intn, vga1_intn
   );

input                   ep0_perstn;
input                   vga0_intn;
input                   vga1_intn;
input [127:0]           rdata_m_pmmbi;
// SoC AXI width (128b).  u_pmmbi_top's m_axi_* master is only 32b, so these are
// zero-extended from the *_int nets at the bottom of the file.
//
// DO NOT remove these declarations, and DO NOT remove the .m_axi_wdata_o /
// .m_axi_wstrb_o overrides at the head of the pmmbi_top AUTO_TEMPLATE.  Without
// those overrides the template's catch-all `.m_axi_\(.*\)_o (\1_m_pmmbi[])'
// rule takes over and AUTOINST drives the pins as wdata_m_pmmbi[31:0] /
// wstrb_m_pmmbi[3:0] -- a narrow slice of a wide port, leaving the upper bits
// floating.  verilog-auto-output-ignore-regexp also lists these names, so if the
// declarations below ever go missing the nets come out undeclared (a loud
// elaboration error) instead of being silently regenerated at 32b.
output wire [15:0]      wstrb_m_pmmbi;
output wire [127:0]     wdata_m_pmmbi;

// Native 32b MBI master width, driven by u_pmmbi_top's AUTOINST.
wire [31:0]             wdata_m_pmmbi_int;
wire [3:0]              wstrb_m_pmmbi_int;

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			aclk;			// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v, ...
input			aresetn;		// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v, ...
input			arready_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input			arready_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			arready_m_pmmbi;	// To u_pmmbi_top of pmmbi_top.v
input			awready_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input			awready_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			awready_m_pmmbi;	// To u_pmmbi_top of pmmbi_top.v
input [9:0]		bid_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input [9:0]		bid_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input [9:0]		bid_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input [1:0]		bresp_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input [1:0]		bresp_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input [1:0]		bresp_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input			bvalid_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input			bvalid_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			bvalid_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input			clk_mvdm;		// To u_mvdm_top of mvdm_top.v
input			clk_pbmc;		// To u_pbmc_top of pbmc_top.v
input			clk_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input			ep0_APRXN0;		// To pcie_ep0 of PCIE_IP.v
input			ep0_APRXP0;		// To pcie_ep0 of PCIE_IP.v
input			ep0_pcie_clkn;		// To pcie_ep0 of PCIE_IP.v
input			ep0_pcie_clkp;		// To pcie_ep0 of PCIE_IP.v
input			ep0_pcie_freerun_clk;	// To pcie_ep0 of PCIE_IP.v
input [75:0]		h2bm_s_ar_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [3:0]		h2bm_s_ar_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [75:0]		h2bm_s_aw_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [3:0]		h2bm_s_aw_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [3:0]		h2bm_s_b_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [2:0]		h2bm_s_b_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [3:0]		h2bm_s_r_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [2:0]		h2bm_s_r_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [158:0]		h2bm_s_w_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [3:0]		h2bm_s_w_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
input [3:0]		mvdm_m_ar_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [2:0]		mvdm_m_ar_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [3:0]		mvdm_m_aw_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [2:0]		mvdm_m_aw_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [15:0]		mvdm_m_b_fifo_rd_side_data_out_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [3:0]		mvdm_m_b_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [144:0]		mvdm_m_r_fifo_rd_side_data_out_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [3:0]		mvdm_m_r_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [3:0]		mvdm_m_w_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [2:0]		mvdm_m_w_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_master_mvdm of ms_axi_async_master.v
input [75:0]		pbmc_s_ar_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [3:0]		pbmc_s_ar_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [75:0]		pbmc_s_aw_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [3:0]		pbmc_s_aw_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [3:0]		pbmc_s_b_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [2:0]		pbmc_s_b_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [3:0]		pbmc_s_r_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [2:0]		pbmc_s_r_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [158:0]		pbmc_s_w_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [3:0]		pbmc_s_w_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep0_m_ar_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [2:0]		pcie_ep0_m_ar_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [3:0]		pcie_ep0_m_aw_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [2:0]		pcie_ep0_m_aw_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [15:0]		pcie_ep0_m_b_fifo_rd_side_data_out_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [3:0]		pcie_ep0_m_b_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [144:0]		pcie_ep0_m_r_fifo_rd_side_data_out_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [3:0]		pcie_ep0_m_r_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [3:0]		pcie_ep0_m_w_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [2:0]		pcie_ep0_m_w_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
input [75:0]		pcie_ep0_s_ar_fifo_rd_side_data_out_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep0_s_ar_fifo_rd_side_push_addr_g_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [75:0]		pcie_ep0_s_aw_fifo_rd_side_data_out_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep0_s_aw_fifo_rd_side_push_addr_g_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep0_s_b_fifo_wr_side_pop_addr_g_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [2:0]		pcie_ep0_s_b_fifo_wr_side_rd_addr_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep0_s_r_fifo_wr_side_pop_addr_g_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [2:0]		pcie_ep0_s_r_fifo_wr_side_rd_addr_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [158:0]		pcie_ep0_s_w_fifo_rd_side_data_out_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep0_s_w_fifo_rd_side_push_addr_g_o;// To u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
input [75:0]		pcie_ep_x2p_ar_fifo_rd_side_data_out_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep_x2p_ar_fifo_rd_side_push_addr_g_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [75:0]		pcie_ep_x2p_aw_fifo_rd_side_data_out_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep_x2p_aw_fifo_rd_side_push_addr_g_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep_x2p_b_fifo_wr_side_pop_addr_g_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [2:0]		pcie_ep_x2p_b_fifo_wr_side_rd_addr_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep_x2p_r_fifo_wr_side_pop_addr_g_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [2:0]		pcie_ep_x2p_r_fifo_wr_side_rd_addr_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [158:0]		pcie_ep_x2p_w_fifo_rd_side_data_out_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input [3:0]		pcie_ep_x2p_w_fifo_rd_side_push_addr_g_o;// To u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
input			pclk;			// To reg_pcie_ep_top of reg_pcie_ep_top.v, ...
input [75:0]		pmmbi_s_ar_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [3:0]		pmmbi_s_ar_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [75:0]		pmmbi_s_aw_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [3:0]		pmmbi_s_aw_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [3:0]		pmmbi_s_b_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [2:0]		pmmbi_s_b_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [3:0]		pmmbi_s_r_fifo_wr_side_pop_addr_g_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [2:0]		pmmbi_s_r_fifo_wr_side_rd_addr_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [158:0]		pmmbi_s_w_fifo_rd_side_data_out_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input [3:0]		pmmbi_s_w_fifo_rd_side_push_addr_g_i;// To u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
input			presetn;		// To reg_pcie_ep_top of reg_pcie_ep_top.v, ...
input			psel;			// To u_mvdm_top of mvdm_top.v
input [127:0]		rdata_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input [127:0]		rdata_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			resetn_mvdm;		// To u_mvdm_top of mvdm_top.v
input			resetn_pbmc;		// To u_pbmc_top of pbmc_top.v
input			resetn_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input [9:0]		rid_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input [9:0]		rid_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input [9:0]		rid_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input			rlast_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input			rlast_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			rlast_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input [1:0]		rresp_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input [1:0]		rresp_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input [1:0]		rresp_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input			rvalid_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input			rvalid_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			rvalid_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
input			wready_m_h2bm;		// To u_h2bm_top of h2bm_top.v
input			wready_m_pbmc;		// To u_pbmc_top of pbmc_top.v
input			wready_m_pmmbi;		// To u_pmmbi_top of pmmbi_top.v
// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output logic [39:0]	araddr_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [39:0]	araddr_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [39:0]	araddr_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic [1:0]	arburst_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [1:0]	arburst_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [1:0]	arburst_m_pmmbi;	// From u_pmmbi_top of pmmbi_top.v
output logic [3:0]	arcache_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [9:0]	arid_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [9:0]	arid_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [9:0]	arid_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic [7:0]	arlen_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [7:0]	arlen_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [7:0]	arlen_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic		arlock_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [2:0]	arprot_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [2:0]	arsize_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [2:0]	arsize_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [2:0]	arsize_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic		arvalid_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		arvalid_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		arvalid_m_pmmbi;	// From u_pmmbi_top of pmmbi_top.v
output logic [39:0]	awaddr_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [39:0]	awaddr_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [39:0]	awaddr_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic [1:0]	awburst_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [1:0]	awburst_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [1:0]	awburst_m_pmmbi;	// From u_pmmbi_top of pmmbi_top.v
output logic [3:0]	awcache_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [9:0]	awid_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [9:0]	awid_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [9:0]	awid_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic [7:0]	awlen_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [7:0]	awlen_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [7:0]	awlen_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic		awlock_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [2:0]	awprot_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [2:0]	awsize_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [2:0]	awsize_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic [2:0]	awsize_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic		awvalid_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		awvalid_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		awvalid_m_pmmbi;	// From u_pmmbi_top of pmmbi_top.v
output logic		bready_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		bready_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		bready_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output			ep0_APTXN0;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXN1;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXN2;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXN3;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXP0;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXP1;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXP2;		// From pcie_ep0 of PCIE_IP.v
output			ep0_APTXP3;		// From pcie_ep0 of PCIE_IP.v
output			ep0_CLKREQ_OUT_N;	// From pcie_ep0 of PCIE_IP.v
output [4:0]		ep0_FLR_IN_PROGRESS;	// From pcie_ep0 of PCIE_IP.v
output			ep0_HOT_RESET_OUT;	// From pcie_ep0 of PCIE_IP.v
output			ep0_LINK_DOWN_RESET_OUT;// From pcie_ep0 of PCIE_IP.v
output [4:0]		ep0_LOCAL_INTERRUPT;	// From pcie_ep0 of PCIE_IP.v
output			ep0_PHY_INTERRUPT_OUT;	// From pcie_ep0 of PCIE_IP.v
output			ep0_POWER_STATE_CHANGE_INTERRUPT;// From pcie_ep0 of PCIE_IP.v
output [31:0]		ep0_pcie_probe_bus;	// From pcie_ep0 of PCIE_IP.v
output [3:0]		h2bm_s_ar_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [2:0]		h2bm_s_ar_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [3:0]		h2bm_s_aw_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [2:0]		h2bm_s_aw_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [15:0]		h2bm_s_b_fifo_wr_side_data_out_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [3:0]		h2bm_s_b_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [144:0]		h2bm_s_r_fifo_wr_side_data_out_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [3:0]		h2bm_s_r_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [3:0]		h2bm_s_w_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output [2:0]		h2bm_s_w_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
output logic		irq_out_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		irq_out_mvdm;		// From u_mvdm_top of mvdm_top.v
output logic		irq_out_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		irq_out_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output [75:0]		mvdm_m_ar_fifo_wr_side_data_out_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [3:0]		mvdm_m_ar_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [75:0]		mvdm_m_aw_fifo_wr_side_data_out_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [3:0]		mvdm_m_aw_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [3:0]		mvdm_m_b_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [2:0]		mvdm_m_b_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [3:0]		mvdm_m_r_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [2:0]		mvdm_m_r_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [158:0]		mvdm_m_w_fifo_wr_side_data_out_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [3:0]		mvdm_m_w_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
output [3:0]		pbmc_s_ar_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [2:0]		pbmc_s_ar_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [3:0]		pbmc_s_aw_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [2:0]		pbmc_s_aw_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [15:0]		pbmc_s_b_fifo_wr_side_data_out_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [3:0]		pbmc_s_b_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [144:0]		pbmc_s_r_fifo_wr_side_data_out_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [3:0]		pbmc_s_r_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [3:0]		pbmc_s_w_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [2:0]		pbmc_s_w_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
output [75:0]		pcie_ep0_m_ar_fifo_wr_side_data_out_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [3:0]		pcie_ep0_m_ar_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [75:0]		pcie_ep0_m_aw_fifo_wr_side_data_out_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [3:0]		pcie_ep0_m_aw_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [3:0]		pcie_ep0_m_b_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [2:0]		pcie_ep0_m_b_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [3:0]		pcie_ep0_m_r_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [2:0]		pcie_ep0_m_r_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [158:0]		pcie_ep0_m_w_fifo_wr_side_data_out_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [3:0]		pcie_ep0_m_w_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
output [3:0]		pcie_ep0_s_ar_fifo_rd_side_pop_addr_g_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [2:0]		pcie_ep0_s_ar_fifo_rd_side_rd_addr_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep0_s_aw_fifo_rd_side_pop_addr_g_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [2:0]		pcie_ep0_s_aw_fifo_rd_side_rd_addr_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [15:0]		pcie_ep0_s_b_fifo_wr_side_data_out_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep0_s_b_fifo_wr_side_push_addr_g_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [144:0]		pcie_ep0_s_r_fifo_wr_side_data_out_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep0_s_r_fifo_wr_side_push_addr_g_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep0_s_w_fifo_rd_side_pop_addr_g_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [2:0]		pcie_ep0_s_w_fifo_rd_side_rd_addr_i;// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep_x2p_ar_fifo_rd_side_pop_addr_g_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [2:0]		pcie_ep_x2p_ar_fifo_rd_side_rd_addr_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep_x2p_aw_fifo_rd_side_pop_addr_g_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [2:0]		pcie_ep_x2p_aw_fifo_rd_side_rd_addr_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [15:0]		pcie_ep_x2p_b_fifo_wr_side_data_out_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep_x2p_b_fifo_wr_side_push_addr_g_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [144:0]		pcie_ep_x2p_r_fifo_wr_side_data_out_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep_x2p_r_fifo_wr_side_push_addr_g_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [3:0]		pcie_ep_x2p_w_fifo_rd_side_pop_addr_g_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [2:0]		pcie_ep_x2p_w_fifo_rd_side_rd_addr_i;// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
output [3:0]		pmmbi_s_ar_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [2:0]		pmmbi_s_ar_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [3:0]		pmmbi_s_aw_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [2:0]		pmmbi_s_aw_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [15:0]		pmmbi_s_b_fifo_wr_side_data_out_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [3:0]		pmmbi_s_b_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [144:0]		pmmbi_s_r_fifo_wr_side_data_out_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [3:0]		pmmbi_s_r_fifo_wr_side_push_addr_g_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [3:0]		pmmbi_s_w_fifo_rd_side_pop_addr_g_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output [2:0]		pmmbi_s_w_fifo_rd_side_rd_addr_o;// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
output logic		rready_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		rready_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		rready_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic [127:0]	wdata_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [127:0]	wdata_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		wlast_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		wlast_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		wlast_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
output logic [15:0]	wstrb_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic [15:0]	wstrb_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		wvalid_m_h2bm;		// From u_h2bm_top of h2bm_top.v
output logic		wvalid_m_pbmc;		// From u_pbmc_top of pbmc_top.v
output logic		wvalid_m_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
// End of automatics

/*AUTO_LISP(setq verilog-auto-output-ignore-regexp
     (concat "penable"
             "\\|psel.*"
             "\\|pwrite.*"
             "\\|pprot.*"
             "\\|.*_pcie_ep0_m"
             "\\|.*_pcie_ep0_s"
             "\\|pstrb"
             "\\|pwdata"
             "\\|prdata"
             "\\|pready"
             "\\|pslverr"
             "\\|wid_m_apb"
             "\\|cactive"
             "\\|csysack"
             "\\|paddr"
             "\\|reg_.*"
             "\\|.*idc.*"
	     "\\|.*pmmbi_int"
	     "\\|w\\(data\\|strb\\)_m_pmmbi"

     )
)*/

/*AUTO_LISP(setq verilog-auto-input-ignore-regexp
     (concat "_pcie_ep0_s"
             "\\|.*_pcie_ep0_m"
     )
)*/



/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
logic [39:0]		araddr_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [39:0]		araddr_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [39:0]		araddr_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [39:0]		araddr_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [39:0]		araddr_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [39:0]		araddr_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [39:0]		araddr_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [39:0]		araddr_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
logic [1:0]		arburst_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [1:0]		arburst_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [1:0]		arburst_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [1:0]		arburst_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [1:0]		arburst_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [1:0]		arburst_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [1:0]		arburst_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [1:0]		arburst_s_pmmbi;	// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [3:0]		arcache_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [3:0]		arcache_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [3:0]		arcache_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [3:0]		arcache_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
logic [9:0]		arid_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [9:0]		arid_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [4:0]		arid_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [9:0]		arid_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [4:0]		arid_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [9:0]		arid_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [9:0]		arid_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [9:0]		arid_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
logic [7:0]		arlen_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [3:0]		arlen_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [3:0]		arlen_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [7:0]		arlen_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [3:0]		arlen_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [7:0]		arlen_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [7:0]		arlen_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [7:0]		arlen_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [1:0]		arlock_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [1:0]		arlock_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [1:0]		arlock_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [2:0]		arprot_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [2:0]		arprot_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [2:0]		arprot_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [2:0]		arprot_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			arready_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire			arready_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire			arready_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire			arready_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			arready_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic			arready_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			arready_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic			arready_s_pmmbi;	// From u_pmmbi_top of pmmbi_top.v
logic [2:0]		arsize_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [2:0]		arsize_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [2:0]		arsize_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [2:0]		arsize_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [2:0]		arsize_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [2:0]		arsize_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [2:0]		arsize_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [2:0]		arsize_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [7:0]		aruser_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [109:0]		aruser_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
logic			arvalid_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire			arvalid_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			arvalid_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire			arvalid_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire			arvalid_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			arvalid_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire			arvalid_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire			arvalid_s_pmmbi;	// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
logic [39:0]		awaddr_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [39:0]		awaddr_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [39:0]		awaddr_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [39:0]		awaddr_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [39:0]		awaddr_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [39:0]		awaddr_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [39:0]		awaddr_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [39:0]		awaddr_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
logic [1:0]		awburst_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [1:0]		awburst_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [1:0]		awburst_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [1:0]		awburst_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [1:0]		awburst_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [1:0]		awburst_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [1:0]		awburst_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [1:0]		awburst_s_pmmbi;	// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [3:0]		awcache_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [3:0]		awcache_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [3:0]		awcache_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [3:0]		awcache_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
logic [9:0]		awid_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [9:0]		awid_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [4:0]		awid_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [9:0]		awid_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [4:0]		awid_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [9:0]		awid_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [9:0]		awid_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [9:0]		awid_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
logic [7:0]		awlen_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [3:0]		awlen_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [3:0]		awlen_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [7:0]		awlen_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [3:0]		awlen_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [7:0]		awlen_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [7:0]		awlen_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [7:0]		awlen_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [1:0]		awlock_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [1:0]		awlock_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [1:0]		awlock_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [2:0]		awprot_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [2:0]		awprot_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [2:0]		awprot_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [2:0]		awprot_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			awready_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire			awready_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire			awready_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire			awready_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			awready_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic			awready_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			awready_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic			awready_s_pmmbi;	// From u_pmmbi_top of pmmbi_top.v
logic [2:0]		awsize_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [2:0]		awsize_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [2:0]		awsize_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [2:0]		awsize_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [2:0]		awsize_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [2:0]		awsize_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [2:0]		awsize_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [2:0]		awsize_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [7:0]		awuser_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [109:0]		awuser_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
logic			awvalid_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire			awvalid_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			awvalid_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire			awvalid_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire			awvalid_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			awvalid_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire			awvalid_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire			awvalid_s_pmmbi;	// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [9:0]		bid_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire [9:0]		bid_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire [9:0]		bid_pcie_ep0_m;		// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire [9:0]		bid_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [4:0]		bid_pcie_ep0_s;		// From pcie_ep0 of PCIE_IP.v
logic [9:0]		bid_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic [9:0]		bid_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic [9:0]		bid_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
logic			bready_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire			bready_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			bready_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire			bready_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire			bready_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			bready_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire			bready_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire			bready_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [1:0]		bresp_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire [1:0]		bresp_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire [1:0]		bresp_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire [1:0]		bresp_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [1:0]		bresp_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic [1:0]		bresp_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic [1:0]		bresp_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic [1:0]		bresp_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire [7:0]		buser_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			bvalid_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire			bvalid_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire			bvalid_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire			bvalid_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			bvalid_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic			bvalid_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			bvalid_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic			bvalid_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire [31:0]		paddr;			// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			penable;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [2:0]		pprot;			// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
logic [31:0]		prdata_h2bm;		// From u_h2bm_top of h2bm_top.v
logic [31:0]		prdata_mvdm;		// From u_mvdm_top of mvdm_top.v
logic [31:0]		prdata_pbmc;		// From u_pbmc_top of pbmc_top.v
wire [31:0]		prdata_pcie_ep0;	// From pcie_ep0 of PCIE_IP.v
wire [31:0]		prdata_pcie_ep_top_reg;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
logic [31:0]		prdata_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
logic			pready_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			pready_mvdm;		// From u_mvdm_top of mvdm_top.v
logic			pready_pbmc;		// From u_pbmc_top of pbmc_top.v
wire			pready_pcie_ep0;	// From pcie_ep0 of PCIE_IP.v
wire			pready_pcie_ep_top_reg;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
logic			pready_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire			psel_h2bm;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			psel_mvdm;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			psel_pbmc;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			psel_pcie_ep0;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			psel_pcie_ep_top_reg;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			psel_pmmbi;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			psel_reserved;		// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
logic			pslverr_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			pslverr_mvdm;		// From u_mvdm_top of mvdm_top.v
logic			pslverr_pbmc;		// From u_pbmc_top of pbmc_top.v
wire			pslverr_pcie_ep0;	// From pcie_ep0 of PCIE_IP.v
wire			pslverr_pcie_ep_top_reg;// From reg_pcie_ep_top of reg_pcie_ep_top.v
logic			pslverr_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire [3:0]		pstrb;			// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [31:0]		pwdata;			// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			pwrite;			// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [127:0]		rdata_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire [127:0]		rdata_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire [127:0]		rdata_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire [127:0]		rdata_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [127:0]		rdata_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic [127:0]		rdata_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic [127:0]		rdata_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic [127:0]		rdata_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire [31:0]		reg_ep0_link_counter;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
wire			reg_ep0_link_en;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
wire			reg_ep0_perst_skip;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
wire [11:0]		reg_ep0_rstn_ctrl;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
wire			reg_ep0_sw_rst;		// From reg_pcie_ep_top of reg_pcie_ep_top.v
wire [11:0]		reg_rc0_rstn_ctrl;	// From reg_pcie_ep_top of reg_pcie_ep_top.v
wire [9:0]		rid_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire [9:0]		rid_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire [9:0]		rid_pcie_ep0_m;		// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire [9:0]		rid_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [4:0]		rid_pcie_ep0_s;		// From pcie_ep0 of PCIE_IP.v
logic [9:0]		rid_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic [9:0]		rid_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic [9:0]		rid_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire			rlast_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire			rlast_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire			rlast_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire			rlast_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			rlast_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic			rlast_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			rlast_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic			rlast_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
logic			rready_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire			rready_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			rready_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire			rready_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire			rready_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			rready_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire			rready_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire			rready_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [1:0]		rresp_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire [1:0]		rresp_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire [1:0]		rresp_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire [1:0]		rresp_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [1:0]		rresp_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic [1:0]		rresp_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic [1:0]		rresp_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic [1:0]		rresp_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire [7:0]		ruser_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			rvalid_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire			rvalid_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire			rvalid_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire			rvalid_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			rvalid_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic			rvalid_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			rvalid_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic			rvalid_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
wire [39:0]		s_araddr_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [1:0]		s_arburst_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [3:0]		s_arcache_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [9:0]		s_arid_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [7:0]		s_arlen_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [1:0]		s_arlock_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [2:0]		s_arprot_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_arready_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [2:0]		s_arsize_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_arvalid_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [39:0]		s_awaddr_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [1:0]		s_awburst_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [3:0]		s_awcache_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [9:0]		s_awid_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [7:0]		s_awlen_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [1:0]		s_awlock_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [2:0]		s_awprot_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_awready_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [2:0]		s_awsize_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_awvalid_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [9:0]		s_bid_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			s_bready_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [1:0]		s_bresp_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			s_bvalid_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [127:0]		s_rdata_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [9:0]		s_rid_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			s_rlast_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			s_rready_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire [1:0]		s_rresp_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire			s_rvalid_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [127:0]		s_wdata_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_wlast_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_wready_pcie_ep_x2p;	// From u_pcie_ep_DW_axi_x2p of pcie_ep_DW_axi_x2p.v
wire [15:0]		s_wstrb_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
wire			s_wvalid_pcie_ep_x2p;	// From u_ms_axi_async_slave_apb of ms_axi_async_slave_slice.v
logic [127:0]		wdata_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [127:0]		wdata_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [127:0]		wdata_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [127:0]		wdata_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [127:0]		wdata_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [127:0]		wdata_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [127:0]		wdata_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [127:0]		wdata_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [9:0]		wid_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [4:0]		wid_pcie_ep0_m;		// From pcie_ep0 of PCIE_IP.v
wire [4:0]		wid_pcie_ep0_s;		// From axi3_id_converter of axi3_id_converter.v
logic			wlast_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire			wlast_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			wlast_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire			wlast_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire			wlast_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			wlast_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire			wlast_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire			wlast_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire			wready_m_mvdm;		// From u_ms_axi_async_master_mvdm of ms_axi_async_master.v
wire			wready_pcie_ep0_idc;	// From axi3_id_converter of axi3_id_converter.v
wire			wready_pcie_ep0_m;	// From u_ms_axi_async_master_pcie_ep0 of ms_axi_async_master.v
wire			wready_pcie_ep0_ms;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			wready_pcie_ep0_s;	// From pcie_ep0 of PCIE_IP.v
logic			wready_s_h2bm;		// From u_h2bm_top of h2bm_top.v
logic			wready_s_pbmc;		// From u_pbmc_top of pbmc_top.v
logic			wready_s_pmmbi;		// From u_pmmbi_top of pmmbi_top.v
logic [15:0]		wstrb_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire [15:0]		wstrb_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire [15:0]		wstrb_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire [15:0]		wstrb_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire [(128)/8-1:0]	wstrb_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire [15:0]		wstrb_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire [15:0]		wstrb_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire [15:0]		wstrb_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
wire [7:0]		wuser_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
logic			wvalid_m_mvdm;		// From u_mvdm_top of mvdm_top.v
wire			wvalid_pcie_ep0_idc;	// From u_nic400_axi4_to_axi3 of nic400_axi4_to_axi3.v
wire			wvalid_pcie_ep0_m;	// From pcie_ep0 of PCIE_IP.v
wire			wvalid_pcie_ep0_ms;	// From u_ms_axi_async_slave_pcie_ep0 of ms_axi_async_slave_slice.v
wire			wvalid_pcie_ep0_s;	// From axi3_id_converter of axi3_id_converter.v
wire			wvalid_s_h2bm;		// From u_ms_axi_async_slave_h2bm of ms_axi_async_slave_slice.v
wire			wvalid_s_pbmc;		// From u_ms_axi_async_slave_pbmc of ms_axi_async_slave_slice.v
wire			wvalid_s_pmmbi;		// From u_ms_axi_async_slave_pmmbi of ms_axi_async_slave_slice.v
// End of automatics

    /*reg_pcie_ep_top  AUTO_TEMPLATE(
      .apb_\(.*\)_out (\1_pcie_ep_top_reg[]),
      .apb_psel       (psel_pcie_ep_top_reg),
      .apb_\(.*\)     (\1[]),
      .pclk           (pclk),
      .rstn           (presetn),);
    */
reg_pcie_ep_top reg_pcie_ep_top (/*AUTOINST*/
				 // Outputs
				 .apb_prdata_out	(prdata_pcie_ep_top_reg[31:0]), // Templated
				 .apb_pready_out	(pready_pcie_ep_top_reg), // Templated
				 .apb_pslverr_out	(pslverr_pcie_ep_top_reg), // Templated
				 .reg_ep0_link_en	(reg_ep0_link_en),
				 .reg_ep0_link_counter	(reg_ep0_link_counter[31:0]),
				 .reg_ep0_sw_rst	(reg_ep0_sw_rst),
				 .reg_ep0_rstn_ctrl	(reg_ep0_rstn_ctrl[11:0]),
				 .reg_ep0_perst_skip	(reg_ep0_perst_skip),
				 .reg_rc0_rstn_ctrl	(reg_rc0_rstn_ctrl[11:0]),
				 // Inputs
				 .apb_paddr		(paddr[11:0]),	 // Templated
				 .apb_psel		(psel_pcie_ep_top_reg), // Templated
				 .apb_penable		(penable),	 // Templated
				 .apb_pwrite		(pwrite),	 // Templated
				 .apb_pwdata		(pwdata[31:0]),	 // Templated
				 .apb_pprot		(pprot[2:0]),	 // Templated
				 .apb_pstrb		(pstrb[3:0]),	 // Templated
				 .pclk			(pclk),		 // Templated
				 .rstn			(presetn));	 // Templated


    /* ms_axi_async_slave_slice AUTO_TEMPLATE(
      .aclk_s(aclk),
      .aresetn_s(aresetn),
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .wid_s(),
      .\(.*\)_s(s_\1_pcie_ep_x2p[]),
      .\(.*fifo.*side.*\)_o(pcie_ep_x2p_\1_i[]),
      .\(.*fifo.*side.*\)_i(pcie_ep_x2p_\1_o[]),);
    */
    ms_axi_async_slave_slice #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_slave_apb (  /*AUTOINST*/
				  // Outputs
				  .ar_fifo_rd_side_pop_addr_g_o(pcie_ep_x2p_ar_fifo_rd_side_pop_addr_g_i[3:0]), // Templated
				  .ar_fifo_rd_side_rd_addr_o(pcie_ep_x2p_ar_fifo_rd_side_rd_addr_i[2:0]), // Templated
				  .arburst_s		(s_arburst_pcie_ep_x2p[1:0]), // Templated
				  .arcache_s		(s_arcache_pcie_ep_x2p[3:0]), // Templated
				  .arid_s		(s_arid_pcie_ep_x2p[9:0]), // Templated
				  .arlen_s		(s_arlen_pcie_ep_x2p[7:0]), // Templated
				  .arlock_s		(s_arlock_pcie_ep_x2p[1:0]), // Templated
				  .arprot_s		(s_arprot_pcie_ep_x2p[2:0]), // Templated
				  .arsize_s		(s_arsize_pcie_ep_x2p[2:0]), // Templated
				  .aruser_s		(),		 // Templated
				  .arvalid_s		(s_arvalid_pcie_ep_x2p), // Templated
				  .aw_fifo_rd_side_pop_addr_g_o(pcie_ep_x2p_aw_fifo_rd_side_pop_addr_g_i[3:0]), // Templated
				  .aw_fifo_rd_side_rd_addr_o(pcie_ep_x2p_aw_fifo_rd_side_rd_addr_i[2:0]), // Templated
				  .awburst_s		(s_awburst_pcie_ep_x2p[1:0]), // Templated
				  .awcache_s		(s_awcache_pcie_ep_x2p[3:0]), // Templated
				  .awid_s		(s_awid_pcie_ep_x2p[9:0]), // Templated
				  .awlen_s		(s_awlen_pcie_ep_x2p[7:0]), // Templated
				  .awlock_s		(s_awlock_pcie_ep_x2p[1:0]), // Templated
				  .awprot_s		(s_awprot_pcie_ep_x2p[2:0]), // Templated
				  .awsize_s		(s_awsize_pcie_ep_x2p[2:0]), // Templated
				  .awuser_s		(),		 // Templated
				  .awvalid_s		(s_awvalid_pcie_ep_x2p), // Templated
				  .b_fifo_wr_side_data_out_o(pcie_ep_x2p_b_fifo_wr_side_data_out_i[15:0]), // Templated
				  .b_fifo_wr_side_push_addr_g_o(pcie_ep_x2p_b_fifo_wr_side_push_addr_g_i[3:0]), // Templated
				  .bready_s		(s_bready_pcie_ep_x2p), // Templated
				  .r_fifo_wr_side_data_out_o(pcie_ep_x2p_r_fifo_wr_side_data_out_i[144:0]), // Templated
				  .r_fifo_wr_side_push_addr_g_o(pcie_ep_x2p_r_fifo_wr_side_push_addr_g_i[3:0]), // Templated
				  .rready_s		(s_rready_pcie_ep_x2p), // Templated
				  .w_fifo_rd_side_pop_addr_g_o(pcie_ep_x2p_w_fifo_rd_side_pop_addr_g_i[3:0]), // Templated
				  .w_fifo_rd_side_rd_addr_o(pcie_ep_x2p_w_fifo_rd_side_rd_addr_i[2:0]), // Templated
				  .wlast_s		(s_wlast_pcie_ep_x2p), // Templated
				  .wstrb_s		(s_wstrb_pcie_ep_x2p[15:0]), // Templated
				  .wuser_s		(),		 // Templated
				  .wvalid_s		(s_wvalid_pcie_ep_x2p), // Templated
				  .wdata_s		(s_wdata_pcie_ep_x2p[127:0]), // Templated
				  .wid_s		(),		 // Templated
				  .araddr_s		(s_araddr_pcie_ep_x2p[39:0]), // Templated
				  .awaddr_s		(s_awaddr_pcie_ep_x2p[39:0]), // Templated
				  // Inputs
				  .aclk_s		(aclk),		 // Templated
				  .ar_fifo_rd_side_data_out_i(pcie_ep_x2p_ar_fifo_rd_side_data_out_o[75:0]), // Templated
				  .ar_fifo_rd_side_push_addr_g_i(pcie_ep_x2p_ar_fifo_rd_side_push_addr_g_o[3:0]), // Templated
				  .aresetn_s		(aresetn),	 // Templated
				  .arready_s		(s_arready_pcie_ep_x2p), // Templated
				  .aw_fifo_rd_side_data_out_i(pcie_ep_x2p_aw_fifo_rd_side_data_out_o[75:0]), // Templated
				  .aw_fifo_rd_side_push_addr_g_i(pcie_ep_x2p_aw_fifo_rd_side_push_addr_g_o[3:0]), // Templated
				  .awready_s		(s_awready_pcie_ep_x2p), // Templated
				  .b_fifo_wr_side_pop_addr_g_i(pcie_ep_x2p_b_fifo_wr_side_pop_addr_g_o[3:0]), // Templated
				  .b_fifo_wr_side_rd_addr_i(pcie_ep_x2p_b_fifo_wr_side_rd_addr_o[2:0]), // Templated
				  .bid_s		(s_bid_pcie_ep_x2p[9:0]), // Templated
				  .bresp_s		(s_bresp_pcie_ep_x2p[1:0]), // Templated
				  .buser_s		({4{1'b0}}),	 // Templated
				  .bvalid_s		(s_bvalid_pcie_ep_x2p), // Templated
				  .r_fifo_wr_side_pop_addr_g_i(pcie_ep_x2p_r_fifo_wr_side_pop_addr_g_o[3:0]), // Templated
				  .r_fifo_wr_side_rd_addr_i(pcie_ep_x2p_r_fifo_wr_side_rd_addr_o[2:0]), // Templated
				  .rdata_s		(s_rdata_pcie_ep_x2p[127:0]), // Templated
				  .rid_s		(s_rid_pcie_ep_x2p[9:0]), // Templated
				  .rlast_s		(s_rlast_pcie_ep_x2p), // Templated
				  .rresp_s		(s_rresp_pcie_ep_x2p[1:0]), // Templated
				  .ruser_s		({4{1'b0}}),	 // Templated
				  .rvalid_s		(s_rvalid_pcie_ep_x2p), // Templated
				  .w_fifo_rd_side_data_out_i(pcie_ep_x2p_w_fifo_rd_side_data_out_o[158:0]), // Templated
				  .w_fifo_rd_side_push_addr_g_i(pcie_ep_x2p_w_fifo_rd_side_push_addr_g_o[3:0]), // Templated
				  .wready_s		(s_wready_pcie_ep_x2p)); // Templated


//psel0  : 0x1C00_0000 - 0x1C00_FFFF
//psel1  : 0x1C01_0000 - 0x1C01_0FFF
//psel2  : 0x1C01_1000 - 0x1C01_1FFF
//psel3  : 0x1C01_2000 - 0x1C01_2FFF
//psel4  : 0x1C01_3000 - 0x1C01_3FFF
//psel5  : 0x1C01_4000 - 0x1C01_4FFF
//psel6  : 0x1C10_0000 - 0x1C1F_FFFF

    /* pcie_ep_DW_axi_x2p AUTO_TEMPLATE (
      .prdata_s0       (prdata_pcie_ep_top_reg[31:0]),
      .prdata_s1       (prdata_mvdm[31:0]),
      .prdata_s2       (prdata_pbmc[31:0]),
      .prdata_s3       (prdata_pmmbi[31:0]),
      .prdata_s4       (prdata_h2bm[31:0]),
      .prdata_s5       (),
      .prdata_s6       (prdata_pcie_ep0[31:0]),
      .pready_s5       (1'b1),
      .pslverr_s5      (1'b0),
      .\(.*\)_s0       (\1_pcie_ep_top_reg[]),
      .\(.*\)_s1       (\1_mvdm[]),
      .\(.*\)_s2       (\1_pbmc[]),
      .\(.*\)_s3       (\1_pmmbi[]),
      .\(.*\)_s4       (\1_h2bm[]),
      .\(.*\)_s5       (\1_reserved[]),
      .\(.*\)_s6       (\1_pcie_ep0[]),
      .aclk            (aclk),
      .aresetn         (aresetn),
      .pclk            (pclk),
      .presetn         (presetn),
      .paddr           (paddr[31:0]),
      .pwdata          (pwdata[31:0]),
      .pstrb           (pstrb[3:0]),
      .p\(.*\)         (p\1[]),
      .\(.*\)bid       (s_\1bid_pcie_ep_x2p[9:0]),
      .\(.*\)rid       (s_\1rid_pcie_ep_x2p[9:0]),
      .\(.*\)arid      (s_\1arid_pcie_ep_x2p[9:0]),
      .\(.*\)awid      (s_\1awid_pcie_ep_x2p[9:0]),
      .\(.*\)data      (s_\1data_pcie_ep_x2p[127:0]),
      .\(.*\)addr      (s_\1addr_pcie_ep_x2p[39:0]),
      .\(.*\)strb      (s_\1strb_pcie_ep_x2p[15:0]),
      .\(.*\)len       (s_\1len_pcie_ep_x2p),
      .\(.*\)lock      (s_\1lock_pcie_ep_x2p[0]),
      .\(.*\)          (s_\1_pcie_ep_x2p[]),);
    */
pcie_ep_DW_axi_x2p u_pcie_ep_DW_axi_x2p (/*AUTOINST*/
					 // Outputs
					 .arready		(s_arready_pcie_ep_x2p), // Templated
					 .awready		(s_awready_pcie_ep_x2p), // Templated
					 .bid			(s_bid_pcie_ep_x2p[9:0]), // Templated
					 .bresp			(s_bresp_pcie_ep_x2p[1:0]), // Templated
					 .bvalid		(s_bvalid_pcie_ep_x2p), // Templated
					 .rdata			(s_rdata_pcie_ep_x2p[127:0]), // Templated
					 .rid			(s_rid_pcie_ep_x2p[9:0]), // Templated
					 .rlast			(s_rlast_pcie_ep_x2p), // Templated
					 .rresp			(s_rresp_pcie_ep_x2p[1:0]), // Templated
					 .rvalid		(s_rvalid_pcie_ep_x2p), // Templated
					 .wready		(s_wready_pcie_ep_x2p), // Templated
					 .paddr			(paddr[31:0]),	 // Templated
					 .penable		(penable),	 // Templated
					 .psel_s0		(psel_pcie_ep_top_reg), // Templated
					 .psel_s1		(psel_mvdm),	 // Templated
					 .psel_s2		(psel_pbmc),	 // Templated
					 .psel_s3		(psel_pmmbi),	 // Templated
					 .psel_s4		(psel_h2bm),	 // Templated
					 .psel_s5		(psel_reserved), // Templated
					 .psel_s6		(psel_pcie_ep0), // Templated
					 .pwdata		(pwdata[31:0]),	 // Templated
					 .pwrite		(pwrite),	 // Templated
					 .pstrb			(pstrb[3:0]),	 // Templated
					 .pprot			(pprot[2:0]),	 // Templated
					 // Inputs
					 .aclk			(aclk),		 // Templated
					 .aresetn		(aresetn),	 // Templated
					 .araddr		(s_araddr_pcie_ep_x2p[39:0]), // Templated
					 .awaddr		(s_awaddr_pcie_ep_x2p[39:0]), // Templated
					 .arburst		(s_arburst_pcie_ep_x2p[1:0]), // Templated
					 .arid			(s_arid_pcie_ep_x2p[9:0]), // Templated
					 .arlen			(s_arlen_pcie_ep_x2p), // Templated
					 .arsize		(s_arsize_pcie_ep_x2p[2:0]), // Templated
					 .arvalid		(s_arvalid_pcie_ep_x2p), // Templated
					 .awburst		(s_awburst_pcie_ep_x2p[1:0]), // Templated
					 .awid			(s_awid_pcie_ep_x2p[9:0]), // Templated
					 .awlen			(s_awlen_pcie_ep_x2p), // Templated
					 .arprot		(s_arprot_pcie_ep_x2p[2:0]), // Templated
					 .arcache		(s_arcache_pcie_ep_x2p[3:0]), // Templated
					 .arlock		(s_arlock_pcie_ep_x2p[0]), // Templated
					 .awcache		(s_awcache_pcie_ep_x2p[3:0]), // Templated
					 .awlock		(s_awlock_pcie_ep_x2p[0]), // Templated
					 .awprot		(s_awprot_pcie_ep_x2p[2:0]), // Templated
					 .awsize		(s_awsize_pcie_ep_x2p[2:0]), // Templated
					 .awvalid		(s_awvalid_pcie_ep_x2p), // Templated
					 .bready		(s_bready_pcie_ep_x2p), // Templated
					 .rready		(s_rready_pcie_ep_x2p), // Templated
					 .wdata			(s_wdata_pcie_ep_x2p[127:0]), // Templated
					 .wlast			(s_wlast_pcie_ep_x2p), // Templated
					 .wstrb			(s_wstrb_pcie_ep_x2p[15:0]), // Templated
					 .wvalid		(s_wvalid_pcie_ep_x2p), // Templated
					 .pclk			(pclk),		 // Templated
					 .presetn		(presetn),	 // Templated
					 .prdata_s0		(prdata_pcie_ep_top_reg[31:0]), // Templated
					 .prdata_s1		(prdata_mvdm[31:0]), // Templated
					 .prdata_s2		(prdata_pbmc[31:0]), // Templated
					 .prdata_s3		(prdata_pmmbi[31:0]), // Templated
					 .prdata_s4		(prdata_h2bm[31:0]), // Templated
					 .prdata_s5		(),		 // Templated
					 .prdata_s6		(prdata_pcie_ep0[31:0]), // Templated
					 .pready_s0		(pready_pcie_ep_top_reg), // Templated
					 .pready_s1		(pready_mvdm),	 // Templated
					 .pready_s2		(pready_pbmc),	 // Templated
					 .pready_s3		(pready_pmmbi),	 // Templated
					 .pready_s4		(pready_h2bm),	 // Templated
					 .pready_s5		(1'b1),		 // Templated
					 .pready_s6		(pready_pcie_ep0), // Templated
					 .pslverr_s0		(pslverr_pcie_ep_top_reg), // Templated
					 .pslverr_s1		(pslverr_mvdm),	 // Templated
					 .pslverr_s2		(pslverr_pbmc),	 // Templated
					 .pslverr_s3		(pslverr_pmmbi), // Templated
					 .pslverr_s4		(pslverr_h2bm),	 // Templated
					 .pslverr_s5		(1'b0),		 // Templated
					 .pslverr_s6		(pslverr_pcie_ep0)); // Templated


    /* ms_axi_async_master AUTO_TEMPLATE(
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .awlen_m  ({4'b0,awlen_pcie_ep0_m[3:0]}), 
      .arlen_m  ({4'b0,arlen_pcie_ep0_m[3:0]}), 
      .awaddr_m ({8'b0,awaddr_pcie_ep0_m[31:0]}), 
      .araddr_m ({8'b0,araddr_pcie_ep0_m[31:0]}),
      .wid_m({5'b0,wid_pcie_ep0_m[4:0]}),
      .awid_m({5'b0,awid_pcie_ep0_m[4:0]}),
      .arid_m({5'b0,arid_pcie_ep0_m[4:0]}),
      .\(.*\)_m(\1_pcie_ep0_m[]),
      .aclk_m(aclk),
      .aresetn_m(aresetn),
      .\(.*fifo.*side.*\)(pcie_ep0_m_\1[]),);
    */
    ms_axi_async_master #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_master_pcie_ep0 (  /*AUTOINST*/
					// Outputs
					.awready_m	(awready_pcie_ep0_m), // Templated
					.wready_m	(wready_pcie_ep0_m), // Templated
					.bvalid_m	(bvalid_pcie_ep0_m), // Templated
					.bid_m		(bid_pcie_ep0_m[9:0]), // Templated
					.bresp_m	(bresp_pcie_ep0_m[1:0]), // Templated
					.buser_m	(),		 // Templated
					.arready_m	(arready_pcie_ep0_m), // Templated
					.rvalid_m	(rvalid_pcie_ep0_m), // Templated
					.rid_m		(rid_pcie_ep0_m[9:0]), // Templated
					.rdata_m	(rdata_pcie_ep0_m[127:0]), // Templated
					.rlast_m	(rlast_pcie_ep0_m), // Templated
					.rresp_m	(rresp_pcie_ep0_m[1:0]), // Templated
					.ruser_m	(),		 // Templated
					.ar_fifo_wr_side_push_addr_g_o(pcie_ep0_m_ar_fifo_wr_side_push_addr_g_o[3:0]), // Templated
					.ar_fifo_wr_side_data_out_o(pcie_ep0_m_ar_fifo_wr_side_data_out_o[75:0]), // Templated
					.r_fifo_rd_side_pop_addr_g_o(pcie_ep0_m_r_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
					.r_fifo_rd_side_rd_addr_o(pcie_ep0_m_r_fifo_rd_side_rd_addr_o[2:0]), // Templated
					.aw_fifo_wr_side_push_addr_g_o(pcie_ep0_m_aw_fifo_wr_side_push_addr_g_o[3:0]), // Templated
					.aw_fifo_wr_side_data_out_o(pcie_ep0_m_aw_fifo_wr_side_data_out_o[75:0]), // Templated
					.w_fifo_wr_side_push_addr_g_o(pcie_ep0_m_w_fifo_wr_side_push_addr_g_o[3:0]), // Templated
					.w_fifo_wr_side_data_out_o(pcie_ep0_m_w_fifo_wr_side_data_out_o[158:0]), // Templated
					.b_fifo_rd_side_pop_addr_g_o(pcie_ep0_m_b_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
					.b_fifo_rd_side_rd_addr_o(pcie_ep0_m_b_fifo_rd_side_rd_addr_o[2:0]), // Templated
					// Inputs
					.aclk_m		(aclk),		 // Templated
					.aresetn_m	(aresetn),	 // Templated
					.awvalid_m	(awvalid_pcie_ep0_m), // Templated
					.awaddr_m	({8'b0,awaddr_pcie_ep0_m[31:0]}), // Templated
					.awid_m		({5'b0,awid_pcie_ep0_m[4:0]}), // Templated
					.awlen_m	({4'b0,awlen_pcie_ep0_m[3:0]}), // Templated
					.awsize_m	(awsize_pcie_ep0_m[2:0]), // Templated
					.awburst_m	(awburst_pcie_ep0_m[1:0]), // Templated
					.awlock_m	(awlock_pcie_ep0_m[1:0]), // Templated
					.awcache_m	(awcache_pcie_ep0_m[3:0]), // Templated
					.awprot_m	(awprot_pcie_ep0_m[2:0]), // Templated
					.awuser_m	({4{1'b0}}),	 // Templated
					.wvalid_m	(wvalid_pcie_ep0_m), // Templated
					.wid_m		({5'b0,wid_pcie_ep0_m[4:0]}), // Templated
					.wdata_m	(wdata_pcie_ep0_m[127:0]), // Templated
					.wstrb_m	(wstrb_pcie_ep0_m[15:0]), // Templated
					.wlast_m	(wlast_pcie_ep0_m), // Templated
					.wuser_m	({4{1'b0}}),	 // Templated
					.bready_m	(bready_pcie_ep0_m), // Templated
					.arvalid_m	(arvalid_pcie_ep0_m), // Templated
					.arid_m		({5'b0,arid_pcie_ep0_m[4:0]}), // Templated
					.araddr_m	({8'b0,araddr_pcie_ep0_m[31:0]}), // Templated
					.arlen_m	({4'b0,arlen_pcie_ep0_m[3:0]}), // Templated
					.arsize_m	(arsize_pcie_ep0_m[2:0]), // Templated
					.arburst_m	(arburst_pcie_ep0_m[1:0]), // Templated
					.arlock_m	(arlock_pcie_ep0_m[1:0]), // Templated
					.arcache_m	(arcache_pcie_ep0_m[3:0]), // Templated
					.arprot_m	(arprot_pcie_ep0_m[2:0]), // Templated
					.aruser_m	({4{1'b0}}),	 // Templated
					.rready_m	(rready_pcie_ep0_m), // Templated
					.ar_fifo_wr_side_pop_addr_g_i(pcie_ep0_m_ar_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
					.ar_fifo_wr_side_rd_addr_i(pcie_ep0_m_ar_fifo_wr_side_rd_addr_i[2:0]), // Templated
					.r_fifo_rd_side_push_addr_g_i(pcie_ep0_m_r_fifo_rd_side_push_addr_g_i[3:0]), // Templated
					.r_fifo_rd_side_data_out_i(pcie_ep0_m_r_fifo_rd_side_data_out_i[144:0]), // Templated
					.aw_fifo_wr_side_pop_addr_g_i(pcie_ep0_m_aw_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
					.aw_fifo_wr_side_rd_addr_i(pcie_ep0_m_aw_fifo_wr_side_rd_addr_i[2:0]), // Templated
					.w_fifo_wr_side_pop_addr_g_i(pcie_ep0_m_w_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
					.w_fifo_wr_side_rd_addr_i(pcie_ep0_m_w_fifo_wr_side_rd_addr_i[2:0]), // Templated
					.b_fifo_rd_side_push_addr_g_i(pcie_ep0_m_b_fifo_rd_side_push_addr_g_i[3:0]), // Templated
					.b_fifo_rd_side_data_out_i(pcie_ep0_m_b_fifo_rd_side_data_out_i[15:0])); // Templated


    /* ms_axi_async_slave_slice AUTO_TEMPLATE(
      .aclk_s(aclk),
      .aresetn_s(aresetn),
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .wid_s(),
      .awlock_s(),
      .arlock_s(),
      .\(.*\)_s(\1_pcie_ep0_ms[]),
      .\(.*fifo.*side.*\)_o(pcie_ep0_s_\1_i[]),
      .\(.*fifo.*side.*\)_i(pcie_ep0_s_\1_o[]),);
    */
    ms_axi_async_slave_slice #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_slave_pcie_ep0 (  /*AUTOINST*/
				       // Outputs
				       .ar_fifo_rd_side_pop_addr_g_o(pcie_ep0_s_ar_fifo_rd_side_pop_addr_g_i[3:0]), // Templated
				       .ar_fifo_rd_side_rd_addr_o(pcie_ep0_s_ar_fifo_rd_side_rd_addr_i[2:0]), // Templated
				       .arburst_s	(arburst_pcie_ep0_ms[1:0]), // Templated
				       .arcache_s	(arcache_pcie_ep0_ms[3:0]), // Templated
				       .arid_s		(arid_pcie_ep0_ms[9:0]), // Templated
				       .arlen_s		(arlen_pcie_ep0_ms[7:0]), // Templated
				       .arlock_s	(),		 // Templated
				       .arprot_s	(arprot_pcie_ep0_ms[2:0]), // Templated
				       .arsize_s	(arsize_pcie_ep0_ms[2:0]), // Templated
				       .aruser_s	(),		 // Templated
				       .arvalid_s	(arvalid_pcie_ep0_ms), // Templated
				       .aw_fifo_rd_side_pop_addr_g_o(pcie_ep0_s_aw_fifo_rd_side_pop_addr_g_i[3:0]), // Templated
				       .aw_fifo_rd_side_rd_addr_o(pcie_ep0_s_aw_fifo_rd_side_rd_addr_i[2:0]), // Templated
				       .awburst_s	(awburst_pcie_ep0_ms[1:0]), // Templated
				       .awcache_s	(awcache_pcie_ep0_ms[3:0]), // Templated
				       .awid_s		(awid_pcie_ep0_ms[9:0]), // Templated
				       .awlen_s		(awlen_pcie_ep0_ms[7:0]), // Templated
				       .awlock_s	(),		 // Templated
				       .awprot_s	(awprot_pcie_ep0_ms[2:0]), // Templated
				       .awsize_s	(awsize_pcie_ep0_ms[2:0]), // Templated
				       .awuser_s	(),		 // Templated
				       .awvalid_s	(awvalid_pcie_ep0_ms), // Templated
				       .b_fifo_wr_side_data_out_o(pcie_ep0_s_b_fifo_wr_side_data_out_i[15:0]), // Templated
				       .b_fifo_wr_side_push_addr_g_o(pcie_ep0_s_b_fifo_wr_side_push_addr_g_i[3:0]), // Templated
				       .bready_s	(bready_pcie_ep0_ms), // Templated
				       .r_fifo_wr_side_data_out_o(pcie_ep0_s_r_fifo_wr_side_data_out_i[144:0]), // Templated
				       .r_fifo_wr_side_push_addr_g_o(pcie_ep0_s_r_fifo_wr_side_push_addr_g_i[3:0]), // Templated
				       .rready_s	(rready_pcie_ep0_ms), // Templated
				       .w_fifo_rd_side_pop_addr_g_o(pcie_ep0_s_w_fifo_rd_side_pop_addr_g_i[3:0]), // Templated
				       .w_fifo_rd_side_rd_addr_o(pcie_ep0_s_w_fifo_rd_side_rd_addr_i[2:0]), // Templated
				       .wlast_s		(wlast_pcie_ep0_ms), // Templated
				       .wstrb_s		(wstrb_pcie_ep0_ms[15:0]), // Templated
				       .wuser_s		(),		 // Templated
				       .wvalid_s	(wvalid_pcie_ep0_ms), // Templated
				       .wdata_s		(wdata_pcie_ep0_ms[127:0]), // Templated
				       .wid_s		(),		 // Templated
				       .araddr_s	(araddr_pcie_ep0_ms[39:0]), // Templated
				       .awaddr_s	(awaddr_pcie_ep0_ms[39:0]), // Templated
				       // Inputs
				       .aclk_s		(aclk),		 // Templated
				       .ar_fifo_rd_side_data_out_i(pcie_ep0_s_ar_fifo_rd_side_data_out_o[75:0]), // Templated
				       .ar_fifo_rd_side_push_addr_g_i(pcie_ep0_s_ar_fifo_rd_side_push_addr_g_o[3:0]), // Templated
				       .aresetn_s	(aresetn),	 // Templated
				       .arready_s	(arready_pcie_ep0_ms), // Templated
				       .aw_fifo_rd_side_data_out_i(pcie_ep0_s_aw_fifo_rd_side_data_out_o[75:0]), // Templated
				       .aw_fifo_rd_side_push_addr_g_i(pcie_ep0_s_aw_fifo_rd_side_push_addr_g_o[3:0]), // Templated
				       .awready_s	(awready_pcie_ep0_ms), // Templated
				       .b_fifo_wr_side_pop_addr_g_i(pcie_ep0_s_b_fifo_wr_side_pop_addr_g_o[3:0]), // Templated
				       .b_fifo_wr_side_rd_addr_i(pcie_ep0_s_b_fifo_wr_side_rd_addr_o[2:0]), // Templated
				       .bid_s		(bid_pcie_ep0_ms[9:0]), // Templated
				       .bresp_s		(bresp_pcie_ep0_ms[1:0]), // Templated
				       .buser_s		({4{1'b0}}),	 // Templated
				       .bvalid_s	(bvalid_pcie_ep0_ms), // Templated
				       .r_fifo_wr_side_pop_addr_g_i(pcie_ep0_s_r_fifo_wr_side_pop_addr_g_o[3:0]), // Templated
				       .r_fifo_wr_side_rd_addr_i(pcie_ep0_s_r_fifo_wr_side_rd_addr_o[2:0]), // Templated
				       .rdata_s		(rdata_pcie_ep0_ms[127:0]), // Templated
				       .rid_s		(rid_pcie_ep0_ms[9:0]), // Templated
				       .rlast_s		(rlast_pcie_ep0_ms), // Templated
				       .rresp_s		(rresp_pcie_ep0_ms[1:0]), // Templated
				       .ruser_s		({4{1'b0}}),	 // Templated
				       .rvalid_s	(rvalid_pcie_ep0_ms), // Templated
				       .w_fifo_rd_side_data_out_i(pcie_ep0_s_w_fifo_rd_side_data_out_o[158:0]), // Templated
				       .w_fifo_rd_side_push_addr_g_i(pcie_ep0_s_w_fifo_rd_side_push_addr_g_o[3:0]), // Templated
				       .wready_s	(wready_pcie_ep0_ms)); // Templated


    /* nic400_axi4_to_axi3 AUTO_TEMPLATE(
       .clk0clk(aclk),
       .clk0resetn(aresetn),
       .\(.*\)_slave_if0_m_s(\1_pcie_ep0_ms[]),
       .\(.*\)_slave_if0_m(\1_pcie_ep0_idc[]),
       .buser_slave_if0_m	(8'b0), 
       .ruser_slave_if0_m	(8'b0),
       .awuser_slave_if0_m_s	(8'b0),
       .wuser_slave_if0_m_s	(8'b0), 
       .aruser_slave_if0_m_s	(8'b0),
       .awlock_slave_if0_m	(awlock_pcie_ep0_idc[]), 
       .arlock_slave_if0_m	(arlock_pcie_ep0_idc[]), 
       .bid_slave_if0_m	(bid_pcie_ep0_idc[9:0]),
       .rid_slave_if0_m	(rid_pcie_ep0_idc[9:0]),);
    */
nic400_axi4_to_axi3 u_nic400_axi4_to_axi3(/*AUTOINST*/
					  // Outputs
					  .awid_slave_if0_m	(awid_pcie_ep0_idc[9:0]), // Templated
					  .awaddr_slave_if0_m	(awaddr_pcie_ep0_idc[39:0]), // Templated
					  .awlen_slave_if0_m	(awlen_pcie_ep0_idc[3:0]), // Templated
					  .awsize_slave_if0_m	(awsize_pcie_ep0_idc[2:0]), // Templated
					  .awburst_slave_if0_m	(awburst_pcie_ep0_idc[1:0]), // Templated
					  .awlock_slave_if0_m	(awlock_pcie_ep0_idc[1:0]), // Templated
					  .awcache_slave_if0_m	(awcache_pcie_ep0_idc[3:0]), // Templated
					  .awprot_slave_if0_m	(awprot_pcie_ep0_idc[2:0]), // Templated
					  .awvalid_slave_if0_m	(awvalid_pcie_ep0_idc), // Templated
					  .wid_slave_if0_m	(wid_pcie_ep0_idc[9:0]), // Templated
					  .wdata_slave_if0_m	(wdata_pcie_ep0_idc[127:0]), // Templated
					  .wstrb_slave_if0_m	(wstrb_pcie_ep0_idc[15:0]), // Templated
					  .wlast_slave_if0_m	(wlast_pcie_ep0_idc), // Templated
					  .wvalid_slave_if0_m	(wvalid_pcie_ep0_idc), // Templated
					  .bready_slave_if0_m	(bready_pcie_ep0_idc), // Templated
					  .arid_slave_if0_m	(arid_pcie_ep0_idc[9:0]), // Templated
					  .araddr_slave_if0_m	(araddr_pcie_ep0_idc[39:0]), // Templated
					  .arlen_slave_if0_m	(arlen_pcie_ep0_idc[3:0]), // Templated
					  .arsize_slave_if0_m	(arsize_pcie_ep0_idc[2:0]), // Templated
					  .arburst_slave_if0_m	(arburst_pcie_ep0_idc[1:0]), // Templated
					  .arlock_slave_if0_m	(arlock_pcie_ep0_idc[1:0]), // Templated
					  .arcache_slave_if0_m	(arcache_pcie_ep0_idc[3:0]), // Templated
					  .arprot_slave_if0_m	(arprot_pcie_ep0_idc[2:0]), // Templated
					  .arvalid_slave_if0_m	(arvalid_pcie_ep0_idc), // Templated
					  .rready_slave_if0_m	(rready_pcie_ep0_idc), // Templated
					  .awuser_slave_if0_m	(awuser_pcie_ep0_idc[7:0]), // Templated
					  .wuser_slave_if0_m	(wuser_pcie_ep0_idc[7:0]), // Templated
					  .aruser_slave_if0_m	(aruser_pcie_ep0_idc[7:0]), // Templated
					  .awready_slave_if0_m_s(awready_pcie_ep0_ms), // Templated
					  .wready_slave_if0_m_s	(wready_pcie_ep0_ms), // Templated
					  .bid_slave_if0_m_s	(bid_pcie_ep0_ms[9:0]), // Templated
					  .bresp_slave_if0_m_s	(bresp_pcie_ep0_ms[1:0]), // Templated
					  .bvalid_slave_if0_m_s	(bvalid_pcie_ep0_ms), // Templated
					  .arready_slave_if0_m_s(arready_pcie_ep0_ms), // Templated
					  .rid_slave_if0_m_s	(rid_pcie_ep0_ms[9:0]), // Templated
					  .rdata_slave_if0_m_s	(rdata_pcie_ep0_ms[127:0]), // Templated
					  .rresp_slave_if0_m_s	(rresp_pcie_ep0_ms[1:0]), // Templated
					  .rlast_slave_if0_m_s	(rlast_pcie_ep0_ms), // Templated
					  .rvalid_slave_if0_m_s	(rvalid_pcie_ep0_ms), // Templated
					  .buser_slave_if0_m_s	(buser_pcie_ep0_ms[7:0]), // Templated
					  .ruser_slave_if0_m_s	(ruser_pcie_ep0_ms[7:0]), // Templated
					  // Inputs
					  .awready_slave_if0_m	(awready_pcie_ep0_idc), // Templated
					  .wready_slave_if0_m	(wready_pcie_ep0_idc), // Templated
					  .bid_slave_if0_m	(bid_pcie_ep0_idc[9:0]), // Templated
					  .bresp_slave_if0_m	(bresp_pcie_ep0_idc[1:0]), // Templated
					  .bvalid_slave_if0_m	(bvalid_pcie_ep0_idc), // Templated
					  .arready_slave_if0_m	(arready_pcie_ep0_idc), // Templated
					  .rid_slave_if0_m	(rid_pcie_ep0_idc[9:0]), // Templated
					  .rdata_slave_if0_m	(rdata_pcie_ep0_idc[127:0]), // Templated
					  .rresp_slave_if0_m	(rresp_pcie_ep0_idc[1:0]), // Templated
					  .rlast_slave_if0_m	(rlast_pcie_ep0_idc), // Templated
					  .rvalid_slave_if0_m	(rvalid_pcie_ep0_idc), // Templated
					  .buser_slave_if0_m	(8'b0),		 // Templated
					  .ruser_slave_if0_m	(8'b0),		 // Templated
					  .awid_slave_if0_m_s	(awid_pcie_ep0_ms[9:0]), // Templated
					  .awaddr_slave_if0_m_s	(awaddr_pcie_ep0_ms[39:0]), // Templated
					  .awlen_slave_if0_m_s	(awlen_pcie_ep0_ms[7:0]), // Templated
					  .awsize_slave_if0_m_s	(awsize_pcie_ep0_ms[2:0]), // Templated
					  .awburst_slave_if0_m_s(awburst_pcie_ep0_ms[1:0]), // Templated
					  .awlock_slave_if0_m_s	(awlock_pcie_ep0_ms), // Templated
					  .awcache_slave_if0_m_s(awcache_pcie_ep0_ms[3:0]), // Templated
					  .awprot_slave_if0_m_s	(awprot_pcie_ep0_ms[2:0]), // Templated
					  .awvalid_slave_if0_m_s(awvalid_pcie_ep0_ms), // Templated
					  .wdata_slave_if0_m_s	(wdata_pcie_ep0_ms[127:0]), // Templated
					  .wstrb_slave_if0_m_s	(wstrb_pcie_ep0_ms[15:0]), // Templated
					  .wlast_slave_if0_m_s	(wlast_pcie_ep0_ms), // Templated
					  .wvalid_slave_if0_m_s	(wvalid_pcie_ep0_ms), // Templated
					  .bready_slave_if0_m_s	(bready_pcie_ep0_ms), // Templated
					  .arid_slave_if0_m_s	(arid_pcie_ep0_ms[9:0]), // Templated
					  .araddr_slave_if0_m_s	(araddr_pcie_ep0_ms[39:0]), // Templated
					  .arlen_slave_if0_m_s	(arlen_pcie_ep0_ms[7:0]), // Templated
					  .arsize_slave_if0_m_s	(arsize_pcie_ep0_ms[2:0]), // Templated
					  .arburst_slave_if0_m_s(arburst_pcie_ep0_ms[1:0]), // Templated
					  .arlock_slave_if0_m_s	(arlock_pcie_ep0_ms), // Templated
					  .arcache_slave_if0_m_s(arcache_pcie_ep0_ms[3:0]), // Templated
					  .arprot_slave_if0_m_s	(arprot_pcie_ep0_ms[2:0]), // Templated
					  .arvalid_slave_if0_m_s(arvalid_pcie_ep0_ms), // Templated
					  .rready_slave_if0_m_s	(rready_pcie_ep0_ms), // Templated
					  .awuser_slave_if0_m_s	(8'b0),		 // Templated
					  .wuser_slave_if0_m_s	(8'b0),		 // Templated
					  .aruser_slave_if0_m_s	(8'b0),		 // Templated
					  .clk0clk		(aclk),		 // Templated
					  .clk0resetn		(aresetn));	 // Templated


    /* axi3_id_converter AUTO_TEMPLATE(
      .clk0clk(aclk),
      .clk0resetn(aresetn),
      .s_\(.*\)_i(\1_pcie_ep0_idc[]),
      .s_\(.*\)_o(\1_pcie_ep0_idc[]),
      .m_\(.*\)_i(\1_pcie_ep0_s[]),
      .m_\(.*\)_o(\1_pcie_ep0_s[]),
		     .clk		(aclk),
		     .rst_n		(aresetn),
		     .s_arlock_i	({1'b0,arlock_pcie_ep0_idc[0]}),
		     .s_awlock_i	({1'b0,arlock_pcie_ep0_idc[0]}),
		     .single_id_mode_i	(1'b1),
		     .max_rd_outstanding_i(9'b0),
		     .max_wr_outstanding_i(9'b0),);
  */


axi3_id_converter  #(
    .S_ID_W(10),
    .M_ID_W(5),
    .DEPTH(32),
    .SLOT_W(5),        
    .TOT_W(9),        
    .CNT_W(9),        
    .WR_ORDER_FIFO_DEPTH(64),
    .ORDER_AW(6),        
    .ID_FIFO_DEPTH(64),       
    .ID_FIFO_AW(6),        
    .DATA_W(128),
    .ADDR_W(40)) 
   axi3_id_converter(/*AUTOINST*/
		     // Outputs
		     .s_awready_o	(awready_pcie_ep0_idc),	 // Templated
		     .s_wready_o	(wready_pcie_ep0_idc),	 // Templated
		     .s_bid_o		(bid_pcie_ep0_idc[9:0]), // Templated
		     .s_bresp_o		(bresp_pcie_ep0_idc[1:0]), // Templated
		     .s_bvalid_o	(bvalid_pcie_ep0_idc),	 // Templated
		     .s_arready_o	(arready_pcie_ep0_idc),	 // Templated
		     .s_rid_o		(rid_pcie_ep0_idc[9:0]), // Templated
		     .s_rdata_o		(rdata_pcie_ep0_idc[127:0]), // Templated
		     .s_rresp_o		(rresp_pcie_ep0_idc[1:0]), // Templated
		     .s_rlast_o		(rlast_pcie_ep0_idc),	 // Templated
		     .s_rvalid_o	(rvalid_pcie_ep0_idc),	 // Templated
		     .m_awid_o		(awid_pcie_ep0_s[4:0]),	 // Templated
		     .m_awaddr_o	(awaddr_pcie_ep0_s[39:0]), // Templated
		     .m_awlen_o		(awlen_pcie_ep0_s[3:0]), // Templated
		     .m_awsize_o	(awsize_pcie_ep0_s[2:0]), // Templated
		     .m_awburst_o	(awburst_pcie_ep0_s[1:0]), // Templated
		     .m_awlock_o	(awlock_pcie_ep0_s[1:0]), // Templated
		     .m_awcache_o	(awcache_pcie_ep0_s[3:0]), // Templated
		     .m_awprot_o	(awprot_pcie_ep0_s[2:0]), // Templated
		     .m_awvalid_o	(awvalid_pcie_ep0_s),	 // Templated
		     .m_wid_o		(wid_pcie_ep0_s[4:0]),	 // Templated
		     .m_wdata_o		(wdata_pcie_ep0_s[127:0]), // Templated
		     .m_wstrb_o		(wstrb_pcie_ep0_s[(128)/8-1:0]), // Templated
		     .m_wlast_o		(wlast_pcie_ep0_s),	 // Templated
		     .m_wvalid_o	(wvalid_pcie_ep0_s),	 // Templated
		     .m_bready_o	(bready_pcie_ep0_s),	 // Templated
		     .m_arid_o		(arid_pcie_ep0_s[4:0]),	 // Templated
		     .m_araddr_o	(araddr_pcie_ep0_s[39:0]), // Templated
		     .m_arlen_o		(arlen_pcie_ep0_s[3:0]), // Templated
		     .m_arsize_o	(arsize_pcie_ep0_s[2:0]), // Templated
		     .m_arburst_o	(arburst_pcie_ep0_s[1:0]), // Templated
		     .m_arlock_o	(arlock_pcie_ep0_s[1:0]), // Templated
		     .m_arcache_o	(arcache_pcie_ep0_s[3:0]), // Templated
		     .m_arprot_o	(arprot_pcie_ep0_s[2:0]), // Templated
		     .m_arvalid_o	(arvalid_pcie_ep0_s),	 // Templated
		     .m_rready_o	(rready_pcie_ep0_s),	 // Templated
		     // Inputs
		     .clk		(aclk),			 // Templated
		     .rst_n		(aresetn),		 // Templated
		     .single_id_mode_i	(1'b1),			 // Templated
		     .max_rd_outstanding_i(9'b0),		 // Templated
		     .max_wr_outstanding_i(9'b0),		 // Templated
		     .s_awid_i		(awid_pcie_ep0_idc[9:0]), // Templated
		     .s_awaddr_i	(awaddr_pcie_ep0_idc[39:0]), // Templated
		     .s_awlen_i		(awlen_pcie_ep0_idc[3:0]), // Templated
		     .s_awsize_i	(awsize_pcie_ep0_idc[2:0]), // Templated
		     .s_awburst_i	(awburst_pcie_ep0_idc[1:0]), // Templated
		     .s_awlock_i	({1'b0,arlock_pcie_ep0_idc[0]}), // Templated
		     .s_awcache_i	(awcache_pcie_ep0_idc[3:0]), // Templated
		     .s_awprot_i	(awprot_pcie_ep0_idc[2:0]), // Templated
		     .s_awvalid_i	(awvalid_pcie_ep0_idc),	 // Templated
		     .s_wid_i		(wid_pcie_ep0_idc[9:0]), // Templated
		     .s_wdata_i		(wdata_pcie_ep0_idc[127:0]), // Templated
		     .s_wstrb_i		(wstrb_pcie_ep0_idc[(128)/8-1:0]), // Templated
		     .s_wlast_i		(wlast_pcie_ep0_idc),	 // Templated
		     .s_wvalid_i	(wvalid_pcie_ep0_idc),	 // Templated
		     .s_bready_i	(bready_pcie_ep0_idc),	 // Templated
		     .s_arid_i		(arid_pcie_ep0_idc[9:0]), // Templated
		     .s_araddr_i	(araddr_pcie_ep0_idc[39:0]), // Templated
		     .s_arlen_i		(arlen_pcie_ep0_idc[3:0]), // Templated
		     .s_arsize_i	(arsize_pcie_ep0_idc[2:0]), // Templated
		     .s_arburst_i	(arburst_pcie_ep0_idc[1:0]), // Templated
		     .s_arlock_i	({1'b0,arlock_pcie_ep0_idc[0]}), // Templated
		     .s_arcache_i	(arcache_pcie_ep0_idc[3:0]), // Templated
		     .s_arprot_i	(arprot_pcie_ep0_idc[2:0]), // Templated
		     .s_arvalid_i	(arvalid_pcie_ep0_idc),	 // Templated
		     .s_rready_i	(rready_pcie_ep0_idc),	 // Templated
		     .m_awready_i	(awready_pcie_ep0_s),	 // Templated
		     .m_wready_i	(wready_pcie_ep0_s),	 // Templated
		     .m_bid_i		(bid_pcie_ep0_s[4:0]),	 // Templated
		     .m_bresp_i		(bresp_pcie_ep0_s[1:0]), // Templated
		     .m_bvalid_i	(bvalid_pcie_ep0_s),	 // Templated
		     .m_arready_i	(arready_pcie_ep0_s),	 // Templated
		     .m_rid_i		(rid_pcie_ep0_s[4:0]),	 // Templated
		     .m_rdata_i		(rdata_pcie_ep0_s[127:0]), // Templated
		     .m_rresp_i		(rresp_pcie_ep0_s[1:0]), // Templated
		     .m_rlast_i		(rlast_pcie_ep0_s),	 // Templated
		     .m_rvalid_i	(rvalid_pcie_ep0_s));	 // Templated


wire pcie_rstn;

//assign pcie_rstn = reg_pcie_reserve0[9] ? (aresetn & ~reg_pcie_reserve0[8]) : (perstn & ~reg_pcie_reserve0[8] & aresetn);
assign pcie_rstn = (ep0_perstn & ~reg_ep0_sw_rst & aresetn);

wire            LINK_TRAINING_ENABLE;
reg     [31:0]  link_en_cnt;
reg             link_en;

always @(posedge pclk or negedge pcie_rstn)
        if(~pcie_rstn)
                link_en_cnt <=#1 32'b0;
        else if(~(link_en_cnt == reg_ep0_link_counter))
                link_en_cnt <=#1 link_en_cnt + 1'b1;

always @(posedge pclk or negedge pcie_rstn)
        if(~pcie_rstn)
                link_en <=#1 1'b0;
        else if((link_en_cnt == reg_ep0_link_counter))
                link_en <=#1 1'b1;




assign LINK_TRAINING_ENABLE = link_en & reg_ep0_link_en;




//`ifndef FPGA_SIM
//wire [1:0]      PCIE_GENERATION_SEL = reg_pcie_reserve0[5:4];
//`else
//wire [1:0]      PCIE_GENERATION_SEL = 2'b10;
//`endif


//************************
//******PCIE EP0**********
//************************
wire	[11:0]	ep0_rstn_ctrl    = reg_ep0_rstn_ctrl;		//register control, def(12'hFFF), low active,
wire		ep0_perst_skip   = reg_ep0_perst_skip;		//register control, def(1),


wire		POR_N = 1'b1;				//power on reset

wire		ep0_pcie_rstn = pcie_rstn;		//Source is PAD_RSTN.
wire		ep0_PERST_n = 1'b1;			//Source is PCIe Slot Pin.

//wire		ep0_pcie_clkp = pcie_clkp;
//wire		ep0_pcie_clkn = pcie_clkn;
//wire		ep0_pcie_freerun_clk = pcie_freerun_clk;

//wire		ep0_APRXP0 = APRXP0;
wire		ep0_APRXP1 = 1'b0;
wire		ep0_APRXP2 = 1'b0;
wire		ep0_APRXP3 = 1'b0;
//wire		ep0_APRXN0 = APRXN0;
wire		ep0_APRXN1 = 1'b0;
wire		ep0_APRXN2 = 1'b0;
wire		ep0_APRXN3 = 1'b0;

wire		ep0_APTXP0;
wire		ep0_APTXP1;
wire		ep0_APTXP2;
wire		ep0_APTXP3;
wire		ep0_APTXN0;
wire		ep0_APTXN1;
wire		ep0_APTXN2;
wire		ep0_APTXN3;
//assign		APTXP0 = ep0_APTXP0;
//assign		APTXN0 = ep0_APTXN0;

wire		ep0_POR_N               = ep0_pcie_rstn && POR_N && ep0_rstn_ctrl[0];

wire		ep0_rst_pcie_pram       = ep0_pcie_rstn && POR_N && ep0_rstn_ctrl[1] && (ep0_PERST_n || ep0_perst_skip);
wire		ep0_PM_RESET_N          = presetn       && POR_N && ep0_rstn_ctrl[2];
wire		ep0_RESET_N             = ep0_pcie_rstn && POR_N && ep0_rstn_ctrl[3] && (ep0_PERST_n || ep0_perst_skip);
wire		ep0_PIPE_RESET_N        = ep0_pcie_rstn && POR_N && ep0_rstn_ctrl[4] && (ep0_PERST_n || ep0_perst_skip);
wire		ep0_MGMT_SOFT_RESET_N   = presetn       && POR_N && ep0_rstn_ctrl[9];
wire		ep0_MGMT_RESET_N        = presetn       && POR_N && ep0_rstn_ctrl[5];
wire		ep0_MGMT_STICKY_RESET_N = presetn       && POR_N && ep0_rstn_ctrl[6];

wire		ep0_HOT_RESET_OUT;

wire	[4:0]	ep0_FLR_IN_PROGRESS;
wire	[4:0]	ep0_FLR_DONE = 5'b0;

wire		ep0_PM_CLK      = ep0_pcie_freerun_clk;

wire		ep0_AXI_CLK     = aclk;							//maximum 600MHz
wire		ep0_AXI_RESET_N         = aresetn       && POR_N && ep0_rstn_ctrl[7];
wire		ep0_APB_CLK     = pclk;							//maximum 400MHz
wire		ep0_APB_RESET_N         = presetn       && POR_N && ep0_rstn_ctrl[8];

              //Internal Interrupts
wire		ep0_POWER_STATE_CHANGE_INTERRUPT;
wire	[4:0]	ep0_LOCAL_INTERRUPT;
wire		ep0_PHY_INTERRUPT_OUT;
wire		ep0_LINK_DOWN_RESET_OUT;

wire	[11:0]	ep0_interrupt = { 3'h0,
                                  ep0_LOCAL_INTERRUPT[4:0],		//8:4
                                  ep0_HOT_RESET_OUT,                    //3
				  ep0_LINK_DOWN_RESET_OUT,		//2
                                  ep0_POWER_STATE_CHANGE_INTERRUPT,	//1
                                  ep0_PHY_INTERRUPT_OUT};		//0

             //PHY CLKREQ
wire		ep0_CLKREQ_IN_N = 1'b0;
wire		ep0_CLKREQ_OUT_N;

             //Inbound Message
wire		ep0_MSG_VALID;
wire		ep0_MSG_START;
wire		ep0_MSG_END;
wire		ep0_MSG_VDH;
wire		ep0_MSG_DATA;
wire    [127:0]	ep0_MSG;
wire    [15:0]	ep0_MSG_BYTE_EN;

             //Probe
wire	[31:0]	ep0_pcie_probe_bus;

/*PCIE_IP  AUTO_TEMPLATE(

    .pcie_target_AXI_\(.*\) (@"(downcase (substring vl-name 16))"_pcie_ep0_m[]),
    .pcie_master_AXI_\(.*\) (@"(downcase (substring vl-name 16))"_pcie_ep0_s[]),
    .pcie_mgmt_APB_\(.*\)   (@"(downcase (substring vl-name 14))"[]),

//inout
		 .pcie_clkp			(ep0_pcie_clkp),
		 .pcie_clkn			(ep0_pcie_clkn),
                 .gtwiz_freerun_clk	        (ep0_pcie_freerun_clk),
		 .LINK_TRAINING_ENABLE_i	(LINK_TRAINING_ENABLE),

		 .APRXP0		(ep0_APRXP0),
		 .APRXP1		(ep0_APRXP1),
		 .APRXP2		(ep0_APRXP2),
		 .APRXP3		(ep0_APRXP3),
		 .APRXN0		(ep0_APRXN0),
		 .APRXN1		(ep0_APRXN1),
		 .APRXN2		(ep0_APRXN2),
		 .APRXN3		(ep0_APRXN3),

		 .APTXP0		(ep0_APTXP0),
		 .APTXP1		(ep0_APTXP1),
		 .APTXP2		(ep0_APTXP2),
		 .APTXP3		(ep0_APTXP3),
		 .APTXN0		(ep0_APTXN0),
		 .APTXN1		(ep0_APTXN1),
		 .APTXN2		(ep0_APTXN2),
		 .APTXN3		(ep0_APTXN3),

              //Clock and Reset
                 .POR_N                 (ep0_POR_N),

                 .rst_pcie_pram         (ep0_rst_pcie_pram),
               //.clk_pcie_pram         (ep0_fpga_pcie_clk),

                 .PM_RESET_N            (ep0_PM_RESET_N),
                 .RESET_N               (ep0_RESET_N),
                 .PIPE_RESET_N          (ep0_PIPE_RESET_N),
                 .MGMT_SOFT_RESET_N     (ep0_MGMT_SOFT_RESET_N),
                 .MGMT_RESET_N          (ep0_MGMT_RESET_N),
                 .MGMT_STICKY_RESET_N   (ep0_MGMT_STICKY_RESET_N),


		 .HOT_RESET_IN          (1'b0),						//no used
                 .HOT_RESET_OUT         (ep0_HOT_RESET_OUT),				//active high

		 .FLR_IN_PROGRESS     	(ep0_FLR_IN_PROGRESS[4:0]),
		 .FLR_DONE              (ep0_FLR_DONE[4:0]),

                 .PM_CLK                (ep0_PM_CLK),

                 .AXI_CLK               (ep0_AXI_CLK),
                 .AXI_RESET_N           (ep0_AXI_RESET_N),

                 .APB_CLK               (ep0_APB_CLK),
                 .APB_RESET_N           (ep0_APB_RESET_N),

              //Internal Interrupts
 		.POWER_STATE_CHANGE_INTERRUPT	(ep0_POWER_STATE_CHANGE_INTERRUPT),	//active high, level
		.DPA_INTERRUPT			(),					//no used

		.LOCAL_INTERRUPT                (ep0_LOCAL_INTERRUPT[4:0]),		//active high, level
		.PHY_INTERRUPT_OUT		(ep0_PHY_INTERRUPT_OUT),		//active high, level
		.HOT_PLUG_INTERRUPT_OUT		(),					//no used
		.LINK_DOWN_RESET_OUT  		(ep0_LINK_DOWN_RESET_OUT),		//active high, pulse 

              //External Interrupts, not for rc
		.int_src0			(vga0_intn), 
		.int_src1			(1'b0),					//used by func1
		.int_src2			(1'b0),					//used by func2
		.int_src3			(1'b0),					//used by func3
		.int_src4			(1'b0),					//used by func4

             //PHY CLKREQ
		.CLKREQ_IN_N			(ep0_CLKREQ_IN_N),
		.CLKREQ_OUT_N			(ep0_CLKREQ_OUT_N),

             //Hot_Plug,
                .MRL_SENSOR_N			(1'b1),					//no used
                .PRSNT_N			(1'b1),					//no used
                .ATTENTION_BUTTON_N		(1'b1),					//no used
                .POWER_FAULT_N			(1'b1),					//no used
                .EMI_STATUS			(1'b0),					//no used
              //.COMMAND_CHANGED		(),
              //.COMMAND_COMPLETED		(1'b0),
              //.HOT_PLUG_INTERRUPT_OUT		(),
                .ATTN_INDICATOR			(),					//no used
                .PWR_INDICATOR			(),					//no used
                .PWR_CTRL			(),					//no used
                .EMI_CTRL			(),					//no used

             //APB
		.pcie_mgmt_APB_PADDR		(paddr[31:0]),
		.pcie_mgmt_APB_PSEL		(psel_pcie_ep0),
		.pcie_mgmt_APB_PENABLE		(penable),
		.pcie_mgmt_APB_PWRITE		(pwrite),
		.pcie_mgmt_APB_PWDATA		(pwdata[31:0]),
		.pcie_mgmt_APB_PSTRB		(pstrb[3:0]),
		.pcie_mgmt_APB_PREADY		(pready_pcie_ep0),
		.pcie_mgmt_APB_PRDATA		(prdata_pcie_ep0[31:0]),
		.pcie_mgmt_APB_PSLVERR		(pslverr_pcie_ep0),

		.CONFIG_REG_NUM			(),					//no used
		.CONFIG_WRITE_RECEIVED		(),					//no used
		.CONFIG_WRITE_BYTE_ENABLE	(),					//no used
		.CONFIG_WRITE_DATA		(),					//no used
		.CONFIG_READ_RECEIVED		(),					//no used
		.CONFIG_READ_DATA_VALID		(1'b1),					//no used
		.CONFIG_READ_DATA		(32'h0),				//no used

              //AXI(target)
		.pcie_target_AXI_AWID		(awid_pcie_ep0_m[4:0]),
		.pcie_target_AXI_AWADDR		(awaddr_pcie_ep0_m[39:0]),
		.pcie_target_AXI_AWLEN		(awlen_pcie_ep0_m[3:0]),
		.pcie_target_AXI_AWSIZE		(awsize_pcie_ep0_m[2:0]),
		.pcie_target_AXI_AWBURST	(awburst_pcie_ep0_m[1:0]),
		.pcie_target_AXI_AWLOCK		(awlock_pcie_ep0_m[1:0]),
		.pcie_target_AXI_AWCACHE	(awcache_pcie_ep0_m[3:0]),
		.pcie_target_AXI_AWPROT		(awprot_pcie_ep0_m[2:0]),
		.pcie_target_AXI_AWUSER		(awuser_pcie_ep0_m[109:0]),
		.pcie_target_AXI_AWVALID	(awvalid_pcie_ep0_m),
		.pcie_target_AXI_AWREADY	(awready_pcie_ep0_m),
   
		.pcie_target_AXI_WID		(wid_pcie_ep0_m[4:0]),
		.pcie_target_AXI_WLAST		(wlast_pcie_ep0_m),
		.pcie_target_AXI_WDATA		(wdata_pcie_ep0_m[127:0]),
		.pcie_target_AXI_WSTRB		(wstrb_pcie_ep0_m[15:0]),
		.pcie_target_AXI_WVALID		(wvalid_pcie_ep0_m),
		.pcie_target_AXI_WREADY		(wready_pcie_ep0_m),

		.pcie_target_AXI_BID		(bid_pcie_ep0_m[4:0]),
		.pcie_target_AXI_BRESP		(bresp_pcie_ep0_m[1:0]),
		.pcie_target_AXI_BVALID		(bvalid_pcie_ep0_m),
		.pcie_target_AXI_BREADY		(bready_pcie_ep0_m),

		.pcie_target_AXI_ARID		(arid_pcie_ep0_m[4:0]),
		.pcie_target_AXI_ARADDR		(araddr_pcie_ep0_m[39:0]),
		.pcie_target_AXI_ARLEN		(arlen_pcie_ep0_m[3:0]),
		.pcie_target_AXI_ARSIZE		(arsize_pcie_ep0_m[2:0]),
		.pcie_target_AXI_ARBURST	(arburst_pcie_ep0_m[1:0]),
		.pcie_target_AXI_ARLOCK		(arlock_pcie_ep0_m[1:0]),
		.pcie_target_AXI_ARCACHE	(arcache_pcie_ep0_m[3:0]),
		.pcie_target_AXI_ARPROT		(arprot_pcie_ep0_m[2:0]),
		.pcie_target_AXI_ARUSER		(aruser_pcie_ep0_m[109:0]),
		.pcie_target_AXI_ARVALID	(arvalid_pcie_ep0_m),
		.pcie_target_AXI_ARREADY	(arready_pcie_ep0_m),

		.pcie_target_AXI_RID		(rid_pcie_ep0_m[4:0]),
		.pcie_target_AXI_RLAST		(rlast_pcie_ep0_m),
		.pcie_target_AXI_RDATA		(rdata_pcie_ep0_m[127:0]),
		.pcie_target_AXI_RRESP		(rresp_pcie_ep0_m[1:0]),
		.pcie_target_AXI_RVALID		(rvalid_pcie_ep0_m),
		.pcie_target_AXI_RREADY		(rready_pcie_ep0_m),

              //AXI(master)
		.pcie_master_AXI_AWID		(awid_pcie_ep0_s[4:0]),
		.pcie_master_AXI_AWADDR		(awaddr_pcie_ep0_s[39:0]),
		.pcie_master_AXI_AWLEN		(awlen_pcie_ep0_s[3:0]),
		.pcie_master_AXI_AWSIZE		(awsize_pcie_ep0_s[2:0]),
		.pcie_master_AXI_AWBURST	(awburst_pcie_ep0_s[1:0]),
		.pcie_master_AXI_AWLOCK		({1'b0,awlock_pcie_ep0_s[0]}),
		.pcie_master_AXI_AWCACHE	(awcache_pcie_ep0_s[3:0]),
		.pcie_master_AXI_AWPROT		(awprot_pcie_ep0_s[2:0]),
		.pcie_master_AXI_AWVALID	(awvalid_pcie_ep0_s),
		.pcie_master_AXI_AWREADY	(awready_pcie_ep0_s),

		.pcie_master_AXI_WID		(wid_pcie_ep0_s[4:0]),
		.pcie_master_AXI_WLAST		(wlast_pcie_ep0_s),
		.pcie_master_AXI_WDATA		(wdata_pcie_ep0_s[127:0]),
		.pcie_master_AXI_WSTRB		(wstrb_pcie_ep0_s[15:0]),
		.pcie_master_AXI_WVALID		(wvalid_pcie_ep0_s),
		.pcie_master_AXI_WREADY		(wready_pcie_ep0_s),

		.pcie_master_AXI_BID		(bid_pcie_ep0_s[4:0]),
		.pcie_master_AXI_BRESP		(bresp_pcie_ep0_s[1:0]),
		.pcie_master_AXI_BVALID		(bvalid_pcie_ep0_s),
		.pcie_master_AXI_BREADY		(bready_pcie_ep0_s),

		.pcie_master_AXI_ARID		(arid_pcie_ep0_s[4:0]),
		.pcie_master_AXI_ARADDR		(araddr_pcie_ep0_s[39:0]),
		.pcie_master_AXI_ARLEN		(arlen_pcie_ep0_s[3:0]),
		.pcie_master_AXI_ARSIZE		(arsize_pcie_ep0_s[2:0]),
		.pcie_master_AXI_ARBURST	(arburst_pcie_ep0_s[1:0]),
		.pcie_master_AXI_ARLOCK		({1'b0,arlock_pcie_ep0_s[0]}),
		.pcie_master_AXI_ARCACHE	(arcache_pcie_ep0_s[3:0]),
		.pcie_master_AXI_ARPROT		(arprot_pcie_ep0_s[2:0]),
		.pcie_master_AXI_ARVALID	(arvalid_pcie_ep0_s),
		.pcie_master_AXI_ARREADY	(arready_pcie_ep0_s),

		.pcie_master_AXI_RID		(rid_pcie_ep0_s[4:0]),
		.pcie_master_AXI_RLAST		(rlast_pcie_ep0_s),
		.pcie_master_AXI_RDATA		(rdata_pcie_ep0_s[127:0]),
		.pcie_master_AXI_RRESP		(rresp_pcie_ep0_s[1:0]),
		.pcie_master_AXI_RVALID		(rvalid_pcie_ep0_s),
		.pcie_master_AXI_RREADY		(rready_pcie_ep0_s),

             //Inbound Message
		.MSG_VALID             		(ep0_MSG_VALID),
		.MSG_START             		(ep0_MSG_START),
		.MSG_END               		(ep0_MSG_END),
		.MSG_VDH               		(ep0_MSG_VDH),
		.MSG_DATA              		(ep0_MSG_DATA),
		.MSG                   		(ep0_MSG),
		.MSG_BYTE_EN           		(ep0_MSG_BYTE_EN),

              //SCAN
 		.SCAN_MODE			(1'b0),
		.SCAN_RESET_N			(1'b1),

              //Probe
		.pcie_probe_bus			(ep0_pcie_probe_bus[31:0]),
);
*/

PCIE_IP #(
    .DSP            (1'b0),
    .RC_MODE_SEL    (1'b0),    //0(EP), 1(RC)
    .PCIE_INS_NO    (1'b0)
) pcie_ep0 (/*AUTOINST*/
	    // Outputs
	    .APTXP0			(ep0_APTXP0),		 // Templated
	    .APTXP1			(ep0_APTXP1),		 // Templated
	    .APTXP2			(ep0_APTXP2),		 // Templated
	    .APTXP3			(ep0_APTXP3),		 // Templated
	    .APTXN0			(ep0_APTXN0),		 // Templated
	    .APTXN1			(ep0_APTXN1),		 // Templated
	    .APTXN2			(ep0_APTXN2),		 // Templated
	    .APTXN3			(ep0_APTXN3),		 // Templated
	    .LINK_DOWN_RESET_OUT	(ep0_LINK_DOWN_RESET_OUT), // Templated
	    .HOT_RESET_OUT		(ep0_HOT_RESET_OUT),	 // Templated
	    .FLR_IN_PROGRESS		(ep0_FLR_IN_PROGRESS[4:0]), // Templated
	    .POWER_STATE_CHANGE_INTERRUPT(ep0_POWER_STATE_CHANGE_INTERRUPT), // Templated
	    .DPA_INTERRUPT		(),			 // Templated
	    .LOCAL_INTERRUPT		(ep0_LOCAL_INTERRUPT[4:0]), // Templated
	    .PHY_INTERRUPT_OUT		(ep0_PHY_INTERRUPT_OUT), // Templated
	    .HOT_PLUG_INTERRUPT_OUT	(),			 // Templated
	    .CLKREQ_OUT_N		(ep0_CLKREQ_OUT_N),	 // Templated
	    .ATTN_INDICATOR		(),			 // Templated
	    .PWR_INDICATOR		(),			 // Templated
	    .PWR_CTRL			(),			 // Templated
	    .EMI_CTRL			(),			 // Templated
	    .pcie_mgmt_APB_PREADY	(pready_pcie_ep0),	 // Templated
	    .pcie_mgmt_APB_PRDATA	(prdata_pcie_ep0[31:0]), // Templated
	    .pcie_mgmt_APB_PSLVERR	(pslverr_pcie_ep0),	 // Templated
	    .CONFIG_READ_RECEIVED	(),			 // Templated
	    .CONFIG_WRITE_RECEIVED	(),			 // Templated
	    .CONFIG_REG_NUM		(),			 // Templated
	    .CONFIG_WRITE_DATA		(),			 // Templated
	    .CONFIG_WRITE_BYTE_ENABLE	(),			 // Templated
	    .pcie_target_AXI_AWID	(awid_pcie_ep0_m[4:0]),	 // Templated
	    .pcie_target_AXI_AWADDR	(awaddr_pcie_ep0_m[39:0]), // Templated
	    .pcie_target_AXI_AWLEN	(awlen_pcie_ep0_m[3:0]), // Templated
	    .pcie_target_AXI_AWSIZE	(awsize_pcie_ep0_m[2:0]), // Templated
	    .pcie_target_AXI_AWBURST	(awburst_pcie_ep0_m[1:0]), // Templated
	    .pcie_target_AXI_AWCACHE	(awcache_pcie_ep0_m[3:0]), // Templated
	    .pcie_target_AXI_AWPROT	(awprot_pcie_ep0_m[2:0]), // Templated
	    .pcie_target_AXI_AWLOCK	(awlock_pcie_ep0_m[1:0]), // Templated
	    .pcie_target_AXI_AWUSER	(awuser_pcie_ep0_m[109:0]), // Templated
	    .pcie_target_AXI_AWVALID	(awvalid_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_WID	(wid_pcie_ep0_m[4:0]),	 // Templated
	    .pcie_target_AXI_WDATA	(wdata_pcie_ep0_m[127:0]), // Templated
	    .pcie_target_AXI_WSTRB	(wstrb_pcie_ep0_m[15:0]), // Templated
	    .pcie_target_AXI_WLAST	(wlast_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_WVALID	(wvalid_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_BREADY	(bready_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_ARID	(arid_pcie_ep0_m[4:0]),	 // Templated
	    .pcie_target_AXI_ARADDR	(araddr_pcie_ep0_m[39:0]), // Templated
	    .pcie_target_AXI_ARLEN	(arlen_pcie_ep0_m[3:0]), // Templated
	    .pcie_target_AXI_ARSIZE	(arsize_pcie_ep0_m[2:0]), // Templated
	    .pcie_target_AXI_ARBURST	(arburst_pcie_ep0_m[1:0]), // Templated
	    .pcie_target_AXI_ARCACHE	(arcache_pcie_ep0_m[3:0]), // Templated
	    .pcie_target_AXI_ARPROT	(arprot_pcie_ep0_m[2:0]), // Templated
	    .pcie_target_AXI_ARLOCK	(arlock_pcie_ep0_m[1:0]), // Templated
	    .pcie_target_AXI_ARUSER	(aruser_pcie_ep0_m[109:0]), // Templated
	    .pcie_target_AXI_ARVALID	(arvalid_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_RREADY	(rready_pcie_ep0_m),	 // Templated
	    .pcie_master_AXI_AWREADY	(awready_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_WREADY	(wready_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_BID	(bid_pcie_ep0_s[4:0]),	 // Templated
	    .pcie_master_AXI_BRESP	(bresp_pcie_ep0_s[1:0]), // Templated
	    .pcie_master_AXI_BVALID	(bvalid_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_ARREADY	(arready_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_RID	(rid_pcie_ep0_s[4:0]),	 // Templated
	    .pcie_master_AXI_RDATA	(rdata_pcie_ep0_s[127:0]), // Templated
	    .pcie_master_AXI_RRESP	(rresp_pcie_ep0_s[1:0]), // Templated
	    .pcie_master_AXI_RLAST	(rlast_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_RVALID	(rvalid_pcie_ep0_s),	 // Templated
	    .MSG_VALID			(ep0_MSG_VALID),	 // Templated
	    .MSG_START			(ep0_MSG_START),	 // Templated
	    .MSG_END			(ep0_MSG_END),		 // Templated
	    .MSG_VDH			(ep0_MSG_VDH),		 // Templated
	    .MSG_DATA			(ep0_MSG_DATA),		 // Templated
	    .MSG			(ep0_MSG),		 // Templated
	    .MSG_BYTE_EN		(ep0_MSG_BYTE_EN),	 // Templated
	    .pcie_probe_bus		(ep0_pcie_probe_bus[31:0]), // Templated
	    // Inputs
	    .POR_N			(ep0_POR_N),		 // Templated
	    .pcie_clkp			(ep0_pcie_clkp),	 // Templated
	    .pcie_clkn			(ep0_pcie_clkn),	 // Templated
	    .gtwiz_freerun_clk		(ep0_pcie_freerun_clk),	 // Templated
	    .LINK_TRAINING_ENABLE_i	(LINK_TRAINING_ENABLE),	 // Templated
	    .rst_pcie_pram		(ep0_rst_pcie_pram),	 // Templated
	    .APRXP0			(ep0_APRXP0),		 // Templated
	    .APRXP1			(ep0_APRXP1),		 // Templated
	    .APRXP2			(ep0_APRXP2),		 // Templated
	    .APRXP3			(ep0_APRXP3),		 // Templated
	    .APRXN0			(ep0_APRXN0),		 // Templated
	    .APRXN1			(ep0_APRXN1),		 // Templated
	    .APRXN2			(ep0_APRXN2),		 // Templated
	    .APRXN3			(ep0_APRXN3),		 // Templated
	    .PM_CLK			(ep0_PM_CLK),		 // Templated
	    .AXI_CLK			(ep0_AXI_CLK),		 // Templated
	    .AXI_RESET_N		(ep0_AXI_RESET_N),	 // Templated
	    .APB_CLK			(ep0_APB_CLK),		 // Templated
	    .APB_RESET_N		(ep0_APB_RESET_N),	 // Templated
	    .PM_RESET_N			(ep0_PM_RESET_N),	 // Templated
	    .PIPE_RESET_N		(ep0_PIPE_RESET_N),	 // Templated
	    .RESET_N			(ep0_RESET_N),		 // Templated
	    .MGMT_SOFT_RESET_N		(ep0_MGMT_SOFT_RESET_N), // Templated
	    .MGMT_RESET_N		(ep0_MGMT_RESET_N),	 // Templated
	    .MGMT_STICKY_RESET_N	(ep0_MGMT_STICKY_RESET_N), // Templated
	    .HOT_RESET_IN		(1'b0),			 // Templated
	    .FLR_DONE			(ep0_FLR_DONE[4:0]),	 // Templated
	    .int_src0			(vga0_intn),		 // Templated
	    .int_src1			(1'b0),			 // Templated
	    .int_src2			(1'b0),			 // Templated
	    .int_src3			(1'b0),			 // Templated
	    .int_src4			(1'b0),			 // Templated
	    .CLKREQ_IN_N		(ep0_CLKREQ_IN_N),	 // Templated
	    .MRL_SENSOR_N		(1'b1),			 // Templated
	    .PRSNT_N			(1'b1),			 // Templated
	    .ATTENTION_BUTTON_N		(1'b1),			 // Templated
	    .POWER_FAULT_N		(1'b1),			 // Templated
	    .EMI_STATUS			(1'b0),			 // Templated
	    .pcie_mgmt_APB_PADDR	(paddr[31:0]),		 // Templated
	    .pcie_mgmt_APB_PSEL		(psel_pcie_ep0),	 // Templated
	    .pcie_mgmt_APB_PENABLE	(penable),		 // Templated
	    .pcie_mgmt_APB_PWRITE	(pwrite),		 // Templated
	    .pcie_mgmt_APB_PWDATA	(pwdata[31:0]),		 // Templated
	    .pcie_mgmt_APB_PSTRB	(pstrb[3:0]),		 // Templated
	    .CONFIG_READ_DATA		(32'h0),		 // Templated
	    .CONFIG_READ_DATA_VALID	(1'b1),			 // Templated
	    .pcie_target_AXI_AWREADY	(awready_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_WREADY	(wready_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_BID	(bid_pcie_ep0_m[4:0]),	 // Templated
	    .pcie_target_AXI_BRESP	(bresp_pcie_ep0_m[1:0]), // Templated
	    .pcie_target_AXI_BVALID	(bvalid_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_ARREADY	(arready_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_RID	(rid_pcie_ep0_m[4:0]),	 // Templated
	    .pcie_target_AXI_RDATA	(rdata_pcie_ep0_m[127:0]), // Templated
	    .pcie_target_AXI_RRESP	(rresp_pcie_ep0_m[1:0]), // Templated
	    .pcie_target_AXI_RLAST	(rlast_pcie_ep0_m),	 // Templated
	    .pcie_target_AXI_RVALID	(rvalid_pcie_ep0_m),	 // Templated
	    .pcie_master_AXI_AWID	(awid_pcie_ep0_s[4:0]),	 // Templated
	    .pcie_master_AXI_AWADDR	(awaddr_pcie_ep0_s[39:0]), // Templated
	    .pcie_master_AXI_AWLEN	(awlen_pcie_ep0_s[3:0]), // Templated
	    .pcie_master_AXI_AWSIZE	(awsize_pcie_ep0_s[2:0]), // Templated
	    .pcie_master_AXI_AWBURST	(awburst_pcie_ep0_s[1:0]), // Templated
	    .pcie_master_AXI_AWCACHE	(awcache_pcie_ep0_s[3:0]), // Templated
	    .pcie_master_AXI_AWPROT	(awprot_pcie_ep0_s[2:0]), // Templated
	    .pcie_master_AXI_AWLOCK	({1'b0,awlock_pcie_ep0_s[0]}), // Templated
	    .pcie_master_AXI_AWVALID	(awvalid_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_WID	(wid_pcie_ep0_s[4:0]),	 // Templated
	    .pcie_master_AXI_WDATA	(wdata_pcie_ep0_s[127:0]), // Templated
	    .pcie_master_AXI_WSTRB	(wstrb_pcie_ep0_s[15:0]), // Templated
	    .pcie_master_AXI_WLAST	(wlast_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_WVALID	(wvalid_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_BREADY	(bready_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_ARID	(arid_pcie_ep0_s[4:0]),	 // Templated
	    .pcie_master_AXI_ARADDR	(araddr_pcie_ep0_s[39:0]), // Templated
	    .pcie_master_AXI_ARLEN	(arlen_pcie_ep0_s[3:0]), // Templated
	    .pcie_master_AXI_ARSIZE	(arsize_pcie_ep0_s[2:0]), // Templated
	    .pcie_master_AXI_ARBURST	(arburst_pcie_ep0_s[1:0]), // Templated
	    .pcie_master_AXI_ARCACHE	(arcache_pcie_ep0_s[3:0]), // Templated
	    .pcie_master_AXI_ARPROT	(arprot_pcie_ep0_s[2:0]), // Templated
	    .pcie_master_AXI_ARLOCK	({1'b0,arlock_pcie_ep0_s[0]}), // Templated
	    .pcie_master_AXI_ARVALID	(arvalid_pcie_ep0_s),	 // Templated
	    .pcie_master_AXI_RREADY	(rready_pcie_ep0_s),	 // Templated
	    .SCAN_MODE			(1'b0),			 // Templated
	    .SCAN_RESET_N		(1'b1));			 // Templated
 

    /* ms_axi_async_slave_slice AUTO_TEMPLATE(
      .aclk_s(aclk),
      .aresetn_s(aresetn),
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .wid_s(),
      .awcache_s(),
      .awlock_s(),
      .awprot_s(),
      .arcache_s(),
      .arlock_s(),
      .arprot_s(),
      .\(.*\)_s(\1_s_h2bm[]),
      .\(.*fifo.*side.*\)(h2bm_s_\1[]),);
  */
    ms_axi_async_slave_slice #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_slave_h2bm (  /*AUTOINST*/
				   // Outputs
				   .ar_fifo_rd_side_pop_addr_g_o(h2bm_s_ar_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				   .ar_fifo_rd_side_rd_addr_o(h2bm_s_ar_fifo_rd_side_rd_addr_o[2:0]), // Templated
				   .arburst_s		(arburst_s_h2bm[1:0]), // Templated
				   .arcache_s		(),		 // Templated
				   .arid_s		(arid_s_h2bm[9:0]), // Templated
				   .arlen_s		(arlen_s_h2bm[7:0]), // Templated
				   .arlock_s		(),		 // Templated
				   .arprot_s		(),		 // Templated
				   .arsize_s		(arsize_s_h2bm[2:0]), // Templated
				   .aruser_s		(),		 // Templated
				   .arvalid_s		(arvalid_s_h2bm), // Templated
				   .aw_fifo_rd_side_pop_addr_g_o(h2bm_s_aw_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				   .aw_fifo_rd_side_rd_addr_o(h2bm_s_aw_fifo_rd_side_rd_addr_o[2:0]), // Templated
				   .awburst_s		(awburst_s_h2bm[1:0]), // Templated
				   .awcache_s		(),		 // Templated
				   .awid_s		(awid_s_h2bm[9:0]), // Templated
				   .awlen_s		(awlen_s_h2bm[7:0]), // Templated
				   .awlock_s		(),		 // Templated
				   .awprot_s		(),		 // Templated
				   .awsize_s		(awsize_s_h2bm[2:0]), // Templated
				   .awuser_s		(),		 // Templated
				   .awvalid_s		(awvalid_s_h2bm), // Templated
				   .b_fifo_wr_side_data_out_o(h2bm_s_b_fifo_wr_side_data_out_o[15:0]), // Templated
				   .b_fifo_wr_side_push_addr_g_o(h2bm_s_b_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				   .bready_s		(bready_s_h2bm), // Templated
				   .r_fifo_wr_side_data_out_o(h2bm_s_r_fifo_wr_side_data_out_o[144:0]), // Templated
				   .r_fifo_wr_side_push_addr_g_o(h2bm_s_r_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				   .rready_s		(rready_s_h2bm), // Templated
				   .w_fifo_rd_side_pop_addr_g_o(h2bm_s_w_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				   .w_fifo_rd_side_rd_addr_o(h2bm_s_w_fifo_rd_side_rd_addr_o[2:0]), // Templated
				   .wlast_s		(wlast_s_h2bm),	 // Templated
				   .wstrb_s		(wstrb_s_h2bm[15:0]), // Templated
				   .wuser_s		(),		 // Templated
				   .wvalid_s		(wvalid_s_h2bm), // Templated
				   .wdata_s		(wdata_s_h2bm[127:0]), // Templated
				   .wid_s		(),		 // Templated
				   .araddr_s		(araddr_s_h2bm[39:0]), // Templated
				   .awaddr_s		(awaddr_s_h2bm[39:0]), // Templated
				   // Inputs
				   .aclk_s		(aclk),		 // Templated
				   .ar_fifo_rd_side_data_out_i(h2bm_s_ar_fifo_rd_side_data_out_i[75:0]), // Templated
				   .ar_fifo_rd_side_push_addr_g_i(h2bm_s_ar_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				   .aresetn_s		(aresetn),	 // Templated
				   .arready_s		(arready_s_h2bm), // Templated
				   .aw_fifo_rd_side_data_out_i(h2bm_s_aw_fifo_rd_side_data_out_i[75:0]), // Templated
				   .aw_fifo_rd_side_push_addr_g_i(h2bm_s_aw_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				   .awready_s		(awready_s_h2bm), // Templated
				   .b_fifo_wr_side_pop_addr_g_i(h2bm_s_b_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				   .b_fifo_wr_side_rd_addr_i(h2bm_s_b_fifo_wr_side_rd_addr_i[2:0]), // Templated
				   .bid_s		(bid_s_h2bm[9:0]), // Templated
				   .bresp_s		(bresp_s_h2bm[1:0]), // Templated
				   .buser_s		({4{1'b0}}),	 // Templated
				   .bvalid_s		(bvalid_s_h2bm), // Templated
				   .r_fifo_wr_side_pop_addr_g_i(h2bm_s_r_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				   .r_fifo_wr_side_rd_addr_i(h2bm_s_r_fifo_wr_side_rd_addr_i[2:0]), // Templated
				   .rdata_s		(rdata_s_h2bm[127:0]), // Templated
				   .rid_s		(rid_s_h2bm[9:0]), // Templated
				   .rlast_s		(rlast_s_h2bm),	 // Templated
				   .rresp_s		(rresp_s_h2bm[1:0]), // Templated
				   .ruser_s		({4{1'b0}}),	 // Templated
				   .rvalid_s		(rvalid_s_h2bm), // Templated
				   .w_fifo_rd_side_data_out_i(h2bm_s_w_fifo_rd_side_data_out_i[158:0]), // Templated
				   .w_fifo_rd_side_push_addr_g_i(h2bm_s_w_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				   .wready_s		(wready_s_h2bm)); // Templated


//************************
//******Host2BMC**********
//************************
/* h2bm_top AUTO_TEMPLATE (
      .clk_apb_i       (pclk),
      .rst_apb_ni      (presetn),
      .clk_h2bm_i      (aclk),
      .rst_h2bm_ni     (aresetn),
      .test_en_i       (1'b0),
      .apb_penable_i   (penable),
      .apb_pwrite_i    (pwrite),
      .apb_paddr_i     (paddr[]),
      .apb_pwdata_i    (pwdata[]),
      .apb_pstrb_i     (pstrb[]),
      .apb_\(.*\)_o    (\1_h2bm[]),
      .apb_\(.*\)_i    (\1_h2bm[]),
      .m_\(.*\)_i      (\1_m_h2bm[]),
      .m_\(.*\)_o      (\1_m_h2bm[]),
      .s_\(.*\)_i      (\1_s_h2bm[]),
      .s_\(.*\)_o      (\1_s_h2bm[]),      
      .dev_enable_o    (),
      .cfg_subsys_id_o (),
      .cfg_dev_vid_o   (),
      .cfg_class_rev_o (),
      .cfg_bar0_o      (),
      .busmaster_o     (),
      .msi_en_o        (), 
      .intx_en_o       (),
      .intr_to_host_o  (), 
      .\(.*\)_o        (\1_h2bm[]),
      .\(.*\)_i        (\1_h2bm[]),);
*/
h2bm_top #(
	   .ApbAw			(12),
	   .ApbDw			(32),
	   .AxiIdW			(10),
	   .AxiAw			(40),
	   .AxiDw			(128),
           .AxiStrbW                    (16))
    u_h2bm_top
      (/*AUTOINST*/
       // Outputs
       .apb_prdata_o			(prdata_h2bm[31:0]),	 // Templated
       .apb_pready_o			(pready_h2bm),		 // Templated
       .apb_pslverr_o			(pslverr_h2bm),		 // Templated
       .irq_out_o			(irq_out_h2bm),		 // Templated
       .intr_to_host_o			(),			 // Templated
       .dev_enable_o			(),			 // Templated
       .busmaster_o			(),			 // Templated
       .intx_en_o			(),			 // Templated
       .msi_en_o			(),			 // Templated
       .cfg_dev_vid_o			(),			 // Templated
       .cfg_subsys_id_o			(),			 // Templated
       .cfg_class_rev_o			(),			 // Templated
       .cfg_bar0_o			(),			 // Templated
       .s_awready_o			(awready_s_h2bm),	 // Templated
       .s_wready_o			(wready_s_h2bm),	 // Templated
       .s_bid_o				(bid_s_h2bm[9:0]),	 // Templated
       .s_bresp_o			(bresp_s_h2bm[1:0]),	 // Templated
       .s_bvalid_o			(bvalid_s_h2bm),	 // Templated
       .s_arready_o			(arready_s_h2bm),	 // Templated
       .s_rid_o				(rid_s_h2bm[9:0]),	 // Templated
       .s_rdata_o			(rdata_s_h2bm[127:0]),	 // Templated
       .s_rresp_o			(rresp_s_h2bm[1:0]),	 // Templated
       .s_rlast_o			(rlast_s_h2bm),		 // Templated
       .s_rvalid_o			(rvalid_s_h2bm),	 // Templated
       .m_awid_o			(awid_m_h2bm[9:0]),	 // Templated
       .m_awaddr_o			(awaddr_m_h2bm[39:0]),	 // Templated
       .m_awlen_o			(awlen_m_h2bm[7:0]),	 // Templated
       .m_awsize_o			(awsize_m_h2bm[2:0]),	 // Templated
       .m_awburst_o			(awburst_m_h2bm[1:0]),	 // Templated
       .m_awvalid_o			(awvalid_m_h2bm),	 // Templated
       .m_wdata_o			(wdata_m_h2bm[127:0]),	 // Templated
       .m_wstrb_o			(wstrb_m_h2bm[15:0]),	 // Templated
       .m_wlast_o			(wlast_m_h2bm),		 // Templated
       .m_wvalid_o			(wvalid_m_h2bm),	 // Templated
       .m_bready_o			(bready_m_h2bm),	 // Templated
       .m_arid_o			(arid_m_h2bm[9:0]),	 // Templated
       .m_araddr_o			(araddr_m_h2bm[39:0]),	 // Templated
       .m_arlen_o			(arlen_m_h2bm[7:0]),	 // Templated
       .m_arsize_o			(arsize_m_h2bm[2:0]),	 // Templated
       .m_arburst_o			(arburst_m_h2bm[1:0]),	 // Templated
       .m_arvalid_o			(arvalid_m_h2bm),	 // Templated
       .m_rready_o			(rready_m_h2bm),	 // Templated
       // Inputs
       .clk_apb_i			(pclk),			 // Templated
       .rst_apb_ni			(presetn),		 // Templated
       .clk_h2bm_i			(aclk),			 // Templated
       .rst_h2bm_ni			(aresetn),		 // Templated
       .test_en_i			(1'b0),			 // Templated
       .apb_psel_i			(psel_h2bm),		 // Templated
       .apb_penable_i			(penable),		 // Templated
       .apb_pwrite_i			(pwrite),		 // Templated
       .apb_paddr_i			(paddr[11:0]),		 // Templated
       .apb_pwdata_i			(pwdata[31:0]),		 // Templated
       .apb_pstrb_i			(pstrb[(32)/8-1:0]),	 // Templated
       .s_awid_i			(awid_s_h2bm[9:0]),	 // Templated
       .s_awaddr_i			(awaddr_s_h2bm[39:0]),	 // Templated
       .s_awlen_i			(awlen_s_h2bm[7:0]),	 // Templated
       .s_awsize_i			(awsize_s_h2bm[2:0]),	 // Templated
       .s_awburst_i			(awburst_s_h2bm[1:0]),	 // Templated
       .s_awvalid_i			(awvalid_s_h2bm),	 // Templated
       .s_wdata_i			(wdata_s_h2bm[127:0]),	 // Templated
       .s_wstrb_i			(wstrb_s_h2bm[15:0]),	 // Templated
       .s_wlast_i			(wlast_s_h2bm),		 // Templated
       .s_wvalid_i			(wvalid_s_h2bm),	 // Templated
       .s_bready_i			(bready_s_h2bm),	 // Templated
       .s_arid_i			(arid_s_h2bm[9:0]),	 // Templated
       .s_araddr_i			(araddr_s_h2bm[39:0]),	 // Templated
       .s_arlen_i			(arlen_s_h2bm[7:0]),	 // Templated
       .s_arsize_i			(arsize_s_h2bm[2:0]),	 // Templated
       .s_arburst_i			(arburst_s_h2bm[1:0]),	 // Templated
       .s_arvalid_i			(arvalid_s_h2bm),	 // Templated
       .s_rready_i			(rready_s_h2bm),	 // Templated
       .m_awready_i			(awready_m_h2bm),	 // Templated
       .m_wready_i			(wready_m_h2bm),	 // Templated
       .m_bid_i				(bid_m_h2bm[9:0]),	 // Templated
       .m_bresp_i			(bresp_m_h2bm[1:0]),	 // Templated
       .m_bvalid_i			(bvalid_m_h2bm),	 // Templated
       .m_arready_i			(arready_m_h2bm),	 // Templated
       .m_rid_i				(rid_m_h2bm[9:0]),	 // Templated
       .m_rdata_i			(rdata_m_h2bm[127:0]),	 // Templated
       .m_rresp_i			(rresp_m_h2bm[1:0]),	 // Templated
       .m_rlast_i			(rlast_m_h2bm),		 // Templated
       .m_rvalid_i			(rvalid_m_h2bm));	 // Templated


    /* ms_axi_async_master AUTO_TEMPLATE(
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .aclk_m(aclk),
      .aresetn_m(aresetn),
      .wid_m('b0),
      .\(.*\)cache_m('b0),
      .\(.*\)lock_m('b0),
      .\(.*\)prot_m('b0),
      .\(.*\)_m(\1_m_mvdm[]),
      .\(.*fifo.*side.*\)(mvdm_m_\1[]),);
    */
    ms_axi_async_master #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_master_mvdm (  /*AUTOINST*/
				    // Outputs
				    .awready_m		(awready_m_mvdm), // Templated
				    .wready_m		(wready_m_mvdm), // Templated
				    .bvalid_m		(bvalid_m_mvdm), // Templated
				    .bid_m		(bid_m_mvdm[9:0]), // Templated
				    .bresp_m		(bresp_m_mvdm[1:0]), // Templated
				    .buser_m		(),		 // Templated
				    .arready_m		(arready_m_mvdm), // Templated
				    .rvalid_m		(rvalid_m_mvdm), // Templated
				    .rid_m		(rid_m_mvdm[9:0]), // Templated
				    .rdata_m		(rdata_m_mvdm[127:0]), // Templated
				    .rlast_m		(rlast_m_mvdm),	 // Templated
				    .rresp_m		(rresp_m_mvdm[1:0]), // Templated
				    .ruser_m		(),		 // Templated
				    .ar_fifo_wr_side_push_addr_g_o(mvdm_m_ar_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				    .ar_fifo_wr_side_data_out_o(mvdm_m_ar_fifo_wr_side_data_out_o[75:0]), // Templated
				    .r_fifo_rd_side_pop_addr_g_o(mvdm_m_r_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				    .r_fifo_rd_side_rd_addr_o(mvdm_m_r_fifo_rd_side_rd_addr_o[2:0]), // Templated
				    .aw_fifo_wr_side_push_addr_g_o(mvdm_m_aw_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				    .aw_fifo_wr_side_data_out_o(mvdm_m_aw_fifo_wr_side_data_out_o[75:0]), // Templated
				    .w_fifo_wr_side_push_addr_g_o(mvdm_m_w_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				    .w_fifo_wr_side_data_out_o(mvdm_m_w_fifo_wr_side_data_out_o[158:0]), // Templated
				    .b_fifo_rd_side_pop_addr_g_o(mvdm_m_b_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				    .b_fifo_rd_side_rd_addr_o(mvdm_m_b_fifo_rd_side_rd_addr_o[2:0]), // Templated
				    // Inputs
				    .aclk_m		(aclk),		 // Templated
				    .aresetn_m		(aresetn),	 // Templated
				    .awvalid_m		(awvalid_m_mvdm), // Templated
				    .awaddr_m		(awaddr_m_mvdm[39:0]), // Templated
				    .awid_m		(awid_m_mvdm[9:0]), // Templated
				    .awlen_m		(awlen_m_mvdm[7:0]), // Templated
				    .awsize_m		(awsize_m_mvdm[2:0]), // Templated
				    .awburst_m		(awburst_m_mvdm[1:0]), // Templated
				    .awlock_m		('b0),		 // Templated
				    .awcache_m		('b0),		 // Templated
				    .awprot_m		('b0),		 // Templated
				    .awuser_m		({4{1'b0}}),	 // Templated
				    .wvalid_m		(wvalid_m_mvdm), // Templated
				    .wid_m		('b0),		 // Templated
				    .wdata_m		(wdata_m_mvdm[127:0]), // Templated
				    .wstrb_m		(wstrb_m_mvdm[15:0]), // Templated
				    .wlast_m		(wlast_m_mvdm),	 // Templated
				    .wuser_m		({4{1'b0}}),	 // Templated
				    .bready_m		(bready_m_mvdm), // Templated
				    .arvalid_m		(arvalid_m_mvdm), // Templated
				    .arid_m		(arid_m_mvdm[9:0]), // Templated
				    .araddr_m		(araddr_m_mvdm[39:0]), // Templated
				    .arlen_m		(arlen_m_mvdm[7:0]), // Templated
				    .arsize_m		(arsize_m_mvdm[2:0]), // Templated
				    .arburst_m		(arburst_m_mvdm[1:0]), // Templated
				    .arlock_m		('b0),		 // Templated
				    .arcache_m		('b0),		 // Templated
				    .arprot_m		('b0),		 // Templated
				    .aruser_m		({4{1'b0}}),	 // Templated
				    .rready_m		(rready_m_mvdm), // Templated
				    .ar_fifo_wr_side_pop_addr_g_i(mvdm_m_ar_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				    .ar_fifo_wr_side_rd_addr_i(mvdm_m_ar_fifo_wr_side_rd_addr_i[2:0]), // Templated
				    .r_fifo_rd_side_push_addr_g_i(mvdm_m_r_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				    .r_fifo_rd_side_data_out_i(mvdm_m_r_fifo_rd_side_data_out_i[144:0]), // Templated
				    .aw_fifo_wr_side_pop_addr_g_i(mvdm_m_aw_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				    .aw_fifo_wr_side_rd_addr_i(mvdm_m_aw_fifo_wr_side_rd_addr_i[2:0]), // Templated
				    .w_fifo_wr_side_pop_addr_g_i(mvdm_m_w_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				    .w_fifo_wr_side_rd_addr_i(mvdm_m_w_fifo_wr_side_rd_addr_i[2:0]), // Templated
				    .b_fifo_rd_side_push_addr_g_i(mvdm_m_b_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				    .b_fifo_rd_side_data_out_i(mvdm_m_b_fifo_rd_side_data_out_i[15:0])); // Templated


//************************
//******MCTP_VDM**********
//************************
/* mvdm_top AUTO_TEMPLATE (
      .clk_apb       (pclk),
      .rst_apb_ni    (presetn),
      .clk_axi       (aclk),
      .rst_axi_ni    (aresetn),
      .clk_vdm_if    (clk_mvdm),
      .rst_vdm_ni    (resetn_mvdm),
      .scan_en_i     (1'b0),
      .p\(.*\)_i     (p\1[]),
      .p\(.*\)_o     (p\1_mvdm[]),
      .msg_valid_i   (ep0_MSG_VALID),
      .msg_start_i   (ep0_MSG_START),
      .msg_end_i     (ep0_MSG_END),
      .msg_vdh_i     (ep0_MSG_VDH),
      .msg_data_i    (ep0_MSG_DATA),
      .msg_bus_i     (ep0_MSG),
      .msg_byte_en_i (ep0_MSG_BYTE_EN),
      .m_\(.*\)      (\1_m_mvdm[]),
      .\(.*\)        (\1_mvdm[]),);
*/

mvdm_top #(
	   .AXI_ID_WIDTH		(10),
	   .AXI_ADDR_WIDTH		(40),
	   .AXI_DATA_WIDTH		(128),
           .AXI_STRB_WIDTH              (16))
    u_mvdm_top
      (/*AUTOINST*/
       // Outputs
       .prdata_o			(prdata_mvdm[31:0]),	 // Templated
       .pready_o			(pready_mvdm),		 // Templated
       .pslverr_o			(pslverr_mvdm),		 // Templated
       .m_awid				(awid_m_mvdm[9:0]),	 // Templated
       .m_awaddr			(awaddr_m_mvdm[39:0]),	 // Templated
       .m_awlen				(awlen_m_mvdm[7:0]),	 // Templated
       .m_awsize			(awsize_m_mvdm[2:0]),	 // Templated
       .m_awburst			(awburst_m_mvdm[1:0]),	 // Templated
       .m_awvalid			(awvalid_m_mvdm),	 // Templated
       .m_wdata				(wdata_m_mvdm[127:0]),	 // Templated
       .m_wstrb				(wstrb_m_mvdm[15:0]),	 // Templated
       .m_wlast				(wlast_m_mvdm),		 // Templated
       .m_wvalid			(wvalid_m_mvdm),	 // Templated
       .m_bready			(bready_m_mvdm),	 // Templated
       .m_arid				(arid_m_mvdm[9:0]),	 // Templated
       .m_araddr			(araddr_m_mvdm[39:0]),	 // Templated
       .m_arlen				(arlen_m_mvdm[7:0]),	 // Templated
       .m_arsize			(arsize_m_mvdm[2:0]),	 // Templated
       .m_arburst			(arburst_m_mvdm[1:0]),	 // Templated
       .m_arvalid			(arvalid_m_mvdm),	 // Templated
       .m_rready			(rready_m_mvdm),	 // Templated
       .irq_out				(irq_out_mvdm),		 // Templated
       // Inputs
       .clk_apb				(pclk),			 // Templated
       .rst_apb_ni			(presetn),		 // Templated
       .clk_axi				(aclk),			 // Templated
       .rst_axi_ni			(aresetn),		 // Templated
       .clk_vdm_if			(clk_mvdm),		 // Templated
       .rst_vdm_ni			(resetn_mvdm),		 // Templated
       .scan_en_i			(1'b0),			 // Templated
       .psel_i				(psel),			 // Templated
       .penable_i			(penable),		 // Templated
       .pwrite_i			(pwrite),		 // Templated
       .paddr_i				(paddr[11:0]),		 // Templated
       .pwdata_i			(pwdata[31:0]),		 // Templated
       .pstrb_i				(pstrb[3:0]),		 // Templated
       .msg_valid_i			(ep0_MSG_VALID),	 // Templated
       .msg_start_i			(ep0_MSG_START),	 // Templated
       .msg_end_i			(ep0_MSG_END),		 // Templated
       .msg_vdh_i			(ep0_MSG_VDH),		 // Templated
       .msg_data_i			(ep0_MSG_DATA),		 // Templated
       .msg_bus_i			(ep0_MSG),		 // Templated
       .msg_byte_en_i			(ep0_MSG_BYTE_EN),	 // Templated
       .m_awready			(awready_m_mvdm),	 // Templated
       .m_wready			(wready_m_mvdm),	 // Templated
       .m_bid				(bid_m_mvdm[9:0]),	 // Templated
       .m_bresp				(bresp_m_mvdm[1:0]),	 // Templated
       .m_bvalid			(bvalid_m_mvdm),	 // Templated
       .m_arready			(arready_m_mvdm),	 // Templated
       .m_rid				(rid_m_mvdm[9:0]),	 // Templated
       .m_rdata				(rdata_m_mvdm[127:0]),	 // Templated
       .m_rresp				(rresp_m_mvdm[1:0]),	 // Templated
       .m_rlast				(rlast_m_mvdm),		 // Templated
       .m_rvalid			(rvalid_m_mvdm));	 // Templated


    /* ms_axi_async_slave_slice AUTO_TEMPLATE(
      .aclk_s(aclk),
      .aresetn_s(aresetn),
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .wid_s(),
      .awcache_s(),
      .awlock_s(),
      .awprot_s(),
      .arcache_s(),
      .arlock_s(),
      .arprot_s(),
      .\(.*\)_s(\1_s_pbmc[]),
      .\(.*fifo.*side.*\) (pbmc_s_\1[]),);
    */
    ms_axi_async_slave_slice #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_slave_pbmc (  /*AUTOINST*/
				   // Outputs
				   .ar_fifo_rd_side_pop_addr_g_o(pbmc_s_ar_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				   .ar_fifo_rd_side_rd_addr_o(pbmc_s_ar_fifo_rd_side_rd_addr_o[2:0]), // Templated
				   .arburst_s		(arburst_s_pbmc[1:0]), // Templated
				   .arcache_s		(),		 // Templated
				   .arid_s		(arid_s_pbmc[9:0]), // Templated
				   .arlen_s		(arlen_s_pbmc[7:0]), // Templated
				   .arlock_s		(),		 // Templated
				   .arprot_s		(),		 // Templated
				   .arsize_s		(arsize_s_pbmc[2:0]), // Templated
				   .aruser_s		(),		 // Templated
				   .arvalid_s		(arvalid_s_pbmc), // Templated
				   .aw_fifo_rd_side_pop_addr_g_o(pbmc_s_aw_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				   .aw_fifo_rd_side_rd_addr_o(pbmc_s_aw_fifo_rd_side_rd_addr_o[2:0]), // Templated
				   .awburst_s		(awburst_s_pbmc[1:0]), // Templated
				   .awcache_s		(),		 // Templated
				   .awid_s		(awid_s_pbmc[9:0]), // Templated
				   .awlen_s		(awlen_s_pbmc[7:0]), // Templated
				   .awlock_s		(),		 // Templated
				   .awprot_s		(),		 // Templated
				   .awsize_s		(awsize_s_pbmc[2:0]), // Templated
				   .awuser_s		(),		 // Templated
				   .awvalid_s		(awvalid_s_pbmc), // Templated
				   .b_fifo_wr_side_data_out_o(pbmc_s_b_fifo_wr_side_data_out_o[15:0]), // Templated
				   .b_fifo_wr_side_push_addr_g_o(pbmc_s_b_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				   .bready_s		(bready_s_pbmc), // Templated
				   .r_fifo_wr_side_data_out_o(pbmc_s_r_fifo_wr_side_data_out_o[144:0]), // Templated
				   .r_fifo_wr_side_push_addr_g_o(pbmc_s_r_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				   .rready_s		(rready_s_pbmc), // Templated
				   .w_fifo_rd_side_pop_addr_g_o(pbmc_s_w_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				   .w_fifo_rd_side_rd_addr_o(pbmc_s_w_fifo_rd_side_rd_addr_o[2:0]), // Templated
				   .wlast_s		(wlast_s_pbmc),	 // Templated
				   .wstrb_s		(wstrb_s_pbmc[15:0]), // Templated
				   .wuser_s		(),		 // Templated
				   .wvalid_s		(wvalid_s_pbmc), // Templated
				   .wdata_s		(wdata_s_pbmc[127:0]), // Templated
				   .wid_s		(),		 // Templated
				   .araddr_s		(araddr_s_pbmc[39:0]), // Templated
				   .awaddr_s		(awaddr_s_pbmc[39:0]), // Templated
				   // Inputs
				   .aclk_s		(aclk),		 // Templated
				   .ar_fifo_rd_side_data_out_i(pbmc_s_ar_fifo_rd_side_data_out_i[75:0]), // Templated
				   .ar_fifo_rd_side_push_addr_g_i(pbmc_s_ar_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				   .aresetn_s		(aresetn),	 // Templated
				   .arready_s		(arready_s_pbmc), // Templated
				   .aw_fifo_rd_side_data_out_i(pbmc_s_aw_fifo_rd_side_data_out_i[75:0]), // Templated
				   .aw_fifo_rd_side_push_addr_g_i(pbmc_s_aw_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				   .awready_s		(awready_s_pbmc), // Templated
				   .b_fifo_wr_side_pop_addr_g_i(pbmc_s_b_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				   .b_fifo_wr_side_rd_addr_i(pbmc_s_b_fifo_wr_side_rd_addr_i[2:0]), // Templated
				   .bid_s		(bid_s_pbmc[9:0]), // Templated
				   .bresp_s		(bresp_s_pbmc[1:0]), // Templated
				   .buser_s		({4{1'b0}}),	 // Templated
				   .bvalid_s		(bvalid_s_pbmc), // Templated
				   .r_fifo_wr_side_pop_addr_g_i(pbmc_s_r_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				   .r_fifo_wr_side_rd_addr_i(pbmc_s_r_fifo_wr_side_rd_addr_i[2:0]), // Templated
				   .rdata_s		(rdata_s_pbmc[127:0]), // Templated
				   .rid_s		(rid_s_pbmc[9:0]), // Templated
				   .rlast_s		(rlast_s_pbmc),	 // Templated
				   .rresp_s		(rresp_s_pbmc[1:0]), // Templated
				   .ruser_s		({4{1'b0}}),	 // Templated
				   .rvalid_s		(rvalid_s_pbmc), // Templated
				   .w_fifo_rd_side_data_out_i(pbmc_s_w_fifo_rd_side_data_out_i[158:0]), // Templated
				   .w_fifo_rd_side_push_addr_g_i(pbmc_s_w_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				   .wready_s		(wready_s_pbmc)); // Templated


//************************
//********PBMC************
//************************
/* pbmc_top AUTO_TEMPLATE (
      .clk_apb           (pclk),
      .clk_axi           (aclk),
      .rst_ni            (resetn_pbmc),
      .test_mode_i       (1'b0),
      .pcie_axi_awuser_i ('b0),
      .pcie_axi_aruser_i ('b0), 
      .pcie_axi_\(.*\)_o  (\1_s_pbmc[]),
      .pcie_axi_\(.*\)_i  (\1_s_pbmc[]),
      .bmc_axi_awqos_o   (),
      .bmc_axi_arqos_o   (),
      .bmc_axi_\(.*\)_o  (\1_m_pbmc[]),
      .bmc_axi_\(.*\)_i  (\1_m_pbmc[]),
      .apb_penable_i     (penable),
      .apb_pwrite_i      (pwrite),
      .apb_paddr_i       (paddr[]),
      .apb_pwdata_i      (pwdata[]),
      .apb_pstrb_i       (pstrb[]),
      .apb_\(.*\)_o      (\1_pbmc[]),
      .apb_\(.*\)_i      (\1_pbmc[]),
      .\(.*\)_o          (\1_pbmc[]),
      .\(.*\)_i          (\1_pbmc[]),);
*/

pbmc_top #(
	   .AxiAw			(40),
	   .AxiDw			(128),
	   .AxiIdw			(10),
	   .AxiUw			(1),
	   .ApbAw			(12),
	   .ApbDw			(32),
	   .NumPid			(16),
	   .PidW			(4),
           .AxiSw                       (16)) 
      u_pbmc_top
      (/*AUTOINST*/
       // Outputs
       .apb_prdata_o			(prdata_pbmc[31:0]),	 // Templated
       .apb_pready_o			(pready_pbmc),		 // Templated
       .apb_pslverr_o			(pslverr_pbmc),		 // Templated
       .pcie_axi_awready_o		(awready_s_pbmc),	 // Templated
       .pcie_axi_wready_o		(wready_s_pbmc),	 // Templated
       .pcie_axi_bid_o			(bid_s_pbmc[9:0]),	 // Templated
       .pcie_axi_bresp_o		(bresp_s_pbmc[1:0]),	 // Templated
       .pcie_axi_bvalid_o		(bvalid_s_pbmc),	 // Templated
       .pcie_axi_arready_o		(arready_s_pbmc),	 // Templated
       .pcie_axi_rid_o			(rid_s_pbmc[9:0]),	 // Templated
       .pcie_axi_rdata_o		(rdata_s_pbmc[127:0]),	 // Templated
       .pcie_axi_rresp_o		(rresp_s_pbmc[1:0]),	 // Templated
       .pcie_axi_rlast_o		(rlast_s_pbmc),		 // Templated
       .pcie_axi_rvalid_o		(rvalid_s_pbmc),	 // Templated
       .bmc_axi_awid_o			(awid_m_pbmc[9:0]),	 // Templated
       .bmc_axi_awaddr_o		(awaddr_m_pbmc[39:0]),	 // Templated
       .bmc_axi_awlen_o			(awlen_m_pbmc[7:0]),	 // Templated
       .bmc_axi_awsize_o		(awsize_m_pbmc[2:0]),	 // Templated
       .bmc_axi_awburst_o		(awburst_m_pbmc[1:0]),	 // Templated
       .bmc_axi_awlock_o		(awlock_m_pbmc),	 // Templated
       .bmc_axi_awcache_o		(awcache_m_pbmc[3:0]),	 // Templated
       .bmc_axi_awprot_o		(awprot_m_pbmc[2:0]),	 // Templated
       .bmc_axi_awqos_o			(),			 // Templated
       .bmc_axi_awvalid_o		(awvalid_m_pbmc),	 // Templated
       .bmc_axi_wdata_o			(wdata_m_pbmc[127:0]),	 // Templated
       .bmc_axi_wstrb_o			(wstrb_m_pbmc[15:0]),	 // Templated
       .bmc_axi_wlast_o			(wlast_m_pbmc),		 // Templated
       .bmc_axi_wvalid_o		(wvalid_m_pbmc),	 // Templated
       .bmc_axi_bready_o		(bready_m_pbmc),	 // Templated
       .bmc_axi_arid_o			(arid_m_pbmc[9:0]),	 // Templated
       .bmc_axi_araddr_o		(araddr_m_pbmc[39:0]),	 // Templated
       .bmc_axi_arlen_o			(arlen_m_pbmc[7:0]),	 // Templated
       .bmc_axi_arsize_o		(arsize_m_pbmc[2:0]),	 // Templated
       .bmc_axi_arburst_o		(arburst_m_pbmc[1:0]),	 // Templated
       .bmc_axi_arlock_o		(arlock_m_pbmc),	 // Templated
       .bmc_axi_arcache_o		(arcache_m_pbmc[3:0]),	 // Templated
       .bmc_axi_arprot_o		(arprot_m_pbmc[2:0]),	 // Templated
       .bmc_axi_arqos_o			(),			 // Templated
       .bmc_axi_arvalid_o		(arvalid_m_pbmc),	 // Templated
       .bmc_axi_rready_o		(rready_m_pbmc),	 // Templated
       .irq_out_o			(irq_out_pbmc),		 // Templated
       // Inputs
       .clk_apb				(pclk),			 // Templated
       .clk_axi				(aclk),			 // Templated
       .clk_pbmc			(clk_pbmc),
       .rst_ni				(resetn_pbmc),		 // Templated
       .test_mode_i			(1'b0),			 // Templated
       .apb_psel_i			(psel_pbmc),		 // Templated
       .apb_penable_i			(penable),		 // Templated
       .apb_pwrite_i			(pwrite),		 // Templated
       .apb_paddr_i			(paddr[11:0]),		 // Templated
       .apb_pwdata_i			(pwdata[31:0]),		 // Templated
       .apb_pstrb_i			(pstrb[(32)/8-1:0]),	 // Templated
       .pcie_axi_awid_i			(awid_s_pbmc[9:0]),	 // Templated
       .pcie_axi_awaddr_i		(awaddr_s_pbmc[39:0]),	 // Templated
       .pcie_axi_awlen_i		(awlen_s_pbmc[7:0]),	 // Templated
       .pcie_axi_awsize_i		(awsize_s_pbmc[2:0]),	 // Templated
       .pcie_axi_awburst_i		(awburst_s_pbmc[1:0]),	 // Templated
       .pcie_axi_awuser_i		('b0),			 // Templated
       .pcie_axi_awvalid_i		(awvalid_s_pbmc),	 // Templated
       .pcie_axi_wdata_i		(wdata_s_pbmc[127:0]),	 // Templated
       .pcie_axi_wstrb_i		(wstrb_s_pbmc[15:0]),	 // Templated
       .pcie_axi_wlast_i		(wlast_s_pbmc),		 // Templated
       .pcie_axi_wvalid_i		(wvalid_s_pbmc),	 // Templated
       .pcie_axi_bready_i		(bready_s_pbmc),	 // Templated
       .pcie_axi_arid_i			(arid_s_pbmc[9:0]),	 // Templated
       .pcie_axi_araddr_i		(araddr_s_pbmc[39:0]),	 // Templated
       .pcie_axi_arlen_i		(arlen_s_pbmc[7:0]),	 // Templated
       .pcie_axi_arsize_i		(arsize_s_pbmc[2:0]),	 // Templated
       .pcie_axi_arburst_i		(arburst_s_pbmc[1:0]),	 // Templated
       .pcie_axi_aruser_i		('b0),			 // Templated
       .pcie_axi_arvalid_i		(arvalid_s_pbmc),	 // Templated
       .pcie_axi_rready_i		(rready_s_pbmc),	 // Templated
       .bmc_axi_awready_i		(awready_m_pbmc),	 // Templated
       .bmc_axi_wready_i		(wready_m_pbmc),	 // Templated
       .bmc_axi_bid_i			(bid_m_pbmc[9:0]),	 // Templated
       .bmc_axi_bresp_i			(bresp_m_pbmc[1:0]),	 // Templated
       .bmc_axi_bvalid_i		(bvalid_m_pbmc),	 // Templated
       .bmc_axi_arready_i		(arready_m_pbmc),	 // Templated
       .bmc_axi_rid_i			(rid_m_pbmc[9:0]),	 // Templated
       .bmc_axi_rdata_i			(rdata_m_pbmc[127:0]),	 // Templated
       .bmc_axi_rresp_i			(rresp_m_pbmc[1:0]),	 // Templated
       .bmc_axi_rlast_i			(rlast_m_pbmc),		 // Templated
       .bmc_axi_rvalid_i		(rvalid_m_pbmc));	 // Templated


    /* ms_axi_async_slave_slice AUTO_TEMPLATE(
      .aclk_s(aclk),
      .aresetn_s(aresetn),
      ..*user_.(@"(if (string= vl-dir \\"input\\") (concat \\"{\\"(concat vl-width \\"{1'b0}}\\"))) \\"\\""),
      .wid_s(),
      .awcache_s(),
      .awlock_s(),
      .awprot_s(),
      .arcache_s(),
      .arlock_s(),
      .arprot_s(),
      .\(.*\)_s(\1_s_pmmbi[]),
      .\(.*fifo.*side.*\) (pmmbi_s_\1[]),);
    */
    ms_axi_async_slave_slice #(
        .X2X_MP_AW          (40),
        .X2X_MP_DW          (128),
        .X2X_MP_SW          (16),
        .X2X_MP_IDW         (10),
        .X2X_MP_LEN         (8),
        .X2X_AR_BUF_DEPTH   (8),
        .X2X_R_BUF_DEPTH    (8),
        .X2X_AW_BUF_DEPTH   (8),
        .X2X_W_BUF_DEPTH    (8),
        .X2X_B_BUF_DEPTH    (8),
        .X2X_MP_SYNC_DEPTH  (2),
        .X2X_SP_SYNC_DEPTH  (2),
        .AR_FIFO_WIDTH      (76),
        .AR_FIFO_DEPTH      (8),
        .AR_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AR_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .R_FIFO_WIDTH       (145),
        .R_FIFO_DEPTH       (8),
        .R_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .R_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .AW_FIFO_WIDTH      (76),
        .AW_FIFO_DEPTH      (8),
        .AW_FIFO_ADDR_WIDTH (3),    // RANGE 2 to 24
        .AW_FIFO_COUNT_WIDTH(4),    // RANGE 3 to 25
        .W_FIFO_WIDTH       (159),
        .W_FIFO_DEPTH       (8),
        .W_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .W_FIFO_COUNT_WIDTH (4),    // RANGE 3 to 25
        .B_FIFO_WIDTH       (16),
        .B_FIFO_DEPTH       (8),
        .B_FIFO_ADDR_WIDTH  (3),    // RANGE 2 to 24
        .B_FIFO_COUNT_WIDTH (4),
        .AR_USER_WIDTH(4),
        .AW_USER_WIDTH(4),
        .W_USER_WIDTH(4),
        .B_USER_WIDTH(4),
        .R_USER_WIDTH(4)
    )  // RANGE 3 to 25
        u_ms_axi_async_slave_pmmbi (  /*AUTOINST*/
				    // Outputs
				    .ar_fifo_rd_side_pop_addr_g_o(pmmbi_s_ar_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				    .ar_fifo_rd_side_rd_addr_o(pmmbi_s_ar_fifo_rd_side_rd_addr_o[2:0]), // Templated
				    .arburst_s		(arburst_s_pmmbi[1:0]), // Templated
				    .arcache_s		(),		 // Templated
				    .arid_s		(arid_s_pmmbi[9:0]), // Templated
				    .arlen_s		(arlen_s_pmmbi[7:0]), // Templated
				    .arlock_s		(),		 // Templated
				    .arprot_s		(),		 // Templated
				    .arsize_s		(arsize_s_pmmbi[2:0]), // Templated
				    .aruser_s		(),		 // Templated
				    .arvalid_s		(arvalid_s_pmmbi), // Templated
				    .aw_fifo_rd_side_pop_addr_g_o(pmmbi_s_aw_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				    .aw_fifo_rd_side_rd_addr_o(pmmbi_s_aw_fifo_rd_side_rd_addr_o[2:0]), // Templated
				    .awburst_s		(awburst_s_pmmbi[1:0]), // Templated
				    .awcache_s		(),		 // Templated
				    .awid_s		(awid_s_pmmbi[9:0]), // Templated
				    .awlen_s		(awlen_s_pmmbi[7:0]), // Templated
				    .awlock_s		(),		 // Templated
				    .awprot_s		(),		 // Templated
				    .awsize_s		(awsize_s_pmmbi[2:0]), // Templated
				    .awuser_s		(),		 // Templated
				    .awvalid_s		(awvalid_s_pmmbi), // Templated
				    .b_fifo_wr_side_data_out_o(pmmbi_s_b_fifo_wr_side_data_out_o[15:0]), // Templated
				    .b_fifo_wr_side_push_addr_g_o(pmmbi_s_b_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				    .bready_s		(bready_s_pmmbi), // Templated
				    .r_fifo_wr_side_data_out_o(pmmbi_s_r_fifo_wr_side_data_out_o[144:0]), // Templated
				    .r_fifo_wr_side_push_addr_g_o(pmmbi_s_r_fifo_wr_side_push_addr_g_o[3:0]), // Templated
				    .rready_s		(rready_s_pmmbi), // Templated
				    .w_fifo_rd_side_pop_addr_g_o(pmmbi_s_w_fifo_rd_side_pop_addr_g_o[3:0]), // Templated
				    .w_fifo_rd_side_rd_addr_o(pmmbi_s_w_fifo_rd_side_rd_addr_o[2:0]), // Templated
				    .wlast_s		(wlast_s_pmmbi), // Templated
				    .wstrb_s		(wstrb_s_pmmbi[15:0]), // Templated
				    .wuser_s		(),		 // Templated
				    .wvalid_s		(wvalid_s_pmmbi), // Templated
				    .wdata_s		(wdata_s_pmmbi[127:0]), // Templated
				    .wid_s		(),		 // Templated
				    .araddr_s		(araddr_s_pmmbi[39:0]), // Templated
				    .awaddr_s		(awaddr_s_pmmbi[39:0]), // Templated
				    // Inputs
				    .aclk_s		(aclk),		 // Templated
				    .ar_fifo_rd_side_data_out_i(pmmbi_s_ar_fifo_rd_side_data_out_i[75:0]), // Templated
				    .ar_fifo_rd_side_push_addr_g_i(pmmbi_s_ar_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				    .aresetn_s		(aresetn),	 // Templated
				    .arready_s		(arready_s_pmmbi), // Templated
				    .aw_fifo_rd_side_data_out_i(pmmbi_s_aw_fifo_rd_side_data_out_i[75:0]), // Templated
				    .aw_fifo_rd_side_push_addr_g_i(pmmbi_s_aw_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				    .awready_s		(awready_s_pmmbi), // Templated
				    .b_fifo_wr_side_pop_addr_g_i(pmmbi_s_b_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				    .b_fifo_wr_side_rd_addr_i(pmmbi_s_b_fifo_wr_side_rd_addr_i[2:0]), // Templated
				    .bid_s		(bid_s_pmmbi[9:0]), // Templated
				    .bresp_s		(bresp_s_pmmbi[1:0]), // Templated
				    .buser_s		({4{1'b0}}),	 // Templated
				    .bvalid_s		(bvalid_s_pmmbi), // Templated
				    .r_fifo_wr_side_pop_addr_g_i(pmmbi_s_r_fifo_wr_side_pop_addr_g_i[3:0]), // Templated
				    .r_fifo_wr_side_rd_addr_i(pmmbi_s_r_fifo_wr_side_rd_addr_i[2:0]), // Templated
				    .rdata_s		(rdata_s_pmmbi[127:0]), // Templated
				    .rid_s		(rid_s_pmmbi[9:0]), // Templated
				    .rlast_s		(rlast_s_pmmbi), // Templated
				    .rresp_s		(rresp_s_pmmbi[1:0]), // Templated
				    .ruser_s		({4{1'b0}}),	 // Templated
				    .rvalid_s		(rvalid_s_pmmbi), // Templated
				    .w_fifo_rd_side_data_out_i(pmmbi_s_w_fifo_rd_side_data_out_i[158:0]), // Templated
				    .w_fifo_rd_side_push_addr_g_i(pmmbi_s_w_fifo_rd_side_push_addr_g_i[3:0]), // Templated
				    .wready_s		(wready_s_pmmbi)); // Templated


//************************
//******PCIE_MMBI*********
//************************
/* pmmbi_top AUTO_TEMPLATE (
      .m_axi_wdata_o	 (wdata_m_pmmbi_int),
      .m_axi_wstrb_o   	 (wstrb_m_pmmbi_int),
      .m_axi_rdata_i	 (rdata_m_pmmbi[31:0]),
      .clk_apb           (pclk),
      .rst_apb_ni        (presetn),
      .clk_axi           (aclk),
      .rst_axi_ni        (aresetn),
      .rst_pmmbi_ni      (resetn_pmmbi),
      .test_en_i         (1'b0),
      .s_axi_awuser_i    ('b0),
      .s_axi_awqos_i     ('b0),
      .s_axi_awprot_i    ('b0),
      .s_axi_awlock_i    ('b0),
      .s_axi_awcache_i   ('b0),
      .s_axi_aruser_i    ('b0),
      .s_axi_arqos_i     ('b0),
      .s_axi_arprot_i    ('b0), 
      .s_axi_arlock_i    ('b0),
      .s_axi_arcache_i   ('b0),
      .s_axi_\(.*\)_o     (\1_s_pmmbi[]),
      .s_axi_\(.*\)_i     (\1_s_pmmbi[]),
      .m_axi_\(.*\)_o    (\1_m_pmmbi[]),
      .m_axi_\(.*\)_i    (\1_m_pmmbi[]),
      .apb_penable_i     (penable),
      .apb_pwrite_i      (pwrite),
      .apb_paddr_i       (paddr[]),
      .apb_pwdata_i      (pwdata[]),
      .apb_pstrb_i       (pstrb[]),
      .apb_\(.*\)_o      (\1_pmmbi[]),
      .apb_\(.*\)_i      (\1_pmmbi[]),
      .hirq_type_o       (),
      .hirq_req_o        (),
      .\(.*\)_o          (\1_pmmbi[]),);
*/
pmmbi_top #(
	    .AxiAddrWidth		(40),
	    .AxiDataWidth		(128),
	    .AxiIdWidth			(10),
	    .AxiUserWidth		(1),
	    .CsrAddrWidth		(12),
	    .NumChannel			(1),
	    .MbiDataWidth		(32),
	    .MbiIdWidth			(10))
      u_pmmbi_top
      (/*AUTOINST*/
       // Outputs
       .apb_prdata_o			(prdata_pmmbi[31:0]),	 // Templated
       .apb_pready_o			(pready_pmmbi),		 // Templated
       .apb_pslverr_o			(pslverr_pmmbi),	 // Templated
       .irq_out_o			(irq_out_pmmbi),	 // Templated
       .s_axi_awready_o			(awready_s_pmmbi),	 // Templated
       .s_axi_wready_o			(wready_s_pmmbi),	 // Templated
       .s_axi_bid_o			(bid_s_pmmbi[9:0]),	 // Templated
       .s_axi_bresp_o			(bresp_s_pmmbi[1:0]),	 // Templated
       .s_axi_bvalid_o			(bvalid_s_pmmbi),	 // Templated
       .s_axi_arready_o			(arready_s_pmmbi),	 // Templated
       .s_axi_rid_o			(rid_s_pmmbi[9:0]),	 // Templated
       .s_axi_rdata_o			(rdata_s_pmmbi[127:0]),	 // Templated
       .s_axi_rresp_o			(rresp_s_pmmbi[1:0]),	 // Templated
       .s_axi_rlast_o			(rlast_s_pmmbi),	 // Templated
       .s_axi_rvalid_o			(rvalid_s_pmmbi),	 // Templated
       .m_axi_awid_o			(awid_m_pmmbi[9:0]),	 // Templated
       .m_axi_awaddr_o			(awaddr_m_pmmbi[39:0]),	 // Templated
       .m_axi_awlen_o			(awlen_m_pmmbi[7:0]),	 // Templated
       .m_axi_awsize_o			(awsize_m_pmmbi[2:0]),	 // Templated
       .m_axi_awburst_o			(awburst_m_pmmbi[1:0]),	 // Templated
       .m_axi_awvalid_o			(awvalid_m_pmmbi),	 // Templated
       .m_axi_wdata_o			(wdata_m_pmmbi_int),	 // Templated
       .m_axi_wstrb_o			(wstrb_m_pmmbi_int),	 // Templated
       .m_axi_wlast_o			(wlast_m_pmmbi),	 // Templated
       .m_axi_wvalid_o			(wvalid_m_pmmbi),	 // Templated
       .m_axi_bready_o			(bready_m_pmmbi),	 // Templated
       .m_axi_arid_o			(arid_m_pmmbi[9:0]),	 // Templated
       .m_axi_araddr_o			(araddr_m_pmmbi[39:0]),	 // Templated
       .m_axi_arlen_o			(arlen_m_pmmbi[7:0]),	 // Templated
       .m_axi_arsize_o			(arsize_m_pmmbi[2:0]),	 // Templated
       .m_axi_arburst_o			(arburst_m_pmmbi[1:0]),	 // Templated
       .m_axi_arvalid_o			(arvalid_m_pmmbi),	 // Templated
       .m_axi_rready_o			(rready_m_pmmbi),	 // Templated
       .hirq_req_o			(),			 // Templated
       .hirq_type_o			(),			 // Templated
       // Inputs
       .clk_apb				(pclk),			 // Templated
       .rst_apb_ni			(presetn),		 // Templated
       .apb_psel_i			(psel_pmmbi),		 // Templated
       .apb_penable_i			(penable),		 // Templated
       .apb_pwrite_i			(pwrite),		 // Templated
       .apb_paddr_i			(paddr[11:0]),		 // Templated
       .apb_pwdata_i			(pwdata[31:0]),		 // Templated
       .apb_pstrb_i			(pstrb[3:0]),		 // Templated
       .clk_axi				(aclk),			 // Templated
       .rst_axi_ni			(aresetn),		 // Templated
       .s_axi_awid_i			(awid_s_pmmbi[9:0]),	 // Templated
       .s_axi_awaddr_i			(awaddr_s_pmmbi[39:0]),	 // Templated
       .s_axi_awlen_i			(awlen_s_pmmbi[7:0]),	 // Templated
       .s_axi_awsize_i			(awsize_s_pmmbi[2:0]),	 // Templated
       .s_axi_awburst_i			(awburst_s_pmmbi[1:0]),	 // Templated
       .s_axi_awlock_i			('b0),			 // Templated
       .s_axi_awcache_i			('b0),			 // Templated
       .s_axi_awprot_i			('b0),			 // Templated
       .s_axi_awqos_i			('b0),			 // Templated
       .s_axi_awuser_i			('b0),			 // Templated
       .s_axi_awvalid_i			(awvalid_s_pmmbi),	 // Templated
       .s_axi_wdata_i			(wdata_s_pmmbi[127:0]),	 // Templated
       .s_axi_wstrb_i			(wstrb_s_pmmbi[(128)/8-1:0]), // Templated
       .s_axi_wlast_i			(wlast_s_pmmbi),	 // Templated
       .s_axi_wvalid_i			(wvalid_s_pmmbi),	 // Templated
       .s_axi_bready_i			(bready_s_pmmbi),	 // Templated
       .s_axi_arid_i			(arid_s_pmmbi[9:0]),	 // Templated
       .s_axi_araddr_i			(araddr_s_pmmbi[39:0]),	 // Templated
       .s_axi_arlen_i			(arlen_s_pmmbi[7:0]),	 // Templated
       .s_axi_arsize_i			(arsize_s_pmmbi[2:0]),	 // Templated
       .s_axi_arburst_i			(arburst_s_pmmbi[1:0]),	 // Templated
       .s_axi_arlock_i			('b0),			 // Templated
       .s_axi_arcache_i			('b0),			 // Templated
       .s_axi_arprot_i			('b0),			 // Templated
       .s_axi_arqos_i			('b0),			 // Templated
       .s_axi_aruser_i			('b0),			 // Templated
       .s_axi_arvalid_i			(arvalid_s_pmmbi),	 // Templated
       .s_axi_rready_i			(rready_s_pmmbi),	 // Templated
       .clk_pmmbi			(clk_pmmbi),
       .rst_pmmbi_ni			(resetn_pmmbi),		 // Templated
       .m_axi_awready_i			(awready_m_pmmbi),	 // Templated
       .m_axi_wready_i			(wready_m_pmmbi),	 // Templated
       .m_axi_bid_i			(bid_m_pmmbi[9:0]),	 // Templated
       .m_axi_bresp_i			(bresp_m_pmmbi[1:0]),	 // Templated
       .m_axi_bvalid_i			(bvalid_m_pmmbi),	 // Templated
       .m_axi_arready_i			(arready_m_pmmbi),	 // Templated
       .m_axi_rid_i			(rid_m_pmmbi[9:0]),	 // Templated
       .m_axi_rdata_i			(rdata_m_pmmbi[31:0]),	 // Templated
       .m_axi_rresp_i			(rresp_m_pmmbi[1:0]),	 // Templated
       .m_axi_rlast_i			(rlast_m_pmmbi),	 // Templated
       .m_axi_rvalid_i			(rvalid_m_pmmbi),	 // Templated
       .test_en_i			(1'b0));			 // Templated

assign wstrb_m_pmmbi = {12'h0, wstrb_m_pmmbi_int};
assign wdata_m_pmmbi = {96'h0, wdata_m_pmmbi_int};

endmodule
// Local Variables:
// verilog-library-directories:("." "../../6_ip/common_ip/x2x/v1/ms_axi_async" "./pcie_ep_x2p" "../../6_ip/pcie_ep/rtl/core" "../../6_ip/axi_bridge/nic400_axi4_to_axi3/nic400/verilog" "../../6_ip/axi3_id_converter" "../../6_ip/Host2BMC/v1/1_rtl/top/" "../../6_ip/MCTP_VDM/v1/1_rtl/" "../../6_ip/PBMC/v1/1_rtl/" "../../6_ip/PCIE_MMBI/v1/1_rtl/")
// verilog-auto-inst-param-value:t
// End:

