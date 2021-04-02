module help
(
	input clk, reset,
	output reg [6:0] HEX0, HEX1, HEX2, HEX3,
	output ledg
);


localparam P = 7'b0001100, L = 7'b1000111, U = 7'b1000001, S = 7'b0010010, NULL = 7'b1111111;
//dzielnik czestotliwosci
reg [24:0] div_clk;
always@(posedge clk, posedge reset)
	if(reset)
		div_clk <= 0;
	else
		div_clk <= div_clk +1;
		
wire slow_clk;
assign slow_clk = div_clk[24];
assign ledg = slow_clk;		

localparam s0=0, s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7;
reg [3:0] aut_reg, aut_next;

//rejestr automatu
always@(posedge slow_clk, posedge reset)
	if(reset)
		aut_reg <= s0;
	else
		aut_reg <= aut_next;

// funkcja przejsciowa automatu, NS		
always@*
	case(aut_reg)
		s0: aut_next = s1;
		s1: aut_next = s2;
		s2: aut_next = s3;
		s3: aut_next = s4;
		s4: aut_next = s5;
		s5: aut_next = s6;
		s6: aut_next = s7;
		s7: aut_next = s0;
		default: aut_next = s0; 
	endcase
	
//funkcja wyjsciowa
always@*
	case(aut_reg)
		s0: begin HEX0 = NULL; HEX1 = NULL; HEX2 = NULL; HEX3 = NULL; end
		s1: begin HEX0 = P; HEX1 = NULL; HEX2 = NULL; HEX3 = NULL; end
		s2: begin HEX0 = L; HEX1 = P; HEX2 = NULL; HEX3 = NULL; end
		s3: begin HEX0 = U; HEX1 = L; HEX2 = P; HEX3 = NULL; end
		s4: begin HEX0 = S; HEX1 = U; HEX2 = L; HEX3 = P; end
		s5: begin HEX0 = NULL; HEX1 = S; HEX2 = U; HEX3 = L; end
		s6: begin HEX0 = NULL; HEX1 = NULL; HEX2 = S; HEX3 = U; end
		s7: begin HEX0 = NULL; HEX1 = NULL; HEX2 = NULL; HEX3 = S; end
		default: begin HEX0 = NULL; HEX1 = NULL; HEX2 = NULL; HEX3 = NULL; end


	endcase

endmodule
