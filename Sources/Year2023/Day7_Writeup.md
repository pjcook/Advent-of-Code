#  Day 7 - Solved

## Part 1

Looking at the problem, I decided to use strong model types, which is my usual favourite approach. 

I created a `WinningHandType` which was an enumeration of the different types of winning hands: highCard, onePair ... 

I assigned these numeric values so that I could use that in some kind of sorting business logic later.

I also created a dictionary of the different types of cards 2,3..J,Q,K,A and gave those numerical values for the same sorting business logic reason.

I created a model object `Hand` that would store the: 
- `cards` the String representing the cards e.g. "32T3K"
- `bid` the numerical bid value that would be required in the final calculation
- `handType` I would calculate the enumerated `WinningHandType` from earlier

I parsed the input file processing 1 line at a time, and using a function `calculateWinningHandType` (later renamed to `calculateWinningHandTypePart1`) I calculated the `Hand` model for each line.

I then wrote a `sorting algorithm` that I used to sort the initial array of `Hand` objects into `ranked order`.

I then enumerated over the `sorted hand array` to calculate the final answer.

### calculateWinningHandTypePart1

Taking the `String` of `cards` I converted that into a `Dictionary` of `Character` keys and used that to count the number of each key.

```
var components = [Character:Int]()
for card in cards {
    components[card] = components[card, default: 0] + 1
}
```

I then used numerous `if` statements to determine how many components there were
- 1 == `fiveOfAKind`
- 2 could be either `fourOfAKind` or `fullHouse`
- 3 could be either `threeOfAKind` or `twoPair`
- 4 == `onePair`
- else `highCard`

### Part 1 - sorting algorithm

```
func < (lhs: Day7.Hand, rhs: Day7.Hand) -> Bool
```

if the left and right side objects have the same `handType` then you need to loop over all the elements of the `cards` string to determine which side has the lowest value first, or return true to retain the sort order if fully the same
if the left and right side objects have different `handType` values then you can simply use the numeric value assigned at the start to return which had the lowest value

## Part 2

Part 2 was nearly identical to part 1 with a couple small changes. Because of these changes, I needed to refactor the code slightly. I needed to refactor the `parsing` function to take another function that would `calculateWinningHandType` because now there are `jokers`. I also needed to write a different sorting algorithm because the `Dictionary` of `cardStrength` values to `character` maps had changed because "J" now had a value of zero instead of ten.

The rest of the code and sequence of processing remained the same.

### calculateWinningHandTypePart2

The only significant difference to `calculateWinningHandTypePart2` over what was described for `calculateWinningHandTypePart1` was that after calculating the `character counts` the next step was to check for the existence of a value with key "J" (for jokers).

If the components contained `jokers` then that element was `removed` from the Dictionary and the `count` added to any other element that already had the largest `count`. Obviously there is 1 edge case to look out for which is where the entire list of cards is ALL jokers.

The rest of the processing remained the same to calculate the winning `handType`.
