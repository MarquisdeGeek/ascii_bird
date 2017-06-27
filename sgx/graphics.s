;
; Constants
;
	INCLUDE "sgx/colors.s"


;
; SGX Library
;
sgx.graphics.init
	lda #sgx_font_normal
	jsr sgx.surface.setCurrentFont

	lda #sgx_font_style_normal
	jsr sgx.surface.setCurrentFontStyle
	rts


sgx.surface.clear

	ldx #1024
	lda #sgx.ColorRGB.blank

_sgx.surface.clear
	sta ,x+
	cmpx #1536
	bne _sgx.surface.clear
	rts



; a = font ID
sgx.surface.setCurrentFont
	sta 	sgx_data_font
	rts

; a = style ID (e.g. #sgx_font_style_normal)
sgx.surface.setCurrentFontStyle
	sta 	sgx_data_font_style
	rts


; x = ptr to string
; y = screen position
sgx.surface.drawText
	lda sgx_data_font
	cmpa #sgx_font_normal
	beq _sgx.surface.drawText_normal

	cmpa #sgx_font_large
	beq _sgx.surface.drawText_large

	rts

_sgx.surface.drawText_normal
	lda	,x+
	beq _sgx.surface.drawText_end
	ora sgx_data_font_style
	sta ,y+
	bra _sgx.surface.drawText_normal


_sgx.surface.drawText_large
	lda	,x+
	beq _sgx.surface.drawText_end
	pshs x,y
	  jsr sgx.graphics.drawCharacter
	puls y,x
	exg x,y
	ldd #3
	abx
	exg x,y
	bra sgx.surface.drawText

_sgx.surface.drawText_end
	rts

; a = number
sgx.surface.drawNumber
	; @TODO Write this method, maybe
	; take mod 10
	; print int
	; a /= 10
	; rts if a = 0
	; else loop
	rts

; y = screen position
; a = character
sgx.graphics.drawCharacter
	ldx #sgx_font_numbers
	
	suba #48
	ldb #6
	mul 		; d=offset in data
	abx


	ldb #3
_sgx.graphics.drawCharacter_textloopb
	pshs b
	ldb #2

_sgx.graphics.drawCharacter_textloop
	lda ,x+
	sta ,y+
	decb
	bne _sgx.graphics.drawCharacter_textloop

	exg y,d
	addd #32-2
	exg y,d
	
	puls b
	decb
	bne _sgx.graphics.drawCharacter_textloopb

	rts

; Workspace for the sprite render code
gfx_ctx           rmb 1
gfx_cty           rmb 1
gfx_ctx_gfx_span  rmb 1
gfx_ctx_gfx       rmb 2
gfx_ctx_screen    rmb 2
gfx_ctx_height    rmb 1
gfx_ctx_width	  rmb 2   ; LO-HI byte order
gfx_ctx_tmp       rmb 2


; x = game object ptr
; y = screen ptr
; WARNING : No clipping
sgx.surface.fillPoint
	sty gfx_ctx_screen
	ldy var_graphics, x

	; Grab width and height params
	lda ,y+
	ldb ,y+
	sty gfx_ctx_gfx

	clr gfx_ctx_width+0
	sta gfx_ctx_width+1

	stb gfx_ctx_height
	clr gfx_ctx_gfx_span

	jsr sgx.graphics.fillPointClipped
	rts


; Before calling this, you must set-up
;  gfx_ctx_width
;  gfx_ctx_height
;  gfx_ctx_gfx
;  gfx_ctx_screen
;  gfx_ctx_gfx_span
sgx.graphics.fillPointClipped
	pshs x

	ldb gfx_ctx_height
	ldx gfx_ctx_gfx
	ldy gfx_ctx_screen

_sgx.surface.fillPoint.b_tcl
	; Save the height counter
	; @TODO Could move this into temp store
	pshs b

	; @TODO Is this line on the screen? If not, jump to the next
	; (check against ptr within 1024-1536)

	ldb gfx_ctx_width+1

	; x : graphics data
	; y : screen position
_sgx.surface.fillPoint._tcl
	lda ,x+
	sta ,y+
	decb
	bne _sgx.surface.fillPoint._tcl

_sgx.surface.fillPoint._next_line
	; Move down to next graphic line
	; (most of the time, this is the next byte)
	ldb gfx_ctx_gfx_span
	abx

	; Move down screen by 1 line
	exg y,d
	addd #32
	subd gfx_ctx_width
	exg y,d
	
	puls b
	decb
	bne _sgx.surface.fillPoint.b_tcl

	puls x
	rts


sgx.surface.erasePoint

	ldb gfx_ctx_height
	ldy gfx_ctx_screen

_sgx.surface.clrloopb_tcl
	; Save the height counter
	; @TODO Could move this into temp store
	pshs b

	; @TODO Is this line on the screen? If not, jump to the next
	; (check against ptr within 1024-1536)

	ldb gfx_ctx_width+1

	; x : graphics data
	; y : screen position
_sgx.surface.clrloop_tcl
	lda #sgx.ColorRGB.blank
	sta ,y+
	decb
	bne _sgx.surface.clrloop_tcl

_sgx.surface.clrloop_next_line
	; Move down screen by 1 line
	exg y,d
	addd #32
	subd gfx_ctx_width
	exg y,d
	
	puls b
	decb
	bne _sgx.surface.clrloopb_tcl

	rts
