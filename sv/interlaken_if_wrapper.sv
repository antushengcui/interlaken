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

`ifndef INTERLAKEN_IF_WRAPPER_SVH
`define INTERLAKEN_IF_WRAPPER_SVH

class interlaken_if_wrapper extends uvm_object;

`uvm_object_utils(interlaken_if_wrapper)

   virtual interlaken_if intf;

   function new(string name = "interlaken_if_wrapper");
        super.new(name);
   endfunction : new

    function void set_intf(virtual interlaken_if _intf);
        intf = _intf;
    endfunction : set_intf
endclass : interlaken_if_wrapper

`endif // INTERLAKEN_IF_WRAPPER_SVH
