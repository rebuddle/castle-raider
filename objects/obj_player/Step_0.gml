// get input
_player_get_input();

// calc movement
_player_calc_movement();

// execute state
script_execute(player_step[state]);

// apply movements
_player_apply_movement();

// apply animations
_player_animations();