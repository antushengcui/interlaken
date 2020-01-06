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
`ifndef INTERLAKEN_AGENT_SV
`define INTERLAKEN_AGENT_SV

class interlaken_agent extends uvm_agent;

  // This field determines whether an agent is active or passive.
  //uvm_active_passive_enum is_active = UVM_ACTIVE;

  interlaken_if_wrapper vif_inst;

  //------------------------------------------
  // Data Members
  //------------------------------------------
  // Configuration information: (vip_config: name, is_active)
  interlaken_vip_config cfg;

  //------------------------------------------
  // Component Members
  //------------------------------------------
  interlaken_monitor   monitor;
  interlaken_collector collector;
  interlaken_sequencer sequencer;
  interlaken_driver    driver;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(interlaken_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(vif_inst, UVM_DEFAULT | UVM_REFERENCE)
  `uvm_component_utils_end

  //------------------------------------------
  // Methods
  //------------------------------------------

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void update_config(input interlaken_vip_config cfg);

endclass : interlaken_agent

// UVM build_phase
function void interlaken_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  if (cfg == null) begin
    if (!uvm_config_db#(interlaken_vip_config)::get(this, "", "cfg", cfg))
     `uvm_warning("NOCONFIG",
          "Config not set for agent, using default is_active field")
    end
  else
    is_active = cfg.is_active;

  monitor = interlaken_monitor::type_id::create("monitor",this);
  collector = interlaken_collector::type_id::create("collector",this);
  //sequencer = interlaken_sequencer::type_id::create("sequencer",this);
  if(is_active == UVM_ACTIVE) begin
    sequencer = interlaken_sequencer::type_id::create("sequencer",this);
    driver = interlaken_driver::type_id::create("driver",this);
  end

  if (!uvm_config_db#(interlaken_if_wrapper)::get(this, "", "vif_inst", vif_inst)) begin
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif_inst"})
  end
  uvm_config_db#(virtual interlaken_if)::set(this, "*", "vif", vif_inst.intf);

endfunction : build_phase

// UVM connect_phase
function void interlaken_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

  collector.item_collected_ana_port.connect(monitor.item_collected_ana_imp);
  monitor.trans_feedback_peek_port.connect(collector.trans_feedback_peek_imp);
  if (is_active == UVM_ACTIVE) begin
    // Connect the driver to the sequencer using TLM interface
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

// ONLY USED IN THE APB_SUBSYSTEM VERIF ENV - REMOVE
// update_config()
function void interlaken_agent::update_config(input interlaken_vip_config cfg);
  //sequencer.cfg = cfg;
  if (is_active == UVM_ACTIVE) begin
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
endfunction : update_config

`endif // INTERLAKEN_AGENT_SV

