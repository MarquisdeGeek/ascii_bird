	org 20000
	jmp game_start

	INCLUDE "dragon/dragon.s"

	INCLUDE "sgx/sgx.s"

	INCLUDE "bhv/base.s"
	INCLUDE "bhv/bird.s"
	INCLUDE "bhv/cloud.s"
	INCLUDE "bhv/pipe.s"
	INCLUDE "bhv/town.s"

	INCLUDE "screens/title.s"

	INCLUDE "game/data.s"
	INCLUDE "game/objects.s"
	INCLUDE "game/logic.s"
	INCLUDE "game/main.s"


; http://www.6809.org.uk/dragon/6809e.txt
; http://dragon32.info/info/memmap.txt
; http://dragon32.info/info/romref.html
; http://atjs.mbnet.fi/mc6809/Information/6809.htm



; Check SGX names
; Limit memory used by objects

;38798 978E RANDOM NUMBER: Generates an 8 bit random         number and puts it in location 278

; Second pipe to not erase background. HOW?W?

; Game loop to have 16 (?) slots for game objects. 
; check @TODO

; Proper key handling


; Random height of pipes

; OPT:V2: Create town:
  ; Generate data block on start
  ; Randomize colours (MSB = set it and select random colour, else just set MSB)

game_start

	jsr sgx.graphics.init

	jsr title_screens

game_restart
	jsr game_init
	jsr game_redraw
	jmp game_loop

