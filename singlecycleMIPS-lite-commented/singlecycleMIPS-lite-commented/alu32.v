module alu32(sum,a,b,zout,gin, statusN,statusV,statusZ,clk);//ALU operation according to the ALU control line values

output [31:0] sum;

input [31:0] a,b; 
input [3:0] gin;//ALU control line
input clk;

reg [31:0] sum;
reg [31:0] less;

output zout;
reg zout;

output reg statusZ, statusN, statusV;
reg tempZ, tempN, tempV;

always @(a or b or gin)
begin
    // Initialize temporary status flags
    tempZ = 0;
    tempN = 0;
    tempV = 0;

    case(gin)
    4'b0010: begin
        sum=a+b;         //ALU control line=0010, ADD
		if ((a[31]&b[31]&(~sum[31]) )| ((~a[31])&(~b[31])&(sum[31]))) tempV=1;
        end
    4'b0110: begin
        sum=a+1+(~b);    //ALU control line=0110, SUB
		if ((a[31]&(~b[31])&(~sum[31])) | ((~a[31])&(b[31])&(sum[31]))) tempV=1;
        end
    4'b0111: begin 
        less=a+1+(~b);    //ALU control line=0111, set on less than
        if (less[31]) sum=1;
        else sum=0;
        end
    4'b1111: begin
        if (a[31] || a == 0) sum = a; //ALU control line=1111, pass through
        else sum = 0;
        end 

    4'b0000: sum=a & b;    //ALU control line=0000, AND 
    4'b0001: sum=a|b;        //ALU control line=0001, OR
    4'b1010: sum=~(a | b); // ALU control line=1010, NOR	- nori
    4'b1001: sum=a^b;        //ALU control line=1001, XOR - jmxor
	4'b1000: sum=a;          //ALU control line=1000, BRV
    default: sum=31'bx;
    endcase

	// Set temporary flags based on the current operation
    tempZ = (sum == 0) ? 1 : 0;
    tempN = sum[31];

zout=~(|sum);
end

always @(posedge clk) begin
	 // Update status flags at the positive edge of the clock
    statusZ = tempZ;
    statusN = tempN;
    statusV = tempV;
end
endmodule

//blezal olayı sikintili