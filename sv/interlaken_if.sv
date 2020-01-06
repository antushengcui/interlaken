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
`ifndef INTERLAKEN_IF_SV
`define INTERLAKEN_IF_SV

interface interlaken_if (input clk, input rst);

  // Control flags
  bit                has_checks = 1;
  bit                has_coverage = 1;
  
  logic tx_rdyout;
  
  logic [127:0] tx_datain0;
  logic [10:0] tx_chanin0;
  logic tx_enain0;
  logic tx_sopin0;
  logic tx_eopin0;
  logic tx_errin0;
  logic [3:0] tx_mtyin0;
  logic tx_bctlin0;

  logic [127:0] tx_datain1;
  logic [10:0] tx_chanin1;
  logic tx_enain1;
  logic tx_sopin1;
  logic tx_eopin1;
  logic tx_errin1;
  logic [3:0] tx_mtyin1;
  logic tx_bctlin1;

  logic [127:0] tx_datain2;
  logic [10:0] tx_chanin2;
  logic tx_enain2;
  logic tx_sopin2;
  logic tx_eopin2;
  logic tx_errin2;
  logic [3:0] tx_mtyin2;
  logic tx_bctlin2;
  
  logic [127:0] tx_datain3;
  logic [10:0] tx_chanin3;
  logic tx_enain3;
  logic tx_sopin3;
  logic tx_eopin3;
  logic tx_errin3;
  logic [3:0] tx_mtyin3;
  logic tx_bctlin3;
  
  logic [127:0] rx_dataout0;
  logic [10:0] rx_chanout0;
  logic rx_enaout0;        
  logic rx_sopout0;        
  logic rx_eopout0;        
  logic rx_errout0;        
  logic [3:0] rx_mtyout0;  
 
  logic [127:0] rx_dataout1;
  logic [10:0] rx_chanout1;
  logic rx_enaout1;
  logic rx_sopout1;
  logic rx_eopout1;
  logic rx_errout1;
  logic [3:0] rx_mtyout1;
 
  logic [127:0] rx_dataout2;
  logic [10:0] rx_chanout2;
  logic rx_enaout2;
  logic rx_sopout2;
  logic rx_eopout2;
  logic rx_errout2;
  logic [3:0] rx_mtyout2;
  
  logic [127:0] rx_dataout3;
  logic [10:0] rx_chanout3;
  logic rx_enaout3;
  logic rx_sopout3;
  logic rx_eopout3;
  logic rx_errout3;
  logic [3:0] rx_mtyout3;


/*  parameter         PADDR_WIDTH  = 32;
  parameter         PWDATA_WIDTH = 8;
  parameter         PRDATA_WIDTH = PWDATA_WIDTH;

  // Actual Signals
  logic [PADDR_WIDTH-1:0]  paddr;
  logic                    prwd;
  logic [PWDATA_WIDTH-1:0] pwdata;
  logic                    penable;
  logic [15:0]             psel;
  logic [PRDATA_WIDTH-1:0] prdata;
  logic               pslverr;
  logic               pready;*/

endinterface : interlaken_if

`endif // INTERLAKEN_IF_SV
