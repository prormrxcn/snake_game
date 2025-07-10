`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: prormrxcn
// 
// Create Date: 06/23/2025 06:36:44 PM
// Design Name: 
// Module Name: PWM
// Project Name: test_esp_1
// Target Devices: xc7a35tcpg236
// Tool Versions: 2025.1
// Description:  pwn signal generation for making a microcontroller
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWM(
    input clk,
    input switch,
    output reg sig
);
    parameter period_length = 200000000;
    parameter pulse_width = 25000000;
    
    reg [31:0] counter = 0;
    
    always @(posedge clk) begin
    if(switch)begin
        counter <= (counter == period_length - 1) ? 0 : counter + 1;
        sig <= (counter < pulse_width);
        end
        else begin
            counter<=0;
            sig<=0;
        end
    end
endmodule