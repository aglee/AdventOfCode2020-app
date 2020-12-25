# Day 17 - Conway Cubes

<https://adventofcode.com/2020/day/17>

Type of puzzle: Game of Life.

When I saw the problem description I thought my `Grid` stuff in `Common` might be useful, but when I actually got down to business I never felt the need to use any of it.

This time I didn't write the `dump()` method until I actually needed it for debugging.

After my initial commit of my solution, I fiddled with the code, for example changing a class to a struct.  I briefly had thoughts of putting `PointSet3D` and `PointSet4D` objects in `Common`, and moving the puzzle-specific code into extensions.  But I didn't go through with it.

Stumbles:

- I made a copy-paste error when I had some code that dealt with `x` and wanted to do the same for `y` and `z`.  As I was copy-pasting, I told myself to be careful of errors.  I even double-checked and didn't see the error.  Only when I got incorrect test results and went back to examine the code again did I spot the error.  Changing an `x` to a `z` fixed it.
- Out of habit, when I wrote the method to compute all neighbors of a point, I added a constraint that every neighbor be "in bounds".  But that constraint did not apply in this puzzle, at least not the way I wrote it, and so I was failing to examine some neighbors I needed to examine.  This was one of a couple of false starts that turned out to be code I never needed to write.


