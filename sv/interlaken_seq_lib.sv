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
`ifndef INTERLAKEN_SEQ_LIB_SV
`define INTERLAKEN_SEQ_LIB_SV

//------------------------------------------------------------------------------
// SEQUENCE: default
//------------------------------------------------------------------------------
typedef class interlaken_transfer;
typedef class interlaken_sequencer;

class interlaken_base_seq extends uvm_sequence #(interlaken_transfer);

  function new(string name="interlaken_base_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(interlaken_base_seq)
  `uvm_declare_p_sequencer(interlaken_sequencer)

// Use a base sequence to raise/drop objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running sequence '",
                                              get_full_name(), "'"});
      `uvm_info(get_full_name(), "Executing", UVM_LOW)
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
      `uvm_info(get_full_name(), "Completed", UVM_LOW)
  endtask

endclass : interlaken_base_seq

class example_interlaken_seq extends interlaken_base_seq;

    function new(string name="");
      super.new(name);
    endfunction : new

  `uvm_object_utils(example_interlaken_seq)

    interlaken_transfer this_transfer;

    virtual task body();
      `uvm_info(get_type_name(), "Starting example sequence", UVM_LOW)
      #300;
      repeat(30) begin
        `uvm_do_on_with(this_transfer,p_sequencer,{
                        this_transfer.eth_pkt.kind == ethgx_transfer::NONE;
                        this_transfer.eth_pkt.layer2_tr.is_mpls == 1'b0;
                        this_transfer.eth_pkt.layer2_tr.eth_kind == layer2_transfer::ETHERNET_II;
                        this_transfer.eth_pkt.layer2_tr.layer3_tr.layer3_kind == layer3_transfer::IPV4;
                       })
      end
      `uvm_info(get_type_name(), $psprintf("Done example sequence: %s",this_transfer.convert2string()), UVM_LOW)
    endtask

endclass : example_interlaken_seq

//------------------------------------------------------------------------------
// SEQUENCE: simple_response_seq
//------------------------------------------------------------------------------
class simple_response_seq extends uvm_sequence #(interlaken_transfer);

  function new(string name="simple_response_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq)
  `uvm_declare_p_sequencer(interlaken_sequencer)

  interlaken_transfer req;
  interlaken_transfer util_transfer;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_LOW)
    forever begin
      p_sequencer.trans_feedback_peek_port.peek(util_transfer);
/*      if((util_transfer.direction == APB_READ) &&
        (p_sequencer.cfg.check_address_range(util_transfer.addr) == 1)) begin
        `uvm_info(get_type_name(), $sformatf("Address:%h Range Matching read.  Responding...", util_transfer.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction == APB_READ; } )
      end*/
      `uvm_do(req);
    end
  endtask : body

endclass : simple_response_seq

// USER: Add your sequences here

`endif // INTERLAKEN_SEQ_LIB_SV

