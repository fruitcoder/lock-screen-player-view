import LockScreenPlayerView
import MediaPlayer
import SnapshotTesting
import XCTest
import SwiftUI

final class LockScreenPlayerViewTests: XCTestCase {
	private final class Player {
		func playLivestream() {
			// configure audio session, register for remote events ...
			let nowPlayingInfo: [String: Any] = [
				MPNowPlayingInfoPropertyIsLiveStream: true,
				MPMediaItemPropertyArtist: "Cool artist",
				MPMediaItemPropertyTitle: "Some title",
				MPMediaItemPropertyAlbumTitle: "Best Of",
				MPNowPlayingInfoPropertyPlaybackRate: 1.0
			]
			MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

			MPRemoteCommandCenter.shared().stopCommand.isEnabled = true
			MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = false
			MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = false
			MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = true
			MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
		}

		func playOnDemandStream() {
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
		}

		func startTimer() {
			var currentNowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
			currentNowPlayingInfo[MPMediaItemPropertyTitle] = [
				"💤10min...",
				currentNowPlayingInfo[MPMediaItemPropertyTitle] as? String
			]
				.compactMap { $0 }
				.joined(separator: " ")
			MPNowPlayingInfoCenter.default().nowPlayingInfo = currentNowPlayingInfo
		}

		func pause() {
			MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
		}
	}

	func testManualInput() {
		let view = LockScreenPlayerView(
			assetKind: .livestream,
			audioRouteName: "AirPods",
			leftControl: .enabled(.previousTrack),
			playbackControl: .enabled(.stop),
			rightControl: .disabled(.nextTrack)
		).embedInContainer()

		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .light)), named: "light")
		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .dark)), named: "dark")
	}

	func testMediaPlayerDerivedStateLive() {
		let player = Player()
		player.playLivestream()

		let view = LockScreenPlayerView(remoteCommandCenter: .shared()).embedInContainer()

		assertSnapshot(matching: MPNowPlayingInfoCenter.default().nowPlayingInfo, as: .dump)

		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .light)), named: "light")
		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .dark)), named: "dark")
	}

	func testMediaPlayerDerivedStateOnDemand() {
		let player = Player()
		player.playOnDemandStream()

		let view = LockScreenPlayerView(remoteCommandCenter: .shared()).embedInContainer()

		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .light)), named: "light")
		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .dark)), named: "dark")

		player.pause()

		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .light)), named: "light-paused")
		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .dark)), named: "dark-paused")
	}

	func testMediaPlayerSleepMode() {
		let player = Player()
		player.playOnDemandStream()
		player.startTimer()

		let view = LockScreenPlayerView(remoteCommandCenter: .shared()).embedInContainer()

		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .light)), named: "light")
		assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone8Plus), traits: .init(userInterfaceStyle: .dark)), named: "dark")
	}
}

private extension View {
	func embedInContainer() -> some View {
		ZStack {
			Color.blue
			VStack {
				self
			}
			.background(Color(.systemBackground))
		}
		.edgesIgnoringSafeArea(.all)
	}
}
