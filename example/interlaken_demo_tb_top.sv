//------------------------------------------------------------------------------
// Company      :   CHENXIAOTECH
//
//                  Copyright(c) 2014, CHENXIAO Technologies Co., Ltd.
//                  All rights reserved
//------------------------------------------------------------------------------
/***************************************************************************
 *
 * Author:      $Author:$
 * File:        $File:$
 * Revision:    $Revision:$
 * Date:        $Date:$
 *
 *******************************************************************************
 */

//`timescale 1ns/100ps

`include "interlaken_dut_dummy.v"
`include "interlaken_if.sv"
`include "interlaken_pkg.sv"

module interlaken_demo_tb_top;

  // Import the UVM Package
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Import the Ethernet UVC Package
  import interlaken_pkg::*;

  // Include the test library
//  `include "interlaken_scoreboard.sv"s
  `include "interlaken_demo_tb.sv"
  
  //-----------------------------
  `include "interlaken_test_lib.sv"

  reg clock;
  reg reset;

  interlaken_if interlaken_if_0(clock, reset);
  interlaken_if_wrapper  interlaken_if_0_inst = new("interlaken_if_0");


  interlaken_dut_dummy dut( .interlaken_clock(clock),
                            .interlaken_reset(reset),
                									
														//---------------------------------------//
														.rx_datain0   (interlaken_if_0.tx_datain0),
														.rx_chanin0   (interlaken_if_0.tx_chanin0),
														.rx_enain0    (interlaken_if_0.tx_enain0),
														.rx_sopin0    (interlaken_if_0.tx_sopin0),
														.rx_eopin0    (interlaken_if_0.tx_eopin0),
														.rx_errin0    (interlaken_if_0.tx_errin0),
														.rx_mtyin0    (interlaken_if_0.tx_mtyin0),
					//									.rx_bctlin0   (interlaken_if_0.tx_bctlin0),
														                               
														.rx_datain1   (interlaken_if_0.tx_datain1),
														.rx_chanin1   (interlaken_if_0.tx_chanin1),
														.rx_enain1    (interlaken_if_0.tx_enain1),
														.rx_sopin1    (interlaken_if_0.tx_sopin1),
														.rx_eopin1    (interlaken_if_0.tx_eopin1),
														.rx_errin1    (interlaken_if_0.tx_errin1),
														.rx_mtyin1    (interlaken_if_0.tx_mtyin1),
					//									.rx_bctlin1   (interlaken_if_0.tx_bctlin1),
														                               
														.rx_datain2   (interlaken_if_0.tx_datain2),
														.rx_chanin2   (interlaken_if_0.tx_chanin2),
														.rx_enain2    (interlaken_if_0.tx_enain2),
														.rx_sopin2    (interlaken_if_0.tx_sopin2),
														.rx_eopin2    (interlaken_if_0.tx_eopin2),
														.rx_errin2    (interlaken_if_0.tx_errin2),
														.rx_mtyin2    (interlaken_if_0.tx_mtyin2),
					//									.rx_bctlin2   (interlaken_if_0.tx_bctlin2),
														                               
														.rx_datain3   (interlaken_if_0.tx_datain3),
														.rx_chanin3   (interlaken_if_0.tx_chanin3),
														.rx_enain3    (interlaken_if_0.tx_enain3),
														.rx_sopin3    (interlaken_if_0.tx_sopin3),
														.rx_eopin3    (interlaken_if_0.tx_eopin3),
														.rx_errin3    (interlaken_if_0.tx_errin3),
														.rx_mtyin3    (interlaken_if_0.tx_mtyin3),
					//									.rx_bctlin3   (interlaken_if_0.tx_bctlin3),
														//---------------------------------------//
														.tx_datain0   (interlaken_if_0.rx_dataout0),
														.tx_chanin0   (interlaken_if_0.rx_chanout0),
														.tx_enain0    (interlaken_if_0.rx_enaout0),
														.tx_sopin0    (interlaken_if_0.rx_sopout0),
														.tx_eopin0    (interlaken_if_0.rx_eopout0),
														.tx_errin0    (interlaken_if_0.rx_errout0),
														.tx_mtyin0    (interlaken_if_0.rx_mtyout0),
					//									.tx_bctlin0   (interlaken_if_0.rx_bctlin0),
														
														.tx_datain1   (interlaken_if_0.rx_dataout1),
														.tx_chanin1   (interlaken_if_0.rx_chanout1),
														.tx_enain1    (interlaken_if_0.rx_enaout1),
														.tx_sopin1    (interlaken_if_0.rx_sopout1),
														.tx_eopin1    (interlaken_if_0.rx_eopout1),
														.tx_errin1    (interlaken_if_0.rx_errout1),
														.tx_mtyin1    (interlaken_if_0.rx_mtyout1),
					//									.tx_bctlin1   (interlaken_if_0.rx_bctlin1),
														
														.tx_datain2   (interlaken_if_0.rx_dataout2),
														.tx_chanin2   (interlaken_if_0.rx_chanout2),
														.tx_enain2    (interlaken_if_0.rx_enaout2),
														.tx_sopin2    (interlaken_if_0.rx_sopout2),
														.tx_eopin2    (interlaken_if_0.rx_eopout2),
														.tx_errin2    (interlaken_if_0.rx_errout2),
														.tx_mtyin2    (interlaken_if_0.rx_mtyout2),
					//									.tx_bctlin2   (interlaken_if_0.rx_bctlin2),
														
														.tx_datain3   (interlaken_if_0.rx_dataout3),
														.tx_chanin3   (interlaken_if_0.rx_chanout3),
														.tx_enain3    (interlaken_if_0.rx_enaout3),
														.tx_sopin3    (interlaken_if_0.rx_sopout3),
														.tx_eopin3    (interlaken_if_0.rx_eopout3),
														.tx_errin3    (interlaken_if_0.rx_errout3),
														.tx_mtyin3    (interlaken_if_0.rx_mtyout3)
					//									.tx_bctlin3   (interlaken_if_0.rx_bctlin3)
					//                 .interlaken_if(interlaken_if_0)
               );

  initial begin
    interlaken_if_0_inst.set_intf(interlaken_if_0);
    uvm_config_db#(interlaken_if_wrapper)::set(null, "*.interlaken_tb0.interlaken_inst*", "vif_inst", interlaken_if_0_inst);
    uvm_config_db#(interlaken_if_wrapper)::set(null, "*.interlaken_tb0.interlaken_inst.vips*", "vif_inst", interlaken_if_0_inst);
    run_test();
  end

  initial begin
    reset <= 1'b0;
    clock <= 1'b0;
    #51 reset = 1'b1;
  end

  //Generate Clock
  always
    #1.67 clock = ~clock;  //300m

endmodule
