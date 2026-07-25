`timescale 1ns/1ps

module traffic_light_controller_tb;

reg clk;
reg reset;
wire [2:0] NS;
wire [2:0] EW;

// Instantiate DUT
traffic_light_controller uut (
    .clk(clk),
    .reset(reset),
    .NS(NS),
    .EW(EW)
);

// Generate 10 ns clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Create VCD waveform file
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, traffic_light_controller_tb);
end

// Apply stimulus
initial begin
    reset = 1;
    #20;

    reset = 0;

    // Run long enough to see all states
    #350;

    $finish;
end

// Print state changes
initial begin
    $monitor("Time=%0t Reset=%b NS=%b EW=%b",
             $time, reset, NS, EW);
end

endmodule