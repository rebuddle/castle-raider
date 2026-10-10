// get input
player_get_input();

// calc movement 
player_calc_movement();

// execute state
script_execute(player_step[state]);

// apply movements
player_apply_movement();

// apply animations
player_animations();