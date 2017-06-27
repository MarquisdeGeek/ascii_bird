

sgx_font_normal		equ 0
sgx_font_large		equ 1

sgx_font_style_normal	equ 64	; fixes characters like * to be their standard video versions
sgx_font_style_literal	equ 0	; takes each character as-is and writes it to the screen. Spaces and some inverse chars will appear

;
; Instance data
;
sgx_data_font	rmb	1
sgx_data_font_style	rmb	1


sgx_font_numbers
	; These characters are 2x3 blocks
	fcb 137,134,  133,138, 134,137		; 0
	fcb 139,133,  sgx.ColorRGB.blank,133, 142,132		; 1
	fcb 131,130,  140,136,  132,140   ; 2
	fcb 131,130,  142,136,  140,136   ; 3
	fcb 142,133,  132,132,  sgx.ColorRGB.blank,133 ; 4
	fcb 129,131,  131,130,  140,136   ; 5
	fcb 129,131,  132,140,  132,136   ; 6
	fcb 131,130,  sgx.ColorRGB.blank,138, sgx.ColorRGB.blank,138   ; 7
	fcb 129,130,  129,130,  132, 136   ;8
	fcb 129,130,  131,130,  sgx.ColorRGB.blank, 138   ;9

