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

`ifndef INTERLAKEN_TRANSFER_SV
`define INTERLAKEN_TRANSFER_SV

typedef enum {INTERLAKEN_BOGUS_VAL } interlaken_trans_kind;

class interlaken_transfer extends uvm_sequence_item;
  // USER: Add transaction fields
  rand interlaken_trans_kind      trans_kind;
  
  int BurstMax;
  int BurstShort;
  int BurstMin;
  int inst_id;
  int vip_id;
  int tr_id;
  
  rand bit[10:0] chan;
  rand bit[7:0]  burst[][];
  rand ethgx_transfer eth_pkt;
  bit[7:0] payload[$];     
/*  rand bit [31:0]           addr;
  rand bit [7:0]            data;*/

   // USER: Add constraint blocks
  `uvm_object_utils_begin(interlaken_transfer)
    `uvm_field_enum     (interlaken_trans_kind, trans_kind, UVM_DEFAULT|UVM_NOPACK|UVM_NOCOMPARE)
    // USER: Register fields here
/*    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_int(data, UVM_DEFAULT)*/
//    `uvm_field_int(inst_id, UVM_DEFAULT|UVM_NOPACK|UVM_NOCOMPARE)
//    `uvm_field_int(vip_id, UVM_DEFAULT|UVM_NOPACK|UVM_NOCOMPARE)
    
    `uvm_field_int(tr_id, UVM_DEFAULT|UVM_NOPACK|UVM_NOCOMPARE)
//    `uvm_field_int(chan, UVM_DEFAULT|UVM_NOPACK|UVM_NOCOMPARE)
    `uvm_field_object(eth_pkt,UVM_DEFAULT)
    
    
//    `uvm_field_object_array(eth_pkt,UVM_DEFAULT|UVM_NOPACK|UVM_NOCOMPARE)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "interlaken_transfer");
    super.new(name);
    eth_pkt = new();
//    foreach(eth_pkt[i]) begin
//    	string str;
//    	$sformatf(str,"eth_pkt[%d]",i);
//    	eth_pkt[i] = ut_ethernet_pkt::type_id::create(str,this);
//    end
  endfunction : new
  extern function void post_randomize();

endclass : interlaken_transfer

function void interlaken_transfer::post_randomize();
//	int pkt_bsz, pkt_len, pkt_remainder,burst_len; 
//	int data_transfer;
//	int bytes_cnt;
//  byte unsigned bytes[];
//  pkt_bsz = eth_pkt.pack_bytes(bytes);
//  pkt_len = pkt_bsz/8;  
//  pkt_remainder = pkt_len;
//  burst_len = pkt_len/BurstMax + 1;
//  burst = new[burst_len];
//  //-----------------------//
//  for(int i=0;i<burst_len;i++) begin
//  	if(pkt_remainder >=BurstMax + BurstMin) begin
//  		data_transfer = BurstMax;  		 		
//  	end
//  	else begin
//  		if((pkt_len % BurstMax < BurstMin) && (pkt_remainder > BurstMax)) begin
//  			data_transfer = BurstMax - BurstMin;
//  		end
//  		else begin
//  			data_transfer = pkt_remainder;
//  		end
//  	end  	
//  	pkt_remainder = pkt_remainder - data_transfer;
//  	burst[i] = new[data_transfer]; 
//  	foreach(burst[i][j]) begin
//  		burst[i][j] = bytes[bytes_cnt + j];  			
//    end
//    bytes_cnt+=data_transfer;
//  end
  
endfunction : post_randomize

`endif // INTERLAKEN_TRANSFER_SV

