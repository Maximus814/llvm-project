; RUN: llc -mtriple=riscv64-linux-gnu --relocation-model=pic < %s | FileCheck %s

declare void @global() nonlazybind

define void @no_PLT_call() nounwind {
  ;CHECK-LABEL: no_PLT_call:

  ;CHECK: # %bb.0:

  ;CHECK-NEXT: addi sp, sp, -16
  ;CHECK-NEXT: sd ra, 8(sp)

  ;CHECK-NEXT: .LBB0_1: # Label of block must be emitted

  ;CHECK-NEXT: auipc	a0, %got_pcrel_hi(global)
  ;CHECK-NEXT: ld	a0, %pcrel_lo(.LBB0_1)(a0)
  ;CHECK-NEXT: jalr	a0

  ;CHECK-NEXT: ld	ra, 8(sp)

  call void @global()
  ret void
}
