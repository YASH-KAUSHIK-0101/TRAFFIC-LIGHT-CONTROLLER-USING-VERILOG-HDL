`timescale 1ns/1ps

module traffic_light_controller(
    input  wire clk,
    input  wire reset,
    output reg  [2:0] NS,
    output reg  [2:0] EW
);

// Light encoding
localparam RED    = 3'b100;
localparam YELLOW = 3'b010;
localparam GREEN  = 3'b001;

// FSM states
localparam S0 = 2'b00; // NS Green, EW Red
localparam S1 = 2'b01; // NS Yellow, EW Red
localparam S2 = 2'b10; // NS Red, EW Green
localparam S3 = 2'b11; // NS Red, EW Yellow

reg [1:0] state;
reg [4:0] timer;

// Durations in clock cycles
localparam GREEN_TIME  = 10;
localparam YELLOW_TIME = 3;

// State register + timer
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        timer <= 0;
    end else begin
        case (state)
            S0: begin
                if (timer == GREEN_TIME-1) begin
                    state <= S1;
                    timer <= 0;
                end else
                    timer <= timer + 1;
            end

            S1: begin
                if (timer == YELLOW_TIME-1) begin
                    state <= S2;
                    timer <= 0;
                end else
                    timer <= timer + 1;
            end

            S2: begin
                if (timer == GREEN_TIME-1) begin
                    state <= S3;
                    timer <= 0;
                end else
                    timer <= timer + 1;
            end

            S3: begin
                if (timer == YELLOW_TIME-1) begin
                    state <= S0;
                    timer <= 0;
                end else
                    timer <= timer + 1;
            end

            default: begin
                state <= S0;
                timer <= 0;
            end
        endcase
    end
end

// Combinational output logic
always @(*) begin
    case (state)
        S0: begin NS = GREEN;  EW = RED;    end
        S1: begin NS = YELLOW; EW = RED;    end
        S2: begin NS = RED;    EW = GREEN;  end
        S3: begin NS = RED;    EW = YELLOW; end
        default: begin
            NS = RED;
            EW = RED;
        end
    endcase
end

endmodule