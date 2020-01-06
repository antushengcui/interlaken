class interlaken_burst_pkt extends uvm_sequence_item;
  
  string tID=get_type_name();
  
  int        tr_id;
  int        burst_id;
  bit[7:0]   payload[];
  bit[10:0]  chain;
//  bit        enain; 
  bit        sopin; 
  bit        eopin; 
//  bit        errin; 
//  bit[3:0]   mtyin; 
//  bit        bctlin;
  
  `uvm_object_utils_begin(interlaken_burst_pkt)
     `uvm_field_int(tr_id,			UVM_ALL_ON|UVM_NOPACK)
     `uvm_field_int(burst_id,	  UVM_ALL_ON|UVM_NOPACK)
     `uvm_field_int(chain,			UVM_ALL_ON|UVM_NOPACK)
     `uvm_field_int(sopin,			UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_int(eopin,			UVM_ALL_ON|UVM_NOPACK)
	   `uvm_field_array_int(payload,	  UVM_ALL_ON)
	   `uvm_field_int(chain,			UVM_ALL_ON|UVM_NOPACK)
//	   `uvm_field_int(enain,			UVM_ALL_ON|UVM_NOPACK)
//	   `uvm_field_int(sopin,			UVM_ALL_ON|UVM_NOPACK)
//	   `uvm_field_int(eopin,			UVM_ALL_ON|UVM_NOPACK)
//	   `uvm_field_int(errin,			UVM_ALL_ON|UVM_NOPACK)
//	   `uvm_field_int(mtyin,			UVM_ALL_ON|UVM_NOPACK)
//	   `uvm_field_int(bctlin,			UVM_ALL_ON|UVM_NOPACK)	   
	`uvm_object_utils_end
	
	function new(string name="interlaken_burst_pkt");
		super.new(name);
//		payload = 128'b0;
    chain = 11'b0; 
//    enain = 1'b0; 
    sopin = 1'b0; 
    eopin = 1'b0; 
//    errin = 1'b0; 
//    mtyin = 4'b0; 
//    bctlin = 1'b0;	
	endfunction : new



endclass