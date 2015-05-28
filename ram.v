// RAM Model
//
// +-----------------------------+
// |    Copyright 1996 DOULOS    |
// |       Library: Memory       |
// |   designer : John Aynsley   |
// +-----------------------------+

module RamChip (Address, Data, CS, WE, OE);

parameter ABus = 1;
parameter DBus = 1;

input [ABus-1:0] Address;
inout [DBus-1:0] Data;
input CS, WE, OE;

reg [DBus-1:0] Mem [0:1<<ABus];

integer i; // para volcar la memoria

assign Data = (!CS && !OE) ? Mem[Address] : {DBus{1'bz}};

always @(CS or WE)
  if (!CS && !WE)
    Mem[Address] = Data;

always @(WE or OE)
  if (!WE && !OE)
    $display("Operational error in RamChip: OE and WE both active");

initial begin // programa y datos
	Mem[0]=1;	// mov a,#10
	Mem[1]=10;

	Mem[2]=2;	// add 20	a <- a+M[20]
	Mem[3]=20;

	Mem[4]=3;	// or 25;	a <- a | M[25]
	Mem[5]=25;

	Mem[6]=0;	// halt
	Mem[7]=0;

	Mem[20]=9;	// datos
	Mem[25]=11;	// datos
			// el acumulador debe terminar en 10+9=19 | 11 = 27
end

initial begin	// despliega el programa
	#10;
	$display("Time\tAdd\tData");
	for(i=0; i<30; i=i+1) begin
  		$display("%3t\t%d\t%d", $time, i, Mem[i]);
	end
end  // este bloque consume 300 ns

endmodule
