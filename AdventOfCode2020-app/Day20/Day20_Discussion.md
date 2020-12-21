# Day 20 - Jurassic Jigsaw

<https://adventofcode.com/2020/day/20>

Concept of "edge number" -- treating edge characters as binary digits.  Accounting for flips and rotations, each tile has 8 possible edge numbers: 4 from the initial data, and the "reversals" of those 4 (rotations and flips cause the binary digits along edges on either 2 or 4 edges to reverse order).

It helped to picture each tile like this, with a, b, c, and d as edge numbers:

```text
+---------+
|\       /|
| \  a  / |
|  \   /  |
|   \ /   |
| b  X  d |
|   / \   |
|  /   \  |
| /  c  \ |
|/       \|
+---------+
```

Assembling the image means matching up adjacent edge numbers.

I had a hypothesis that there was no ambiguity in edge numbers.  By this I mean, given the set of all possible edge numbers for all tiles (including those from reversing bit order), any edge number appears in at most two tiles.  I wrote code to confirm this in both the example data and the "real" input.  This code included a quick implementation of a `CountedSet`, which as it happens I'd been thinking about adding to `Common` since early in the Advent (I mentioned it in the README).

So now I knew that if a given edge number appears in only one tile (I called such an edge number a "singleton"), that tile must be on the edge of the overall image.   A tile on the corner of the image has 4 "singleton" possible-edge-numbers: two of the tile edges are **image edges**, and each of those edges has two possible edge numbers due to bit reversal.

Knowing this, I found the corner tiles and thus solved Part 1 without having to assemble the whole image.

For Part 2 there are two big sub-problems:

1. Now I **do** have to assemble the whole image.
2. Second, I have to find the sea monsters, and might have to flip and/or rotate the image until I find at least one sea monster.


## Assembling the whole image

Here's my general idea for constructing the 2-dimensional array of tiles that will be used to construct the image:

- Find the corner tiles.  I already know how to do this from Part 1.
- Pick a corner tile (any one will do) and orient it so it is a top-left corner, i.e. the two tile edges that are image edges are at its top and left.  "Orient" means flip and/or rotate the tile until it satisfies the condition.
- Only one other tile can be the adjacent neighbor of this tile on the right.  Find it and orient it so its left edge number matches the first tile's right edge number.
- Repeat until the whole first row of tiles is assembled.
- Using similar logic, add rows until we reach the bottom of the image.

UPDATE: I have this working.


## Finding the sea monsters

First step is to remove the edges of the tiles and construct the image. (UPDATE: I have this working, I think.)  Then search the image for sea monsters, orienting the image as necessary for a non-zero number of sea monsters to be found.  I'm going to assume brute force search will be fast enough.

I'm thinking I'll flip-and-rotate the image, but could also flip-and-rotate the sea monster pattern.


