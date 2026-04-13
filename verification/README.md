# CPU Parity Verification

This workflow checks that the FPGA Verilog CPU interprets each machine instruction the same way as the simulator.

## 1) Generate simulator trace

The simulator `Model` now supports a trace file via environment variable:

- `SIM_TRACE_FILE=<path>`

Example (PowerShell):

```powershell
$env:SIM_TRACE_FILE = "verification/out/sim_trace.csv"
```

Run the simulator and execute your `.bin` program. Each `tick()` writes:

- `cycle, pc, instruction, opcodeCombined, rd, rs, immSigned`
- register writeback event
- memory write event
- flags (`C/L/F/Z/N`)

## 2) Generate HDL trace

Run:

```powershell
powershell -ExecutionPolicy Bypass -File "verification/run_cpu_parity.ps1" `
  -ProgramBin "New Assembler/assembly/instructions.bin" `
  -HdlTrace "verification/out/hdl_trace.csv" `
  -SimTrace "verification/out/sim_trace.csv"
```

`tb_cpu.v` logs one row per retired instruction, with delayed handling for `LOAD`.

## 3) Diff simulator vs HDL

`verification/compare_traces.py` compares traces row-by-row and reports first mismatch with context:

```powershell
python "verification/compare_traces.py" --sim "verification/out/sim_trace.csv" --hdl "verification/out/hdl_trace.csv"
```

## 4) FPGA observability checklist (SignalTap/ILA)

Probe at minimum:

- `cpu_instance.programCounterContentsOutput`
- `cpu_instance.instructionRegisterContentsOutput`
- `cpu_instance.instruction_decoder_instance.aluOpcode`
- `cpu_instance.instruction_decoder_instance.registerAddressA`
- `cpu_instance.instruction_decoder_instance.registerAddressB`
- `cpu_instance.register_file_instance.writeEnable`
- `cpu_instance.register_file_instance.writeAddress`
- `cpu_instance.register_file_instance.writeData`
- `cpu_instance.memoryWriteEnable`
- `cpu_instance.memoryReadWriteAddress`
- `cpu_instance.registerFileContentsB`
- `cpu_instance.programStateRegisterContentsOutput`
- `cpu_instance.controlUnitState`
- `cpu_instance.controlUnitNextState`

Run a short micro-test `.bin`, capture waveforms, and compare transitions against HDL trace rows around the first mismatch reported by the diff tool.
