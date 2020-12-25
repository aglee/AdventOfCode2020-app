#  Advent of Code 2020

[[See all 25 days here.](/AdventOfCode2020-app)]

This year I took a different approach.  I did it all in Swift, with all 25 of the puzzles in a single Cocoa app.  My intention was to build a UI that displays a list of the 25 days.  The idea would be that I can click on any day in the list to run my solution for that day's puzzle and and read my notes about it.  Haven't gotten around to the UI part though.  Right now to run a given day's solution you have to go to `AppDelegate`, find where it calls `doOneDay(_:)`, and edit the argument to use that day.

I figured on some days the puzzle will lend itself to some kind of visual display of the solution, perhaps with some sort of animation.  I wanted to figure out a way to do that when it makes sense.

This year seemed easier than the last couple of years.  Maybe one reason was to enable a broader audience to get further along before being stumped.  Maybe one reason was that 2020 has been a rough year for many people -- maybe the creators wanted to reduce stress levels.  Maybe the creators wanted to reduce their *own* stress level, an idea I'd gladly support considering how 2020 has been.

For all of this year's puzzles I used a first-generation M1 MacBook Air with 8 GB of memory.


## Things to think about

- Add more data structures and algorithms to `Common`, e.g. `A*`, e.g. `CountedSet`, e.g. Chinese Remainder Theorem.  I looked at Apple's Swift algorithms stuff, it doesn't seem to be what I mean.  I could go through past years of my own code, and also of course look for stuff on GitHub and/or SPM.  Could be a good way to learn to use git modules and/or SPM.
	- Add tests for my `Common` stuff, partly to burn the ideas into my brain a little better, partly just because it feels nice to see things work correctly, partly to learn how to use Xcode's testing setup.
- What's the deal with Xcode always forcing my `.txt` files to end with a newline?  Doesn't matter for my purposes, just wondering.
- I've been copy-pasting the puzzle descriptions as plain text and adding a bit of Markdown.  The result looks fine but doesn't capture all the highlighting and links.  Would it be worth grabbing the HTML and CSS instead?  Or maybe pasting into .rtf files rather than plain text?  I'd only grab the problem descriptions, not the surrounding stuff like ads and site navigation.
- Should I put the correct final answers I got somewhere, so when I run the code later I can have the satisfaction of seeing it still works on the real data and not just the test data?  I haven't been wanting to, out of perhaps a misguided concern about spoilers/cheating.  Perhaps it's even less of a concern this year, since I'm not posting my solutions publicly right away.
- For each day I originally had a file called `DayXX_Discussion.md`, which was added to the app bundle.  I renamed them to `README.md` so they'll be automatically displayed on GitHub when you go to that subdirectory.  If I still want to add them as resources to the eventual (?) Cocoa app, I'll probably have to add a build phase with a script that copies them over using distinct names.
- Use generics for `Grid`  and `CharGrid`.
- Thinking rename `Grid` to something like `Space2D<Element>`, could add a `Space3D` too, could use the `Point3D` stuff from Day 17.  Then rename `CharGrid` to `Grid<Element>`.  Just a thought.
- It might have been nice to grab screenshots (or HTML grabs) of each day's front page, so I could have something in my UI to show it building up over time.  I suspect somebody has already done that though.  Haven't looked for it yet.




