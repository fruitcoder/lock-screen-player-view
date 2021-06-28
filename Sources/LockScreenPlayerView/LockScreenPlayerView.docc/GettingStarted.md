# Getting Started

Create a lock screen player view with different configurations.

## Overview

The lock screen player view comes in two variants:
1. A livestream asset which renders the ``LiveBar`` and hides any progress related views
2. An on demand asset which renders a progess and the elapsed and remaining playback time

The type of information that the view renders is determined at initialization so there is no observation or any
way to update an exisiting view.

## Create a LockScreenPlayerView

The easiest way to create a lock screen player view is to use the empty initializer which will render an on demand asset:
```swift
let view = LockScreenPlayerView()
```

If you want to tweak some parts of the view just use explicit values instead of the default ones for the exlicit initializer. Here is how to change the title text:
```swift
let view = LockScreenPlayerView(title: "Some other title")
```

To render a livestream just provide `.livestream` for the `assetKind`:
```swift
let view = LockScreenPlayerView(assetKind: .livestream)
```

To use the previous track as the left and the skip 60 seconds foward command as the right control use the following:
```swift
let view = LockScreenPlayerView(
	leftControl: .previousTrack,
	rightControl: .skipForward60
)
```

There is also the possibility to implicitly create the input of a lock screen player view by setting the now playing info on the now playing info center and enabling/disabling remote commands on the shared remote command center:
```swift
import MediaPlayer 

let nowPlayingInfo: [String: Any] = [
MPNowPlayingInfoPropertyIsLiveStream: false,
MPMediaItemPropertyArtist: "Cool artist",
MPMediaItemPropertyTitle: "Some title",
MPMediaItemPropertyAlbumTitle: "Best Of",
MPMediaItemPropertyPlaybackDuration: 300.0,
MPNowPlayingInfoPropertyPlaybackRate: 1.0,
MPNowPlayingInfoPropertyElapsedPlaybackTime: 30.0
]
MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = true
MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [60]
MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = true

let view = LockScreenPlayerView(remoteCommandCenter: .shared())
```
