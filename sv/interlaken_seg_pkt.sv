class interlaken_seg_pkt extends uvm_sequence_item;
  
  string tID=get_type_name();
  int        tr_id;
  int        burst_id;
  int        seg_id;
  bit[127:0] datain;
  bit[10:0]  chain;
  bit        enain; 
  bit        sopin; 
  bit        eopin; 
  bit        errin; 
  bit[3:0]   mtyin; 
  bit        bctlin;  
  bit        burst_end;
//  rand int unsigned transmit_idle;
  
  `uvm_object_utils_begin(interlaken_seg_pkt)
     `uvm_field_int(tr_id,			   UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(burst_id,	     UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(seg_id,			   UVM_ALL_ON|UVM_NOPACK)	
//	   `uvm_field_int(transmit_idle, UVM_ALL_ON|UVM_NOPACK)                                        
	   `uvm_field_int(datain,			   UVM_ALL_ON)
	   `uvm_field_int(chain,		     UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(enain,			   UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(sopin,			   UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(eopin,			   UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(errin,			   UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(mtyin,			   UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(bctlin,			   UVM_ALL_ON|UVM_NOPACK)	   
	   `uvm_field_int(burst_end,	   UVM_ALL_ON|UVM_NOPACK)	
	`uvm_object_utils_end
	
	function new(string name="interlaken_seg_pkt");
		super.new(name);
		datain = 128'b0;
    chain = 11'b0; 
    enain = 1'b0; 
    sopin = 1'b0; 
    eopin = 1'b0; 
    errin = 1'b0; 
    mtyin = 4'b0; 
    bctlin = 1'b0;	
    burst_end = 1'b0;
	endfunction : new



endclass