bhv_cloud_size equ		20


cloud_init
	ldd #cloud_update
	std fun_update,x

	ldd #cloud_gfx
	std var_graphics,x

	; How many ticks of the loop, before we respond with a timed action
	ldd #50
	std var_speed, x

	lda #20
	sta var_position_x, x
	lda #0
	sta var_position_y, x

	rts


cloud2_init
	jsr cloud_init

	lda #2
	sta var_position_x, x
	rts

cloud_update

	lda var_position_x, x
	cmpa #-6
	bne cloud_update_not_at_edge
	lda #32
cloud_update_not_at_edge
	deca
	sta var_position_x, x

	jsr [fun_draw,x]
	rts


cloud_gfx
	fcb 7, 2
	fcb 139, 141+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 142+sgx.ColorRGB.white, 135, sgx.ColorRGB.blank
	fcb sgx.ColorRGB.blank, 139,131,131,135,sgx.ColorRGB.blank,sgx.ColorRGB.blank
