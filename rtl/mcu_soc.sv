module mcu_soc import mcu_soc_pkg::*; #(
  parameter  string INIT_FILE="",
  parameter  int    INIT_FILE_BIN=0,
  parameter  int    MEM_SIZE_WORDS=4096
  ) (
  input  logic clk,
  input  logic rstn,

  output logic tx,
  input  logic rx
);
  localparam int IdLen = 4;
  localparam int AddrWidth = 32;
  localparam int DataWidth = 32;
  localparam int NBytes = (DataWidth / 8);

  logic [IdLen-1:0]     obi_instr_aid;
  logic                 obi_instr_areq;
  logic                 obi_instr_agnt;
  logic [AddrWidth-1:0] obi_instr_aaddr;
  logic                 obi_instr_awe;
  logic [NBytes-1:0]    obi_instr_abe;
  logic [DataWidth-1:0] obi_instr_awdata;

  logic [IdLen-1:0]     obi_instr_rid;
  logic                 obi_instr_rvalid;
  logic                 obi_instr_rready;
  logic [DataWidth-1:0] obi_instr_rdata;
  logic                 obi_instr_rerr;

  logic [IdLen-1:0]     obi_data_aid;
  logic                 obi_data_areq;
  logic                 obi_data_agnt;
  logic [AddrWidth-1:0] obi_data_aaddr;
  logic                 obi_data_awe;
  logic [NBytes-1:0]    obi_data_abe;
  logic [DataWidth-1:0] obi_data_awdata;

  logic [IdLen-1:0]     obi_data_rid;
  logic                 obi_data_rvalid;
  logic                 obi_data_rready;
  logic [DataWidth-1:0] obi_data_rdata;
  logic                 obi_data_rerr;

  obi_req_t             core_instr_obi_req;
  obi_rsp_t             core_instr_obi_rsp;
  obi_req_t             core_data_obi_req;
  obi_rsp_t             core_data_obi_rsp;
  obi_req_t             xbar_mem_obi_req;
  obi_rsp_t             xbar_mem_obi_rsp;
  obi_req_t             xbar_uart_obi_req;
  obi_rsp_t             xbar_uart_obi_rsp;

  rvj1_obi rvj1_inst (
    .clk_i          (clk),
    .rstn_i         (rstn),

    .instr_aid_o    (obi_instr_aid),
    .instr_areq_o   (obi_instr_areq),
    .instr_agnt_i   (obi_instr_agnt),
    .instr_aaddr_o  (obi_instr_aaddr),
    .instr_awe_o    (obi_instr_awe),
    .instr_abe_o    (obi_instr_abe),
    .instr_awdata_o (obi_instr_awdata),

    .instr_rid_i    (obi_instr_rid),
    .instr_rvalid_i (obi_instr_rvalid),
    .instr_rready_o (obi_instr_rready),
    .instr_rdata_i  (obi_instr_rdata),
    .instr_rerr_i   (obi_instr_rerr),
    
    .data_aid_o     (obi_data_aid),
    .data_areq_o    (obi_data_areq),
    .data_agnt_i    (obi_data_agnt),
    .data_aaddr_o   (obi_data_aaddr),
    .data_awe_o     (obi_data_awe),
    .data_abe_o     (obi_data_abe),
    .data_awdata_o  (obi_data_awdata),

    .data_rid_i     (obi_data_rid),
    .data_rvalid_i  (obi_data_rvalid),
    .data_rready_o  (obi_data_rready),
    .data_rdata_i   (obi_data_rdata),
    .data_rerr_i    (obi_data_rerr),

    .irq_external_i (1'b0),
    .irq_timer_i    (1'b0),
    .irq_sw_i       (1'b0),
    .irq_lcofi_i    (1'b0),
    .irq_platform_i ('0),
    .irq_nmi_i      (1'b0)
  );

  assign core_instr_obi_req.req     = obi_instr_areq;
  assign core_instr_obi_req.rready  = obi_instr_rready;
  assign core_instr_obi_req.a.addr  = obi_instr_aaddr;
  assign core_instr_obi_req.a.we    = obi_instr_awe;
  assign core_instr_obi_req.a.be    = obi_instr_abe;
  assign core_instr_obi_req.a.wdata = obi_instr_awdata;
  assign core_instr_obi_req.a.aid   = obi_instr_aid;

  assign obi_instr_agnt   = core_instr_obi_rsp.gnt;
  assign obi_instr_rvalid = core_instr_obi_rsp.rvalid;
  assign obi_instr_rid    = core_instr_obi_rsp.r.rid;
  assign obi_instr_rdata  = core_instr_obi_rsp.r.rdata;
  assign obi_instr_rerr   = core_instr_obi_rsp.r.err;

  assign core_data_obi_req.req     = obi_data_areq;
  assign core_data_obi_req.rready  = obi_data_rready;
  assign core_data_obi_req.a.addr  = obi_data_aaddr;
  assign core_data_obi_req.a.we    = obi_data_awe;
  assign core_data_obi_req.a.be    = obi_data_abe;
  assign core_data_obi_req.a.wdata = obi_data_awdata;
  assign core_data_obi_req.a.aid   = obi_data_aid;

  assign obi_data_agnt   = core_data_obi_rsp.gnt;
  assign obi_data_rvalid = core_data_obi_rsp.rvalid;
  assign obi_data_rid    = core_data_obi_rsp.r.rid;
  assign obi_data_rdata  = core_data_obi_rsp.r.rdata;
  assign obi_data_rerr   = core_data_obi_rsp.r.err;

  obi_xbar #(
    .SbrPortObiCfg      (ObiCfg),
    .MgrPortObiCfg      (ObiCfg),
    .sbr_port_obi_req_t (obi_req_t),
    .sbr_port_a_chan_t  (obi_a_chan_t),
    .sbr_port_obi_rsp_t (obi_rsp_t),
    .sbr_port_r_chan_t  (obi_r_chan_t),
    .mgr_port_obi_req_t (obi_req_t),
    .mgr_port_obi_rsp_t (obi_rsp_t),
    .NumSbrPorts        (NumManagers),
    .NumMgrPorts        (NumSubordinates),
    .NumMaxTrans        (4),
    .NumAddrRules       (NumSubordinates),
    .addr_map_rule_t    (addr_map_rule_t),
    .UseIdForRouting    (1'b0),
    .Connectivity       ('1)
  ) xbar (
    .clk_i            (clk),
    .rst_ni           (rstn),

    .testmode_i       (1'b0),

    .sbr_ports_req_i  ({core_instr_obi_req, core_data_obi_req}),
    .sbr_ports_rsp_o  ({core_instr_obi_rsp, core_data_obi_rsp}),

    .mgr_ports_req_o  ({xbar_uart_obi_req, xbar_mem_obi_req}),
    .mgr_ports_rsp_i  ({xbar_uart_obi_rsp, xbar_mem_obi_rsp}),

    .addr_map_i       ( Rvj1AddrMap ),
    .en_default_idx_i ('1),
    .default_idx_i    ('0)
  );

  obi_ram #(
    .INIT_FILE     (INIT_FILE),
    .INIT_FILE_BIN (INIT_FILE_BIN),
    .MEM_SIZE_WORDS(MEM_SIZE_WORDS),
    .IDLEN         (IdLen)
  ) mem (
    .clk_i  (clk),
    .rstn_i (rstn),

    .obi_aid_i    (xbar_mem_obi_req.a.aid),
    .obi_areq_i   (xbar_mem_obi_req.req),
    .obi_agnt_o   (xbar_mem_obi_rsp.gnt),
    .obi_aaddr_i  (xbar_mem_obi_req.a.addr),
    .obi_awe_i    (xbar_mem_obi_req.a.we),
    .obi_awdata_i (xbar_mem_obi_req.a.wdata),
    .obi_abe_i    (xbar_mem_obi_req.a.be),

    .obi_rid_o    (xbar_mem_obi_rsp.r.rid),
    .obi_rvalid_o (xbar_mem_obi_rsp.rvalid),
    .obi_rready_i (xbar_mem_obi_req.rready),
    .obi_rdata_o  (xbar_mem_obi_rsp.r.rdata)
  );

  obi_uart #(
    .ObiCfg   (ObiCfg),
    .obi_req_t(obi_req_t),
    .obi_rsp_t(obi_rsp_t)
  ) uart (
    .clk_i  (clk),
    .rst_ni (rstn),

    .obi_req_i (xbar_uart_obi_req),
    .obi_rsp_o (xbar_uart_obi_rsp),

    .rxd_i  (rx),
    .txd_o  (tx),

    .irq_o  (),
    .irq_no (),

    .cts_ni ('1),
    .dsr_ni ('1),
    .ri_ni  ('1),
    .cd_ni  ('1),
    .rts_no (),
    .dtr_no (),
    .out1_no(),
    .out2_no()
  );

endmodule
