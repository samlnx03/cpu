module alu (AluOut, AluSel, Aalu, Balu);
    parameter Bus=5;
    output reg [Bus-1:0] AluOut;
    input [Bus-1:0] Aalu, Balu;
    input AluSel; 

    always @(*) begin
	case(AluSel)
		0: AluOut=Aalu+Balu;
		1: AluOut=Aalu | Balu;
	endcase
    end
endmodule
