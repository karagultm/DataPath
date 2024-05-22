module alu32(sum,a,b,zout,gin);//ALU operation according to the ALU control line values

output [31:0] sum;

input [31:0] a,b; 
input [3:0] gin;//ALU control line

reg [31:0] sum;
reg [31:0] less;

output zout;
reg zout;
always @(a or b or gin)
begin
    case(gin)
    4'b0010: sum=a+b;         //ALU control line=0010, ADD
    4'b0110: sum=a+1+(~b);    //ALU control line=0110, SUB
    4'b0111: begin less=a+1+(~b);    //ALU control line=0111, set on less than
            if (less[31]) sum=1;
            else sum=0;
          end
    4'b0000: sum=a & b;    //ALU control line=0000, AND 
    4'b0001: sum=a|b;        //ALU control line=0001, OR
    4'b1010: sum=~(a | b) // ALU control line=1010, NOR	- nori
    4'b1001: sum=a^b;        //ALU control line=1001, XOR - jmxor
	4'b1000: sum=a           //ALU control line=1000, BRV
    default: sum=31'bx;
    endcase
zout=~(|sum);
end
endmodule

//blezal olayı sikintili