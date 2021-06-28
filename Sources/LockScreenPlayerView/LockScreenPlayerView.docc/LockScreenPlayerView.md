# ``LockScreenPlayerView``

A simple view that can be used to write snapshot tests for the iOS lock screen player.

## Overview

LockScreenPlayerView provides a view that looks similar to the iOS 14 lock screen player. While it can be used directly in an app it is mostly meant to be used for snapshot tests to give a visual representation of different player states and catch regression bugs when changing player code. 

The view can either be created with explicit input using the ``LockScreenPlayerView/init(assetKind:audioRouteName:leftControl:playbackControl:rightControl:subtitle:title:)`` or the rather imlicit ``LockScreenPlayerView/init(nowPlayingInfo:remoteCommandCenter:)`` initializer. The latter uses the values of the specified now playing info dictionary (or the one from the default now playing info center) and the controls enabled in the specified remote command center to infer which UI the native lock screen player would render.  

![A lock screen player view with an on demand asset.](on-demand.png)
![A lock screen player view with a livestream asset.](live.png)

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:Creating-Lock-Screen-Player-Views>
- ``LockScreenPlayerView/LockScreenPlayerView``

### Creating LockScreenPlayerViews

- ``LockScreenPlayerView/init(assetKind:audioRouteName:leftControl:playbackControl:rightControl:subtitle:title:)``
- ``LockScreenPlayerView/init(nowPlayingInfo:remoteCommandCenter:)``

### Components
- ``LiveBar``
- ``PlayerControlsView``

### Controls
- ``ControlType``
- ``StatefulControl``
- ``LeftControl``
- ``PlaybackControl``
- ``RightControl``
