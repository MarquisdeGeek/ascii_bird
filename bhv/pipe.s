bhv_pipe_size equ		20
var_height 	equ		var_userdata


pipe_init
	ldd #pipe_update
	std fun_update,x

	ldd #pipe_draw
	std fun_draw,x

	ldd #pipe_gfx
	std var_graphics,x


	lda #25
	sta var_position_x, x
	lda #10
	sta var_position_y, x

	lda #6
	sta var_height, x

	ldd #150
	std var_speed, x

	rts


pipe2_init
	jsr pipe_init

	lda #10
	sta var_position_x, x
	lda #13
	sta var_position_y, x

	lda #3
	sta var_height, x
	rts


pipe_draw
	; Over-write the graphics data height parameter with our own
	lda var_height, x
	ldy var_graphics, x
	sta 1,y

	jsr game_object_prepare_gfx
	jmp sgx.graphics.fillPointClipped


pipe_update
	; @TODO This is a hack to redraw the cityscape before the first
	; pipe.
	cmpx #pipe1
	bne _pipe_draw_gfx
	
	pshs x
	ldx #cityscape
	jsr game_object_draw
	puls x

_pipe_draw_gfx

	; Move the pipe to the left
	lda var_position_x, x

	cmpa #-4
	bne _pipe_update_not_at_edge

	; When the pipe reaches the end, we do both:
	; 1. Gradually increase the speed of the pipe
	ldd var_speed,x
	subd #1
	std var_speed,x

	; 2. Reset it to start
	lda #32
_pipe_update_not_at_edge
	deca
	sta var_position_x, x

	; Add the score when the pipe is under the bird
	cmpa #2
	bne _pipe_doesnt_score

	; If the bird is dead, don't add the score. (but allow if dying, because we're generous)
	; (this is a bit hacky, TBH)
	ldy #flappy
	ldd fun_update, y
	cmpd #flappy_update_dead
	beq _pipe_doesnt_score


	pshs x
	jsr flappy_inc_score
	puls x

_pipe_doesnt_score	

	; force a pipe redraw
	jsr [fun_draw,x]
	rts


pipe_gfx

sgx.ColorRGB.lt		equ sgx.ColorRGB.yellow
sgx.ColorRGB.dk		equ sgx.ColorRGB.blue

	fcb 5, 5

	fcb 129+sgx.ColorRGB.lt, 131+sgx.ColorRGB.white, 131+sgx.ColorRGB.white, 130+sgx.ColorRGB.dk, sgx.ColorRGB.blank
	fcb 132+sgx.ColorRGB.lt, 140+sgx.ColorRGB.white, 140+sgx.ColorRGB.white, 136+sgx.ColorRGB.dk, sgx.ColorRGB.blank
	fcb 138+sgx.ColorRGB.nul, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133+sgx.ColorRGB.nul, sgx.ColorRGB.blank
	fcb 138+sgx.ColorRGB.nul, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133+sgx.ColorRGB.nul, sgx.ColorRGB.blank
	fcb 138+sgx.ColorRGB.nul, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133+sgx.ColorRGB.nul, sgx.ColorRGB.blank
	fcb 138+sgx.ColorRGB.nul, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133+sgx.ColorRGB.nul, sgx.ColorRGB.blank
	fcb 138+sgx.ColorRGB.nul, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133+sgx.ColorRGB.nul, sgx.ColorRGB.blank
	fcb 138+sgx.ColorRGB.nul, 143+sgx.ColorRGB.white, 143+sgx.ColorRGB.white, 133+sgx.ColorRGB.nul, sgx.ColorRGB.blank
