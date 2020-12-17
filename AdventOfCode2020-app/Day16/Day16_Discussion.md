# Day 16 - Ticket Translation

<https://adventofcode.com/2020/day/16>

Relatively straightforward today.

I spent a little time on code whose only purpose was to reassure myself I'd parsed the input correctly.  Specifically, I printed the contents of my `PuzzleInfo` object so I could make sure the output matched the input.  I could probably have skipped that sanity-checking and only added it if tests did not return the correct answer.

It was convenient to be able to easily declare an array of `ClosedRange<Int>`.  I started to make my own range object, but quickly realized there was no need to do so.

I find simple typealiases sometimes help with readability, e.g. `typealias Ticket = Array<Int>`.  It seems easier for my brain to see `Ticket` and remember it's an array of integers than to see an array of integers and remember it's there to represent a ticket.

Afterwards I remembered I could have used a `groupedLines` function that I'd written for an earlier puzzle this year, precisely for the case where the input uses empty lines to separate sections.  It would have saved me a couple of minutes.



