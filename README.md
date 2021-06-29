# LockScreenPlayerView

A view that can be used to write snapshot tests simulating the iOS lock screen player.

## Intro

This is by no means a pixel perfect representation of the iOS lock screen player but it's good enough for writing snapshot tests for against code that manipulates the now playing info center and remote playback controls. I like a visual overview of different player states. Of course, you could just use the `dump` of the dictionary and use text files as snapshots.

## Usage

Once [installed](#installation), _no additional configuration is required_. You can import the `LockScreenPlayerView` module and configure it either explicitly or by inferring the properties from the now playing info.

##### Explicitly 

```swift
LockScreenPlayerView(
	assetKind: .livestream,
	audioRouteName: "AirPods",
	leftControl: .enabled(.previousTrack),
	playbackControl: .enabled(.stop),
	rightControl: .disabled(.nextTrack)
)
```

##### Implicitly 

```swift
LockScreenPlayerView(remoteCommandCenter: .shared())
```

Although the primary use is to include the target in your test targets it can theoretically also be used in your feature modules. 

##### Tests

Checkout the `LockScreenPlayerViewTests` to see how to integrate a snapshotting library like [https://github.com/pointfreeco/swift-snapshot-testing](swift-snapshot-testing) and write tests for different states of the lock screen player view.

## Installation

### Xcode 11

> ⚠️ Warning: By default, Xcode will try to add the LockScreenPlayerView package to your project's main application/framework target. If you intend to use the package for testing only please ensure that LockScreenPlayerView is added to a _test_ target instead, as documented in the last step, below.

 1. From the **File** menu, navigate through **Swift Packages** and select **Add Package Dependency…**.
 2. Enter package repository URL: `https://github.com/fruitcoder/lock-screen-player-view.git`
 3. Confirm the version and let Xcode resolve the package
 4. On the final dialog, update LockScreenPlayerView's **Add to Target** column to a test target that will contain snapshot tests (if you have more than one test target, you can later add LockScreenPlayerView to them by manually linking the library in its build phase)

##### Dependencies

This package uses the `swift-snapshot-test` repository from [https://github.com/pointfreeco/swift-snapshot-testing](pointfree) for its tests but the view itself could also be used without a snapshot framework. In case you use *any* snapshot framework there is the usual disclaimer to always use the same simulator and iOS version (in my case iPhone 8 with 14.5).

## Documentation	

I played around with DocC a little and added a little tutorial to add a `LockScreenPlayerView` to your SwiftUI views. Actually, I planned to add another tutorial on how to write snapshot tests with this view but then I found out you can't host compiled DocC documentation on Github pages so my motivation dropped 😅

![./Sources/LockScreenPlayerView/LockScreenPlayerView.docc/Resources/tutorials-art/tutorial-scroll-through.gif](Video of scrolling through the "Using LockScreenPlayerView" tutorial)
