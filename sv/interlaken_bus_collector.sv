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
`ifndef INTERLAKEN_BUS_COLLECTOR_SV
`define INTERLAKEN_BUS_COLLECTOR_SV

//------------------------------------------------------------------------------
// CLASS: interlaken_bus_collector
//------------------------------------------------------------------------------

class interlaken_bus_collector extends uvm_component;

  // The virtual interface used to view HDL signals.
  virtual interlaken_if vif;

  // INTERLAKEN configuration information
  interlaken_config cfg;

  // Property indicating the number of transactions occuring on the apb.
  protected int unsigned num_transactions = 0;

  // The following two bits are used to control whether checks and coverage are
  // done both in the collector class and the interface.
  bit checks_enable = 0;
  bit coverage_enable = 0;

  // TLM Ports - transfer collected for monitor other components
  uvm_analysis_port #(interlaken_transfer) item_collected_ana_port;

  // TLM Port - Allows sequencer access to transfer during address phase
  uvm_blocking_peek_imp#(interlaken_transfer,interlaken_bus_collector) trans_feedback_peek_imp;
  event trans_feedback_grabbed;

  // The following property holds the transaction information currently
  // being captured (by the collect_address_phase and data_phase methods).
  interlaken_transfer trans_collected;

  //Adding pseudo-memory leakage for heap analysis lab
  `ifdef HEAP
  static interlaken_transfer runq[$];
  `endif

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(interlaken_bus_collector)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_field_int(num_transactions, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = interlaken_transfer::type_id::create("trans_collected");
    // TLM ports are created here
    item_collected_ana_port = new("item_collected_ana_port", this);
    trans_feedback_peek_imp = new("trans_feedback_peek_imp", this);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions();
  extern task peek(output interlaken_transfer trans);
  extern virtual function void report_phase(uvm_phase phase);

endclass : interlaken_bus_collector

// UVM build_phase
function void interlaken_bus_collector::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(interlaken_config)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG", "interlaken_config not set for this component")
endfunction : build_phase

// UVM connect_phase
function void interlaken_bus_collector::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual interlaken_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : connect_phase


// UVM run_phase()
task interlaken_bus_collector::run_phase(uvm_phase phase);
    @(posedge vif.rst);
    `uvm_info("COLLECTOR", "Detected Reset Done", UVM_LOW)
    collect_transactions();
endtask : run_phase

// collect_transactions
task interlaken_bus_collector::collect_transactions();
  forever begin
    @(posedge vif.clk);
    // @(posedge vif.clk iff (vif.psel != 0));
    // void'(this.begin_tr(trans_collected, "interlaken_bus_collector", "UVM Debug",
    //        "INTERLAKEN collector transaction inside collect_transactions()"));
    // trans_collected.addr = vif.paddr;
    // trans_collected.master = cfg.master_config.name;
    // trans_collected.slave = cfg.get_slave_name_by_addr(trans_collected.addr);
    // trans_collected.direction = (vif.prwd == 0) ? INTERLAKEN_READ : INTERLAKEN_WRITE;
    // @(posedge vif.clk);
    // if(trans_collected.direction == INTERLAKEN_READ)
    //   trans_collected.data = vif.prdata;
    // if (trans_collected.direction == INTERLAKEN_WRITE)
    //   trans_collected.data = vif.pwdata;
    // -> trans_feedback_grabbed;
    // @(posedge vif.clk);
    // if(trans_collected.direction == INTERLAKEN_READ) begin
    //     if(vif.pready != 1'b1)
    //       @(posedge vif.clk);
    //   trans_collected.data = vif.prdata;
    //   end
    // this.end_tr(trans_collected);
    // item_collected_ana_port.write(trans_collected);
    // `uvm_info("COLLECTOR", $sformatf("Transfer collected :\n%s",
    //           trans_collected.sprint()), UVM_MEDIUM)
    //   `ifdef HEAP
    //   runq.push_back(trans_collected);
    //   `endif
    //  num_transactions++;
  end
endtask : collect_transactions

task interlaken_bus_collector::peek(output interlaken_transfer trans);
  @trans_feedback_grabbed;
  trans = trans_collected;
endtask : peek

function void interlaken_bus_collector::report_phase(uvm_phase phase);
  super.report_phase(phase);
  `uvm_info("REPORT", $sformatf("INTERLAKEN collector collected %0d transfers", num_transactions), UVM_LOW);
endfunction : report_phase

`endif // INTERLAKEN_BUS_COLLECTOR_SV
