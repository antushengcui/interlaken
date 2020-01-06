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
`ifndef INTERLAKEN_SEQUENCER_SV
`define INTERLAKEN_SEQUENCER_SV

class interlaken_sequencer extends uvm_sequencer #(interlaken_transfer);

  uvm_blocking_peek_port#(interlaken_transfer) trans_feedback_peek_port;
  uvm_analysis_port #(interlaken_transfer) item_seq_ana_port;

  // Config in case it is needed by the sequencer
  interlaken_vip_config cfg;


  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_sequencer_utils_begin(interlaken_sequencer)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    // USER: Register fields
  `uvm_sequencer_utils_end

  // Constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (cfg == null) begin
        if (!uvm_config_db#(interlaken_vip_config)::get(this, "", "cfg", cfg))
          `uvm_warning("NOCONFIG", "interlaken_vip_config not set for this component")
      end
      if(cfg.has_feedback_port) begin
        trans_feedback_peek_port = new("trans_feedback_peek_port", this);
      end
      item_seq_ana_port = new("item_seq_ana_port", this);
  endfunction : build_phase

endclass : interlaken_sequencer


`endif // INTERLAKEN_SEQUENCER_SV


