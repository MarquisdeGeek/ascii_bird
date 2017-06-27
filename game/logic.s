game_logic_size equ		30

game_logic_init
	ldd #game_logic_update
	std fun_update,x

	ldd #game_logic_draw
	std fun_draw,x
	
	jsr game_object_set_noupdate 
	rts

game_logic_update
	rts

game_logic_draw

	; draw score
	lda #sgx_font_large
	jsr sgx.surface.setCurrentFont

	ldx #game_data_score
	ldy #1024+32+32+26
	jsr sgx.surface.drawText

	rts
