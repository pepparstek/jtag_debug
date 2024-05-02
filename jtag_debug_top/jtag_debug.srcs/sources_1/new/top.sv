// jtag_debug
`timescale 1ns / 1ps

// Tested on Arch Linux x86_64, Kernel: 6.8.5-arch1-1
// Board: Arty A7. xc7a35t
// Simple USB between board and host computer.


// In this simpler implementation we assume all transactions are handeled fast enough
// Therefore DTM_RSP_READY and DM_REQ_READY as well as DMIBusy are not implemented
// as checks yet.



// Prerequisites:
// 1) Have Vivado installed. Current version 2023.2.
// 2) If you have not generate the project before -> Move to directory jtag_debug
// and open terminal.
// Generate the project with the tcl file: vivado -mode tcl -source jtag_debug.tcl
// 2) Have run Synthesis/Implementation/Generate Bitstream
// 3) Open Hardware Manager -> Open Target -> Auto Connect.
// 4) Program Device and choose the .bit file generated by Generate Bitstream

// ################ GENERAL WORKFLOW FOR XSDB ################
// During testing we selected clk_gen/inst/clk_in_clk_wiz_0 as debug clock for
// all debug signals.
// Generated bitstream with debug signals -> Auto Connect -> Program device
// -> xsdb. In the debug window you set the a trigger signal on DMI_SEL and
// then run the xsdb commands below.

// ################ RUNNING XSDB FOR DMI ################
// Have debug signals for the DM registers, DMI signals, dmi_data.
// You should see a terminal output giving you some information then finally see: xsdb%
// Run the following:
// Replace [path to] with your path to the jtag_debug directory.
// This script rearranges the bytes so that what you write appears in that
// order in the registers. They are written byte-wise.

// 1) source [path to]/jtag_debug/scripts/jtag_reorder.tcl
// 2) connect
// 3) jtag targets

// This will spit out enumerated options to choose from. Choose the option that reflects
// xc7a35t in our case. Our option matched with the second option. Then select it with:
// 4) jtag targets 2

// Set up a sequence so that you can perform reads. Run:
// 5) set jseq [jtag sequence]
// Now you have two options. Either send a write request or read request.
//
// If you need to construct your own hex command then one way is to write the
// bits: addr_data_op 000001_11111111111111111111111111111111_10
// and convert this with a binary to hex converter online. This command will
// selects address 1, data FFFFFFFF, op 2(write). 07FFFFFFFE
// WRITE request: -state is where we end up after, we always used IDLE.
// -hex 6 specifies irlen 6. 23 is the JTAG USER4 in hex for this board.
// Can be different in another board.
// Look at specifications for that board.
//
// 6) xsdb% $jseq irshift -state IDLE -hex 6 23
// 7) xsdb% $jseq drshift -state IDLE -hex 40 [jtag_reorder 07FFFFFFFE]
// 8) xsdb% $jseq run
// 9) xsdb% $jseq clear
//
// This operation will happen the next time CAPTURE goes high.



import arty_pkg::*;

module top (
    input sysclk,

    output LedT led,
    output LedT led_r,
    output LedT led_g,
    output LedT led_b,
    input  SwT  sw,

    output logic rx,  // seen from host side
    input  logic tx,

    input BtnT btn
);
  import debug_pkg::*;

  logic clk;
  logic [31:0] r_count;
  logic locked;

  // DTMCS and DMI datastreams
  localparam DTMCS_DATAWIDTH = 32;
  localparam DMI_DATAWIDTH = 40;
  localparam DM_REGISTER_SIZE = 6;


  (* KEEP = "TRUE" *) reg [DTMCS_DATAWIDTH-1:0] dtmcs_data;
  (* KEEP = "TRUE" *) reg [DMI_DATAWIDTH-1:0] dmi_data;
  (* KEEP = "TRUE" *) reg [31:0] dm_register[DM_REGISTER_SIZE - 1];
  // dm_register won't show up in netlist for debugging unless assigned as below??
  (* KEEP = "TRUE" *) logic [31:0] dm_reg0;
  (* KEEP = "TRUE" *) logic [31:0] dm_reg1;
  (* KEEP = "TRUE" *) logic [31:0] dm_reg2;
  (* KEEP = "TRUE" *) logic [31:0] dm_reg3;
  (* KEEP = "TRUE" *) logic [31:0] dm_reg4;
  (* KEEP = "TRUE" *) logic [31:0] dm_reg5;

  (* KEEP = "TRUE" *)assign dm_reg0 = dm_register[0];
  (* KEEP = "TRUE" *)assign dm_reg1 = dm_register[1];
  (* KEEP = "TRUE" *)assign dm_reg2 = dm_register[2];
  (* KEEP = "TRUE" *)assign dm_reg3 = dm_register[3];
  (* KEEP = "TRUE" *)assign dm_reg4 = dm_register[4];
  (* KEEP = "TRUE" *)assign dm_reg5 = dm_register[5];

  // ################ DTM/DM communication ################
  // Explanation:
  // Used for telling the state machine when it can process a request/response
  dmi_interface_signals_t dmi_interface_signals;  // NOT IMPLEMENTED YET






  // ################ DMI Specifics ################

  // Initializing DMI structs
  dmi_t dmi_resp, dmi_req;
  dmi_state_e dmi_state;
  dmi_op_e dmi_ops;

  (* KEEP = "TRUE" *) logic dmi_clear;
  assign DMI_TDO   = dmi_data[0];
  // Had to remove DMI_RESET from dmi_clear. For some reason it forces a reset
  // after DMI_UPDATE which overwrites the dmi_req and dmi_resp registers and
  // no data can be handled. DMI_RESET seems to run every so often.
  assign dmi_clear = dtmcs.dmireset || sw[1];
  (* KEEP = "TRUE" *)logic running;  // Not really used.
  (* KEEP = "TRUE" *)logic write_enabled;  // Enabled by default. If op == read, then don't write
  logic [1:0] error_in, error_out;  // Handles errors during runs

  // Debug signals
  (* KEEP = "TRUE" *) logic [DM_REGISTER_SIZE - 1:0] dmi_req_addr;
  (* KEEP = "TRUE" *) logic [31:0] dmi_req_data;
  (* KEEP = "TRUE" *) logic [1:0] dmi_req_op;
  assign dmi_req_addr = dmi_req.address;
  assign dmi_req_data = dmi_req.data;
  assign dmi_req_op   = dmi_req.op;

  (* KEEP = "TRUE" *) logic [DM_REGISTER_SIZE - 1:0] dmi_resp_addr;
  (* KEEP = "TRUE" *) logic [31:0] dmi_resp_data;
  (* KEEP = "TRUE" *) logic [1:0] dmi_resp_op;
  assign dmi_resp_addr = dmi_resp.address;
  assign dmi_resp_data = dmi_resp.data;
  assign dmi_resp_op   = dmi_resp.op;











  clk_wiz_0 clk_gen (
      // Clock in ports
      .clk_in1(sysclk),
      // Clock out ports
      .clk_out1(clk),
      // Status and control signals
      .reset(sw[0]),
      .locked
  );

  // clock divider
  always @(posedge clk) begin
    r_count <= r_count + 1;
  end

















  // Setting up scanchain for DMI
  (* KEEP = "TRUE" *)logic DMI_CAPTURE;
  (* KEEP = "TRUE" *)logic DMI_DRCK;
  (* KEEP = "TRUE" *)logic DMI_RESET;
  (* KEEP = "TRUE" *)logic DMI_RUNTEST;
  (* KEEP = "TRUE" *)logic DMI_SEL;
  (* KEEP = "TRUE" *)logic DMI_SHIFT;
  (* KEEP = "TRUE" *)logic DMI_TCK;
  (* KEEP = "TRUE" *)logic DMI_TDI;
  (* KEEP = "TRUE" *)logic DMI_TMS;
  (* KEEP = "TRUE" *)logic DMI_UPDATE;
  (* KEEP = "TRUE" *)logic DMI_TDO;

  // DMI
  BSCANE2 #(
      .JTAG_CHAIN(4)  // Value for USER command. USER4 0x23
  ) bse2_dmi_inst (
      // Outputs
      .CAPTURE(DMI_CAPTURE),  // 1-bit output: CAPTURE output from TAP controller.
      .DRCK(DMI_DRCK),         // 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or
                               // SHIFT are asserted.
      .RESET(DMI_RESET),  // 1-bit output: Reset output for TAP controller.
      .RUNTEST(DMI_RUNTEST),   // 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
      .SEL(DMI_SEL),  // 1-bit output: USER instruction active output.
      .SHIFT(DMI_SHIFT),  // 1-bit output: SHIFT output from TAP controller.
      .TCK(DMI_TCK),  // 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
      .TDI(DMI_TDI),  // 1-bit output: Test Data Input (TDI) output from TAP controller.
      .TMS(DMI_TMS),  // 1-bit output: Test Mode Select output. Fabric connection to TAP.
      .UPDATE(DMI_UPDATE),  // 1-bit output: UPDATE output from TAP controller

      // Inputs
      .TDO(DMI_TDO)  // 1-bit input: Test Data Output (TDO) input for USER function.
  );











  always_comb begin
    if (sw[1]) begin
      for (integer k = 0; k < LedWidth; k++) begin
        led_r[k] = 0;
        led_g[k] = 0;
        led_b[k] = 0;
      end
    end else begin
      led_r[0] <= r_count[22];
    end
  end











  initial begin
    dmi_data[DMI_DATAWIDTH-1:0] <= '0;
    dmi_interface_signals.DTM_RSP_READY = 1;  // Ready for reponse as default.
    dmi_interface_signals.DM_REQ_READY = 1;  // Ready for request as default.
    error_out = DMINoError;
    error_in = DMINoError;
    running = 0;
    write_enabled = 1;
  end











  // ########################### DMI ########################### 
  // DMI OVERVIEW EXPLANATION:
  // JTAG state machine runs CAPTURE -> SHIFT -> UPDATE.
  // In UPDATE, the operation should start..
  // In CAPTURE, we capture the data from the requested operation.
  // DMI should not recieve an error during an operation. If we get UPDATE
  // during an operation in progress, we say the DMI is busy. Error is sticky
  // and needs to be reset by the DTMCS dmireset before running next READ/WRITE next request.
  // This is done by writing the appropriate bit in DTMCS, aka USER3 (0x22)

  // TODO: Implement additional cycles in Run-Test/Idle if DMI was busy. Might not be necessary
  // if the requests are handled fast enough.

  // ################ Error handling DMI ################
  always_comb begin
    if (dmi_req.address > DM_REGISTER_SIZE - 1) begin
      error_in = DMIOpFailed;
    end

    //    if (DMI_UPDATE && running) begin
    //      error_in = DMIBusy;
    //    end

    if (dmi_clear) begin
      error_in = DMINoError;
    end


    dmi_resp.op <= error_in;
    // Propagate the current error into the next iteration
    error_out = error_in;
  end





  // ################ DMI: Request/Response handling ################
  always_comb begin
    if (dmi_clear) begin
      // Should be dtm_clear. It should clear all registers but not implemented.
      // dmi_req <= '0;
      // dmi_resp.address <= '0;
      // dmi_resp.data <= '0;
    end else begin
      if (DMI_UPDATE && DMI_SEL) begin
        dmi_req.address <= dmi_data[DM_REGISTER_SIZE+33:34];
        dmi_req.data <= dmi_data[33:2];
        dmi_req.op <= dmi_data[1:0];

        // Check the previous operation's status. If it succeded, we allow new
        // data to be written/read. Otherwise error is sticky and needs to be
        // reset with dmireset in DTMCS
        unique case (dmi_resp.op)
          DMINoError: begin
            dmi_resp.address = dmi_req.address;
            dmi_resp.data = dm_register[dmi_req.address];
          end

          DMIOpFailed: begin
            dmi_resp.address = dmi_req.address;
            dmi_resp.data = 32'hAAAAAAAA;
            // TODO: Add additional information for dtmcs_err_info
          end

          DMIBusy: begin
            dmi_resp.address = dmi_req.address;
            dmi_resp.data = 32'hBBBBBBBB;
          end

          default: begin
            dmi_resp.address = dmi_req.address;
            dmi_resp.data = 32'hCCCCCCCC;
          end
        endcase
      end
    end

  end


  // ################ DMI: Data handling ################
  always @(posedge DMI_TCK) begin
    if (dmi_clear) begin
      dmi_data[DMI_DATAWIDTH-1:0] <= '0;
    end else begin
      // During the CAPTURE event, we catch the response from the requested
      // operation.
      if (DMI_CAPTURE && DMI_SEL) begin
        running = 1;
        write_enabled = 1;
        unique case (dmi_req.op)
          DMIRead: begin
            dmi_data <= {dmi_resp.address, dmi_resp.data, dmi_resp.op};
            write_enabled = 0;  // If DMIRead operation, we dont want to overwrite the dmi_data buffer
          end

          DMIWrite: begin
            dm_register[dmi_req.address] = dmi_req.data;
          end

          // If any other operation then do nothing.
          default: begin
          end
        endcase
      end

      // Shifts in the instruction recieved
      if (DMI_SHIFT && DMI_SEL && write_enabled) begin
        dmi_data <= {DMI_TDI, dmi_data[DMI_DATAWIDTH-1:1]};
      end

      if (DMI_UPDATE && DMI_SEL) begin
        running = 0;
      end
    end

  end








endmodule


