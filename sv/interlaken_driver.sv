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
`ifndef INTERLAKEN_DRIVER_SV
`define INTERLAKEN_DRIVER_SV

class interlaken_driver extends uvm_driver #(interlaken_transfer);

  //////////////////////////////////////////////////////////////////////////////
  //
  //  Public interface (Component users may manipulate these fields/methods)
  //
  //////////////////////////////////////////////////////////////////////////////

  protected int unsigned num_transactions = 0;

  // The virtual interface used to drive and view HDL signals.
  virtual interlaken_if vif;

  // A pointer to the configuration unit of the agent
  interlaken_vip_config cfg;

  // USER: Add your fields here
  string logs_dir;
  string OUTPUT_FILE_NAME;
  int OUTPUT_FILE;
  int drive_seg_cnt;
  parameter BurstMax = 256;
  parameter BurstMin = 64;
  
  interlaken_seg_pkt seg_inpkt_q[$];
  interlaken_burst_pkt burst_inpkt_q[$];
  int num_multi_four;
	int num_add_seg;
	int rand_idle;
//	bit en_insert_idle;
//	int transmit_idle;	
	int cnt_tr;
	int cnt_burst;
	int cnt_seg;
  
  semaphore drive_burst_sem;
  semaphore drive_bus_sem;
  // This macro performs uvm object creation, type control manipulation, and
  // factory registration
  `uvm_component_utils_begin(interlaken_driver)
     `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
     `uvm_field_string(logs_dir, UVM_DEFAULT)
     `uvm_field_int(num_transactions, UVM_DEFAULT)

     // USER: Register fields here
  `uvm_component_utils_end

  // Constructor which calls super.new() with appropriate parameters.
  function new (string name, uvm_component parent);
    super.new(name, parent);
    drive_bus_sem=new(1);
    drive_burst_sem=new(1);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset();
  extern virtual protected task idle_the_bus();
  extern virtual protected task drive_the_bus();
  extern virtual protected task drive_transfer (interlaken_transfer trans);
//  extern virtual protected task drive_address_phase (interlaken_transfer trans);
  extern virtual protected task drive_data_phase (interlaken_transfer trans);
  extern virtual protected task get_burst(interlaken_transfer trans);
  extern virtual protected task drive_burst();
  extern virtual protected task burst2seg (interlaken_burst_pkt burst_trans);
//  extern virtual protected task seg2vif ();
  

  extern virtual function void record_str(string str_print);

endclass : interlaken_driver

// UVM build_phase
function void interlaken_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(interlaken_vip_config)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG", "interlaken_vip_config not set for this component")
endfunction : build_phase

// UVM connect_phase - gets the vif as a config property
function void interlaken_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if (!uvm_config_db#(virtual interlaken_if)::get(this, "", "vif", vif))
    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
endfunction : connect_phase


// Declaration of the UVM run_phase method.
task interlaken_driver::run_phase(uvm_phase phase);
  `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  get_and_drive();
endtask : run_phase

// This task manages the interaction between the sequencer and driver
task interlaken_driver::get_and_drive();
  while (1) begin
    reset();
    fork
      @(negedge vif.rst)
        // INTERLAKEN_DRIVER tag required for Debug Labs
        `uvm_info("INTERLAKEN_DRIVER", "get_and_drive: Reset dropped", UVM_MEDIUM)
      begin
        // This thread will be killed at reset
        forever begin
//          @(posedge vif.clk iff (vif.rst))
          seq_item_port.get_next_item(req);
          $cast(rsp, req.clone());
          rsp.set_id_info(req);
          drive_transfer(rsp);
          seq_item_port.item_done();
          num_transactions++;
          //seq_item_port.put_response(rsp);
          //rsp.print();
        end
      end
    join_any
    disable fork;
      //If we are in the middle of a transfer, need to end the tx. Also,
      //do any reset cleanup here. The only way we got to this point is via
      //a reset.
      /*if(req.is_active()) this.end_tr(req);*/
  end
endtask : get_and_drive

// Drive all signals to reset state
task interlaken_driver::reset();
  /*wait(!vif.preset);*/
  // INTERLAKEN_DRIVER tag required for Debug Labs
  `uvm_info("INTERLAKEN_DRIVER", $sformatf("Reset observed"), UVM_MEDIUM)
  idle_the_bus();
endtask : reset


// Drives a transfer when an item is ready to be sent.
task interlaken_driver::drive_transfer (interlaken_transfer trans);
  void'(this.begin_tr(trans, "interlaken driver", "UVM Debug",
       "INTERLAKEN driver transaction from get_and_drive"));
/*  if (trans.transmit_delay > 0) begin
    repeat(trans.transmit_delay) @(posedge vif.pclock);
  end*/
//  drive_address_phase(trans);
  drive_data_phase(trans);
//  idle_the_bus();
  // INTERLAKEN_DRIVER_TR tag required for Debug Labs
  `uvm_info(get_type_name(), $sformatf("INTERLAKEN Finished Driving Transfer \n%s",
            trans.sprint()), UVM_MEDIUM)
  this.record_str(trans.sprint());
  this.end_tr(trans);
endtask : drive_transfer

function void interlaken_driver::record_str(string str_print);
  if(logs_dir != "") begin
    this.OUTPUT_FILE_NAME = {this.logs_dir,"/",this.get_full_name(),".log"};
  end
  if(this.OUTPUT_FILE_NAME != "") begin
    this.OUTPUT_FILE = $fopen(this.OUTPUT_FILE_NAME,"a");
    $fdisplay(this.OUTPUT_FILE,str_print);
    $fclose(this.OUTPUT_FILE);
  end
endfunction

function void interlaken_driver::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report: INTERLAKEN Send %0d transfers", num_transactions), UVM_LOW);
endfunction : report_phase

task interlaken_driver::idle_the_bus();
    drive_bus_sem.get(1);
    repeat(1) @(posedge vif.clk);
    
		vif.tx_rdyout <= 1'b0;
		//------------------------//
	  vif.tx_datain0 <= 128'h0;
	  vif.tx_chanin0 <= 11'h0 ;   //idle 可以随机的数据
	  vif.tx_enain0 <= 1'b0;
	  vif.tx_sopin0 <= 1'b0;
	  vif.tx_eopin0 <= 1'b0;
	  vif.tx_errin0 <= 1'b0;
	  vif.tx_mtyin0 <= 4'b0;
	  vif.tx_bctlin0 <= 1'b0;
	  
	  vif.tx_datain1 <= 128'h0;
	  vif.tx_chanin1 <= 11'h0 ;
	  vif.tx_enain1 <= 1'b0;
	  vif.tx_sopin1 <= 1'b0;
	  vif.tx_eopin1 <= 1'b0;
	  vif.tx_errin1 <= 1'b0;
	  vif.tx_mtyin1 <= 4'b0;
	  vif.tx_bctlin1 <= 1'b0;
    
	  vif.tx_datain2 <= 128'h0;
	  vif.tx_chanin2 <= 11'h0 ;
	  vif.tx_enain2 <= 1'b0;
	  vif.tx_sopin2 <= 1'b0;
	  vif.tx_eopin2 <= 1'b0;
	  vif.tx_errin2 <= 1'b0;
	  vif.tx_mtyin2 <= 4'b0;
	  vif.tx_bctlin2 <= 1'b0;
	  
	  vif.tx_datain3 <= 128'h0;
	  vif.tx_chanin3 <= 11'h0 ;
	  vif.tx_enain3 <= 1'b0;
	  vif.tx_sopin3 <= 1'b0;
	  vif.tx_eopin3 <= 1'b0;
	  vif.tx_errin3 <= 1'b0;
	  vif.tx_mtyin3 <= 4'b0;
	  vif.tx_bctlin3 <= 1'b0;
//    repeat(1) @(posedge vif.clk);
    drive_bus_sem.put(1);
endtask: idle_the_bus

task interlaken_driver::drive_the_bus();
//  `uvm_info("",$sformatf("in the time %t drive the seg_tr to bus",$realtime),UVM_LOW)
   bit en_insert_idle;
   drive_bus_sem.get(1);
   
	 begin
		 interlaken_seg_pkt seg_pkt[4];		
		 bit temp_tx_rdyout;
	   foreach(seg_pkt[i]) begin
	   	if(seg_inpkt_q.size >=1 && en_insert_idle==0) begin
	   		seg_pkt[i] = seg_inpkt_q.pop_front();
	   		temp_tx_rdyout = 1'b1;
	   		if(seg_pkt[i].burst_end ==1 ) begin
	   			//随机生成时候是否插入idle,通过使能信号en_insert_idle
	   			int is_insert = {$random}%2; 
		   		if(is_insert)	 begin 	en_insert_idle = 1; end
		   		else           begin  en_insert_idle = 0;	end	   		 		   		
		   	end
	   	end
	   	else begin
	   		seg_pkt[i] = new($sformatf("seg_pkt[%0d]",i)); 
	   		temp_tx_rdyout = 1'b0;
	   	end
	   	`uvm_info("",$sformatf("the seg2vif num=%d seg_tr=%s",i,seg_pkt[i].sprint()),UVM_HIGH)
	   end
	   
	   
	   repeat(1) @(posedge vif.clk);
	   
	   //驱动信号
	   vif.tx_rdyout <= temp_tx_rdyout;
		 //------------------------//
		 vif.tx_datain0 <= seg_pkt[0].datain;
		 vif.tx_chanin0 <= seg_pkt[0].chain ;
		 vif.tx_enain0  <= seg_pkt[0].enain;
		 vif.tx_sopin0  <= seg_pkt[0].sopin;
		 vif.tx_eopin0  <= seg_pkt[0].eopin;
		 vif.tx_errin0  <= seg_pkt[0].errin;
		 vif.tx_mtyin0  <= seg_pkt[0].mtyin;
		 vif.tx_bctlin0 <= seg_pkt[0].bctlin;
		 
		 vif.tx_datain1 <= seg_pkt[1].datain;
		 vif.tx_chanin1 <= seg_pkt[1].chain ;
		 vif.tx_enain1  <= seg_pkt[1].enain;
		 vif.tx_sopin1  <= seg_pkt[1].sopin;
		 vif.tx_eopin1  <= seg_pkt[1].eopin;
		 vif.tx_errin1  <= seg_pkt[1].errin;
		 vif.tx_mtyin1  <= seg_pkt[1].mtyin;
		 vif.tx_bctlin1 <= seg_pkt[1].bctlin;
		 
		 vif.tx_datain2 <= seg_pkt[2].datain;
		 vif.tx_chanin2 <= seg_pkt[2].chain ;
		 vif.tx_enain2  <= seg_pkt[2].enain;
		 vif.tx_sopin2  <= seg_pkt[2].sopin;
		 vif.tx_eopin2  <= seg_pkt[2].eopin;
		 vif.tx_errin2  <= seg_pkt[2].errin;
		 vif.tx_mtyin2  <= seg_pkt[2].mtyin;
		 vif.tx_bctlin2 <= seg_pkt[2].bctlin;
		 
		 vif.tx_datain3 <= seg_pkt[3].datain;
		 vif.tx_chanin3 <= seg_pkt[3].chain ;
		 vif.tx_enain3  <= seg_pkt[3].enain;
		 vif.tx_sopin3  <= seg_pkt[3].sopin;
		 vif.tx_eopin3  <= seg_pkt[3].eopin;
		 vif.tx_errin3  <= seg_pkt[3].errin;
		 vif.tx_mtyin3  <= seg_pkt[3].mtyin;
		 vif.tx_bctlin3 <= seg_pkt[3].bctlin;
		 
//		 repeat(1) @(posedge vif.clk);			  		 
	 end
	 drive_bus_sem.put(1);
	 
	 //决定是否插入IDLE
	 if(en_insert_idle==1) begin
	 	  int transmit_idle = {$random} % 9; //随机间隔
		 	repeat(transmit_idle) begin
		 		idle_the_bus();
		 	end
		 	`uvm_info("",$sformatf("--------get into the Idle insert,and the transmit_idle=%d, the en_insert_idle=%d-------",transmit_idle,en_insert_idle),UVM_LOW)
		 	en_insert_idle=0;
	 end  
	 
	
   
endtask: drive_the_bus


// Drive the data phase of the transfer
task interlaken_driver::drive_data_phase (interlaken_transfer trans);

  fork
  	this.get_burst(trans);
  	this.drive_burst();
	join_any
//	disable fork;
endtask : drive_data_phase

task interlaken_driver::get_burst(interlaken_transfer trans);
	int pkt_bsz, pkt_len, pkt_remainder,burst_len; 
	int data_transfer;
	int bytes_cnt;
  byte unsigned bytes[];
  bit [7:0] trans_byte[$];
    
  trans.tr_id = cnt_tr;
  cnt_tr++;
  
  pkt_bsz = trans.pack_bytes(bytes);
  pkt_len = pkt_bsz/8;  
  pkt_remainder = pkt_len;
  burst_len = pkt_len/BurstMax + 1;

  foreach(bytes[i]) begin
  	trans_byte.push_back(bytes[i]);
  end
  //-----------------------//
  for(int i=0;i<burst_len;i++) begin
  	interlaken_burst_pkt new_burst_pkt;
  	new_burst_pkt = new("new_burst_pkt");
  	
  	if(pkt_remainder >=BurstMax + BurstMin) begin
  		data_transfer = BurstMax;  		 		
  	end
  	else begin
  		if((pkt_len % BurstMax < BurstMin) && (pkt_remainder > BurstMax)) begin
  			data_transfer = BurstMax - BurstMin;
  		end
  		else begin
  			data_transfer = pkt_remainder;
  		end
  	end  	
  	pkt_remainder = pkt_remainder - data_transfer;
  	
  	//组织成burst形式 	
  	new_burst_pkt.payload = new[data_transfer];
  	foreach(new_burst_pkt.payload[i]) begin
  		new_burst_pkt.payload[i]= trans_byte.pop_front();  			
    end
    new_burst_pkt.chain = trans.eth_pkt.chan;
    if(i==0) new_burst_pkt.sopin = 1; else new_burst_pkt.sopin = 0;
    if(i==burst_len-1) new_burst_pkt.eopin = 1; else  new_burst_pkt.eopin = 0;    
    new_burst_pkt.tr_id = trans.tr_id;
    new_burst_pkt.burst_id = cnt_burst;
    cnt_burst++;
    burst_inpkt_q.push_back(new_burst_pkt);
    `uvm_info("",$sformatf("the get_burst num=%d burst_tr=%s",i,new_burst_pkt.sprint()),UVM_HIGH)
    this.burst2seg(new_burst_pkt);
  end

endtask:get_burst

task interlaken_driver::burst2seg(interlaken_burst_pkt burst_trans);
  bit [7:0] trans_bytes[];
  bit [7:0] data_send[];
  bit is_multi_sixteen;
  int send_seg_count;
  int data_position;
  bit [3:0]  temp_mtyin;
  
  burst_trans.pack_bytes(trans_bytes);
  is_multi_sixteen = (trans_bytes.size % 16 == 0)? 0:1;
  send_seg_count = trans_bytes.size/16 + is_multi_sixteen;
  temp_mtyin = 16 - trans_bytes.size % 16; 
  data_send = new[send_seg_count*16];   
  foreach(data_send[i]) data_send[i] = 8'h00;
  for(int i=0;i<trans_bytes.size();i++) begin
  	data_send[i] = trans_bytes[i];  	
  end  
  
  for(int i=0;i<send_seg_count;i++) begin
		interlaken_seg_pkt new_seg_pkt;
		new_seg_pkt = new("new_seg_pkt");
		new_seg_pkt.datain = {data_send[i*16+0],data_send[i*16+1],data_send[i*16+2],data_send[i*16+3],
		                      data_send[i*16+4],data_send[i*16+5],data_send[i*16+6],data_send[i*16+7],
		                      data_send[i*16+8],data_send[i*16+9],data_send[i*16+10],data_send[i*16+11],
		                      data_send[i*16+12],data_send[i*16+13],data_send[i*16+14],data_send[i*16+15]}; 
		                      
		new_seg_pkt.chain = burst_trans.chain;
		new_seg_pkt.enain = 1'b1;
		if(i==0 && burst_trans.sopin==1) new_seg_pkt.sopin = 1'b1; else new_seg_pkt.sopin = 1'b0;
		if(i==send_seg_count-1 && burst_trans.eopin==1) new_seg_pkt.eopin = 1'b1; else new_seg_pkt.eopin = 1'b0;
		new_seg_pkt.errin = 1'b0;
		if(i==send_seg_count-1 && burst_trans.eopin==1) new_seg_pkt.mtyin = temp_mtyin; else new_seg_pkt.mtyin = 4'b0;
		new_seg_pkt.bctlin = 1'b0;
		if(i==send_seg_count-1 && burst_trans.eopin==1) new_seg_pkt.burst_end = 1'b1; else new_seg_pkt.burst_end = 1'b0;
		new_seg_pkt.burst_id = burst_trans.burst_id;
		new_seg_pkt.seg_id = cnt_seg;
		cnt_seg++;
	  seg_inpkt_q.push_back(new_seg_pkt);
		drive_seg_cnt++;
		`uvm_info("",$sformatf("the burst2seg num=%d seg_tr=%s",drive_seg_cnt,new_seg_pkt.sprint()),UVM_HIGH)
  end
  
  
endtask:burst2seg

task interlaken_driver::drive_burst();
  do begin	  
  	drive_burst_sem.get(1);
//  	bit en_insert_idle;
		drive_the_bus();
		drive_burst_sem.put(1);
  end while(seg_inpkt_q.size >=1);
  idle_the_bus();

endtask: drive_burst

`endif // INTERLAKEN_DRIVER_SV
