module movement 
#(parameter DATA_WIDTH=16, ADDR_WIDTH=16)
(
	input wire                         clk, 
	input wire                         rst,
	input wire [(DATA_WIDTH-1):0]  data_in,
	output reg [(ADDR_WIDTH-1):0]     addr,
	output reg [(DATA_WIDTH-1):0] data_out,
	output reg                          we
);


localparam COUNT = 12500000;	// 500 sec
localparam STATE_ITER = 3;
wire timer;

pulse pwm (
	.clk(clk), 
	.rst(rst),
	.length1(STATE_ITER), 
	.length2(COUNT),
	.pulse(timer)
);


localparam FETCH_X = 3'd0, SAVE_X = 3'd1;
localparam FETCH_Y = 3'd2, SAVE_Y = 3'd3;
localparam FETCH_M = 3'd4, SAVE_M = 3'd5, SAVE_M_STANDING = 3'd6;
localparam IDLE = 3'd7;
reg [2:0] PS, NS;


localparam MARIO_X_END = 300;

localparam MARIO_STANDING   = 2;
localparam MARIO_WALK_START = 1;
localparam MARIO_WALK_MID   = 0;
localparam MARIO_WALK_END   = 1;
reg inc_in, inc_out;

// dff for mario walking animation (increment or decrement walk pattern)
always @(posedge clk)
	inc_out <= inc_in;


always @(posedge clk, negedge rst) begin
	if (~rst) 		 PS <= FETCH_X;
	else if (timer) PS <= NS;
	else		  PS <= PS;
end


always @(PS, data_in, inc_out) begin
	addr = 'hx;
	data_out = 'hx;
	we = 1'b0;
	inc_in = 1'bx;
	
	case (PS)
		
		FETCH_X: begin
			addr = 'h1000;
			NS = SAVE_X;
		end
		
		SAVE_X: begin
			addr = 'h1000;
			data_out = data_in + 3'd4;
			we = 1'b1;
			if (data_in < MARIO_X_END)
				NS = FETCH_M;
			else
				NS = SAVE_M_STANDING;
			end
		
		FETCH_M: begin
			addr = 'h1002;
			NS = SAVE_M;
		end
		
		SAVE_M: begin
			addr = 'h1002;
			we = 1'b1;
			case (data_in)
				MARIO_STANDING: begin
					data_out = MARIO_WALK_START;
					inc_in = 1'b1;
				end
				
				MARIO_WALK_START: begin
					data_out = MARIO_WALK_MID;
					inc_in = 1'b1;
				end
				
				MARIO_WALK_MID: begin
					if (inc_out) data_out = MARIO_WALK_START;
					else		data_out = MARIO_WALK_END;
					inc_in = inc_out;
				end
				
				MARIO_WALK_END: begin
					data_out = MARIO_WALK_MID;
					inc_in = 1'b0;
				end
				
				default: begin
					data_out = 'hx;
					inc_in = 1'bx;
				end
			endcase
			NS = FETCH_X;
		end
		
		SAVE_M_STANDING: begin
			addr = 'h1002;
			data_out = MARIO_STANDING;
			we = 1'b1;
			NS = IDLE;
		end
		
		IDLE: begin
			NS = IDLE;
		end
	
	endcase 
	
end

endmodule
