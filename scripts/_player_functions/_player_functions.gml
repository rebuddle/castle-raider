
function _player_get_input(){
    // keyboard input
    // movement
    input.left = keyboard_check(ord("A"));
    input.right = keyboard_check(ord("D"));
    input.up = keyboard_check(ord("W"));
    input.down = keyboard_check(ord("S"));
    // attack
    input.attack = mouse_check_button_pressed(mb_left);
    // jump
    input.jump = keyboard_check_pressed(vk_space);
    input.jump_held = keyboard_check(vk_space);
    // block
    input.block = keyboard_check(vk_shift);
    
    // controller input
    var device = 0;
    if gamepad_is_connected(device) {
        var deadzone = 0.3;
        input.left = gamepad_axis_value(device, gp_axislh) < -deadzone or input.left;
        input.right = gamepad_axis_value(device, gp_axislh) > deadzone or input.right;
        input.up = gamepad_axis_value(device, gp_axislv) < -deadzone or input.up;
        input.down = gamepad_axis_value(device, gp_axislv) > deadzone or input.down;
        input.attack = gamepad_button_check_pressed(device, gp_face2) or input.attack;
        input.jump = gamepad_button_check_pressed(device, gp_face1) or input.jump;
        input.jump_held = gamepad_button_check(device, gp_face1) or input.jump_held;
        input.block = gamepad_button_check(device, gp_shoulderr) or input.block;
    }
}

function _player_calc_movement(){
    // apply movement
    move.hsp = move.hsp + (input.right - input.left) * move.walk_spd;
    move.vsp += global.gravity;
    
    // slow down/drag
    move.hsp = lerp(move.hsp, 0, move.drag); // drag per step
    if (abs(move.hsp) <= 0.1) {
        move.hsp=0; // stop (lerp takes too long)
    } else {
         // face the correct direction
        move.facing = sign(move.hsp);
    }
    
    // orientation
    move.hsp = min(abs(move.hsp), move.max_hsp) * move.facing; // limit speed
}

function _player_apply_movement(){
    // apply carried over decimals
    move.hsp += move.hsp_decimal;
    move.vsp += move.vsp_decimal;
    
    // floor decimals; save and subtract decimals
    move.hsp_decimal = move.hsp - (floor(abs(move.hsp)) * sign(move.hsp));
    move.hsp -= move.hsp_decimal;
    move.vsp_decimal = move.vsp - (floor(abs(move.vsp)) * sign(move.vsp));
    move.vsp -= move.vsp_decimal;
    
    // COLLISION VARS
    var side;
    var t1;
    var t2;
    // HORIZONTAL COLLISION
    // determine which side to test for collisions
    if move.hsp > 0 side = bbox_right else side = bbox_left;
        
    // check bottom and top of side
    t1 = tilemap_get_at_pixel(global.map, side + move.hsp, bbox_top);
    t2 = tilemap_get_at_pixel(global.map, side + move.hsp, bbox_bottom);
    
    if t1 != VOID or t2 != VOID {
        // collision found
        if (move.hsp>0) {
            x = x - (x mod global.tile_size) + global.tile_size - 1 - (side - x);
        } else {
            x = x - (x mod global.tile_size) - (side - x);
        }
        move.hsp = 0;
    }
    x += move.hsp;
    
    // VERTICAL COLLISION
    // determine which side to test for collisions
    if move.vsp > 0 side = bbox_bottom else side = bbox_top;
        
    // check left and right of side
    t1 = tilemap_get_at_pixel(global.map, bbox_left, side + move.vsp);
    t2 = tilemap_get_at_pixel(global.map, bbox_right, side + move.vsp);
    
    if t1 != VOID or t2 != VOID {
        // collision found
        if (move.vsp>0) {
            y = y - (y mod global.tile_size) + global.tile_size - 1 - (side - y);
        } else {
            y = y - (y mod global.tile_size) - (side - y);
        }
        move.vsp = 0;
    }
    y += move.vsp;
}

function _player_animations(){
    sprite_index = player_sprite[state];
    mask_index = player_mask[state];
    image_xscale = move.facing;
    
    switch(state){
        case states.JUMP:
            if move.vsp < 0 image_index = 0 else image_index = 1;
        break;
    
        case states.ATTACK:
            if !_player_on_ground() {
                sprite_index = s_player_air_attack;
            } else {
            	// on ground
                if move.hsp != 0 sprite_index = s_player_attack_walk else sprite_index = s_player_attack;
            }
        break;
        
    }
}

function _player_on_ground(){
    var side = bbox_bottom;
    var t1 = tilemap_get_at_pixel(global.map, bbox_left, side + 1);
    var t2 = tilemap_get_at_pixel(global.map, bbox_right, side + 1);
    
    if (t1 == SOLID or t2 == SOLID) return true else return false;
}

function _player_jump(){
    if _player_on_ground() move.jumps = move.max_jumps;
        
    if move.jumps > 0 {
        // particles for jumping
        var inst = instance_create_layer(x, y, "Particles", obj_player_particles, 
            {
                image_xscale: move.facing, 
                sprite_index: s_player_dust_jump
            });
        inst.fade = 0.04;
        state = states.JUMP;
        move.vsp = move.jump_spd;
        move.jumps -= 1;
    }
}

function _player_lands() {
    instance_create_layer(x, y, "Particles", obj_player_particles, 
    {
        image_xscale: move.facing, 
        sprite_index: s_player_dust_land
    });
}

function _player_block_check(){
    if input.block {
        if input.down state = states.CROUCH_BLOCK else state = states.BLOCK;
        move.hsp = 0;
    } else {
        if input.down {
            state = states.CROUCH;
            move.hsp = 0;
        } else {
            if move.hsp != 0 {
                if !_player_on_ground() state = states.JUMP else state = states.WALK;
            } else {
                state = states.IDLE;
            }
        }
    }
}