#  Day 10 - Writeup

## Part 1

I firstly parsed the input into a `Grid` of `Tiles` where the `Tiles` enumeration looked like this:

```
enum Tiles: Character, CustomStringConvertible {
    case northSouth = "|"
    case eastWest = "-"
    case northEast = "L"
    case northWest = "J"
    case southWest = "7"
    case southEast = "F"
    case ground = "."
    case start = "S"
    case outside = "O"
    case inside = "I"
            
    func points(for point: Point) -> [Point] {
        switch self {
            case .northSouth:
                [point.up(), point.down()]
            case .eastWest:
                [point.right(), point.left()]
            case .northEast:
                [point.up(), point.right()]
            case .northWest:
                [point.up(), point.left()]
            case .southWest:
                [point.down(), point.left()]
            case .southEast:
                [point.down(), point.right()]
            default:
                [point]
        }
    }

    var description: String {
        String(rawValue)
    }
}
```

I would the `Point` where the `start` tile was located, and then calculated the 2 valid `Tiles` that were adjacent to that `startTile`. The reason there could only be 2 options was because each `Tile` only has 1 entrance and 1 exit. (There was a bit of a `lucky` assumption there that the author didn't put valid dummy tiles next to the start tile).

The `findValidAdjacentStartTiles` function checked each of the `ordinal` tiles. Firstly it checked that they were inside the `Grid` in case the `start` was located on the edge of the `Grid`. Then it checked whether the:
- `tile above` was either [.northSouth, .southWest, .southEast]
- `tile below` was either [.northSouth, .northEast, .northWest]
- `tile left` was either [.eastWest, .northEast, .southEast]
- `tile right` was either [.eastWest, .northWest, .southWest]
and returned the two `Points` that were valid.

I initialised 2 arrays, a Left Hand Side `lhs` and Rigth Hand Side `rhs`, I put the `start` `Point` into both of those arrays. 
Having round the 2 valid adjacent `Grid` `Points` I split them across the `lhs` and `rhs` arrays.
Then I ran a `while loop` until the `last` element in the `lhs` and `rhs` arrays matched. 
Inside the `while loop` I calculated the `nextPoint` for each of the arrays.
I used the `currentPoint` from the end of either the `lhs` array, and the `previousPoint` which was the `last element - 1` of the `lhs` array, and then appended the `nextPoint` to the end of the `lhs` array. 
I did the same logic for the `rhs` array.
Once that was done, I simply counted how many elements were in the `lhs` array -1 because it starts counting from zero.

## Part 2

While calculating the solution to `part 1` I ended up with 2 sequences of points leading from the `start` to the `furthest point`. 
I merged both of these lists into a single list of all the `Points` that make up the `circular path`.
I converted the `start tile` to it's equivalent real tile option. e.g. `northSouth` or `eastWest`.
I then created an empty `Grid` and set all the initial `Tile` states to `Ground`. 
I then copied all of the data from the original `Grid` to the new `Grid` but only for the `Points` on the `circular path`.
I then found all of the `Points` around the circumference of the `Grid` that were of type `Ground` and added them to a `Set` of `Points` to use to fill in the `outside` tiles.
I did a `While loop` over the items in the `outsidePoints` list until it was empty, interrogating each `Point` in the new `Grid` to see if it was a `Ground` tile. If it was then I set it to an `Outside` tile, and checked all of it's 8 neighbours to see if any of those were `Ground` tiles, if they were I appended those `Points` to the `outsidePoints` list to process later.
Once all of the main outside was filled in, I needed to still `run around the path` looking for any `Outside` tiles that were hiding deeper inside the `Grid`. 
So I looked for the first `Point` on the path that was touching either the `outer edge of the grid` or an `Outside` tile.
Using this as the new `startingPoint` on the `circular path` I calculated all of the `outer edges` for that `Tile`. 
So for the 8 positions around the `startingPoint` I knew which edges were the `Outside`, which were part of the `Pipe` and therefore, which were `Internal`. 
Looking at all of the `Outside` edges for that `Tile` I checked to see if any were currently set to `Ground` if they were then I added them to the `outsidePoints` list from earlier (which was now empty), and I would repeat the previous loop to check and fill in all adjoining `Outside` tiles once I had run around the whole path.
I then went round the entire `circular path` calculating the `Outside` edges for the next `Tile` until I got back to the `startingPoint`. 
At this point, I had found some of the `Outside` points that were hiding in the maze / grid. So I did the same loop as previously doing the `While loop` of all the `Points` in the `outsidePoints` list checking the adjoining points as before until the `outsidePoints` was empty. 
Finally I had a `Grid` where all the remaining `Ground` tiles must therefore be the `Internal` positions that we were looking for, so I just counted all the `Ground` tiles in the grid and that was the answer.

