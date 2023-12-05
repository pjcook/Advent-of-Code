#  Day 5 - Partially solved

## Part 1



## Part 2

For part 2 I grouped the `seeds` into the `startSeedNumber` and `rangeLength` pairs.

I looked for all the `ranges` in the `seedToSoil` section of data where `seedToSoil.sourceRangeStart...seedToSoil.sourceRangeStart+seedToSoil.rangeLength` overlapped with the `startSeedNumber...startSeedNumber+rangeLength`.

I then took the `seedToSoil.sourceRangeStart` values from the overlapping options and used those values in the solution from `part 1` to calculate the `lowest distance`.

Whilst the above appeared to work for my `input file` it did NOT work in the `example input`.

So for a `full solution` it might be a case of rince and repeating the above down through the other 5 layers of `map`.

