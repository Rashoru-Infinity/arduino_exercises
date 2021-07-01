import processing.serial.*;
import cc.arduino.*;
import java.util.*;
import java.io.*;

int width = 750;
int height = 1500;

final int rowLength = 10;
final int columnLength = 30;
final int objectWidth = 4;
final int objectHeight = 4;

enum Direction {
  right,
  left,
  down,
  undefined
};

Arduino arduino;
//input0 = potentionmeter input2 = light input4 = joystick_x input6 = joystick_y
int input0 = 0,input2 = 2,input4 = 4,input6 = 3;
//previous potention value
int rot_pre = 0;
//previous light strength
int light_pre = 100;
//shape of object that is moving
int[][] block = new int[4][4];
//block status [stage][x][y]
int[][][] field = new int[2][10][30];
int stage = 0;
//number of deleted lines max = 5
int line = 0;
//time max = 60
int count = 0;
//position of upper left
int x_pos = 0, y_pos = 0;
//height of fallen objects
int[][] top = new int[2][10];
//height(y value) of object that is moving
int[][] bottom = new int[2][4];
//shape of blocks
int[][] i_block = {{0,0,1,0},{0,0,1,0},{0,0,1,0},{0,0,1,0}};
int[][] s_block = {{0,0,0,0},{0,1,1,0},{0,0,1,1},{0,0,0,0}};
int[][] z_block = {{0,0,0,0},{0,0,1,1},{0,1,1,0},{0,0,0,0}};
int[][] t_block = {{0,0,0,0},{0,0,1,0},{0,1,1,1},{0,0,0,0}};
int[][] o_block = {{0,0,0,0},{0,1,1,0},{0,1,1,0},{0,0,0,0}};
int[][] l_block = {{0,1,0,0},{0,1,0,0},{0,1,1,0},{0,0,0,0}};
int[][] rl_block = {{0,0,1,0},{0,0,1,0},{0,1,1,0},{0,0,0,0}};

long time = Long.MAX_VALUE;



/*
 * loads new blocks
 */
void set_block(){
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
  for(int x = 0; x < objectWidth; x++){
    for(int y = 0; y < objectHeight; y++){
      if(block[x][y] == 1){
        bottom[stage][x] = y;
      }
    }
  }
  x_pos = 5;
  y_pos = 0;
}

void printTop() {
  for (int i = 0;i < top[0].length;i++) {
    System.out.print(top[stage][i]);
  }
  System.out.print(System.getProperty("line.separator"));
}

/*
 * rotate blocks
 * @value rot value of potentionmeter
 */
void rotate(int rot){
    int[][] tmp_block = new int[4][4];
    for(int x = 0; x < tmp_block.length; x++){
      for(int y = 0; y < tmp_block[x].length; y++){
        //turn right
        if (rot_pre > rot + 50) {
          tmp_block[block.length - 1 - y][x] = block[x][y];
        //turn left
        } else if (rot_pre < rot - 50) {
          tmp_block[y][block.length - 1 - x] = block[x][y];
        }
      }
    }
    if (abs(rot - rot_pre) <= 50) {
      return ;
    }
    if (!isRotatable(tmp_block)) {
      return ;
    }
    for (int x = 0;x < block.length;x++) {
      for (int y = 0;y < block[x].length;y++) {
        block[x][y] = tmp_block[x][y];
      }
    }
    setBottom();
  rot_pre = rot;
}

Direction getDirection(int x_in, int y_in) {
  if (x_in == 0) {
    return Direction.right;
  }
  if (x_in == 1023) {
    return Direction.left;
  }
  if (y_in == 1023) {
    return Direction.down;
  }
  return Direction.undefined;
}
/*
 * change stage
 * @value light strength of light
 */
void changeStage(int light){
    if(stage == 0){
    if(light_pre - light > 50 ){
      stage = 1;
      set_block();
    }
  }
  else{
    if(light - light_pre > 50){
      stage = 0;
      set_block();
    }
  }
  light_pre = light;
}
/*
 * checks if block is fallen or not
 */
boolean checkFallen(){
  //System.out.println(y_pos);
  //System.out.println(field[stage][x_pos].length);
  int check = 0;
  for(int x = 0; x < block.length && x_pos + x < rowLength; x++){
    if (y_pos + bottom[stage][x] + 1 == columnLength) {
      check = 1;
    }
    if(check != 1 && x_pos + x >= 0 && field[stage][x_pos + x][y_pos + bottom[stage][x] + 1] == 1){
      if (block[x][bottom[stage][x]] == 1) {
        check = 1;
      }
    }
  } //<>//
  if(check == 1){
    for(int x = 0; x < objectWidth; x++){
      for(int y = 0; y < objectHeight; y++){
        if (block[x][y] == 1 && x_pos + x < field[stage].length) {
          field[stage][x_pos+x][y_pos+y] = block[x][y];
        }
      }
    }
    for(int x = 0; x < field[stage].length; x++){
      for(int y = field[stage][x].length - 1; y >=0; y--){
        if(field[stage][x][y] == 1){
          top[stage][x] = y;
        }
      }
    }
    set_block();
    return true;
  }
  return false;
}

/*
 * set moving object bottom
 */
void setBottom() {
  for (int x = 0;x < block.length;x++) {
    for (int y = block[x].length - 1;y >= 0;y--) {
      if (block[x][y] == 1) {
        bottom[stage][x] = y;
        break;
      }
    }
  }
}

void setTop() {
  for (int x = 0;x < field[stage].length;x++) {
    int y = 0;
    for (;y < field[stage][x].length;y++) {
      if (field[stage][x][y] == 1) {
        top[stage][x] = y;
        break;
      }
    }
    if (y == field[stage][x].length) {
      top[stage][x] = 50;
    }
  }
}

boolean isRotatable(int[][] rotatingObject) {
  for (int x = 0;x < rotatingObject.length;x++) {
    if (x_pos + x < 0 || x_pos + x >= field[stage].length) {
      return false;
    }
    for (int y = rotatingObject[x].length - 1;y >= 0;y--) {
      if (y_pos + y >= field[stage][x].length) {
        return false;
      }
      if (y_pos + y >= field[stage][x_pos + x].length) {
        return false;
      }
      if (x_pos + x < 0 || x_pos + x >= field[stage].length) {
        return false;
      }
      if (field[stage][x_pos + x][y_pos + y] == 1) {
        return false;
      }
    }
  }
  return true;
}
/*
 * moves blocks
 */
void move(int move_x,int move_y){
  if (time / 100 != millis() / 100) {
    if (checkFallen()) {
      return ;
    }
    y_pos++;
    time = millis();
  }
  int loc = 0;
  if(getDirection(move_x, move_y) == Direction.right) {
    for (int x = 0;x < block.length;x++) {
      for (int y = 0;y < block[x].length;y++) {
        if (block[x][y] == 1 && x + x_pos + 1 < field[stage].length && field[stage][x + x_pos + 1][y + y_pos] == 1) {
            return ;
        }
        if (block[x][y] == 1 && x + x_pos + 1 >= field[stage].length) {
          return ;
        }
      }
    }
    x_pos++;
  } else if(getDirection(move_x, move_y) == Direction.down){
    for (int x = 0;x < block.length;x++) {
      for (int y = 0;y < block[x].length;y++) {
        if (block[x][y] == 1 && y + y_pos + 1 < field[stage][x].length && field[stage][x + x_pos][y + y_pos + 1] == 1) {
            return ;
        }
        if (block[x][y] == 1 && y + y_pos + 1 >= field[stage][x].length) {
          return ;
        }
      }
    }
    y_pos++;
  } else if (getDirection(move_x, move_y) == Direction.left){
    for (int x = 0;x < block.length;x++) {
      for (int y = 0;y < block[x].length;y++) {
        if (block[x][y] == 1 && x + x_pos - 1 >= 0 && field[stage][x + x_pos - 1][y + y_pos] == 1) {
            return ;
        }
        if (block[x][y] == 1 && x + x_pos - 1 < 0) {
          return ;
        }
      }
    }
    x_pos--;
  }
  checkFallen();
}

/*
 * deletes completed row
 */
void delete(){
  List<Integer> array = new ArrayList<Integer>();
  for(int y = 0; y < field[stage][0].length; y++){
    boolean removeable = true;
    for(int x = 0; x < field[stage].length; x++){
      if(field[stage][x][y] == 0){
        removeable = false;
        break;
      }
    }
    if(removeable){
      array.add(y);
      line++;
    }
  }
  for(int i = 0; i < array.size(); i++){
    System.out.println(i);
    for(int y = array.get(i); y > 0; y--){
      for(int x = 0; x < rowLength; x++){
        field[stage][x][y] = field[stage][x][y - 1];
        field[stage][x][y - 1] = 0;
      }
    }
  }
  setTop();
}

/*
 * draws field
 */
void updateView(){
  for(int x = 0; x < field[stage].length; x++){
    for(int y = 0; y < field[stage][x].length; y++){
      if(field[stage][x][y] == 1){
        rect(width / rowLength * x + 1, height / columnLength * y + 1, width / rowLength - 2, height / columnLength - 2);
      }
    }
  }
  fill(255,255,255);
  for(int x = 0; x < objectWidth; x++){
    for(int y = 0; y < objectHeight; y++){
      if(block[x][y] == 1){
        rect(width / rowLength * (x_pos+x) + 1, height / columnLength * (y_pos + y) + 1, width / rowLength - 2, height / columnLength - 2);
      }
    }
  }
  fill(255, 0, 0);
  line(0, height / columnLength * 10, width, height / columnLength * 10);
  stroke(255);
}

void setup() {
  size(800, 1500);
  arduino = new Arduino(this, "COM4", 57600);
  arduino.pinMode(input0, Arduino.INPUT);
  arduino.pinMode(input2, Arduino.INPUT);
  arduino.pinMode(input4, Arduino.INPUT);
  arduino.pinMode(input6, Arduino.INPUT);
  for (int stage = 0;stage < top.length;stage++) {
    for (int x = 0;x < top[stage].length;x++) {
      top[stage][x] = field[stage][x].length;
    }
  }
  delay(1000);
  set_block();
}

void draw() {
  background(0);
  int rot = arduino.analogRead(input0); 
  int move_x = arduino.analogRead(input4);
  int move_y = arduino.analogRead(input6);

  textSize(32);
  text("Time Limit : " + ((300 * 1000 - millis()) / 1000) + "[s]", 20, 60);
  
  printTop();
  rotate(rot);
  move(move_x,move_y);
  delete();
  updateView();
  if(line >= 1){
    textSize(60);
    text("Congulatulations!!!!" , 80, height / 2);
    noLoop();
  }
  if (millis() >= 300 * 1000) {
    textSize(60);
    text("GameOver!", 210, height / 2);
    noLoop();
  }
  for (int x = 0;x < rowLength;x++) {
    if (top[stage][x] < 10) {
      textSize(60);
      text("GameOver!", 210, height / 2);
      noLoop();
    }
  }
}
