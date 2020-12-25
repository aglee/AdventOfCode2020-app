# Day 20 - Jurassic Jigsaw

<https://adventofcode.com/2020/day/20>

***[TL;DR: For Part 1 I played dominoes, and rather than solve for the general case, I relied heavily on specific properties of the input.  In particular, for any edge of a given tile, there is at most one other tile that can possibly be adjacent at that edge.  For Part 2 I used brute-force comparisons of a pattern of array elements.  A common theme in both parts was applying every possible combination of flips and rotations to a grid until a condition is satisfied.]***

I used the concept of what I called an "edge number" -- treating characters on the edges of tiles as binary digits.  Accounting for flips and rotations, each tile has 8 possible edge numbers: 4 from the initial data, and the "reversals" of those 4 (rotations and flips cause the binary digits along edges on either 2 or 4 of the edges to be in the reverse order from the original).  Afterwards it occurred to me there wasn't actually any bitwise math involved in my solution, so maybe my solution would have run just fine if I'd used "edge strings" instead of "edge numbers".

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

Assembling the image means matching up adjacent edge numbers.  So, for example, if the above is a tile in the assembled image, the tile to the right of it has to look like this (the d's have to match up, kind of like dominoes):

```text
+---------++---------+
|\       /||\       /|
| \  a  / || \  p  / |
|  \   /  ||  \   /  |
|   \ /   ||   \ /   |
| b  X  d || d  X  q |
|   / \   ||   / \   |
|  /   \  ||  /   \  |
| /  c  \ || /  r  \ |
|/       \||/       \|
+---------++---------+
```

I had a hypothesis that there was no ambiguity in edge numbers.  By this I mean, given the set of all possible edge numbers for all tiles (including those from reversing bit order), any edge number appears in at most two tiles.  I was guessing that the input data was such that I could make this simplifying assumption rather than solve for the general case.  I wrote code to confirm this hypothesis in both the example data and the "real" input, and it was true.

So now I knew that if a given edge number appears in only one tile (I called such an edge number a "singleton"), that tile must be on the edge of the overall image, because if it was in the interior, some other tile would need to have the same edge number.   A tile on the corner of the image has 4 "singleton" possible-edge-numbers: two of the tile edges are **image edges**, and each of those edges has two possible edge numbers due to bit reversal.

Knowing this, I found the corner tiles and thus solved Part 1 without having to assemble the whole image.

For Part 2 there were two big sub-problems:

1. Now I **do** have to assemble the whole image.
2. Second, I have to find the sea monsters, and might have to flip and/or rotate the image until I find at least one sea monster.

I spun my wheels on this for hours before deciding to go to bed.  I had general ideas about the solution, but couldn't get them down in code.  It's always nice to solve Parts 1 and 2 in one sitting, but I decided that wasn't going to happen this time.  And sure enough, after resting up I was able to solve Part 2 the next evening.


## Assembling the whole image

Here was my idea for constructing the 2-dimensional array of tiles that make up the image:

- Find a corner tile (any one will do) and orient it so it is a top-left corner, i.e. the two tile edges that are image edges are at its top and left.  By "orient" I mean flip and/or rotate the tile until it satisfies the condition.
- Only one other tile can be the neighbor to the right of this tile.  Find that tile and orient it so its left edge number matches the first tile's right edge number.
- Repeat until the whole first row of tiles is assembled.
- Using similar logic, add rows until we reach the bottom of the image.

A couple of things got me over the pain point of implementing this idea:

- I added methods to my `Tile` class to flip and rotate.  I realized it doesn't matter what the tile's original orientation was when I created it.  It's conceptually the same tile no matter what.
- I added properties to `Tile` for the top, left, bottom, and right edge numbers.  I didn't worry about caching them -- turns out it was fine computing edge numbers on the fly.  So now, no matter how many flips and rotations I do to a tile, I can always ask for its current edge numbers.
- I added a method to `Tile` that tries all flips and rotations until some condition is met.  First it rotates 4 times, testing for the condition each time.  If that doesn't work, it does a flip and tries again rotating 4 times.  This covers all the possible combinations of flips and rotations.  (By the way, my mental fatigue had made it hard to reason about the flips and rotations.  I really needed the rest.)

My first thought had been to try to figure out what sequence of flips and rotations I would need to meet a given condition.  But I decided instead to do it the other way around: apply the transforms and each time see if the tile now satisfied the condition.  This was now easy using the methods I'd added.  I didn't even bother with simple optimizations like testing the current orientation first, on the chance it would satisfy the condition and I wouldn't have to do any transforms.  The program still ran in a flash, even with the "real" data.

So now I could tell a tile to orient itself so a given edge number was on a given edge.  For example, given the **right-side edge number** of a tile, I could first find the tile that **must** be its right-hand neighbor, because only one other tile would have that as a possible edge number.  Then I could orient that second tile like this:

```objective-c
nextTile.flipAndRotateUntil { nextTile.leftEdgeNumber == rightEdge }
```

And I could look at what *that* tile's right edge number is to find *its* right-hand neighbor, and so forth until all tiles are arranged in a grid making up the image.


## Finding the sea monsters

So now I had the arrangement of the tiles.  Next:

- Remove the edges of all the tiles and construct the full image "bitmap".  This was a bit of a grind but it had to be done.  At this point I no longer needed the concept of the tiles.  All I cared about was the big assembled "bitmap".
- Search the image for sea monsters, orienting the image as necessary.  I used the same trial-and-error approach -- try all the possible transforms until a non-zero number of sea monsters is found.  The previous night I had vaguely thought I'd want to convert the monster pattern into a bunch of bitmasks, which would have been a real pain.  Turns out brute-force search was perfectly fine.  It was nice in my testing to print the results using the test data, and using Command-F to see it matched the answer in the puzzle description.

It occurred to me I could also have applied flip-and-rotate to the sea monster *pattern* rather than the *image*.


