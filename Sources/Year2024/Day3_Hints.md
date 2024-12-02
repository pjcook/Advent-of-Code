#  Day 3 Hints

## Summary

Today took me about 1 hours, but that’s only because:
- I already have the parser to import the file and convert it into lines
- I already had my generic Grid class from previous years
- I already had my Point class with associated helper functions like neighbors and isValid, and the ability to calculate the neighboring point to the left and right functions

## Part 1

- Initially I wrote a function to extract all the different symbols from the file
- Then I looped through every point in the grid looking for the symbols
- I looked at the neighbors of that symbolPoint and put them in a Set
- I looped through all the neighbors in the set
- If the neighbor was a digit then I extracted the full number, removing any adjacent points from the original neighborSet so that I didn’t process the same numbers multiple times

## Part 2

was just the above, but for the list of symbols to inspect I just gave it the `"*"`
and only calculated the multiplication if there were exactly 2 results, no more or less
and summed the results 
