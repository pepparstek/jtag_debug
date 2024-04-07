// fpga_arty
`timescale 1ns / 1ps

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



  localparam JDATA_WIDTH = 32;
  localparam DMI_DATAWIDTH = 40;
  (* KEEP = "TRUE" *)reg [  JDATA_WIDTH-1:0] jtag_data;
  (* KEEP = "TRUE" *)reg [DMI_DATAWIDTH-1:0] dmi_inc_data;

  initial begin
    jtag_data[JDATA_WIDTH-1:0] = 'h10e31913;
    dmi_inc_data[DMI_DATAWIDTH-1:0] = 'h000000000;
  end





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







  // (* KEEP = "TRUE" *)logic DT_CAPTURE;
  // (* KEEP = "TRUE" *)logic DT_DRCK;
  // (* KEEP = "TRUE" *)logic DT_RESET;
  // (* KEEP = "TRUE" *)logic DT_RUNTEST;
  // (* KEEP = "TRUE" *)logic DT_SEL;
  // (* KEEP = "TRUE" *)logic DT_SHIFT;
  // (* KEEP = "TRUE" *)logic DT_TCK;
  // (* KEEP = "TRUE" *)logic DT_TDI;
  // (* KEEP = "TRUE" *)logic DT_TMS;
  // (* KEEP = "TRUE" *)logic DT_UPDATE;
  // (* KEEP = "TRUE" *)logic DT_TDO;


  // DTMCS
  // BSCANE2 #(
  //     .JTAG_CHAIN(3)  // USER3 0x22
  // ) bse2_dtmcs_inst (
  //     .CAPTURE(DT_CAPTURE),  // 1-bit output: CAPTURE output from TAP controller.
  //     .DRCK(DT_DRCK),       // 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or
  //     // SHIFT are asserted.

  //     .RESET(DT_RESET),  // 1-bit output: Reset output for TAP controller.
  //     .RUNTEST(DT_RUNTEST), // 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
  //     .SEL(DT_SEL),  // 1-bit output: USER instruction active output.
  //     .SHIFT(DT_SHIFT),  // 1-bit output: SHIFT output from TAP controller.
  //     .TCK(DT_TCK),  // 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
  //     .TDI(DT_TDI),  // 1-bit output: Test Data Input (TDI) output from TAP controller.
  //     .TMS(DT_TMS),  // 1-bit output: Test Mode Select output. Fabric connection to TAP.
  //     .UPDATE(DT_UPDATE),  // 1-bit output: UPDATE output from TAP controller
  //     .TDO(DT_TDO)  // 1-bit input: Test Data Output (TDO) input for USER function.
  // );


  // assign DT_TDO = jtag_data[0];
  // assign dt_data_valid = DT_SHIFT & DT_SEL;


  (* KEEP = "TRUE" *)logic DM_CAPTURE;
  (* KEEP = "TRUE" *)logic DM_DRCK;
  (* KEEP = "TRUE" *)logic DM_RESET;
  (* KEEP = "TRUE" *)logic DM_RUNTEST;
  (* KEEP = "TRUE" *)logic DM_SEL;
  (* KEEP = "TRUE" *)logic DM_SHIFT;
  (* KEEP = "TRUE" *)logic DM_TCK;
  (* KEEP = "TRUE" *)logic DM_TDI;
  (* KEEP = "TRUE" *)logic DM_TMS;
  (* KEEP = "TRUE" *)logic DM_UPDATE;
  (* KEEP = "TRUE" *)logic DM_TDO;

  // DMI
  BSCANE2 #(
      .JTAG_CHAIN(4)  // Value for USER command. USER4 0x23
  ) bse2_dmi_inst (
      .CAPTURE(DM_CAPTURE),  // 1-bit output: CAPTURE output from TAP controller.
      .DRCK(DM_DRCK),       // 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or
      // SHIFT are asserted.

      .RESET(DM_RESET),  // 1-bit output: Reset output for TAP controller.
      .RUNTEST(DM_RUNTEST), // 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
      .SEL(DM_SEL),  // 1-bit output: USER instruction active output.
      .SHIFT(DM_SHIFT),  // 1-bit output: SHIFT output from TAP controller.
      .TCK(DM_TCK),  // 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
      .TDI(DM_TDI),  // 1-bit output: Test Data Input (TDI) output from TAP controller.
      .TMS(DM_TMS),  // 1-bit output: Test Mode Select output. Fabric connection to TAP.
      .UPDATE(DM_UPDATE),  // 1-bit output: UPDATE output from TAP controller
      .TDO(DM_TDO)  // 1-bit input: Test Data Output (TDO) input for USER function.
  );

  assign DM_TDO = dmi_inc_data[0];
  assign dm_data_valid = DM_SHIFT & DM_SEL;




  always_comb begin
    if (sw[1]) begin
      for (integer k = 0; k < LedWidth; k++) begin
        led_r[k] = 0;
        led_g[k] = 0;
        led_b[k] = 0;
      end
    end else begin
      led_r[0] <= r_count[22];
      led_r[1] = DM_TCK;
      led_r[2] = DM_TDI;
      led_r[3] = DM_TMS;
    end
  end
  assign led_r[1] = DM_TCK;
  assign led_r[2] = DM_TDI;
  assign led_r[3] = DM_TMS;




  always @(posedge DM_TCK) begin
    if (dm_data_valid) begin
      // jtag_data[JDATA_WIDTH-1:0] <= {DT_TDI, jtag_data[JDATA_WIDTH-1:1]};
      dmi_inc_data[DMI_DATAWIDTH-1:0] <= {DM_TDI, dmi_inc_data[DMI_DATAWIDTH-1:1]};
    end
  end






  dmi_error_e error_d, error_q;
  //dtmcs_t dtmcs_d, dtmcs_q;

  dtmcs_t dtmcs_d = '{
      zero         : '0,
      errinfo      : '0,
      dtmhardreset : 1'b0,
      dmireset     : 1'b0,
      zero_        : '0,
      idle         : 3'd1,  // 1: Enter Run-Test/Idle and leave it immediately
      dmistat      : error_q,  // 0: No error, 2: Op failed, 3: too fast
      abits        : 6'd7,  // The size of address in dmi
      version      : 4'd1  // Version described in spec version 0.13 (and later?)
  };

  // DMI test array
  (* KEEP = "TRUE" *) reg [31:0] dmi_test_arr[3:0];
  (* KEEP = "TRUE" *) logic [31:0] dmi_read_data;
  (* KEEP = "TRUE" *) logic [1:0] dmi_read_op;
  (* KEEP = "TRUE" *) logic [5:0] dmi_read_addr;

  always_comb begin
    //dtmcs_d = dtmcs_q;

    // if (DT_CAPTURE) begin
    //   if (DT_SEL) begin
    //     dtmcs_d = '{
    //         zero         : '0,
    //         errinfo      : '0,
    //         dtmhardreset : 1'b0,
    //         dmireset     : 1'b0,
    //         zero_        : '0,
    //         idle         : 3'd1,  // 1: Enter Run-Test/Idle and leave it immediately
    //         dmistat      : error_q,  // 0: No error, 2: Op failed, 3: too fast
    //         abits        : 6'd7,  // The size of address in dmi
    //         version      : 4'd1  // Version described in spec version 0.13 (and later?)
    //     };
    //   end
    // end

    // if (DT_SHIFT) begin
    //   if (DT_SEL) begin
    //     dtmcs_d <= {DT_TDI, 31'(dtmcs_q >> 1)};
    //   end
    // end
    if (DM_SEL) begin
      if (DM_SHIFT) begin
        dmi_read_addr = dmi_inc_data[39:34];
        dmi_read_data = dmi_inc_data[33:2];
        dmi_read_op   = dmi_inc_data[1:0];
        case (dmi_read_op)
          DMINop: dmi_test_arr[dmi_read_addr] = 'hffffffff;
          DMIRead: dmi_read_data = dmi_test_arr[dmi_read_addr];
          DMIWrite: dmi_test_arr[dmi_read_addr] = dmi_read_data;
          DMIReserved: dmi_test_arr[dmi_read_addr] = 'heeeeeeee;
          default: dmi_test_arr[dmi_read_addr] = 'hfefefefe;
        endcase

      end
    end

  end

endmodule
