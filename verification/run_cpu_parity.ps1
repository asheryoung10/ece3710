param(
    [string]$ProgramBin = "New Assembler/assembly/instructions.bin",
    [string]$HdlTrace = "verification/out/hdl_trace.csv",
    [string]$SimTrace = "verification/out/sim_trace.csv",
    [string]$BuildDir = "verification/out"
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null

$simv = Join-Path $BuildDir "tb_cpu.out"

# Build HDL testbench (Icarus Verilog expected on PATH)
iverilog -g2012 `
  -I "Verilog/Doodle Jump/cpu" `
  -I "Verilog/Doodle Jump" `
  -o $simv `
  "Verilog/Doodle Jump/cpu/tb_cpu.v" `
  "Verilog/Doodle Jump/cpu/cpu.v" `
  "Verilog/Doodle Jump/cpu/control_unit.v" `
  "Verilog/Doodle Jump/cpu/instruction_decoder.v" `
  "Verilog/Doodle Jump/cpu/register_file.v" `
  "Verilog/Doodle Jump/cpu/register.v" `
  "Verilog/Doodle Jump/cpu/alu.v" `
  "Verilog/Doodle Jump/cpu/mux2.v" `
  "Verilog/Doodle Jump/cpu/mux4.v" `
  "Verilog/Doodle Jump/sharedMemory.v" `
  "Verilog/Doodle Jump/memory.v"

# Emit HDL trace
vvp $simv +PROGRAM=$ProgramBin +TRACE=$HdlTrace

# Compare traces (requires simulator trace already generated)
python "verification/compare_traces.py" --sim $SimTrace --hdl $HdlTrace
