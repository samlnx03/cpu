module controlUnit(
	input clock, reset, input [4:0] IReg,
	output MARL, SMMAR, MRW, MCS, IRL, PCL, SMPC, SMALUA, SMALUB, AL, SMA, CLKMASK, OPALU 
	);

  parameter DBus=5;
  wire [5:0] t;	// salidas de decodificador de tiempo del secuenciador

  // señales de salida de la unidad de control
  wire ResetSEQ; // para resetear el sequenciador (uso interno)
  wire Ior, Iadd, Imov, Ihalt; // instruccion executandose

  // instanciar decodificador de instruccion
  decodIR decod_ir(IReg, {Ior, Iadd, Imov, Ihalt});

  assign ResetSEQ=t[2]&Ihalt | t[4]&Imov | t[5]&(Iadd | Ior) | reset;  // solo uso interno
  // instanciar el seq y decod
  Sequencer sd(clock, ResetSEQ, t);

  assign MRW=0;  // por lo pronto RAM solo lectura
  assign MCS=0;  // por lo pronto RAM siempre activa

  assign MARL=t[0] | t[2]&(Imov | Iadd | Ior) | t[3]&(Iadd | Ior);
  assign SMMAR=t[0] | t[2]&(Imov | Iadd | Ior);
  assign IRL=t[1];
  assign PCL=t[1];
  assign SMPC=t[1];
  assign SMALUA=t[4]&(Iadd | Ior);
  assign SMALUB=t[4]&(Iadd | Ior);
  assign AL=t[3]&Imov | t[4]&(Iadd | Ior);
  assign SMA=t[4]&(Iadd | Ior);
  assign CLKMASK =t[2]&Ihalt;
  assign OPALU=t[4]&Ior;

  initial begin
	#289;
	forever begin
		#10 $display(" uc %4t: MARL=%d, SMMAR=%d, IRL=%d, PCL=%d, SMPC=%d, SMALUA=%d, SMALUB=%d, OPALU=%d, AL=%d, SMA=%d, CLKMASK=%d, MRW=%d, MCS=%d, t=%d",  
		$time,MARL, SMMAR, IRL, PCL, SMPC, SMALUA, SMALUB, OPALU, AL, SMA, CLKMASK, MRW, MCS, t);
	end
  end

endmodule




// decodificador de instrucciones ejecutandose por la cpu
module decodIR(input [4:0] ir, output reg [3:0] instruc);
	always @(*)
		case (ir)
			0: instruc=1; // halt
			1: instruc=2; // mov
			2: instruc=4; // add
			3: instruc=8; // or
			default: instruc=0; // error
		endcase

endmodule
