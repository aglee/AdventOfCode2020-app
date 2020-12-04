# Grid

Advent of Code usually has a number of puzzles that involve a grid data structure, for example to represent a maze.  This directory contains two kinds of grid:

- `CharGrid` is a finite rectangular grid of 1-character strings -- basically syntactic sugar around a 2-dimensional array.
- `Grid` represents an infinite grid, for when we don't know the bounds of the grid beforehand, and/or we may need to use points with negative coordinates, and/or we may need to deal with coordinates so large it would be impractical to use an array.



