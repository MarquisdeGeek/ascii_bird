
sgx_system_pause
	pshs x
	ldx  #$2000
_sgx_system_pause_loop
	leax -1,x
	bne _sgx_system_pause_loop
	puls x, pc
	rts

sgx_system_key_wait
	jsr $8006
	cmpa #32
	bne sgx_system_key_wait
	rts

sgx_system_halt
	bra sgx_system_halt
	
sgx_trace_point		macro
	pshs a,x
	ldx sgx_trace_point_ptr
	lda  #\1
	sta ,x+
	stx sgx_trace_point_ptr
	puls a,x
	endm

sgx_trace_point_ptr fdb 1024


sgx_trace_d macro
	pshs a,x
	ldx sgx_trace_point_ptr
	sta ,x+
	stb ,x+
	stx sgx_trace_point_ptr
	puls a,x
	endm

sgx_trace_x macro
	exg x,d
	sgx_trace_d
	exg x,d
	endm
