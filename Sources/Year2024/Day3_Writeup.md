#  Day 3 - Solved

## Part 1

I read in the files as usual as an `array of strings` using my `.lines` function extension on `String`.
I have this generic `Grid` class that will take an array of strings and break it down into a 2 dimensional array. This has helper properties like: `columns` and `rows` as well as `bottomRight` to provide the max point in the grid, this is because (0,0) is the top left. There are also other useful functions like subscript so that you can use `array style syntax` to extract elements from points or coordinates in the grid. e.g. grid[0,0] or grid[Point(x: 0,y: 0)]
Once I had the input file in a Grid class that I could interrogate, firstly I decided to extract an explicit list of `symbols` from both the file and example input. The example input gave me: ["#", "$", "*", ".", "+"] and my input gave me: ["%", "/", "$", "+", ".", "@", "=", "&", "#", "*", "-"]
The instructions mentioned that `"."` does not count as a symbol and is effectively a spacer character, so I removed that from the list. I could see that the example list was a subset of the list from my input file, so I hard coded that into a variable called `symbols` to use later to help identify the `symbols` in the input.
I used my standard pattern of 2 `nested for loops` for parse over the grid
```
for y in (0..<grid.rows) {
   for x in (0..<grid.columns) {}
}
```
Instead of trying to extract the numbers first and match them to symbols, I assumed it would be easier to identify the symbols first and then interrogate the adjacent `points` to see if they contained `digits`, and then extract the `full number`.
So in the inner `for loop` I checked whether the `value at the current point` was in the `array of symbols` that I extracted from my input file.
If not then I just continued to the `next point`, but if it did, then I passed the `grid` and `currentPoint` to a function called `extractAdjacentNumbers`.

### extractAdjacentNumbers

This function took a copy of the `Grid` and a `Point` (the current position to check). The `Point` type is another object that I have crafted over the years, and this has useful functions like:
- *neighbors* which is a function to return an array of `Point` objects to adjacent points. There are additional properties where you can supply `min` and `max` `Points` in order to guarantee that the points that you receive back do not stretch outside the bounds of the grid e.g. less than (0,0)

I chose to store these `neighbors` into a `Set` and use a `while loop` to `popFirst` from the array until there were no options left. The reason for this was so that when extracting the `full numbers` I could remove any points that made up a number already extracted so that I did not interrogate the same neighbor multiple times.
After popping a neighbor, I inspected that element in the grid to see if that element contained a `digit`. If it did, then I used 2 separate `while loops` to `scan left` and `scan right` from the current neighbor to find all of the individual digits that make up the `full number`.
In order to `scan left` and `scan right` 
In those `scan left` and `scan right` `while loops` is use some different helper functions on the `Point` object called `left` and `right` which increment the point to the left or right depending on the function.
I keep inspecting the next point until I find one that is not a digit then stop, and each time I find a digit I remove that point from the original list of `neighbors` so that I don't interrogate the same position multiple times.
I store all the digits in a `String` that I then convert to an `Integer` at the very end.
When `scanning left` I insert any additional digits at the start of the variable.
When `scanning right` I append any additional digits to the end of the variable.
Once I have the final number I store that to a list of results to return from the `extractAdjacentNumbers` function.

## Part 2

For part 2 I mostly reused the same code from `part 1`. The core differences were that the array of `symbols` that I used in `part 1` I reduced that to just `["*"]`.
I let the `extractAdjacentNumbers` function return an array of numbers adjacent to any `*` symbols, and "if" and ONLY if the array of results contains 2 numbers, I multiply those together and `add` them to the `final answer`.
Then just return the `final answer`.
