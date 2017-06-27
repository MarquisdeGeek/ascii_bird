
fun_init		equ	0
fun_update		equ	2
fun_draw		equ	4
var_graphics	equ	6
var_position_x	equ	8
var_position_y	equ	9
var_flags		equ 10
int_drawcode	equ	11
var_userdata 	equ 13
var_userdata2	equ 14
var_userdata3	equ 15
var_speed		equ 16		; number of update ticks before udpate is called
var_tiemcum		equ 18 		; current tick count


gameobj_flag_draw	equ 1
gameobj_flag_update	equ 2




; x = address of character definition
game_object_init
	; Prepare default parameters
	
	clr var_flags, x
	bsr game_object_show
	bsr game_object_set_update

	ldd #game_object_nop
	std fun_update,x

	ldd #game_object_draw_internal
	std fun_draw,x

	ldd #gfx_draw_object
	std int_drawcode,x

	ldd #1500
	std var_speed, x
	ldd #0
	std var_tiemcum, x

	; Call 
	jsr [fun_init,x]

	; Do other stuff? Validation?
	rts

game_object_nop
	rts


game_object_show
	lda var_flags,x
	ora #gameobj_flag_draw
	sta var_flags,x
	rts

game_object_hide
	lda var_flags,x
	anda #~gameobj_flag_draw
	sta var_flags,x
	rts

game_object_set_update
	lda var_flags,x
	ora #gameobj_flag_update
	sta var_flags,x
	rts

game_object_set_noupdate
	lda var_flags,x
	anda #~gameobj_flag_update
	sta var_flags,x
	rts



game_object_update

	lda var_flags,x
	anda #gameobj_flag_update
	beq _game_object_update_flag_not_set

	ldd var_tiemcum, x
	addd #1
	
	cmpd var_speed, x
	bgt _game_object_update_process
	std var_tiemcum, x
	rts	

_game_object_update_process

	ldd #0
	std var_tiemcum, x
	jmp [fun_update,x]

_game_object_update_flag_not_set
	rts


game_object_draw

	lda var_flags,x
	anda #gameobj_flag_draw
	beq _game_object_draw_flag_not_set

	jsr [fun_draw,x]

_game_object_draw_flag_not_set
	rts

game_object_draw_internal
	jmp [int_drawcode,x]


; x = game object ptr
gfx_erase_object
	jsr game_object_prepare_gfx
	jmp sgx.surface.erasePoint


; x = game object ptr
gfx_draw_object
	jsr game_object_prepare_gfx
	jmp sgx.graphics.fillPointClipped



; x = game object ptr
game_object_prepare_gfx

	;
	; Determine the basic parameters
	;
	ldy var_graphics,x
	lda ,y+
	ldb ,y+


	; Store the width into two bytes, since we use it in subd 
	sta gfx_ctx_width+1
	clr gfx_ctx_width+0

	; Width is just one byte
	stb gfx_ctx_height

	; Span : the number of gfx source pixels between the end of one line
	; and the start of the next. (usually 0)
	clr gfx_ctx_gfx_span

	;
	lda var_position_x, x
	sta gfx_ctx
	lda var_position_y, x
	sta gfx_cty


	ldd var_graphics,x
	addd #2		; skip the width and height params
	std gfx_ctx_gfx


	;
	; Get the screen memory location of A,B in Y
	;

	; if x < 0
	;   gfx = gfx + x
	;   scr = scr + x
	;   width = width + x
	;   span = -x
	; else if x+w > 31
	;   width -= d
	;   span += d
	; else
	;   compute memory lcoation as normal

	ldb gfx_ctx
	blt _game_object_prepare_gfx_x_is_negative

	lda gfx_cty
	ldb #32
	mul
	addb gfx_ctx
	adca #0
	bra _game_object_prepare_gfx_x_complete


_game_object_prepare_gfx_x_is_negative
	
	; if gfx_ctx is -ve, then we do magic
	; this is because -1 is 255, which does not get treated as -ve by addb
	negb
	stb gfx_ctx_tmp+1
	clr gfx_ctx_tmp+0

	lda gfx_cty
	ldb #32
	mul
	subd gfx_ctx_tmp
	adca #0

_game_object_prepare_gfx_x_complete
	addd #1024
	std gfx_ctx_screen


	; Is the X co-ord off the left hand side of the screen?
	lda gfx_ctx
	tsta
	bge  _game_object_prepare_gfx_not_off_left

	;sgx_trace_point 2

	; X is negative, so clip -x pixels
	nega
	sta gfx_ctx_gfx_span

	; Start rendering with the next pixel, by shuffling the gfx ptr
	; along by 'a' bytes
_game_object_prepare_gfx_slide_off
	inc gfx_ctx_gfx+1

	; and fixing the screen x position to 0
	inc gfx_ctx_screen+1

	deca
	bne _game_object_prepare_gfx_slide_off


	; And skip a pixel when moving through the gfx data
	lda gfx_ctx_width+1
	suba gfx_ctx_gfx_span
	sta gfx_ctx_width+1


	bra _game_object_prepare_gfx_end



_game_object_prepare_gfx_not_off_left
	; a is still x co-ord
	adda gfx_ctx_width+1
	cmpa #32
	blt  _game_object_prepare_gfx_end

	; We extend beyond the RHS of the screen so
	; * Reduce width by N pixels
	; * Increase span by N pixels
	suba #32	; a = number of pixels off screen
	sta gfx_ctx_gfx_span

	lda gfx_ctx_width+1
	suba gfx_ctx_gfx_span
	sta gfx_ctx_width+1

_game_object_prepare_gfx_end

	rts





