module control(in,func,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,aluop3,brvControl,jmxorControl,jalpcControl,balnControl,blezalControl,noriControl); //Added our new output signals
input [5:0] in; 
input [5:0] func; 

output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2,aluop3;
output brvControl,jmxorControl,jalpcControl,balnControl,blezalControl,noriControl; //Added our new output signals

wire rformat,lw,sw,beq;
wire nori,blezal,jalpc,baln;
wire jmxor,brv;

assign rformat=~|in;
assign jmxor=(~|in) & (func[5] & (~func[4]) & (~func[3]) & (~func[2]) & (~func[1]) & (func[0])); //jmxor opcode
assign brv=(~|in) & ((~func[5]) & (func[4]) & (~func[3]) & func[2] & (~func[1]) & (~func[0])); //brv opcode
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign nori=(~in[5]) & (~in[4]) & in[3] & in[2] & in[1] & in[0]; //nori opcode
assign blezal=in[5] & (~in[4]) & (~in[3]) & in[2] & (~in[1]) & (~in[0]); //blezal opcode
assign jalpc=(~in[5]) & in[4] & in[3] & in[2] & in[1] & in[0]; //jalpc opcode
assign baln=(~in[5]) & in[4] & in[3] & (~in[2]) & in[1] & in[0]; //baln opcode

assign regdest=rformat;
assign alusrc=lw|sw|nori; //nori added to alusrc
assign memtoreg=lw;
assign regwrite=rformat|lw|nori|blezal|jalpc|baln|jmxor; //nori,blezal,jalpc,baln,jmxor added to regwrite
assign memread=lw;
assign memwrite=sw;
assign branch=beq;
assign aluop1=beq|nori;
assign aluop2=rformat|nori|brv|jmxor; //nori,brv,jmxor added to aluop1
assign aluop3=blezal;
assign noriControl=nori;
assign blezalControl=blezal; 
assign jalpcControl=jalpc;
assign balnControl=baln;
assign jmxorControl=jmxor;
assign brvControl=brv;
//aluop0 = aluop2

//blezal aluop da napıcak bilmiyoruzzzzz

endmodule
