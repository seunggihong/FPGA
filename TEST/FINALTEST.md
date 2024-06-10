# 기말고사

## 📌 FPGA, ASIC, RTL 약어

| 약어 | 설명                                          |
| :--: | :-------------------------------------------- |
| FPGA | **_Field Programmable Gate Array_**           |
| ASIC | **_Application Specific Integrated Circuit_** |
| RTL  | **_Register-transfer level_**                 |

## 📌 조합회로 순서회로 차이

|   회로    | 설명                                                                                                              |
| :-------: | :---------------------------------------------------------------------------------------------------------------- |
| 조합 회로 | ▪ 메모리(또는 상태)를 포함하지 않음<br>▪ 같은 입력 → 같은 출력<br>▪ Verilog 설계 시 사용 가능                     |
| 순서 회로 | ▪ 메모리(또는 상태)를 포함함<br>▪ 같은 입력 → 회로 상태에 따라 출력 달라질 수 있음<br>▪ Verilog 설계 시 사용 가능 |

## 📌 Latch Flip-flop 동작 이해하기

|   장치    | 설명                                                                                                                                                    |
| :-------: | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
|   Latch   | ▪ 1비트 정보를 저장하는 기본 메모리 소자<br>▪ Clock 신호 없음<br>▪ 비동기식(Asynchronous)<br>▪ Level-sensitive<br>▪ 회로 설계 시 거의 사용하지 않음.    |
| Flip-flop | ▪ 1비트 정보를 저장하는 기본 메모리 소자<br>▪ Clock 신호 있음<br>▪ 동기식(Synchronous)<br>▪ Edge-sensitive<br>▪ Latch보다 2배정도 크지만 안정성이 높음. |

## 📌 출력신호 나타내는 그래프 그리기

**_Latch, Filp-flop 출력 신호_**

<p align="center">
<img width="882" alt="latch_flipflop" src="https://github.com/seunggihong/FPGA/assets/39299265/86e5b360-70e4-4fe2-979e-51cf1a617248">
</p>

```v
// Latch
module d_latch
# (
    parameter N = 8
) (
    input               c,
    input       [N-1:0] d,
    output reg  [N-1:0] q
);

always @* begin
    if (c)  q = d;
    else    q = q;
end

endmodule
```

```v
// D-FF
module d_ff
# (
    parameter N = 8
) (
    input               clk,
    input       [N-1:0] d,
    output reg  [N-1:0] q
)

always @(posedge clk) begin
    q <= d;
end

endmodule
```

```v
// 비동기식 reset D-FF
module d_ff_rstb
# (
    parameter N = 8
) (
    input               clk,
	input				rstb,
    input       [N-1:0] d,
    output reg  [N-1:0] q
)

always @(posedge clk or negedge rstb) begin
    if (~rstb) 	q <= 0;
	else		q <= d;
end

endmodule
```

## 📌 Mod-counter 코드 쓰기

**_상태 레지스터 값에 따른 설계_**

<img width="884" alt="reg1" src="https://github.com/seunggihong/FPGA/assets/39299265/273927ab-c67d-4801-ad16-6c51a0626b97">

```v
module modm_counter_1
#(
	parameter M = 10,
	parameter N = $clog2(M)
) (
	input 			clk, rstb,
	output 	[N-1:0] q,
	output			max_tick
);

reg	[N-1:0] state_reg;
wire [N-1:0] state_next;
always @(posedge clk or negedge rstb) begin
	if (~rstb) 	state_reg <= 0;
	else 		state_reg <= state_next;
end

assign q = state_reg;
assign max_tick = (state_reg == (M-1)) ? 1'b1 : 1'b0;

assign state_next = max_tick ? 0 : state_reg+1;

endmodule
```

**_상태 레지스터 다음 값에 따른 설계_**

<img width="884" alt="reg2" src="https://github.com/seunggihong/FPGA/assets/39299265/1e37a605-b708-48ea-afbd-07b72ce0371f">

```v
module modm_counter_2
#(
	parameter M = 10,
	parameter N = $clog2(M)
) (
	input 			clk, rstb,
	output 	[N-1:0] q,
	output 			max_tick
);

reg [N-1:0] state_reg;
wire [N-1:0] state_next, state_inc;

always @(posedge clk or negedge rstb) begin
	if (~rstb) state_reg <= 0;
	else state_reg <= state_next;
end

assign q = state_reg;
assign max_tick = (state_inc == M) ? 1'b1 : 1'b0;

assign state_inc = state_reg+1;
assign state_next = max_tick ? 0 : state_inc;

endmodule
```

## 📌 FSM 상태도 보여주고, 동작 방식 설명하기

**_FSM : Finite State Machine (유한 상태 기계)_**

- 순서 회로
- 복잡한 next-state 로직
  - 일반적으로 알고리즘 흐름도를 통해 next-state 로직 설계
- 큰 디지털 시스템
  - Data path : 메모리, 기본 혹은 복잡한 연산 하는 회로
  - Control path : data path의 컨트롤 신호 생성을 위한 FSM
- 실용성 높음
- FSM 종류
  - Mealy : 출력 = f(상태, 입력)
  - Moore : 출력 = f(상태)

**_FSM 블록도_**

<p align="center">
<img width="769" alt="fsm_state" src="https://github.com/seunggihong/FPGA/assets/39299265/e7fb0e86-fbca-4aa1-b572-c4e5b70eb50a">
</p>

**_FSM 상태도_**

<p align="center">
<img width="769" alt="fsm_state_" src="https://github.com/seunggihong/FPGA/assets/39299265/057ae1b2-460f-4263-a9de-0976d83ccbdc">
</p>

## 📌 FSM 상태는 어떻게 표시할 수 있는지 알기

<p align="center">
<img width="845" alt="fsmMealyVSMoore" src="https://github.com/seunggihong/FPGA/assets/39299265/ee5d8752-eec1-4c9e-b3db-e3a0814e065b">
</p>

<p align="center">
<img width="845" alt="take1" src="https://github.com/seunggihong/FPGA/assets/39299265/74af235f-7cd9-4e3a-9848-049265d93772">
</p>

## 📌 Mealy FSM vs Moore FSM 비교해서 알기

|     종류      | 설명                                                                                                                                                                                   |
| :-----------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Mealy FSM** | ▪ Moore FSM보다 상태 갯수 적음 → 회로 크기 작음<br>▪ 입력의 변경에 대한 빠른 응답 → "glitch"에 민감함<br>▪ Moore FSM보다 edge-sensitive 제어 신호 생성에 적합함                        |
| **Moore FSM** | ▪ Mealy FSM보다 상태 갯수 많음 → 회로 크기 큼<br>▪ Clock의 Edge에만 상태 바꿔서 출력 신호 생성함 → "glitch"에 민감하지 않음<br>▪ Mealy FSM보다 level-sensitive 제어 신호 생성에 적합함 |

```v
// Mealy FSM
module edge_detector_mealy(
	input 	clk, rstb,
	input 	strobe,
	output 	reg p2
);

localparam 	ZERO = 1'b0,
			ONE = 1'b1;

reg state_reg, state_next;

always @(posedge clk or negedge rstb) begin
	if (~rstb) state_reg <= 0;
	else state_reg <= state_next;
end

always @* begin
	state_next = state_reg;
	p2 = 1'b0;
	case (state_reg)
		ZERO: if (strobe) begin
			state_next = ONE;
			p2 = 1'b1;
		end
		ONE: if (~strobe) state_next = ZERO;
		default: state_next = ZERO;
	endcase
end

endmodule
```

```v
// Moore FSM
module edge_detector_moore(
	input 		clk, rstb,
	input 		strobe,
	output reg 	p1
);

localparam [1:0] 	ZERO = 2'b00,
					EDGE = 2'b01,
					ONE = 2'b10;

reg [1:0] state_reg, state_next;

always @(posedge clk or negedge rstb) begin
	if (~rstb) 	state_reg <= 0;
	else 		state_reg <= state_next;
end

always @* begin
	state_next = state_reg;
	p1 = 1'b0;
	case (state_reg)
		ZERO: if (strobe) state_next = EDGE;
		EDGE: begin
			p1 = 1'b1;
			state_next = strobe ? ONE : ZERO;
		end
		ONE: if (~strobe) state_next = ZERO;
		default: state_next = ZERO;
	endcase
end

endmodule
```

## 📌 상태할당

**_많이 사용하는 할당 제도_**

- 2진수
  - 상태 개수에 따른 순서 2진수 사용
  - N개의 상태 → log2N 비트 필요
- Gray 코드
  - 한 상태에서 다음 상태로 변할 때 인접 코드 간 오직 한자리만 변화함
  - N개의 상태 → log2N 비트 필요
  - 그레이코드 사용이유? 전력소비 최소화
- One-hot
  - 한 상태 코드에서 1비트 하나만 있음
  - N개의 상태 → N비트 필요
  - One-hot사용 이유? 회로 크기 줄이기 위해 사용
- Almost one-hot
  - One-hot과 비슷하지만 00...0코드도 사용
  - N개의 상태 → (N-1)비트 필요

**_상태 할당 예시_**
|상태|2진수|Gray 코드|One-hot|Almost one-hot|
|:--|:---:|:---:|:---:|:---:|
|IDLE|000|000|000001|00000|
|READ1|001|001|000010|00001|
|READ2|010|011|000100|00010|
|READ3|011|010|001000|00100|
|READ4|100|110|010000|01000|
|WRITE|101|111|100000|10000|

## 📌 RAM에 대해서 설명

**_RAM(Random Access Memory)_**

- 대용량 저장을 위한 메모리 장치
- RAM 소자는 D-FF보다 훨씬 간단함
- RAM 종류
  - DRAM(dynamic RAM)
  - SRAM(static RAM)
- RAM은 칩 속에 포함되면 내장 메모리(on-chip memory), 밖에 있으면 외장 메모리(external memory)
- 메모리 접근의 복잡도
  - 레지스터 파일 < on-chip RAM < external RAM
- External RAM에 접근하려면 메모리 컨트롤러를 사용해야함

🙅‍♂️ 외부램은 안나옴

🙅‍♂️ 내장 메모리(on-chip)만 나옴.

## 📌 on-chip 메모리 single-port 동기, 비동기 verilog 코드 차이 알기

**_비동기식 읽기 Single-port RAM_**

- 주소 바로 사용함.

<p align='center'>
<img width="483" alt="ram1" src="https://github.com/seunggihong/FPGA/assets/39299265/a8d27369-582f-41cf-9188-b5d59d2141cc">
</p>

```v
// 비동기식 single-port RAM
module sp_ram_async_read
#(
	parameter 	N = 8,
				W = 2
) (
	input 			clk,
	input 			we,
	input 	[W-1:0] addr,
	input 	[N-1:0] din,
	output 	[N-1:0] dout
);

reg [N-1:0] ram[2**W-1:0];

always @(posedge clk) begin
	if (we)
		ram[addr] <= din;
end

assign dout = ram[addr];

endmodule
```

**_동기식 읽기 Single-port RAM_**

- 데이터 읽기 전에 주소를 레지스터에 저장

<p align='center'>
<img width="483" alt="ram2" src="https://github.com/seunggihong/FPGA/assets/39299265/c695979f-f852-470a-a919-d12f8eca8622">
</p>

```v
module sp_ram_sync_read
#(
	parameter N = 8,
	W = 2
) (
	input 			clk,
	input			we,
	input 	[W-1:0] addr,
	input 	[N-1:0] din,
	output 	[N-1:0] dout
);

reg [N-1:0] ram[2**W-1:0];
reg [W-1:0] addr_reg;

always @(posedge clk) begin
	if (we)
		ram[addr] <= din;
	addr_reg <= addr;
end

assign dout = ram[addr_reg];

endmodule
```
