bhv_town_size equ		20

town_init
	ldd #town_update
	std fun_update,x

	ldd #town_draw
	std fun_draw,x

	ldd #town_gfx
	std var_graphics, x

	ldd #200000
	std var_speed, x

	rts


town_draw
	ldy #1536-64
	jsr sgx.surface.fillPoint

	ldy #1536-64+8
	jsr sgx.surface.fillPoint

	ldy #1536-64+16
	jsr sgx.surface.fillPoint

	ldy #1536-64+24
	jsr sgx.surface.fillPoint

	rts


town_update
	rts


town_gfx
	fcb 8,2
	fcb 133+sgx.ColorRGB.red,138+sgx.ColorRGB.red,   138,130,   sgx.ColorRGB.blank,sgx.ColorRGB.blank,  138,130
	fcb 133+sgx.ColorRGB.red,138+sgx.ColorRGB.red,   138,130,   136+sgx.ColorRGB.purple,130+sgx.ColorRGB.purple, 138,130
