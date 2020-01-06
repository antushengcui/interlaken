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
`ifndef INTERLAKEN_BUS_MONITOR_SV
`define INTERLAKEN_BUS_MONITOR_SV

class interlaken_bus_monitor extends uvm_monitor;

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////

  // Property indicating the number of transactions occuring on the interlaken.
  protected int unsigned num_transactions = 0;

  // FOR UVM_ACCEL
  //protected uvm_abstraction_level_t abstraction_level = RTL;
  //protected uvma_output_pipe_proxy#(interlaken_transfer) m_op;

  //INTERLAKEN Configuration Class
  interlaken_config cfg;

  // This field controls if this has its checkers enabled
  // (by default checkers are on)
  bit checks_enable = 0;

  // This field controls if this has its coverage enabled
  // (by default coverage is on)
  bit coverage_enable = 0;

  // USER: Add your fields here

  // TLM PORT for sending transaction OUT to scoreboard, register database, etc
  uvm_analysis_port #(interlaken_transfer) item_collected_ana_port;

  // TLM Connection to the Collector - look for a write() task implementation
  uvm_analysis_imp  #(interlaken_transfer, interlaken_bus_monitor) item_collected_ana_imp;

  // Allows the sequencer to look at monitored data for responses
  uvm_blocking_peek_imp#(interlaken_transfer,interlaken_bus_monitor) trans_feedback_peek_imp;

  // Allows to look at collector for address information
  uvm_blocking_peek_port#(interlaken_transfer) trans_feedback_peek_port;

  event trans_addr_grabbed;

  // The current interlaken_transfer
  protected interlaken_transfer trans_collected;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(interlaken_bus_monitor)
      `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
      `uvm_field_int(num_transactions, UVM_DEFAULT)
     // USER: Register your fields here
  `uvm_component_utils_end

  // Transfer collected covergroup
  covergroup interlaken_transfer_cg;
    option.per_instance=1;
    // USER implemented coverpoints
    // TRANS_ADDR : coverpoint trans_collected.addr {
    //   bins ZERO = {0};
    //   //bins NON_ZERO = {[1:32'hffffffff]};
    //   bins NON_ZERO = {[1:16'hffff]};
    // }
    // TRANS_DIRECTION : coverpoint trans_collected.direction {
    //   bins READ = {0};
    //   bins WRITE = {1};
    // }
    // TRANS_DATA : coverpoint trans_collected.data {
    //   bins ZERO     = {0};
    //   //bins NON_ZERO = {[1:32'hfffffffe]};
    //   bins NON_ZERO = {[1:8'hfe]};
    //   //bins ALL_ONES = {32'hffffffff};
    //   bins ALL_ONES = {8'hff};
    // }
    // TRANS_ADDR_X_TRANS_DIRECTION: cross TRANS_ADDR, TRANS_DIRECTION;
  endgroup : interlaken_transfer_cg

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    // Create covergroup only if coverage is enabled
    void'(uvm_config_int::get(this, "", "coverage_enable", coverage_enable));
    if (coverage_enable) begin
       interlaken_transfer_cg = new();
       interlaken_transfer_cg.set_inst_name({get_full_name(), ".interlaken_transfer_cg"});
    end
    // Create TLM ports
    item_collected_ana_port = new("item_collected_ana_port", this);
    item_collected_ana_imp = new("item_collected_ana_imp", this);
    trans_feedback_peek_imp = new("trans_feedback_peek_imp", this);
    trans_feedback_peek_port   = new("trans_feedback_peek_port", this);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  extern task peek (output interlaken_transfer trans); // Interface to the sequencer
  // Receives transfers from the collector
  extern virtual function void write(interlaken_transfer trans);
  extern protected function void perform_checks();
  extern virtual protected function void perform_coverage();
  extern virtual function void report_phase(uvm_phase phase);

endclass : interlaken_bus_monitor


// UVM build_phase
function void interlaken_bus_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (cfg == null) begin
    if (!uvm_config_db#(interlaken_config)::get(this, "", "cfg", cfg))
      `uvm_warning("NOCONFIG", "interlaken_config not set for this component")
  end
endfunction : build_phase

// UVM run_phase
task interlaken_bus_monitor::run_phase(uvm_phase phase);
  forever begin
    trans_feedback_peek_port.peek(trans_collected);
    /*`uvm_info(get_type_name(), $sformatf("Address Phase Complete: %h %s ", trans_collected.addr, trans_collected.direction.name() ), UVM_HIGH)*/
    -> trans_addr_grabbed;
  end
endtask : run_phase

// TASK: peek - Allows the sequencer to peek at for responses
task interlaken_bus_monitor::peek(output interlaken_transfer trans);
  @trans_addr_grabbed;
  trans = trans_collected;
endtask

// FUNCTION: write - transaction interface to the collector
function void interlaken_bus_monitor::write(interlaken_transfer trans);
  // Make a copy of the transaction (may not be necessary!)
  $cast(trans_collected, trans.clone());
  num_transactions++;
  `uvm_info(get_type_name(), {"Transaction Collected:\n", trans_collected.sprint()}, UVM_HIGH)
  if (checks_enable) perform_checks();
  if (coverage_enable) perform_coverage();
  // Broadcast transaction to the rest of the environment (module UVC)
  item_collected_ana_port.write(trans_collected);
endfunction : write

// FUNCTION: perform_checks()
function void interlaken_bus_monitor::perform_checks();
  // Add checks here
endfunction : perform_checks

// FUNCTION : perform_coverage()
function void interlaken_bus_monitor::perform_coverage();
  interlaken_transfer_cg.sample();
endfunction : perform_coverage

// FUNCTION: UVM report() phase
function void interlaken_bus_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report: INTERLAKEN collected %0d transfers", num_transactions), UVM_LOW);
endfunction : report_phase

`endif // INTERLAKEN_BUS_MONITOR_SV

