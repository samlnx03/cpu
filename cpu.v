module Cpu(clock, reset, Address, DataMem, cs,rw,oe);
    // para la ram
    parameter ABus=5, DBus=5;
    input clock, reset;
    inout [DBus-1:0] DataMem;
    output [ABus-1:0] Address;
    output cs, rw, oe; 

    reg [DBus-1:0] IR, PC, MAR, A;  // registros de la cpu

    wire [DBus-1:0] wPC, /* conexion del mux al PC */
			wMAR, /* conexion del mux a MAR */
			wA,   /* conexion del mux a A */
    			AluOut, /* salida de la alu */
			wAalu, wBalu;  /* entradas de la alu */
			

    //seniales de control
    wire MARL, SMMAR, MRW, MCS, IRL, PCL, SMPC, SMALUA, SMALUB, AL, SMA, CLKMASK, OPALU;

    controlUnit ucontrol(clock, reset, IR,
	MARL, SMMAR, MRW, MCS, IRL, PCL, SMPC, SMALUA, SMALUB, AL, SMA, CLKMASK, OPALU
	);

	   // mux2a1(I0, I1, s, o);
    mux2a1 MuxPC(DataMem, AluOut, SMPC, wPC);
    mux2a1 MuxMAR(DataMem, PC, SMMAR, wMAR);
    mux2a1 MuxA(DataMem, AluOut, SMA, wA);
    mux2a1 MuxAalu(PC, A, SMALUA, wAalu);
    mux2a1 MuxBalu(1, DataMem, SMALUB, wBalu);
    alu alu0(AluOut, AluSel, wAalu, wBalu);
	//alu(AluOut, AluSel, Aalu, Balu);

    always @(posedge reset) begin PC=0; MAR=1; A=2; IR=9; end

    always @(posedge clock) begin
	if(MARL) MAR<=wMAR;
	if(IRL)  IR<=DataMem;
	if(AL)	 A<=wA;
	if(PCL)	 PC<=wPC;
    end
	
    initial begin
	#298;
	//forever begin
		#10 $monitor("cpu %4t: MARL=%d, SMMAR=%d, IRL=%d, PCL=%d, SMPC=%d, SMALUA=%d, SMALUB=%d, OPALU=%d, AL=%d, SMA=%d, CLKMASK=%d, MRW=%d, MCS=%d\n\tRegistros: PC=%d, MAR=%d A=%d, IR=%d", 
		$time,MARL, SMMAR, IRL, PCL, SMPC, SMALUA, SMALUB, OPALU, AL, SMA, CLKMASK, MRW, MCS, PC, MAR, A, IR);
	//end
    end
endmodule

module mux2a1(I0, I1, s, o);
	parameter Bus=5;
	input [Bus-1:0] I0, I1;
	input s;
	output [Bus-1:0] o;
	assign o = s ? I1 : I0;
endmodule
