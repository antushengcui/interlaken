//------------------------------------------------------------------------------
// Company      :   CHENXIAOTECH
//
//                  Copyright(c) 2014, CHENXIAO Technologies Co., Ltd.
//                  All rights reserved
//------------------------------------------------------------------------------
//This is dummy DUT. 

module interlaken_dut_dummy( input interlaken_clock, 
                             input interlaken_reset, 
                         
													   input [127:0] rx_datain0,
													   input [10:0] rx_chanin0,
													   input rx_enain0,
													   input rx_sopin0,        
													   input rx_eopin0,        
													   input rx_errin0,        
													   input [3:0] rx_mtyin0,  
													   
													   input [127:0] rx_datain1,
													   input [10:0] rx_chanin1,
													   input rx_enain1,
													   input rx_sopin1,        
													   input rx_eopin1,        
													   input rx_errin1,        
													   input [3:0] rx_mtyin1,  
													   
													   input [127:0] rx_datain2,
													   input [10:0] rx_chanin2,
													   input rx_enain2,
													   input rx_sopin2,        
													   input rx_eopin2,        
													   input rx_errin2,        
													   input [3:0] rx_mtyin2,  
													   
													   input [127:0] rx_datain3,
													   input [10:0] rx_chanin3,
													   input rx_enain3,
													   input rx_sopin3,        
													   input rx_eopin3,        
													   input rx_errin3,        
													   input [3:0] rx_mtyin3,  
													   
													   //---------------------//
													   output reg [127:0] tx_datain0,
													   output reg [10:0] tx_chanin0,
													   output reg tx_enain0,
													   output reg tx_sopin0,
													   output reg tx_eopin0,
													   output reg tx_errin0,
													   output reg [3:0] tx_mtyin0,
													   output reg tx_bctlin0,
													           
													   output reg [127:0] tx_datain1,
													   output reg [10:0] tx_chanin1,
													   output reg tx_enain1,
													   output reg tx_sopin1,
													   output reg tx_eopin1,
													   output reg tx_errin1,
													   output reg [3:0] tx_mtyin1,
													   output reg tx_bctlin1,
													           
													   output reg [127:0] tx_datain2,
													   output reg [10:0] tx_chanin2,
													   output reg tx_enain2,
													   output reg tx_sopin2,
													   output reg tx_eopin2,
													   output reg tx_errin2,
													   output reg [3:0] tx_mtyin2,
													   output reg tx_bctlin2,
													           
													   output reg [127:0] tx_datain3,
													   output reg [10:0] tx_chanin3,
													   output reg tx_enain3,
													   output reg tx_sopin3,
													   output reg tx_eopin3,
													   output reg tx_errin3,
													   output reg [3:0] tx_mtyin3,
													   output reg tx_bctlin3
													   );


  
  always @(posedge interlaken_clock) begin
  	if(!interlaken_reset) begin
		  tx_datain0 <= 128'b0;
		  tx_chanin0 <= 11'b0;
		  tx_enain0  <= 1'b0;
		  tx_sopin0  <= 1'b0;
		  tx_eopin0  <= 1'b0;
		  tx_errin0  <= 1'b0;
		  tx_mtyin0  <= 4'b0;
		  tx_bctlin0 <= 1'b1;
		  
		  tx_datain1 <= 128'b0;
		  tx_chanin1 <= 11'b0;
		  tx_enain1  <= 1'b0;
		  tx_sopin1  <= 1'b0;
		  tx_eopin1  <= 1'b0;
		  tx_errin1  <= 1'b0;
		  tx_mtyin1  <= 4'b0;
		  tx_bctlin1 <= 1'b1;
		  
		  tx_datain2 <= 128'b0;
		  tx_chanin2 <= 11'b0;
		  tx_enain2  <= 1'b0;
		  tx_sopin2  <= 1'b0;
		  tx_eopin2  <= 1'b0;
		  tx_errin2  <= 1'b0;
		  tx_mtyin2  <= 4'b0;
		  tx_bctlin2 <= 1'b1;
		  
		  tx_datain3 <= 128'b0;
		  tx_chanin3 <= 11'b0;
		  tx_enain3  <= 1'b0;
		  tx_sopin3  <= 1'b0;
		  tx_eopin3  <= 1'b0;
		  tx_errin3  <= 1'b0;
		  tx_mtyin3  <= 4'b0;
		  tx_bctlin3 <= 1'b1;
  	end
  	else begin
  		tx_datain0 <= rx_datain0;
		  tx_chanin0 <= rx_chanin0;
		  tx_enain0  <= rx_enain0;
		  tx_sopin0  <= rx_sopin0;
		  tx_eopin0  <= rx_eopin0;
		  tx_errin0  <= rx_errin0;
		  tx_mtyin0  <= rx_mtyin0;
//		  tx_bctlin0 <= rx_bctlin0;
		  
		  tx_datain1 <= rx_datain1;
		  tx_chanin1 <= rx_chanin1;
		  tx_enain1  <= rx_enain1;
		  tx_sopin1  <= rx_sopin1;
		  tx_eopin1  <= rx_eopin1;
		  tx_errin1  <= rx_errin1;
		  tx_mtyin1  <= rx_mtyin1;
//		  tx_bctlin1 <= rx_bctlin1;
		  
		  tx_datain2 <= rx_datain2;
		  tx_chanin2 <= rx_chanin2;
		  tx_enain2  <= rx_enain2;
		  tx_sopin2  <= rx_sopin2;
		  tx_eopin2  <= rx_eopin2;
		  tx_errin2  <= rx_errin2;
		  tx_mtyin2  <= rx_mtyin2;
//		  tx_bctlin2 <= rx_bctlin2;
		  
		  tx_datain3 <= rx_datain3;
		  tx_chanin3 <= rx_chanin3;
		  tx_enain3  <= rx_enain3;
		  tx_sopin3  <= rx_sopin3;
		  tx_eopin3  <= rx_eopin3;
		  tx_errin3  <= rx_errin3;
		  tx_mtyin3  <= rx_mtyin3;
//		  tx_bctlin3 <= rx_bctlin3;
  	end
  end

endmodule
