#  Day 6 - Solved

## Basic Solution

For a pair of `time` and `distance` values, starting from `zero` through to `time`; `count` how many times `(time - i) * i` is greater than `distance`.

For `part 1` do this for each pair, and then multiply the results.
For `part 2` just do this for the single `time`, `distance` pair.

## Optimised Solution

Create a function that `countsWins` taking a `time` and `distance` property
Start a `count` variable at `1`
Set `halfway = time/2`
Iterate through `(1..<halfway)`
Get the lowerIndex `halfway-i`
Calculate `result` as `(time-lowerIndex) * lowerIndex`
if `result` is greater than `distance` then increment `count` by 2
if `result`is less than or equal to `distance` then you need to double check a couple values on the other side to balance it out so:
if `(time-(halfway+i-1)) * (halfway+i-1) <= distance` then decrement `count` by `1`
if `(time-(halfway+i)) * (halfway+i) > distance` then increment `count` by `1`

For `part 1` call the above function for each pair, then multiply all the results.
For `part 2` call the above function for the single `time` and `distance` values.
