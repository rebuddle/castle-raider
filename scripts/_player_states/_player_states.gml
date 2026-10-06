/*
 * FINITE STATE MACHINE HANDLER
 * 
*/


function FSM_player_idle(){
    //show_debug_message("[Player] - IDLE STATE");
    // check state
    if (move.hsp!=0) {
        state = states.WALK;
    }
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
        _player_jump();
    }
    if input.block {
        state = states.BLOCK;
        move.hsp = 0;
    }
    if input.down {
        state = states.CROUCH;
        move.hsp = 0;
    }
}

function FSM_player_walk(){
    //show_debug_message("[Player] - WALK STATE");
    
    // check if falling off ledge
    var side = bbox_bottom;
    var t1 = tilemap_get_at_pixel(global.map, bbox_left, side + 1);
    var t2 = tilemap_get_at_pixel(global.map, bbox_right, side + 1);
    if (t1 == VOID and t2 == VOID) {
        // falling off ledge
        state = states.JUMP;
        move.jumps = move.max_jumps;
    }
    
    // check state
    if (move.hsp==0) {
        state = states.IDLE;
    }
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
         _player_jump();
    }
    if input.block {
        state = states.BLOCK;
        move.hsp = 0;
    }
    if input.down {
        state = states.CROUCH;
        move.hsp = 0;
    }
}

function FSM_player_attack(){
    //show_debug_message("[Player] - ATTACK STATE");
    
    // check state
    var image_speed_alt = sprite_get_speed(sprite_index)/game_get_speed(gamespeed_fps);
    if (image_index >= image_number - image_speed_alt) {
        if _player_on_ground() {
            if (move.hsp!=0) state = states.WALK else state = states.IDLE;
        } else {
            state = states.JUMP;
        }
    }
    if input.jump{
        _player_jump();
        state = states.ATTACK;
    }
    
    // enable smaller jumps
    if move.vsp < 0 and !input.jump_held move.vsp = max(move.vsp, move.jump_spd/move.jump_drag); // bug with different jump height
}

function FSM_player_jump(){
    //show_debug_message("[Player] - JUMP STATE");
    
    // check state
    if _player_on_ground() {
        if (move.hsp != 0) {
            state = states.WALK;
        } else {
            state = states.IDLE;
        }
        // landing
        if move.vsp > 0 {
            _player_lands();
        }
                
    }
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
        _player_jump();
    }
    
    // enable smaller jumps
    if move.vsp < 0 and !input.jump_held move.vsp = max(move.vsp, move.jump_spd/move.jump_drag); // bug with different jump height
}

function FSM_player_block(){
    //show_debug_message("[Player] - BLOCK STATE");
    
    // check state
    _player_block_check();
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
         _player_jump();
    }
}

function FSM_player_crouch(){
    //show_debug_message("[Player] - CROUCH STATE");
    
    // check state
    _player_block_check();
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
        _player_jump();
    }
}

function FSM_player_crouch_block(){
    //show_debug_message("[Player] - CROUCH_BLOCK STATE");
    
    // check state
    _player_block_check();
    if input.attack {
        state = states.ATTACK;
        image_index = 0;
    }
    if input.jump {
        _player_jump();
    }
}