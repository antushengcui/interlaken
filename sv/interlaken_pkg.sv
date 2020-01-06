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
`ifndef INTERLAKEN_PKG_SV
`define INTERLAKEN_PKG_SV

package interlaken_pkg;

import uvm_pkg::*;
import ut_packets_pkg::*;
import common_pkg::*;
//import ethgx_pkg::*;

`include "uvm_macros.svh"
`include "interlaken_if_wrapper.sv"

`include "interlaken_burst_pkt.sv"
`include "interlaken_seg_pkt.sv"
`include "interlaken_config.sv"
`include "interlaken_transfer.sv"

`include "interlaken_bus_monitor.sv"
`include "interlaken_bus_collector.sv"

`include "interlaken_monitor.sv"
`include "interlaken_collector.sv"
`include "interlaken_sequencer.sv"
`include "interlaken_driver.sv"
`include "interlaken_agent.sv"
`include "interlaken_seq_lib.sv"

`include "interlaken_env.sv"

endpackage : interlaken_pkg


`endif //  `ifndef INTERLAKEN_PKG_SV
