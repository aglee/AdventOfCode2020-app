# Day 7 - Handy Haversacks

<https://adventofcode.com/2020/day/7>

Type of problem: graph traversal.

Terminology: I used the terms "parent color", "child color", "descendant", and "ancestor".  A bag with a given "parent color" must contain a particular combination of bags with "child colors", with a particular number of bags of each color.

For Part 1 I used the graph defined by the **child-to-parent** relationships.  Each node of this graph is a color name.  I traversed the subgraph rooted at the color "shiny gold".

For Part 2 I used the graph defined by the **parent-to-child** relationships.  Each node of this graph is a pair consisting of a color and a count.  The root of the graph for purposes of Part 2 was the pair `(1, "shiny gold")`.

I had to be careful to avoid off-by-one errors.  Both parts of the puzzle required the answer to exclude the starting node at which the graph traversal began.  My testing caught an off-by-one error in Part 2, which saved me from submitting the wrong answer at the web site.

The puzzle description warns that the input file is long.  I wondered if I would need to memoize intermediate answers in Part 2.  But that wasn't necessary -- it completed in no time at all.


