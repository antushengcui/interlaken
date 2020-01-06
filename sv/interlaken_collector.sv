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
`ifndef INTERLAKEN_COLLECTOR_SV
`define INTERLAKEN_COLLECTOR_SV

//------------------------------------------------------------------------------
// CLASS: interlaken_collector
//------------------------------------------------------------------------------

class interlaken_collector extends uvm_component;

  // The virtual interface used to view HDL signals.
  virtual interlaken_if vif;

  // INTERLAKEN configuration information
  interlaken_vip_config cfg;
  interlaken_transfer ilk_trs[int];
  // Property indicating the number of transactions occuring on the apb.
  protected int unsigned num_transactions = 0;
  

  // The following two bits are used to control whether checks and coverage are
  // done both in the collector class and the interface.
  bit checks_enable = 0;
  bit coverage_enable = 0;

  // TLM Ports - transfer collected for monitor other components
  uvm_analysis_port #(interlaken_transfer) item_collected_ana_port;

  // TLM Port - Allows sequencer access to transfer during address phase
  uvm_blocking_peek_imp#(interlaken_transfer,interlaken_collector) trans_feedback_peek_imp;
  event trans_feedback_grabbed;

  // The following property holds the transaction information currently
  // being captured (by the collect_address_phase and data_phase methods).
  interlaken_transfer trans_collected;
  interlaken_seg_pkt  seg_collected[4];

  //Adding pseudo-memory leakage for heap analysis lab
  `ifdef HEAP
  static interlaken_transfer runq[$];
  `endif

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(interlaken_collector)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_field_int(num_transactions, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = interlaken_transfer::type_id::create("trans_collected");
    // TLM ports are created here
    item_collected_ana_port = new("item_collected_ana_port", this);
    trans_feedback_peek_imp = new("trans_feedback_peek_imp", this);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual function void get_seg();
  extern virtual protected task collect_transactions();
  extern task peek(output interlaken_transfer trans);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass : interlaken_collector

// UVM build_phase
function void interlaken_collector::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (cfg == null)
      if (!uvm_config_db#(interlaken_vip_config)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG", "interlaken_vip_config not set for this component")
endfunction : build_phase

// UVM connect_phase
function void interlaken_collector::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (!uvm_config_db#(virtual interlaken_if)::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : connect_phase


// UVM run_phase()
task interlaken_collector::run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    @(posedge vif.rst);
    `uvm_info("COLLECTOR", "Detected Reset Done", UVM_LOW)
    collect_transactions();
endtask : run_phase

// collect_transactions
task interlaken_collector::collect_transactions();
  bit[7:0] trans_bytes[];
  forever begin
    @(posedge vif.clk);
    this.get_seg();
    foreach(seg_collected[i]) begin
    	int position;
    	bit[7:0] seg_bytes[];
    	interlaken_transfer ilk_tr;
//    	`uvm_info("",$sformatf("the seg_collected[%d] = %s",i,seg_collected[i].sprint()),UVM_LOW)
    	if(seg_collected[i].enain == 1) begin    		
 	    	position = seg_collected[i].chain;  //通道为标记	    	
	    	//开始以通道为标记建立新的ilk_tr
	    	if(seg_collected[i].sopin == 1 ) begin //!ilk_trs.exists(position)
	    		ilk_tr = new();
	    		ilk_trs[position] = ilk_tr;
	    	end		    	
	    	//将seg的值采集下来放到 不同position的ilk_tr的数组中    	
	    	seg_collected[i].pack_bytes(seg_bytes);	 	
	    	foreach(seg_bytes[j]) begin
	    		`uvm_info("",$sformatf("the seg_bytes[%d] = %h",j,seg_bytes[j]),UVM_LOW)
          //获取有效的数值	    		
	    		if(j < (16-seg_collected[i].mtyin)) begin
	    			ilk_trs[position].payload.push_back(seg_bytes[j]);
	    		end
	    	end	    	
	    	//最后结束时将不同通道的报文打包成tr
	    	if(seg_collected[i].eopin == 1) begin
//	    		trans_bytes = null;
	    		trans_bytes = new[ilk_trs[position].payload.size];
	    		foreach(trans_bytes[j]) begin 
	    			trans_bytes[j] = ilk_trs[position].payload.pop_front();
	    			`uvm_info("",$sformatf("the trans_bytes[%d]=%h",j,trans_bytes[j]),UVM_LOW)
	    		end
	    		trans_collected.unpack_bytes(trans_bytes);
	    		trans_collected.eth_pkt.chan = position;
          `uvm_info("COLLECTOR", $sformatf("The position=%d Transfer collected :\n%s",
           position,trans_collected.sprint()), UVM_LOW)
				   -> trans_feedback_grabbed;
				    this.end_tr(trans_collected);
//				    trans_collected.cnt_id = num_transactions;
				    item_collected_ana_port.write(trans_collected);
				      `ifdef HEAP
				      runq.push_back(trans_collected);
				      `endif
				     num_transactions++;
	    	end
    	end
    end
   
  end
endtask : collect_transactions

task interlaken_collector::peek(output interlaken_transfer trans);
  @trans_feedback_grabbed;
  trans = trans_collected;
endtask : peek

function void interlaken_collector::report_phase(uvm_phase phase);
  super.report_phase(phase);
  `uvm_info("REPORT", $sformatf("INTERLAKEN collector collected %0d transfers", num_transactions), UVM_LOW);
endfunction : report_phase

function void interlaken_collector::get_seg();
  foreach(seg_collected[i]) begin
  	seg_collected[i] = new($sformatf("seg_collected[%d]",i));
  end
	seg_collected[0].datain = vif.rx_dataout0;
  seg_collected[0].chain  = vif.rx_chanout0;
  seg_collected[0].enain  = vif.rx_enaout0;        
  seg_collected[0].sopin  = vif.rx_sopout0;        
  seg_collected[0].eopin  = vif.rx_eopout0;        
  seg_collected[0].errin  = vif.rx_errout0;        
  seg_collected[0].mtyin  = vif.rx_mtyout0;  
  
  seg_collected[1].datain = vif.rx_dataout1;
  seg_collected[1].chain  = vif.rx_chanout1;
  seg_collected[1].enain  = vif.rx_enaout1;        
  seg_collected[1].sopin  = vif.rx_sopout1;        
  seg_collected[1].eopin  = vif.rx_eopout1;        
  seg_collected[1].errin  = vif.rx_errout1;        
  seg_collected[1].mtyin  = vif.rx_mtyout1;
  
  seg_collected[2].datain = vif.rx_dataout2;
  seg_collected[2].chain  = vif.rx_chanout2;
  seg_collected[2].enain  = vif.rx_enaout2;        
  seg_collected[2].sopin  = vif.rx_sopout2;        
  seg_collected[2].eopin  = vif.rx_eopout2;        
  seg_collected[2].errin  = vif.rx_errout2;        
  seg_collected[2].mtyin  = vif.rx_mtyout2;
  
  seg_collected[3].datain = vif.rx_dataout3;
  seg_collected[3].chain  = vif.rx_chanout3;
  seg_collected[3].enain  = vif.rx_enaout3;        
  seg_collected[3].sopin  = vif.rx_sopout3;        
  seg_collected[3].eopin  = vif.rx_eopout3;        
  seg_collected[3].errin  = vif.rx_errout3;        
  seg_collected[3].mtyin  = vif.rx_mtyout3;
 
endfunction

`endif // INTERLAKEN_COLLECTOR_SV
