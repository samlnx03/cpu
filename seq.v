// secuenciador y decodificador
module Sequencer (CLK, reset, t);

input CLK;
input reset;
output reg [5:0] t;

reg [2:0] Q;

always @(posedge CLK, posedge reset) begin
  if (reset)
  	Q<=0;
  else
  	Q<=Q+1;
end


always @(Q) begin
	case (Q)
		0: t=1;
		1: t=2;
		2: t=4;
		3: t=8;
		4: t=16;
		5: t=32;
		default: t=0;
	endcase
end

endmodule
