// player_inputs
input = {}

// player_movements
move = {
    hsp: 0,
    vsp: 0,
    max_hsp: 2,
    hsp_decimal: 0,
    vsp_decimal: 0,
    walk_spd: 1.5,
    drag: .12,
    jump_spd: -5,
    jump_drag: 2.5,
    jumps: 2,
    max_jumps: 2,
    facing: 1
}

// states
enum states {
    IDLE, // 0
    WALK, // 1
    JUMP, // 2
    ATTACK, // 3
    BLOCK, // 4
    CROUCH, // 5
    CROUCH_BLOCK, // 6
}
state = states.IDLE;

// states array
player_step[states.IDLE]           = FSM_player_idle;
player_step[states.WALK]           = FSM_player_walk;
player_step[states.JUMP]           = FSM_player_jump;
player_step[states.ATTACK]         = FSM_player_attack;
player_step[states.BLOCK]          = FSM_player_block;
player_step[states.CROUCH]         = FSM_player_crouch;
player_step[states.CROUCH_BLOCK]   = FSM_player_crouch_block;

// sprites array
player_sprite[states.IDLE]           = spr_player_idle;
player_sprite[states.WALK]           = spr_player_walk;
player_sprite[states.JUMP]           = spr_player_jump;
player_sprite[states.ATTACK]         = spr_player_attack;
player_sprite[states.BLOCK]          = spr_player_block;
player_sprite[states.CROUCH]         = spr_player_crouch;
player_sprite[states.CROUCH_BLOCK]   = spr_player_crouch_block;

// mask array
player_mask[states.IDLE]           = spr_player_idle;
player_mask[states.WALK]           = spr_player_idle;
player_mask[states.JUMP]           = spr_player_idle;
player_mask[states.ATTACK]         = spr_player_idle;
player_mask[states.BLOCK]          = spr_player_idle;
player_mask[states.CROUCH]         = spr_player_crouch;
player_mask[states.CROUCH_BLOCK]   = spr_player_crouch;
