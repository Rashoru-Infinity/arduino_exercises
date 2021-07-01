import processing.serial.*;
import cc.arduino.*;
import java.util.*;
import java.io.*;

int width = 750;
int height = 1500;

final int rowLength = 25;
final int columnLength = 50;
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
int[][][] field = new int[2][25][50];
int stage = 0;
//number of deleted lines max = 5
int line = 0;
//time max = 60
int count = 0;
//position of upper left
int x_pos = 0, y_pos = 0;
//height of fallen objects
int[][] top = new int[2][25];
//height(y value) of object that is moving
int[][] bottom = new int[2][4];
//shape of blocks
//int[][] i_block = {{0,0,1,0},{0,0,1,0},{0,0,1,0},{0,0,1,0}};
int[][] i_block = {{1,1,1,1},{0,0,0,0},{0,0,0,0},{0,0,0,0}};
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
  get = 0;
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
  //x_pos = 12;
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
void rotation(int rot){
  if(rot_pre > rot){
      int[][] tmp_block = new int[4][4];
      for(int x = 0; x < tmp_block.length; x++){
        for(int y = 0; y < tmp_block[x].length; y++){
          tmp_block[x][y] = block[tmp_block[x].length - 1 - y][x];
        }
      }
      if (!isRotatable(tmp_block)) {
        return ;
      }
      block = tmp_block;
      setBottom();
  }
  rot_pre = rot;
}

Direction getDirection(int x_in, int y_in) {
  if (x_in > 1023/2*(1-cos(PI/3)) && x_in < 1023/2*(1-cos(2*PI/3))
    && y_in > 0 && y_in < 1023/2*(1-sin(PI/3))) {
    return Direction.right;
  }
  if (x_in > 1023/2*(1-cos(5*PI/6)) && x_in < 1023
    && y_in > 1023/2*(1-sin(5*PI/6)) && y_in < 1023/2*(1-sin(7*PI/6))) {
    return Direction.down;
  }
  if (x_in > 1023/2*(1-cos(PI/3)) && x_in <1023/2*(1-cos(2*PI/3))
    && y_in > 1023/2*(1-sin(5*PI/3)) && y_in < 1023) {
    return Direction.left;
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
 * checks if block is fallen
 */
boolean checkFallen(){
  //System.out.println(y_pos);
  //System.out.println(field[stage][x_pos].length);
  int check = 0;
  for(int i = 0; i < objectWidth && x_pos + i < rowLength; i++){
    if(top[stage][x_pos+i] - (y_pos + bottom[stage][i]) == 1){
      check = 1;
    }
  }
  if(check == 1){
    for(int x = 0; x < objectWidth; x++){
      for(int y = 0; y < objectHeight; y++){
        if (block[x][y] == 1) {
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
    ++x_pos;
    x_pos %= rowLength;
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
    for (int y = rotatingObject[x].length - 1;y >= 0;y--) {
      if (y_pos + y >= field[stage][x_pos + x].length) {
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
  text(y_pos, 20, 40);
  text(time / 1000, 20, 80);
  text(millis() / 1000, 20, 120);
  if (time / 10 != millis() / 10) {
    if (checkFallen()) {
      return ;
    }
    y_pos++;
    time = millis();
  }
  int loc = 0;
  if(getDirection(move_x, move_y) == Direction.right) {
    for(int i = 0; i < objectWidth; i++){
      for(int j = objectHeight - 1; j >= 0; j--){
        if(block[i][j] == 1){
          loc = j;
        }
      }
    }
    if(x_pos+loc < field[stage].length){
      x_pos++;
    }
  } else if(getDirection(move_x, move_y) == Direction.down){
    for (int x = 0;x < block.length;x++) {
      if (bottom[stage][x] + 1 >= top[stage][x]) {
        return ;
      }
      y_pos++;
    }
  } else if (getDirection(move_x, move_y) == Direction.left){
    if(x_pos > 0){
      for (int y = 0;y < block.length;y++) {
        if (field[stage][x_pos - 1][y] == 1) {
          return ;
        }
      }
      x_pos++;
    }
  }
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
    for(int y = array.get(i); y > 0; y--){ //<>//
      for(int x = 0; x < rowLength; x++){
        field[stage][x][y] = field[stage][x][y - 1];
        field[stage][x][y - 1] = 0; //<>//
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
  line(0, width / rowLength * 10, width, height / columnLength * 10);
  stroke(255);
}

void setup() {
  size(750, 1500);
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
}

void draw() {
  background(0);
  int rot = arduino.analogRead(input0);
  int light = arduino.analogRead(input2); 
  int move_x = arduino.analogRead(input4);
  int move_y = arduino.analogRead(input6);
  //rotation(rot);
  printTop();
  move(move_x,move_y);
  //checkFallen();
  delete();
  changeStage(light);
  updateView();
  //delay(1000);
  if(line == 5){
    text("player1 win!" ,20,40);
    noLoop();
  }
  //if(count == 60){
  if (millis() >= 100 * 1000) {
    text("player2 win!",20,40);
    noLoop();
  }
  for (int x = 0;x < top[stage].length;x++) {
    if (top[stage][x] < 10) {
      text("player2 win!", 20, 40);
      noLoop();
    }
  }
  //noLoop();
  count++;
}
