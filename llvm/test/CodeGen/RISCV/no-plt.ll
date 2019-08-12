; RUN: llc -mtriple=riscv64-linux-gnu --relocation-model=pic < %s | FileCheck %s

declare i32 @global() nonlazybind

define i32 @no_PLT_call() {
  ;CHECK-LABEL: no_PLT_call:

  ;CHECK: # %bb.0:

  ;CHECK-NEXT: addi sp, sp, -16
  ;CHECK-NEXT: .cfi_def_cfa_offset 16
  ;CHECK-NEXT: sd ra, 8(sp)
  ;CHECK-NEXT: .cfi_offset ra, -8

  ;CHECK-NEXT: .LBB0_1: # Label of block must be emitted

  ;CHECK-NEXT: auipc	a0, %got_pcrel_hi(global)
  ;CHECK-NEXT: ld	a0, %pcrel_lo(.LBB0_1)(a0)
  ;CHECK-NEXT: jalr	a0

  ;CHECK-NEXT: ld	ra, 8(sp)

  %tmp = call i32 @global()
  ret i32 %tmp
}
