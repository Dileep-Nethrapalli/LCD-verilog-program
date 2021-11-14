`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dilep Nethrapalli
// 
// Create Date: 12.12.2020 09:53:23
// Design Name: 
// Module Name: LCD_controller
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


module LCD_controller_16x2(
         output reg [7:4] LCD_DB,
         output reg LCD_E, LCD_RS, LCD_RW,
         input  Clock_100MHz, Clear_n);
 
   reg count_en; 
   reg [18:0] count;
   

 // Enter Text to be displayed on LCD in strings Line_1 and Line_2.
  // Number of characters in Line_1 and Line_2 must be 16,
  // If number of characters in Line_1 and Line_2 is less than 16, 
  //  fill the remaining characters with blank spaces 
  
    reg [127:0] Line_1, Line_2;  
  
   always@(negedge Clock_100MHz, negedge Clear_n)
    if(!Clear_n)
       begin    
         Line_1 <= {(16){8'h20}}; // 16 Blank Characters
         Line_2 <= {(16){8'h20}}; // 16 Blank Characters
       end  
    else 
       begin    
         Line_1 <= "Hello world!    "; 
         Line_2 <= "Dilip Netrapalli";
       end 
       
    
// FSM for LCD controller of 16 Characters per line and 2 Lines   
  reg [5:0] present_state = 0, next_state = 0; 
   
  parameter [5:0] 
    CLEAR = 6'd0,
    POWER_INIT_1 = 6'd1, POWER_INIT_2 = 6'd2, 
    POWER_INIT_3 = 6'd3, POWER_INIT_4 = 6'd4,
                  
    FUNCTION_SET   = 6'd5, ENTRY_MODE_SET = 6'd6,
    DISPLAY_ON_OFF = 6'd7, CLEAR_DISPLAY  = 6'd8,
                  
    Char_16x1 = 6'd9,  Char_15x1 = 6'd10, Char_14x1 = 6'd11,       Char_13x1 = 6'd12, 
    Char_12x1 = 6'd13, Char_11x1 = 6'd14, Char_10x1 = 6'd15, Char_9x1  = 6'd16, 
    Char_8x1  = 6'd17, Char_7x1  = 6'd18, Char_6x1  = 6'd19, Char_5x1  = 6'd20,
    Char_4x1  = 6'd21, Char_3x1  = 6'd22, Char_2x1  = 6'd23, Char_1x1  = 6'd24,
                  
    DD_RAM_ADDR_40 = 6'd25,
                  
    Char_16x2 = 6'd26, Char_15x2 = 6'd27, Char_14x2 = 6'd28, Char_13x2 = 6'd29, 
    Char_12x2 = 6'd30, Char_11x2 = 6'd31, Char_10x2 = 6'd32, Char_9x2  = 6'd33, 
    Char_8x2  = 6'd34, Char_7x2  = 6'd35, Char_6x2  = 6'd36, Char_5x2  = 6'd37,
    Char_4x2  = 6'd38, Char_3x2  = 6'd39, Char_2x2  = 6'd40, Char_1x2  = 6'd41,
                  
    DD_RAM_ADDR_00 = 6'd42;
                  
                  
 // Sequential Logic 
  always@(posedge Clock_100MHz, negedge Clear_n)
    if(!Clear_n)
       present_state <= CLEAR; 
    else
       present_state <= next_state;       
       
 // Combinational Logic
 always@(present_state, count)   
  case(present_state) 
   CLEAR: begin
            {LCD_DB, LCD_E, LCD_RS, LCD_RW, count_en} = 0;
             next_state = POWER_INIT_1;
          end           
           
   POWER_INIT_1: Init(6'h03, count, 410000, POWER_INIT_2); // 4.1ms delay                 
   POWER_INIT_2: Init(6'h03, count, 10000,  POWER_INIT_3); // 100us delay                                  
   POWER_INIT_3: Init(6'h03, count, 4000,   POWER_INIT_4); // 40us delay                 
   POWER_INIT_4: Init(6'h02, count, 4000,   FUNCTION_SET); // 40us delay
                
   FUNCTION_SET:   Display(10'h028, count, 4000,   ENTRY_MODE_SET); // 40us delay                                                   
   ENTRY_MODE_SET: Display(10'h006, count, 4000,   DISPLAY_ON_OFF); // 40us delay                     
   DISPLAY_ON_OFF: Display(10'h00F, count, 4000,   CLEAR_DISPLAY);  // 40us delay                                                                                                                
   CLEAR_DISPLAY:  Display(10'h001, count, 160000, Char_16x1);     // 1.6ms delay                    
                                                  // 40us delay from here onwards
   Char_16x1: Display({2'b10, Line_1[127:120]}, count, 4000, Char_15x1);                            
   Char_15x1: Display({2'b10, Line_1[119:112]}, count, 4000, Char_14x1);                
   Char_14x1: Display({2'b10, Line_1[111:104]}, count, 4000, Char_13x1);                               
   Char_13x1: Display({2'b10, Line_1[103:96]},  count, 4000, Char_12x1);                            
   Char_12x1: Display({2'b10, Line_1[95:88]},   count, 4000, Char_11x1);                               
   Char_11x1: Display({2'b10, Line_1[87:80]},   count, 4000, Char_10x1);                 
   Char_10x1: Display({2'b10, Line_1[79:72]},   count, 4000, Char_9x1);                              
   Char_9x1:  Display({2'b10, Line_1[71:64]},   count, 4000, Char_8x1);                              
   Char_8x1:  Display({2'b10, Line_1[63:56]},   count, 4000, Char_7x1);                 
   Char_7x1:  Display({2'b10, Line_1[55:48]},   count, 4000, Char_6x1);                
   Char_6x1:  Display({2'b10, Line_1[47:40]},   count, 4000, Char_5x1); 
   Char_5x1:  Display({2'b10, Line_1[39:32]},   count, 4000, Char_4x1);                  
   Char_4x1:  Display({2'b10, Line_1[31:24]},   count, 4000, Char_3x1);                  
   Char_3x1:  Display({2'b10, Line_1[23:16]},   count, 4000, Char_2x1);                
   Char_2x1:  Display({2'b10, Line_1[15:8]},    count, 4000, Char_1x1);                 
   Char_1x1:  Display({2'b10, Line_1[7:0]},     count, 4000, DD_RAM_ADDR_40);                            
            
   DD_RAM_ADDR_40: Display(10'h0C0, count, 4000, Char_16x2);
                   
   Char_16x2: Display({2'b10, Line_2[127:120]}, count, 4000, Char_15x2);                              
   Char_15x2: Display({2'b10, Line_2[119:112]}, count, 4000, Char_14x2);               
   Char_14x2: Display({2'b10, Line_2[111:104]}, count, 4000, Char_13x2);                 
   Char_13x2: Display({2'b10, Line_2[103:96]},  count, 4000, Char_12x2);                           
   Char_12x2: Display({2'b10, Line_2[95:88]},   count, 4000, Char_11x2);                           
   Char_11x2: Display({2'b10, Line_2[87:80]},   count, 4000, Char_10x2);               
   Char_10x2: Display({2'b10, Line_2[79:72]},   count, 4000, Char_9x2);                            
   Char_9x2:  Display({2'b10, Line_2[71:64]},   count, 4000, Char_8x2);                           
   Char_8x2:  Display({2'b10, Line_2[63:56]},   count, 4000, Char_7x2);
   Char_7x2:  Display({2'b10, Line_2[55:48]},   count, 4000, Char_6x2);               
   Char_6x2:  Display({2'b10, Line_2[47:40]},   count, 4000, Char_5x2);                
   Char_5x2:  Display({2'b10, Line_2[39:32]},   count, 4000, Char_4x2);                 
   Char_4x2:  Display({2'b10, Line_2[31:24]},   count, 4000, Char_3x2);                
   Char_3x2:  Display({2'b10, Line_2[23:16]},   count, 4000, Char_2x2);               
   Char_2x2:  Display({2'b10, Line_2[15:8]},    count, 4000, Char_1x2);                
   Char_1x2:  Display({2'b10, Line_2[7:0]},     count, 4000, DD_RAM_ADDR_00);               

   DD_RAM_ADDR_00: Display(10'h080, count, 4000, Char_16x1);                      
                   
   default: begin 
              {LCD_DB, LCD_RS, LCD_RW, LCD_E, count_en} = 0; 
               next_state = POWER_INIT_1; 
            end  
  endcase
  
  
 task Init(  
        input [5:0]  data,
        input [18:0] Count, cen_value,
        input [5:0]  Next_State);        
    begin               
      if((Count >= 1) && (Count <= 17)) 
         {LCD_RS, LCD_RW, LCD_DB} = data;
      else
         {LCD_RS, LCD_RW, LCD_DB} = 0;      
         
      if((Count >= 5) && (Count <= 16)) 
          LCD_E = 1;
      else
          LCD_E  = 0;  
         
      if(cen_value == Count) 
         begin 
           count_en = 0; next_state = Next_State; 
         end 
      else               
         begin 
           count_en = 1; next_state = present_state; 
         end           
    end  
 endtask  
 
 
  task Display(  
        input [9:0]  data,  
        input [18:0] Count, cen_value, 
        input [5:0]  Next_State);        
    begin               
      if((Count >= 1) && (Count <= 28)) 
         {LCD_RS, LCD_RW, LCD_DB} = data[9:4];
      else if((Count >= 124) && (Count <= 151)) 
         {LCD_RS, LCD_RW, LCD_DB} = {data[9:8], data[3:0]};
      else
         {LCD_RS, LCD_RW, LCD_DB} = 0; 
                     
      if(((Count >= 5) && (Count <= 27)) ||
         ((Count >= 128) && (Count <= 150)))
           LCD_E = 1;
      else
           LCD_E = 0;  
         
      if(cen_value == Count) 
         begin 
           count_en = 0; next_state = Next_State; 
         end 
      else               
         begin 
           count_en = 1; next_state = present_state; 
         end     
    end  
 endtask 
 

 // Create a counter to provide delay upto 4.2ms
  // 100MHz = 10ns = 1; 4.2ms = x;
  // x = 420000 = 110 0110 1000 1010 0000b
  always@(posedge Clock_100MHz, negedge Clear_n)
    if(!Clear_n)
       count <= 0;    
    else if(count_en)
       count <= count + 1; 
    else
       count <= 0;
           
endmodule
