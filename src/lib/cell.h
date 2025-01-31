#ifndef CELL_H
#define CELL_H

#include "common.h"

class Cell{
  public:
    Cell(int x, int y);
    Cell();
    // Cell(const Cell &c1); //copying constructor
    int getX();
    void setX(int x);
    int getY();
    void setY(int y);

  private:
    int x, y;
};

#endif