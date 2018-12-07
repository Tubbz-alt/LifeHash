# LifeHash

[![CI Status](https://img.shields.io/travis/wolfmcnally/LifeHash.svg?style=flat)](https://travis-ci.org/wolfmcnally/LifeHash)
[![Version](https://img.shields.io/cocoapods/v/LifeHash.svg?style=flat)](https://cocoapods.org/pods/LifeHash)
[![License](https://img.shields.io/cocoapods/l/LifeHash.svg?style=flat)](https://cocoapods.org/pods/LifeHash)
[![Platform](https://img.shields.io/cocoapods/p/LifeHash.svg?style=flat)](https://cocoapods.org/pods/LifeHash)

A method of hash visualization based on Conway’s Game of Life that creates beautiful icons that are deterministic, yet distinct and unique given the input data.

The basic concept is to take a SHA256 hash of the input data (which can be any data including another hash) and then use the 256-bit digest as a 16x16 pixel "seed" for running the cellular automata known as [Conway’s Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

After the pattern becomes stable (or begins repeating) the resulting history is used to compile a grayscale image of all the states from the first to last generation. Using Game of Life provides visual structure to the resulting image, even though it was seeded with entropy.

Some bits of the initial hash are then used to deterministically apply symmetry and color to the icon to add beauty and quick recognizability.

![Samples of LifeHash](Art/Samples-0.jpg?raw=true "Samples 1") ![Samples of LifeHash](Art/Samples-1090.jpg?raw=true "Samples 2")

![Samples of LifeHash](Art/Sample-315.jpg?raw=true "Sample 315") ![Samples of LifeHash](Art/Sample-777.jpg?raw=true "Sample 777")

![Samples of LifeHash](Art/Sample-1012.jpg?raw=true "Sample 1012") ![Samples of LifeHash](Art/Sample-1015.jpg?raw=true "Sample 1015")

![Samples of LifeHash](Art/Sample-1113.jpg?raw=true "Sample 1113") ![Samples of LifeHash](Art/Sample-2187.jpg?raw=true "Sample 2187")

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 4.2

## Installation

LifeHash is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LifeHash'
```

## Author

Wolf McNally, wolf@wolfmcnally.com

## License

LifeHash is available under the MIT license. See the LICENSE file for more info.
