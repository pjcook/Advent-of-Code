#  Day 4 - Solved

## Part 1

I created a `ScratchCard` struct to store the parsed data from the input file. The reason for this is that I prefer this strongly typed data approach, but also, once the data is processed, having it in objects makes adding functions to that later much easier and cleaner.

After creating a simple struct to hold the data, I wrote a parser to convert the input file into an array of those objects.

It was the usual boiler plate code using combinations of `replacingOccurrences` where appropriate and `components(separatedBy:)` where appropriate. 

For part 1 I created a function on `ScratchCard` that would calculate the score using the `winningNumbers` list and `numbers` list. I simply iterated through all `numbers` and did a `contains` function against `winningNumbers` I could have made this more efficient by removing winning numbers as I found them, but I ignored that optimisation as the number of items was very small.

Finally I ran a `reduce` function against the array of `ScratchCards` summing the result of the `points` function.

## Part 2

For part 2 I moved the code from the `points` function into the initialised for the Struct and counted the `numberOfWinningNumbers` whilst going about it so that I calculated both the `points` and `numberOfWinningNumbers` in the same for loop. Mainly this was to keep the code clean and reduce code duplication. It would have been totally valid to use a separate function to calculate `numberOfWinningNumbers`, but since that would need to be called multiple times, it made more sense to do it in the initialiser so it only gets run once (since it's relatively expensive), and since I was doing the same kind of loop required for the `points` function I simply merged both into the initialiser.

Looking at the nuance description for `part 2` I decided that iterating the array of `ScratchCards` in reverse seemed like the best approach. Also, because I needed to keep track of the `currentIndex` as I iterated, I iterated over the index positions instead of the objects themselves.

I created a `results` array initialising it's `repeating` contents to `zero` so that I ended up with an array the same length as the number of `ScratchCards`.

When iterating through the `ScratchCards` (in reverse), I calculated a `total` for that `ScratchCard` which signified the number of scratch cards for that position. I then looked at the `numberOfWinningNumbers` for the `current ScratchCard` and took the `values` from the `results` array for the elements at the `index positions` for the next `n` elements where `n` == `numberOfWinningNumbers`. This is to calculate the `accumulated` count of winning scratch cards.

Once `results` was fully populated having iterated through all `ScratchCards` in the original array, I simply ran a `reduce` function to `sum` all the elements in the `results` array. And that gave the total number of scratch cards required.
