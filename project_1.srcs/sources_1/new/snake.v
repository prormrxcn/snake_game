`timescale 1ns / 1ps

module snake_game(
    input clk,             // 100MHz clock from Basys3
    input reset,           // btnC for reset
    input [3:0] ctrl,      // ctrl[0]=up, ctrl[1]=down, ctrl[2]=left, ctrl[3]=right
    output reg [3:0] vga_red,
    output reg [3:0] vga_green,
    output reg [3:0] vga_blue,
    output vga_hsync,
    output vga_vsync
);

    // VGA timing (640x480 @ 60Hz)
    parameter H_DISPLAY = 640, H_FRONT = 16, H_SYNC = 96, H_BACK = 48;
    parameter V_DISPLAY = 480, V_FRONT = 10, V_SYNC = 2, V_BACK = 33;
    parameter H_TOTAL = H_DISPLAY + H_FRONT + H_SYNC + H_BACK;
    parameter V_TOTAL = V_DISPLAY + V_FRONT + V_SYNC + V_BACK;

    // Game configuration
    parameter GRID_SIZE = 20;
    parameter GRID_WIDTH = H_DISPLAY / GRID_SIZE;
    parameter GRID_HEIGHT = V_DISPLAY / GRID_SIZE;
    parameter INITIAL_LENGTH = 3;
    parameter MAX_SNAKE_LENGTH = 64;
    parameter GAME_SPEED = 10000000;  // 10Hz game speed (100ms)

    // Color constants
    parameter SNAKE_COLOR = 12'h0F0, FOOD_COLOR = 12'hF00;
    parameter BG_COLOR = 12'h000, BORDER_COLOR = 12'h888;

    // Pixel clock (25MHz)
    reg [1:0] pix_clk_div = 0;
    wire pix_clk = pix_clk_div[1];
    always @(posedge clk)
        pix_clk_div <= pix_clk_div + 1;

    // VGA sync counters
    reg [9:0] h_count = 0, v_count = 0;
    always @(posedge pix_clk) begin
        h_count <= reset ? 0 : 
                  (h_count == H_TOTAL - 1) ? 0 : h_count + 1;
        v_count <= reset ? 0 : 
                  (h_count == H_TOTAL - 1) ? 
                      (v_count == V_TOTAL - 1) ? 0 : v_count + 1 
                  : v_count;
    end

    assign vga_hsync = ~((h_count >= H_DISPLAY + H_FRONT) && (h_count < H_DISPLAY + H_FRONT + H_SYNC));
    assign vga_vsync = ~((v_count >= V_DISPLAY + V_FRONT) && (v_count < V_DISPLAY + V_FRONT + V_SYNC));

    // Game clock
    reg [24:0] game_counter = 0;
    wire game_clk = (game_counter == GAME_SPEED - 1);
    always @(posedge clk)
        game_counter <= reset ? 0 : 
                       game_clk ? 0 : game_counter + 1;

    // Button sync
    reg [2:0] btn_sync [0:3];
    always @(posedge clk) begin
        btn_sync[0] <= reset ? 0 : {btn_sync[0][1:0], ctrl[0]};
        btn_sync[1] <= reset ? 0 : {btn_sync[1][1:0], ctrl[1]};
        btn_sync[2] <= reset ? 0 : {btn_sync[2][1:0], ctrl[2]};
        btn_sync[3] <= reset ? 0 : {btn_sync[3][1:0], ctrl[3]};
    end

    wire [3:0] btn_pressed = {
        btn_sync[0][1] & ~btn_sync[0][2], // up
        btn_sync[1][1] & ~btn_sync[1][2], // down
        btn_sync[2][1] & ~btn_sync[2][2], // left
        btn_sync[3][1] & ~btn_sync[3][2]  // right
    };

    // Game state
    reg [5:0] snake_x [0:MAX_SNAKE_LENGTH-1];
    reg [5:0] snake_y [0:MAX_SNAKE_LENGTH-1];
    reg [5:0] food_x, food_y;
    reg [6:0] snake_length;
    reg [1:0] direction, next_direction;
    reg [15:0] score;
    reg game_over;

    // LFSR for food
    reg [15:0] lfsr = 16'hACE1;
    always @(posedge clk)
        lfsr <= game_clk ? {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]} : lfsr;

    // Reset/init and game state update
    integer i;
    reg [5:0] new_head_x, new_head_y;
    reg collision_self, collision_food;

    // Self-collision check
    always @(*) begin
        collision_self = 0;
        for (i = 1; i < snake_length; i = i + 1)
            collision_self = collision_self | ((new_head_x == snake_x[i]) && (new_head_y == snake_y[i]));
    end

    always @(posedge clk) begin
        // Direction input handling
        next_direction <= reset ? 1 : 
                         !game_over ? 
                             (btn_pressed[0] && (direction != 2)) ? 0 :
                             (btn_pressed[3] && (direction != 3)) ? 1 :
                             (btn_pressed[1] && (direction != 0)) ? 2 :
                             (btn_pressed[2] && (direction != 1)) ? 3 : next_direction
                         : next_direction;

        // Calculate new head position
        new_head_x <= (next_direction == 0) ? snake_x[0] : 
                     (next_direction == 1) ? (snake_x[0] == GRID_WIDTH - 1) ? 0 : snake_x[0] + 1 :
                     (next_direction == 3) ? (snake_x[0] == 0) ? GRID_WIDTH - 1 : snake_x[0] - 1 : snake_x[0];
                     
        new_head_y <= (next_direction == 0) ? (snake_y[0] == 0) ? GRID_HEIGHT - 1 : snake_y[0] - 1 :
                     (next_direction == 2) ? (snake_y[0] == GRID_HEIGHT - 1) ? 0 : snake_y[0] + 1 : snake_y[0];

        collision_food <= (new_head_x == food_x) && (new_head_y == food_y);

        // Game state updates
        direction <= reset ? 1 : 
                    (game_clk && !game_over) ? next_direction : direction;
        
        game_over <= reset ? 0 : 
                    (game_clk && collision_self) ? 1 : game_over;

        snake_length <= reset ? INITIAL_LENGTH : 
                      (game_clk && !game_over && collision_food && (snake_length < MAX_SNAKE_LENGTH)) ? snake_length + 1 : snake_length;

        score <= reset ? 0 : 
                (game_clk && !game_over && collision_food) ? score + 10 : score;

        food_x <= reset ? GRID_WIDTH/4 : 
                 (game_clk && !game_over && collision_food) ? lfsr[4:0] % GRID_WIDTH : food_x;
        food_y <= reset ? GRID_HEIGHT/4 : 
                 (game_clk && !game_over && collision_food) ? lfsr[9:5] % GRID_HEIGHT : food_y;

        // Snake body movement
        if (game_clk && !game_over && !reset) begin
            snake_x[0] <= new_head_x;
            snake_y[0] <= new_head_y;
            for (i = MAX_SNAKE_LENGTH - 1; i > 0; i = i - 1) begin
                snake_x[i] <= (i < snake_length) ? snake_x[i-1] : snake_x[i];
                snake_y[i] <= (i < snake_length) ? snake_y[i-1] : snake_y[i];
            end
        end
        else if (reset) begin
            snake_x[0] <= GRID_WIDTH/2;
            snake_y[0] <= GRID_HEIGHT/2;
            for (i = 1; i < MAX_SNAKE_LENGTH; i = i + 1) begin
                snake_x[i] <= (i == 1) ? GRID_WIDTH/2 - 1 : 
                             (i == 2) ? GRID_WIDTH/2 - 2 : 0;
                snake_y[i] <= (i == 1) ? GRID_HEIGHT/2 : 
                             (i == 2) ? GRID_HEIGHT/2 : 0;
            end
        end
    end

    // Rendering
    reg [5:0] grid_x, grid_y;
    reg snake_pixel, food_pixel, border_pixel;
    integer i_render;
    
    always @(posedge pix_clk) begin
        grid_x <= h_count / GRID_SIZE;
        grid_y <= v_count / GRID_SIZE;
    end
    
    always @(posedge pix_clk) begin
        snake_pixel = 0;
        for (i_render = 0; i_render < snake_length; i_render = i_render + 1)
            snake_pixel = snake_pixel | ((grid_x == snake_x[i_render]) && (grid_y == snake_y[i_render]));
        
        food_pixel = (grid_x == food_x) && (grid_y == food_y);
        border_pixel = (h_count < 2) || (h_count >= H_DISPLAY - 2) || 
                       (v_count < 2) || (v_count >= V_DISPLAY - 2);
    end

    // VGA color output
    always @(posedge pix_clk) begin
        {vga_red, vga_green, vga_blue} <= 
            (h_count < H_DISPLAY && v_count < V_DISPLAY) ? 
                (snake_pixel ? SNAKE_COLOR : 
                 food_pixel ? FOOD_COLOR : 
                 border_pixel ? BORDER_COLOR : BG_COLOR) 
            : 12'h000;
    end
endmodule