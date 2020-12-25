#  Advent of Code 2020

This year I took a different approach.  I did it all in Swift, with all 25 of the puzzles in a single Cocoa app.  My intention was to build a UI that displays a list of the 25 days.  The idea would be that I can click on any day in the list to run my solution for that day's puzzle and and read my notes about it.

I figured on some days the puzzle will lend itself to some kind of visual display of the solution, perhaps with some sort of animation.  I wanted to figure out a way to do that when it makes sense.  Haven't gotten around to it though.

For all of this year's puzzles I used a first-generation M1 MacBook Air 8 GB of memory.


## Things to think about

- Add more data structures and algorithms to `Common`, e.g. `A*`, e.g. `CountedSet`, e.g. Chinese Remainder Theorem.  I looked at Apple's Swift algorithms stuff, it doesn't seem to be what I mean.  I could go through past years of my own code, and also of course look for stuff on GitHub and/or SPM.  Could be a good way to learn to use git modules and/or SPM.
	- Add tests for my `Common` stuff, partly to burn the ideas into my brain a little better, partly just because it feels nice to see things work correctly, partly to learn how to use Xcode's testing setup.
- What's the deal with Xcode always forcing my `.txt` files to end with a newline?  Doesn't matter for my purposes, just wondering.
- I've been copy-pasting the puzzle descriptions as plain text and adding a bit of Markdown.  The result looks fine but doesn't capture all the highlighting and links.  Would it be worth grabbing the HTML and CSS instead?  Or maybe pasting into .rtf files rather than plain text?  I'd only grab the problem descriptions, not the surrounding stuff like ads and site navigation.
- Should I put the correct final answers I got somewhere, so when I run the code later I can have the satisfaction of seeing it still works on the real data and not just the test data?  I haven't been wanting to, out of perhaps a misguided concern about spoilers/cheating.  Perhaps it's even less of a concern this year, since I'm not posting my solutions publicly right away.
- I'd like to rename all the "DayXX_Discussion.md" files to "README.md" so they are detected and displayed on GitHub.  If I still want to add them as resources to the eventual (?) Cocoa app, I'll probably have to add a build phase with a script that copies them over using distinct names.
- Use generics for `Grid`  and `CharGrid`.
- Thinking rename `Grid` to something like `Space2D<Element>`, could add a `Space3D` too, could use the `Point3D` stuff from Day 17.  Then rename `CharGrid` to `Grid<Element>`.  Just a thought.




