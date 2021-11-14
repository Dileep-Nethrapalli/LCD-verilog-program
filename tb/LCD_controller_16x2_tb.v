`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dilep Nethrapalli
// 
// Create Date: 12.12.2020 11:51:30
// Design Name: 
// Module Name: LCD_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LCD_controller_16x2_tb( );

  wire [3:0]  LCD_DB;
  wire LCD_E, LCD_RS, LCD_RW;
  reg Clock_100MHz, Clear_n;
  
  wire count_en;
  wire [5:0] present_state;
  wire [18:0] count;  
  

  LCD_controller_16x2 lcd_DUT(
     .LCD_DB( LCD_DB), .LCD_E(LCD_E), .LCD_RS(LCD_RS), .LCD_RW(LCD_RW),
     .Clock_100MHz(Clock_100MHz), .Clear_n(Clear_n));
                          
                          
  assign count_en = lcd_DUT.count_en;                        
  assign present_state = lcd_DUT.present_state;
  assign count = lcd_DUT.count;  
                        
                          
  initial   Clock_100MHz = 0;
  always #5 Clock_100MHz = ~Clock_100MHz; 
  
  initial
    begin
          Clear_n = 0;
      #50 Clear_n = 1;
      #32300000 $finish;
    end                      

endmodule
