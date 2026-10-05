
function FSM_player_idle(){
    //show_debug_message("[Player] - IDLE STATE");
    // get input
    _player_get_input();
    
    // calc movement
    _player_calc_movement();
    
    // check state
    if (move.hsp!=0) {
        state = states.WALK;
    }
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
        state = states.JUMP;
        move.vsp = move.jump_spd;
    }
    if input.block {
        state = states.BLOCK;
        move.hsp = 0;
    }
    
    // apply movement
    _player_apply_movement();
    
    // apply animation
    _player_animations();
}

function FSM_player_walk(){
    //show_debug_message("[Player] - WALK STATE");
    // get input
    _player_get_input();
    
    // calc movement
    _player_calc_movement();
    
    // check state
    if (move.hsp==0) {
        state = states.IDLE;
    }
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
        state = states.JUMP;
        move.vsp = move.jump_spd;
    }
    if input.block {
        state = states.BLOCK;
        move.hsp = 0;
    }
    
    // apply movement
    _player_apply_movement();
    
    // apply animation
    _player_animations();
}

function FSM_player_attack(){
    //show_debug_message("[Player] - ATTACK STATE");
    // get input
    _player_get_input();
    
    // calc movement
    _player_calc_movement();
    
    // check state
    var image_speed_alt = sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps);
    if (image_index >= image_number - image_speed_alt) {
        if _player_on_ground() {
            if (move.hsp!=0) {
                state = states.WALK;
            } else {
            	state = states.IDLE;
            }
        } else {
            state = states.JUMP;
        }
    }
    
    // apply movement
    _player_apply_movement();
    
    // apply animation
    _player_animations();
}

function FSM_player_jump(){
    //show_debug_message("[Player] - JUMP STATE");
    // get input
    _player_get_input();
    
    // calc movement
    _player_calc_movement();
    
    // check state
    if _player_on_ground() {
        if (move.hsp != 0) {
            state = states.WALK;
        } else {
            state = states.IDLE;
        }
    }
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    
    // apply movement
    _player_apply_movement();
    
    // apply animation
    _player_animations();
}

function FSM_player_block(){
    //show_debug_message("[Player] - BLOCK STATE");
    // get input
    _player_get_input();
    
    // calc movement
    _player_calc_movement();
    
    // check state
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.block {
        move.hsp = 0;
    } else {
        if move.hsp != 0 {
            if !_player_on_ground() state = states.JUMP else state = states.WALK;
        } else {
            state = states.IDLE;
        }
    }
    if input.jump {
        state = states.JUMP;
        move.vsp = move.jump_spd;
    }
    
    // apply movement
    _player_apply_movement();
    
    // apply animation
    _player_animations();
}

function FSM_player_crouch(){

}

function FSM_player_crouch_block(){

}