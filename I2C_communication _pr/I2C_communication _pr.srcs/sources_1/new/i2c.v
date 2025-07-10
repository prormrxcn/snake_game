module i2c(output  scl, output reg [6:0] sda, input clk); 
reg [6:0] data;
always@(posedge clk)begin
    sda <=0;
    
end 
endmodule