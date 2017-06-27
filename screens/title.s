
title_screens
	jsr sgx.surface.clear
	
	lda #sgx_font_normal
	jsr sgx.surface.setCurrentFont

	ldx #title_screen_main
	ldy #1024+64+11
	jsr sgx.surface.drawText

	ldx #title_screen_author
	ldy #1024+128+5
	jsr sgx.surface.drawText

	ldx #title_screen_versioon
	ldy #1024+32*14+11
	jsr sgx.surface.drawText

	ldx #title_screen_start
	ldy #1024+256+6
	jsr sgx.surface.drawText

	jsr sgx_system_key_wait
	rts


title_screen_main      fcc "ASCII BIRD", 0
title_screen_author    fcc "BY STEVEN GOODWIN 2017", 0
title_screen_start     fcc "TAP *SPACE* TO START", 0
title_screen_versioon  fcc "VERSION 1.0", 0
