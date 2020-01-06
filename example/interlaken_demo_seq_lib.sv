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
`ifndef INTERLAKEN_DEMO_SEQ_LIB_SV
`define INTERLAKEN_DEMO_SEQ_LIB_SV

//------------------------------------------------------------------------------
// SEQUENCE LIBRARY: interlaken_demo_seq_lib
//------------------------------------------------------------------------------
// SEQUENCE: example_interlaken_seq
// SEQUENCE: example_interlaken_seq
// SEQUENCE: example_interlaken_seq
// SEQUENCE: example_interlaken_seq
//-------------------------------------------------------------------
class interlaken_demo_seq_lib extends uvm_sequence_library #(interlaken_transfer);

  `uvm_object_utils(interlaken_demo_seq_lib)
  `uvm_sequence_library_utils(interlaken_demo_seq_lib)

  function new(string name="interlaken_demo_seq_lib");
    super.new(name);
    // built-in fields
    min_random_count = 1;
    max_random_count = 5;
    // add sequences for this library
    add_sequence(example_interlaken_seq::get_type());
    add_sequence(simple_response_seq::get_type());
    init_sequence_library();
  endfunction

  task body();
    super.body();
    this.print();
  endtask : body

endclass : interlaken_demo_seq_lib

class interlaken_demo_seq_lib2 extends interlaken_demo_seq_lib;

  `uvm_object_utils(interlaken_demo_seq_lib2)
  `uvm_sequence_library_utils(interlaken_demo_seq_lib2)

  function new(string name="interlaken_demo_seq_lib2");
    super.new(name);
    // built-in fields
    min_random_count = 3;
    max_random_count = 8;
    // remove sequence for this library extension
    remove_sequence(simple_response_seq::get_type());
    //init_sequence_library();
  endfunction

  task body();
   fork
    super.body();
    #800 remove_sequence(example_interlaken_seq::get_type());
    #1000 add_sequence(simple_response_seq::get_type());
   join
  endtask : body

endclass : interlaken_demo_seq_lib2
`endif // INTERLAKEN_DEMO_SEQ_LIB_SV
