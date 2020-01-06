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
class interlaken_demo_config extends interlaken_config;

  `uvm_object_utils(interlaken_demo_config)

  function new(string name = "interlaken_demo_config");
    super.new(name);
    add_vip("vip0",UVM_ACTIVE,0);
  endfunction

endclass
