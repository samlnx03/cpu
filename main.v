module main;
    // para la ram
    parameter AdBus=5, DataBus=5;
    wire [AdBus-1:0] Address;
    wire CS, WE, OE;
    wire [DataBus-1:0] DataMem;

    // para el secuenciador y el decodificador de tiempos en el testbench
    reg clock, reset;
    // para monitorear la carga del programa
    integer i;
    reg [AdBus-1:0] rAddress;
    reg rCS, rWE, rOE;

    assign Address=rAddress;
    /*assign CS=rCS; assign WE=rWE; */
    assign OE=rOE;

    RamChip #(.ABus(AdBus), .DBus(DataBus)) RAM1(Address, DataMem, CS, WE, OE);
    Cpu #(.ABus(AdBus), .DBus(DataBus)) cpu(clock, reset, Address, DataMem, CS, WE, OE);

/*
  initial begin
	$display("Time\tAdd\tData");
  	$monitor("%3t\t%d\t%d", $time, Address, DataMem);
  	reset=0; clock=0;
        #10;  // esperar la carga del prog.
	rWE=1; rCS=0; rOE=0;
	reset=1;
	for(i=0; i<30; i=i+1) begin
		rAddress=i;
		#10;
	end
  end  // este bloque consume 300 ns
*/
	/*
  initial begin
	#301 $monitor("t:%4t\tResetSEQ:%d\ttn:%d", $time, ResetSEQ, t);
  end
	*/

  initial begin
  	reset=0; clock=0;
	#1 reset=1;
  	#299 reset=0; clock=0;
	forever #10 clock=~clock;
  end

  initial #1000 $finish;

endmodule
