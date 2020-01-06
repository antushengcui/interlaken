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

`ifndef INTERLAKEN_CONFIG_SV
`define INTERLAKEN_CONFIG_SV

// INTERLAKEN vip Configuration Information
class interlaken_vip_config extends uvm_object;

  string name;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  int has_feedback_port = 0;
  int inst_id;
  int vip_id;

  function new (string name = "unnamed-interlaken_vip_config");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  `uvm_object_utils_begin(interlaken_vip_config)
    `uvm_field_string(name, UVM_DEFAULT)
    `uvm_field_int(has_feedback_port, UVM_DEFAULT)
    `uvm_field_int(inst_id, UVM_DEFAULT)
    `uvm_field_int(vip_id, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : interlaken_vip_config

// INTERLAKEN Configuration Information
class interlaken_config extends uvm_object;

  bit has_bus_monitor = 0;

  interlaken_vip_config vip_configs[$];
  int num_vips = 1;

  int inst_id;

  `uvm_object_utils_begin(interlaken_config)
    `uvm_field_int(has_bus_monitor, UVM_DEFAULT)
    `uvm_field_int(num_vips, UVM_DEFAULT)
    `uvm_field_int(inst_id, UVM_DEFAULT)
    `uvm_field_queue_object(vip_configs, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "unnamed-interlaken_config");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  function void set_vip_configs();
    for(int i = 0; i < num_vips; i++) begin
      string inst_name;
      $sformat(inst_name, "vip%0d", i);
      add_vip(inst_name, UVM_ACTIVE,i);
    end
  endfunction : set_vip_configs

  // interlaken_config - Creates and configures a vip agent config and adds to a queue
  function void add_vip(string name, uvm_active_passive_enum is_active = UVM_ACTIVE, int vip_id);
    interlaken_vip_config tmp_vip_cfg;

    tmp_vip_cfg = interlaken_vip_config::type_id::create("vip_config");
    tmp_vip_cfg.name = name;
    tmp_vip_cfg.is_active = is_active;
    tmp_vip_cfg.vip_id = vip_id;
    tmp_vip_cfg.inst_id = inst_id;

    vip_configs.push_back(tmp_vip_cfg);
  endfunction : add_vip
endclass  : interlaken_config

//================================================================
// Default INTERLAKEN configuration
//================================================================
class default_interlaken_config extends interlaken_config;

  `uvm_object_utils(default_interlaken_config)

  function new(string name = "default_interlaken_config-v0v1");
    super.new(name);
    add_vip("vip0",UVM_ACTIVE,0);
  endfunction

endclass : default_interlaken_config

`endif // INTERLAKEN_CONFIG_SV
