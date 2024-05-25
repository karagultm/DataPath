module alucont(aluop2,aluop1,aluop0,f5,f4,f3,f2,f1,f0,gout);//Figure 4.12 
input aluop2,aluop1,aluop0,f5,f4,f3,f2,f1,f0;

output [3:0] gout;

reg [3:0] gout;

always @(aluop2 or aluop1 or aluop0 or f5 or f4 or f3 or f2 or f1 or f0)
begin
if(aluop2) gout = 4'b1111;
if(~(aluop1|aluop0))  gout=4'b0010;
if(aluop0)gout=4'b0110; //aluop 01
if(aluop0&aluop1)gout=4'b1010; //aluop 11 - nori 
if(aluop1)//R-type //aluop 10
begin
	if (f5&(~(f4|f3|f2|f1|f0)))gout=4'b0010; 	//function code=0000,ALU control=010 (add)
	if ((f5)&(~f4)&(~f3)&(~f2)&(f1)&(~f0))gout=4'b0110;		//function code=0x10,ALU control=110 (sub)
	if ((f5)&(~f4)&(~f3)&(f2)&(~f1)&(~f0))gout=4'b0000;		//function code=x1x0,ALU control=000 (and)
	if ((f5)&(~f4)&(~f3)&(f2)&(~f1)&(f0))gout=4'b0001;			//function code=x1x1,ALU control=001 (or)
	if ((f5)&(~f4)&(f3)&(~f2)&(f1)&(~f0))gout=4'b0111;			//function code=1x1x,ALU control=111 (set on less than)
	if ((~f5)&(f4)&(~f3)&(f2)&(~f1)&(~f0))gout=4'b1000;  //brv
	if ((f5)&(~f4)&(~f3)&(~f2)&(~f1)&(f0))gout=4'b1001;	//jmxor
end
end
endmodule

//blezal lu op bilinmediğinden alu op yapamıyoruz şu anda