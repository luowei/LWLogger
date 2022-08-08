# LWLogger

[![CI Status](https://img.shields.io/travis/luowei/LWLogger.svg?style=flat)](https://travis-ci.org/luowei/LWLogger)
[![Version](https://img.shields.io/cocoapods/v/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)
[![License](https://img.shields.io/cocoapods/l/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)
[![Platform](https://img.shields.io/cocoapods/p/LWLogger.svg?style=flat)](https://cocoapods.org/pods/LWLogger)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LWLogUtil initLogConfig];
    
    return YES;
}

LWLog(@"======LWLogger Log: %s",__func__);
```

## Requirements

## Installation

LWLogger is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWLogger'
```

**Carthage**
```ruby
github "luowei/LWLogger"
```

## Author

luowei, luowei@wodedata.com

## License

LWLogger is available under the MIT license. See the LICENSE file for more info.
