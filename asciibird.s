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

game_start

	jsr sgx.graphics.init

	jsr title_screens

game_restart
	jsr game_init
	jsr game_redraw
	jmp game_loop

