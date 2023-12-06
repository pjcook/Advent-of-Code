#  Day 5 - Partially solved

## Part 1

After converting the input file into data structures, I wrote a main function that accepts the list of `seeds`.

Taking each `seed` it runs that initial value through all the different `maps`, `in order` extracting the output value from each `map` until you are left with the `location distance`.

As each `location distance` is calculated, retain the `smallest value` and return this as the `final result`.

## Part 2

Using the same main function from `part 1` I used the `pairs` of `seed` values to construct a `range` and iterated through each individual `seed` in each `range` in the same way as `part 1`, just for a significantly larger number of seeds. I tried several options to optimise the solution, but could not think of anything better than `brute force` in the end.

Code optimisations that I made along the way however included:
• Initially I was storing the `maps` in a `dictionary` and using an `enumeration value` for the `key`. Whilst this is `very efficient`, it does incur a lookup cost and since all the `maps` just need accessing sequentially it made more sense to remove the dictionary and just keep an `ordered array of maps` instead.
• Initially I just read the values in each `map` (each line in the input file) in the order that the lines appeared in the input file. A consideration that I made was to sort those values based on the `start of range` (second value), this is because when iterating through those `ranges` in each `map` when I find the first valid range, I exit early, by checking them from smallest to largest, I'm more likely to find the valid range faster.

Making the above optimisations took my brute force solution (when running the code in `release` mode) from 1045 seconds down to 205 seconds (on an 2020 M1 Mac Mini).
