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
 ****************************************************************************/

`ifndef INC_INTERLAKEN_DEMO_TB_SV
 `define INC_INTERLAKEN_DEMO_TB_SV

//------------------------------------------------------------------------------
//
// CLASS: interlaken_tb
//
//------------------------------------------------------------------------------

//import interlaken_pkg::*;

`include "interlaken_demo_config.sv"
`include "interlaken_demo_seq_lib.sv"
`include "interlaken_seq_lib.sv"
//`include "interlaken_scoreboard.sv"

class interlaken_demo_tb extends uvm_env;
   interlaken_env interlaken_inst;
   interlaken_demo_config interlaken_demo_cfg;
//   interlaken_scoreboard interlaken_scb;

   // Provide implementations of virtual methods such as get_type_name and create
   `uvm_component_utils_begin(interlaken_demo_tb)
   `uvm_component_utils_end

   // new
   function new (string name, uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : interlaken_demo_tb

// UVM build_phase
function void interlaken_demo_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  interlaken_demo_cfg = interlaken_demo_config::type_id::create("interlaken_demo_cfg");
  uvm_config_object::set(this, "interlaken_inst*", "cfg", interlaken_demo_cfg);
  for(int i = 0; i < interlaken_demo_cfg.vip_configs.size(); i++) begin
    string sname;
    sname = $sformatf("interlaken_inst.vips[%0d]*", i);
    uvm_config_object::set(this, sname, "cfg", interlaken_demo_cfg.vip_configs[i]);
  end
  interlaken_inst = interlaken_env::type_id::create("interlaken_inst", this);
//  interlaken_scb = interlaken_scoreboard::type_id::create("interlaken_scb", this);

 //Create Scoreboard -
 // scoreboard0 = interlaken_demo_scoreboard::type_id::create("scoreboard0", this);
endfunction : build_phase

// UVM connect_phase
function void interlaken_demo_tb::connect_phase(uvm_phase phase);
  //Connect slave monitor to scoreboard

 // interlaken_inst.vips[0].monitor.item_collected_ana_port.connect(scoreboard0.item_collected_imp);
//  interlaken_inst.vips[0].monitor.item_collected_ana_port.connect(interlaken_scb.recv_export);
//  interlaken_inst.vips[0].sequencer.item_seq_ana_port.connect(interlaken_scb.send_export);

endfunction : connect_phase


`endif // INC_INTERLAKEN_DEMO_TB_SV

