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
`ifndef INTERLAKEN_ENV_SV
`define INTERLAKEN_ENV_SV

class interlaken_env extends uvm_env;

  // Virtual interface for this environment. This should only be done if the
  // same interface is used for all masters/vips in the environment. Otherwise,
  // Each agent should have its interface independently set.
  interlaken_if_wrapper vif_inst;

  // Environment Configuration Parameters
  interlaken_config cfg;     // INTERLAKEN configuration object

  // The following two bits are used to control whether checks and coverage are
  // done both in the bus monitor class and the interface.
  bit checks_enable = 0;
  bit coverage_enable = 0;

  // Components of the environment
  interlaken_bus_monitor bus_monitor;
  interlaken_bus_collector bus_collector;

  interlaken_agent vips[];

  // This macro performs UVM object creation, type control manipulation, and
  // factory registration
  `uvm_component_utils_begin(interlaken_env)
    `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_object(vif_inst, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
     // USER: Register fields your here
  `uvm_component_utils_end

  // Constructor - Required UVM syntax
  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual function void update_config(interlaken_config cfg);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_vif_enables();

endclass : interlaken_env


function void interlaken_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  if(cfg == null) //begin
    if (!uvm_config_db#(interlaken_config)::get(this, "", "cfg", cfg)) begin
    `uvm_info("NOCONFIG", "Using default_interlaken_config", UVM_MEDIUM)
    $cast(cfg, factory.create_object_by_name("default_interlaken_config","cfg"));
  end

  `uvm_info(get_full_name(), $sformatf("Current Config : \n %s",cfg.sprint()), UVM_HIGH)

  // set the master config
  uvm_config_object::set(this, "*", "cfg", cfg);
  // set the slave configs
  foreach(cfg.vip_configs[i]) begin
    string sname;
    sname = $sformatf("vips[%0d]*", i);
    uvm_config_object::set(this, sname, "cfg", cfg.vip_configs[i]);
  end
  if (cfg.has_bus_monitor) begin
    bus_monitor = interlaken_bus_monitor::type_id::create("bus_monitor",this);
    bus_collector = interlaken_bus_collector::type_id::create("bus_collector",this);
  end

  vips = new[cfg.vip_configs.size()];
  for(int i = 0; i < cfg.vip_configs.size(); i++) begin
    string inst_name;
    $sformat(inst_name, "vips[%0d]", i);
    vips[i] = interlaken_agent::type_id::create(inst_name,this);
  end

  // if (!uvm_config_db#(interlaken_if_wrapper)::get(this, "", "vif_inst", vif_inst)) begin
  //   `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif_inst"})
  // end
  //uvm_config_db#(virtual interlaken_if)::set(this, "bus_collector*", "vif", vif_inst.intf);

endfunction : build_phase

// UVM connect_phase
function void interlaken_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

  if (cfg.has_bus_monitor) begin
    bus_collector.item_collected_ana_port.connect(bus_monitor.item_collected_ana_imp);
    bus_monitor.trans_feedback_peek_port.connect(bus_collector.trans_feedback_peek_imp);
  end

  // Set verbosity level so you don't get so much data in the log file.
  foreach(vips[i]) begin
    //vips[i].monitor = bus_monitor;
    //vips[i].collector = bus_collector;
    // Set verbosity level so you don't get so much data in the log file.
    //vips[i].monitor.set_report_verbosity_level(UVM_NONE);
    //vips[i].collector.set_report_verbosity_level(UVM_NONE);

    if (vips[i].is_active == UVM_ACTIVE && vips[i].cfg.has_feedback_port) begin
      vips[i].sequencer.trans_feedback_peek_port.connect(vips[i].monitor.trans_feedback_peek_imp);
    end

  end
endfunction : connect_phase


// UVM start_of_simulation_phase
function void interlaken_env::start_of_simulation_phase(uvm_phase phase);
  set_report_id_action_hier("CFGOVR", UVM_DISPLAY);
  set_report_id_action_hier("CFGSET", UVM_DISPLAY);
  check_config_usage();
endfunction : start_of_simulation_phase

// update_config() method
function void interlaken_env::update_config(interlaken_config cfg);
  if(cfg.has_bus_monitor) begin
    bus_monitor.cfg = cfg;
    bus_collector.cfg = cfg;
  end

  foreach(vips[i])
    vips[i].update_config(cfg.vip_configs[i]);
endfunction : update_config

// update_vif_enables
task interlaken_env::update_vif_enables();
  // vif_inst.intf.has_checks <= checks_enable;
  // vif_inst.intf.has_coverage <= coverage_enable;
  // forever begin
  //   @(checks_enable || coverage_enable);
  //   vif_inst.intf.has_checks <= checks_enable;
  //   vif_inst.intf.has_coverage <= coverage_enable;
  // end
endtask : update_vif_enables

//UVM run_phase()
task interlaken_env::run_phase(uvm_phase phase);
  fork
    update_vif_enables();
  join
endtask : run_phase

`endif // INTERLAKEN_ENV_SV
