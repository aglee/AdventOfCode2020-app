# Day 22 - Crab Combat

<https://adventofcode.com/2020/day/22>

For Part 2 my test gave the right final answer, so I should have run the real input and submitted that answer right away.  If it was wrong, *then* I could have looked for bugs.  But I spent way too much time -- I want to say like 30 minutes at least -- adding printf's to generate output that exactly matched what was in the puzzle description.  I was averse to submitting a wrong answer, and wanted to make sure my test didn't get the right answer by accident.  But really, that was probably highly unlikely.  All that time adding printf's and I found no bugs.  So, submitting an answer with "only" 95% confidence instead of 99% is something for me to work on.

Part 2 took 14 seconds with `DEBUGPRINT_ENABLED` turned on, 6 seconds with it off.  I guess it was time-consuming to construct the strings I was passing to `DEBUGPRINT()` -- concatenating array elements and whatnot.

