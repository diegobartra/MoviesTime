# MoviesTime
Nice iOS application for cinephiles and movie hobbyists

## Features

- [x] Scroll through the list of upcoming movies (movie name, poster image, genre and release date).
- [x] Select a specific movie to see details (name, poster image, backdrop image, genre, overview and release date).

## Third-Party Libraries

- SDWebImage: Used because it provides a very elegant and simple async image downloader with cache support and a convenience category for UIImageView. It downloads the poster and backdrop images for the movies.

## Requirements

- iOS 8.1 or later
- Xcode 8.1 or later

## Build Instructions

- Make sure you have the CocoaPods files (Podfile, Podfile.lock and Pods folder). If not, please read the instructions below to install SDWebImage using CocoaPods.
- Open from MoviesTime.xcworkspace.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

#### Podfile
```
platform :ios, '7.0'
pod 'SDWebImage', '~>3.8'
```

### Build Project

At this point your workspace should build without error.

## Author

Diego Bartra\t
diegobartra@me.com


