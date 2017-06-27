;
; Equates for PIA0
;

; A- side registers
P0DDRA	EQU $FF00	; Data direction register
P0PDRA	EQU P0DDRA ; Peripheral data register
P0CRA	EQU $FF01	; Control register
; B-side registers
P0DDRB	EQU $FF02	; Data direction register
P0PDRB	EQU P0DDRB	; Peripheral data register
P0CRB	EQU $FF03	; Control register

;
; Equates for PIA1
;
; A-side registers
P1DDRA	EQU $FF02; Data direction register
P1PDRA	EQU P1DDRA	; Peripheral data register
P1CRA	EQU $FF21	; Control register

; B-side registers
P1DDRB	EQU $FF22	; Data direction register
P1PDRB	EQU P1DDRB	; Peripheral data register
P1CRB	EQU $FF23	; Control register