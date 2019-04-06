Cell[][] grid;
Cell[][] next;
int cols;
int rows;
int resolution = 10; //3 is the lowest we can go here
int generation = 0;
final int NUM_STATES = 75;

class stateChange {
  int state;
  int generation;

  stateChange(int thisState, int thisGeneration) {
    state = thisState;
    generation = thisGeneration;
  }
}

class Cell {
  Cell(int thisValue, stateChange[] thisStateChanges) {
    value = thisValue;
    stateChanges = thisStateChanges;
  }
  Cell(int thisValue, stateChange[] thisStateChanges, int thisIterator) {
    value = thisValue;
    stateChanges = thisStateChanges;
    iterator = thisIterator;
  }  
  Cell(int thisValue) {
    value = thisValue;
  }
  int iterator;  
  int value;
  stateChange[] stateChanges;
}

void setup() {
  size(1100, 1000);
  cols = (width-200) / resolution;
  rows = height / resolution;
  grid = new Cell[cols][rows];

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      stateChange[] states = new stateChange[NUM_STATES];
      for (int k = 0; k<NUM_STATES; k++) {
        stateChange stateChange = new stateChange(2, 0);
        states[k] = stateChange;
      }
      if (floor(random(2)) == 1) {
        grid[i][j] = new Cell(floor(random(2)), states, 0);
      } else {
        grid[i][j] = new Cell(0, states, 0);
      }
    }
  }
}

void draw() {

  background(0);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * resolution;
      int y = j * resolution;
      if (grid[i][j].value == 1) {
        fill(255);
        stroke(0);
        rect(x, y, resolution - 1, resolution - 1);
      }
      //} else if (grid[i][j].stateChanges[0].state != 2) {
      //  fill(100);
      //  stroke(0);
      //  rect(x, y, resolution - 1, resolution - 1);
      //}
    }
  }

  Cell[][] next = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      next[i][j] = new Cell(grid[i][j].value, grid[i][j].stateChanges, grid[i][j].iterator++);
    }
  }


  // Compute next based on grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int state = grid[i][j].value;
      // Count live neighbors!
      int neighbors = countNeighbors(grid, i, j);

      if (state == 0 && neighbors == 3) {      
        next[i][j].value = 1;
        if ( grid[i][j].value != next[i][j].value) {
          logChange(next, i, j, state, next[i][j].iterator);
          next[i][j].iterator++;
        }
      } else if (state == 1 && (neighbors < 2 || neighbors > 3)) {
        next[i][j].value = 0;
        if ( grid[i][j].value != next[i][j].value) {
          logChange(next, i, j, state, next[i][j].iterator);
          next[i][j].iterator++;
        }
      } else {     
        next[i][j].value = state;
      }
    }
  }
  grid = next;
  generation++;
}



int countNeighbors(Cell[][] grid, int x, int y) {
  int sum = 0;
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      int col = (x + i + cols) % cols;
      int row = (y + j + rows) % rows;
      sum += grid[col][row].value;
    }
  }
  sum -= grid[x][y].value;
  return sum;
}

void logChange(Cell[][] next, int x, int y, int state, int itr) {
  stateChange stateChange = new stateChange(state, generation);  
  next[x][y].stateChanges[itr%NUM_STATES] = stateChange;
}

void mousePressed() {
  noLoop(); 
  int x = mouseX/ resolution;
  int y = mouseY/ resolution;
  //print("---------------------------------------\n");
  if (x <= (width-200) / resolution) {
    for (int i = 0; i<NUM_STATES; i++) {
      textSize(18);
      text("State", width-170, height/100+5);
      text("Generation", width-110, height/100+5);
      textSize(14);
      if (grid[x][y].stateChanges[i].state != 2) {
        text(grid[x][y].stateChanges[i].state, width-150, floor((height/100)+20)+i*13);
        text(grid[x][y].stateChanges[i].generation, width-80, floor((height/100)+20)+i*13);
      }
    }
  }
}

void mouseReleased() {
  loop();
}
