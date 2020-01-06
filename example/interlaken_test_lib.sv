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

`ifndef INTERLAKEN_TEST_LIB_SV
 `define INTERLAKEN_TEST_LIB_SV

//`include "interlaken_demo_tb.sv"

class interlaken_base_test extends uvm_test;

  `uvm_component_utils(interlaken_base_test)

  interlaken_demo_tb interlaken_tb0;
  uvm_table_printer printer;

  function new(string name = "interlaken_base_test",
    uvm_component parent);
    super.new(name,parent);
    printer = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    set_config_int("*", "recording_detail", UVM_FULL);
    // EXAMPLE: disable coverage for the bus_monitor
     //set_config_int("interlaken_tb0.interlaken_inst.bus_monitor", "coverage_enable", 0);
     //uvm_config_int::set(this, "interlaken_tb0.interlaken_inst.bus_monitor", "coverage_enable", 0);
     //uvm_config_int::set(this, "*", "coverage_enable", 0);
    // Create the tb
    interlaken_tb0 = interlaken_demo_tb::type_id::create("interlaken_tb0", this);
    // uvm_config_db #(uvm_object_wrapper)::set(this,
    //    "interlaken_tb0.interlaken_inst.vips*.sequencer.run_phase",
    //    "default_sequence", interlaken_base_seq::type_id::get());
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    //EXAMPLE: Set verbosity for the bus monitor
    //interlaken_tb0.interlaken_inst.monitor.set_report_verbosity_level(UVM_FULL);
  endfunction : connect_phase

  // function void end_of_elaboration_phase(uvm_phase phase);
  //  super.end_of_elaboration_phase(phase);
  //  this.print();   // prints the test hierarchy
  // endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    printer.knobs.depth = 5;
    this.print(printer);
    // Use the drain time for this phase
    phase.phase_done.set_drain_time(this, 2000);
  endtask : run_phase

endclass : interlaken_base_test

//----------------------------------------------------------------
// TEST: interlaken_example_test
//----------------------------------------------------------------
class interlaken_example_test extends interlaken_base_test;

  `uvm_component_utils(interlaken_example_test)

  function new(string name = "interlaken_example_test", uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // Set the default sequence for the master and slaves
    uvm_config_db #(uvm_object_wrapper)::set(this,
       "interlaken_tb0.interlaken_inst.vips*.sequencer.run_phase",
       "default_sequence", example_interlaken_seq::type_id::get());
    // Create the tb
    super.build_phase(phase);
  endfunction : build_phase

endclass : interlaken_example_test

   
   
`endif


