game_init
	ldx #game_logic
	jsr game_object_init

	lda #sgx_font_large
	jsr sgx.surface.setCurrentFont

	jsr game_reset_object_list

	ldx #flappy
 	jsr game_object_init
 	jsr game_add_object

	ldx #cityscape
 	jsr game_object_init
 	jsr game_add_object

 	ldx #cloud1
 	jsr game_object_init
 	jsr game_add_object
 	ldx #cloud2
 	jsr game_object_init
 	jsr game_add_object

	ldx #pipe1
 	jsr game_object_init
 	jsr game_add_object
	ldx #pipe2
 	jsr game_object_init
 	jsr game_add_object

	; initialise the score to 0 0 nul
	; (i.e. the characters, not an integer)
	ldx #game_data_score
	lda #48
	sta ,x+
	sta ,x+
	clra
	sta ,x

 	rts


; I wanted an object list, so the update & draw loops could just call the function pointers
; in the array. But I couldn't find the instruction. (It's something like jsr [0,x])
; See below
game_reset_object_list
	;sgx_trace_point 129
	ldx #game_data_objlist
	ldd #game_data_objlist_size
_game_reset_object_list_loop
	clr ,x+
	subd #1
	bne _game_reset_object_list_loop
	rts

game_clear_object
	; 
	rts

; x = object to store
game_add_object
	ldy #game_data_objlist
_game_add_object_find	
	ldd ,y++
	cmpd #0
	bne _game_add_object_find
	stx ,--y
	rts



game_update
	ldy #game_data_objlist
	ldd #game_data_objlist_size/2
_game_update_object_loop
	ldx ,y++
	cmpx #0
	bne _game_update_object_loop_no_item

	; @TODO Find out how to call the function pointer in the game object list
	;pshs x,y,d
	;jsr [0,x]
	;puls x,y,d

_game_update_object_loop_no_item
	subd #1
	bne _game_update_object_loop
	
	; This is a work-around : explicitly call the update of each object
	ldx #game_logic
	jsr game_object_update

	ldx #flappy
	jsr game_object_update

 	ldx #cloud1
	jsr game_object_update
 	ldx #cloud2
	jsr game_object_update

 	ldx #pipe1
	jsr game_object_update
 	ldx #pipe2
	jsr game_object_update

	rts

game_draw
	rts

game_redraw
	jsr sgx.surface.clear

	ldx #cloud1
	jsr game_object_draw
	ldx #cloud2
	jsr game_object_draw
		
	ldx #cityscape
	jsr game_object_draw

	ldx #pipe1
	jsr game_object_draw
	ldx #pipe2
	jsr game_object_draw

	ldx #flappy
	jsr game_object_draw

	ldx #game_logic
	jsr game_object_draw

	rts


game_loop
	jsr game_update
	bra game_loop
