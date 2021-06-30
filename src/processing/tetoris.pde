import processing.serial.*;
import cc.arduino.*;
import java.util.*;
import java.io.*;

Arduino arduino;
int input0 = 0,input2 = 2,input4 = 4,input6 = 3;//input0 = rot input2 = light input4 = joystick_x input6 = joystick_y
int rot_pre = 0;
int light_pre = 100;
int[][] block = new int[4][4];
int[][][] field = new int[2][10][20];
int stage = 0;
int line = 0;
int count = 0;
int x_pos = 4 ,y_pos = 0;
int[][] top = new int[2][10];
int[][] bottom = new int[2][4];
int[][] i_block = {{0,0,1,0},{0,0,1,0},{0,0,1,0},{0,0,1,0}};
int[][] s_block = {{0,0,0,0},{0,1,1,0},{0,0,1,1},{0,0,0,0}};
int[][] z_block = {{0,0,0,0},{0,0,1,1},{0,1,1,0},{0,0,0,0}};
int[][] t_block = {{0,0,0,0},{0,0,1,0},{0,1,1,1},{0,0,0,0}};
int[][] o_block = {{0,0,0,0},{0,1,1,0},{0,1,1,0},{0,0,0,0}};
int[][] l_block = {{0,1,0,0},{0,1,0,0},{0,1,1,0},{0,0,0,0}};
int[][] rl_block = {{0,0,1,0},{0,0,1,0},{0,1,1,0},{0,0,0,0}};

void get_block(){
  float get = random(7);
  if(get < 1){
    block = i_block;
  }
  else if(get < 2){
    block = s_block;
  }
  else if(get < 3){
    block = z_block;
  }
  else if(get < 4){
    block = t_block;
  }
  else if(get < 5){
    block = o_block;
  }
  else if(get < 6){
    block = l_block;
  }
  else{
    block = rl_block;
  }
  for(int x = 0; x < 4; x++){
    for(int y = 0; y < 4; y++){
      if(block[x][y] == 1){
        bottom[stage][x] = y;
      }
    }
  }
  x_pos = 8;
  y_pos = 0;
}

void rotation(int rot){
  if(rot_pre > rot){
      int[][] tmp_block = new int[4][4];
      for(int x = 0; x < 4; x++){
        for(int y = 0; y < 4; y++){
          tmp_block[x][y] = block[3-y][x];
        }
      }
      block = tmp_block;
      for(int x = 0; x < 4; x++){
        for(int y = 0; y < 4; y++){
          if(block[x][y] == 1){
            bottom[stage][x] = y;
          }
        }
      }
  }
  rot_pre = rot;
}

void stage_change(int light){
    if(stage == 0){
    if(light_pre - light > 50 ){
      stage = 1;
      get_block();
    }
  }
  else{
    if(light - light_pre > 50){
      stage = 0;
      get_block();
    }
  }
  light_pre = light;
}

void check(){
  int check = 0;
  for(int i = 0; i < 4; i++){
    System.out.println(stage+","+x_pos +","+i+","+y_pos);
    if(top[stage][x_pos+i] - y_pos - bottom[stage][i] == 1){
      check = 1;
    }
  }
  if(check == 1){
    for(int x = 0; x < 4; x++){
      for(int y = 0; y < 4; y++){
        field[stage][x_pos+x][y_pos+y] = block[x][y];
      }
    }
    for(int x = 0; x < 10; x++){
      for(int y = 19; y >=0; y--){
        if(field[stage][x][y] == 1){
          top[stage][x] = y;
        }
      }
    }
    get_block();
  }
}

void move(int move_x,int move_y){
  int loc = 0;
  if(move_x > 1023/2*(1-cos(3.14/3)) && move_x <1023/2*(1-cos(2*3.14/3)) && move_y > 0 && move_y < 1023/2*(1-sin(3.14/3))){
    for(int i = 0; i<4; i++){
      for(int j = 3; j>=0; j++){
        if(block[i][j] == 1){
          loc = j;
        }
      }
    }
    if(x_pos+loc<9){
      x_pos = x_pos+1;
    }
  }
  else if(move_x > 1023/2*(1-cos(5*3.14/6)) && move_x < 1023 &&
  move_y > 1023/2*(1-sin(5*3.14/6)) &&move_y < 1023/2*(1-sin(7*3.14/6))){
    for(int i = 3; i>=0; i++){
      for(int j = 3; j>=0; j++){
        if(block[j][i] == 1){
          loc = j;
        }
      }
    }
    if(y_pos+loc<19){
      y_pos = y_pos+1;
    }
    else if(move_x > 1023/2*(1-cos(3.14/3)) &&move_x <1023/2*(1-cos(2*3.14/3)) &&
   move_y > 1023/2*(1-sin(5*3.14/3)) &&move_y < 1023){
      if(x_pos > 0){
        x_pos = x_pos - 1;
      }
    }
  }
}

void delete(){
  boolean flug = true;
  List<Integer> array = new ArrayList<Integer>();
  for(int y = 0; y <20; y++){
    for(int x = 0; x < 10; x++){
      if(field[stage][x][y] == 0){
        flug = false;
      }
    }
    if(flug){
      array.add(y);
      line++;
    }
  }
  for(int i = 0; i < array.size(); i++){
    for(int y = array.get(i); y > 0; y--){
      for(int x = 0; x < 10; x++){
        field[stage][x][y] = field[stage][x][y-1];
      }
    }
  }
}

void drawing(){
  for(int x = 0; x < 10; x++){
    for(int y = 0; y < 20; y++){
      if(field[stage][x][y] == 1){
        rect(20*x,20*y,50,50);
      }
    }
  }
  for(int x = 0; x < 4; x++){
    for(int y = 0; y <4; y++){
      if(block[x][y] == 1){
        rect(20*(x_pos+x),20*(y_pos+y),19,19);
      }
    }
  }
}

void setup() {
  size(500, 1000);
  arduino = new Arduino(this, "COM4", 
    57600);
  arduino.pinMode(input0, Arduino.INPUT);
  arduino.pinMode(input2, Arduino.INPUT);
  arduino.pinMode(input4, Arduino.INPUT);
  arduino.pinMode(input6, Arduino.INPUT);
   
}

void draw() {
  background(0);
  int rot = arduino.analogRead(input0);
  int light = arduino.analogRead(input2); 
  int move_x = arduino.analogRead(input4);
  int move_y = arduino.analogRead(input6);
  rotation(rot);
  move(move_x,move_y);
  check();
  delete();
  stage_change(light);
  drawing();
  delay(1000);
  if(line == 5){
    text("player1 win!" ,0,0);
    noLoop();
  }
  if(count == 60){
    text("player2 win!",0,0);
    noLoop();
  }
  noLoop();
  count++;
}
