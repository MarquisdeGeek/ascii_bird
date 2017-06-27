
bhv_flappy_size equ		20

var_drop_counter 	equ		var_userdata
var_dying_path_ptr 	equ		var_userdata+1	; two bytes


flappy_init

	ldd #flappy_update
	std fun_update,x
	
	lda #2
	sta var_position_x,x
	lda #4
	sta var_position_y,x

	ldd #flappy_gfx
	std var_graphics,x

	; How many ticks of the loop, before we respond with a timed action
	ldd #40000
	std var_speed, x

	clra
	sta var_drop_counter, x

	rts


flappy_inc_score

	ldy #game_data_score
	lda 1,y
	inca
	sta 1,y

	cmpa #58
	bne flappy_inc_score_done
	
	; Wrap units
	lda #48
	sta 1,y

	; Inc tens
	lda ,y
	inca
	sta ,y

	; What about >99???

flappy_inc_score_done
	; @TODO Mark the object as dirty
	jsr game_logic_draw
	rts



flappy_repair_above
	jsr game_object_prepare_gfx
	ldd gfx_ctx_screen
	subd #32

	bra flappy_repair_screen


_flappy_repair_below
	jsr game_object_prepare_gfx
	ldd gfx_ctx_screen
	addd #32*6

flappy_repair_screen	
	std gfx_ctx_screen

	ldy #gfx_clear
	sty gfx_ctx_gfx

	lda #1
	sta gfx_ctx_height

	jmp sgx.graphics.fillPointClipped

_flappy_check_above
	jsr game_object_prepare_gfx
	ldd gfx_ctx_screen
	subd #32
	addd #2 		; the bird has two sgx.ColorRGB.blanks on the LHS, so ignore these
	exg d,y
	lda #6
	bra _flappy_collision_test

_flappy_check_below
	jsr game_object_prepare_gfx
	ldd gfx_ctx_screen
	addd #32*6
	addd #2 		; the bird has two sgx.ColorRGB.blanks on the LHS, so ignore these
	exg d,y
	lda #6

_flappy_collision_test	
_flappy_collision_check_below_loop
	ldb ,y+
	cmpb #sgx.ColorRGB.blank
	bne _flappy_collision_found
	deca
	bne _flappy_collision_check_below_loop
	rts
_flappy_collision_found
	;bra _flappy_collision_found
	ldd #flappy_update_dying
	std fun_update, x

	ldd #flappy_dying_path
	std var_dying_path_ptr, x

	ldd #40000
	std var_speed, x
	rts

flappy_dying_path
	fcb 1,-1, 1,-1, 1,0, 1,0, 1,1, 1,2, 1,2, 1,3, 1,3, 1,3, 1,3, 128,128

flappy_update_dying
	lda var_drop_counter, x
	adda #2
	sta var_drop_counter, x
	bne _flappy_update_dying_delay


	; Very lazy repair code
	jsr gfx_erase_object

	; y is the current point in the path array
	ldy var_dying_path_ptr,x

	; check for the terminator
	lda ,y
	cmpa #128
	beq _flappy_switch_to_dead

	; @TODO Why did ldb ,y and adda b not work here?
	lda var_position_x, x
	adda ,y+
	sta var_position_x, x

	ldb var_position_y, x
	addb ,y+
	stb var_position_y, x

	sty var_dying_path_ptr,x

	jsr gfx_draw_object

_flappy_update_dying_delay
	rts

_flappy_switch_to_dead
	ldd #flappy_update_dead
	std fun_update, x

	ldd #flappy_draw_dead
	std fun_draw, x
	jmp game_object_draw


flappy_update_dead
	pshs x
	jsr $8006
	puls x
	cmpa #32
	beq _flappy_update_restart
	rts
_flappy_update_restart
	jmp game_restart

flappy_update
	inc var_drop_counter, x
	bne _flappy_update_no_drop

	jsr _flappy_check_above	
	jsr _flappy_check_below

	ldd #flappy_gfx
	inc var_position_y, x
	std var_graphics,x
	jsr gfx_draw_object
	jsr flappy_repair_above
	
	
_flappy_update_no_drop

	jsr $8006
	cmpa #32
	
	bne flappy_update_not_space

	; We switch in a different graphic for the flapping version
	; (it's not very visible as it's only a change between white & yellow)
	ldd #flappy_gfx2
	std var_graphics,x
	dec var_position_y, x
	jsr _flappy_repair_below
	jsr gfx_draw_object

	rts


flappy_update_not_space
	rts


flappy_draw_dead
	pshs x
	lda #sgx_font_normal
	jsr sgx.surface.setCurrentFont

	ldx #flappy_restart
	ldy #1024+192+4
	jsr sgx.surface.drawText
	puls x

	rts


flappy_restart fcb "PRESS *SPACE* TO RESTART", 0


flappy_gfx
	fcb 8, 6
	fcb sgx.ColorRGB.blank,sgx.ColorRGB.blank, 137+sgx.ColorRGB.yellow, 131+sgx.ColorRGB.yellow, 130+sgx.ColorRGB.yellow, 131+sgx.ColorRGB.white, 141, sgx.ColorRGB.blank
	fcb sgx.ColorRGB.blank, 138, 143+sgx.ColorRGB.yellow,143+sgx.ColorRGB.yellow, 138+sgx.ColorRGB.yellow, 142+sgx.ColorRGB.white, 139+sgx.ColorRGB.white, 141
	fcb 142, 131+sgx.ColorRGB.white, 141+sgx.ColorRGB.yellow, 143+sgx.ColorRGB.yellow,139+sgx.ColorRGB.yellow, 141+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133
	fcb 133+sgx.ColorRGB.yellow, 143+sgx.ColorRGB.white, 138+sgx.ColorRGB.yellow, 143+sgx.ColorRGB.orange, 143+sgx.ColorRGB.orange, 139+sgx.ColorRGB.orange, 137+sgx.ColorRGB.red, 131+sgx.ColorRGB.red
	fcb 139, 140+sgx.ColorRGB.yellow, 135+sgx.ColorRGB.orange, 143+sgx.ColorRGB.orange, 143+sgx.ColorRGB.orange, 139+sgx.ColorRGB.orange, 137+sgx.ColorRGB.red, 130+sgx.ColorRGB.red
	fcb sgx.ColorRGB.blank,sgx.ColorRGB.blank, 131,131,131,131,131,135

flappy_gfx2
	fcb 8, 6
	fcb sgx.ColorRGB.blank,sgx.ColorRGB.blank, 137+sgx.ColorRGB.yellow, 131+sgx.ColorRGB.yellow, 130+sgx.ColorRGB.yellow, 131+sgx.ColorRGB.white, 141, sgx.ColorRGB.blank
	fcb sgx.ColorRGB.blank, 138, 143+sgx.ColorRGB.yellow,143+sgx.ColorRGB.yellow, 138+sgx.ColorRGB.yellow, 142+sgx.ColorRGB.white, 139+sgx.ColorRGB.white, 141
	fcb 142, 131+sgx.ColorRGB.yellow, 141+sgx.ColorRGB.yellow, 143+sgx.ColorRGB.yellow,139+sgx.ColorRGB.yellow, 141+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133
	fcb 133+sgx.ColorRGB.yellow, 143+sgx.ColorRGB.white, 138+sgx.ColorRGB.yellow, 143+sgx.ColorRGB.orange, 143+sgx.ColorRGB.orange, 139+sgx.ColorRGB.orange, 137+sgx.ColorRGB.red, 131+sgx.ColorRGB.red
	fcb 139, 140+sgx.ColorRGB.white, 135+sgx.ColorRGB.orange, 143+sgx.ColorRGB.orange, 143+sgx.ColorRGB.orange, 139+sgx.ColorRGB.orange, 137+sgx.ColorRGB.red, 130+sgx.ColorRGB.red
	fcb sgx.ColorRGB.blank,sgx.ColorRGB.blank, 131,131,131,131,131,135

gfx_clear
	fcb sgx.ColorRGB.blank,sgx.ColorRGB.blank,sgx.ColorRGB.blank,sgx.ColorRGB.blank,sgx.ColorRGB.blank,sgx.ColorRGB.blank,sgx.ColorRGB.blank,sgx.ColorRGB.blank

