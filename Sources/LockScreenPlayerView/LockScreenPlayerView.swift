import MediaPlayer
import SwiftUI


/// A view that displays the now playing info an remote controls similar to the iOS lock screen player.
public struct LockScreenPlayerView: View {
	/// The asset kind displayed by the view.
	public let assetKind: AssetKind

	/// The audio route name displayed by the view.
	public let audioRouteName: String

	/// The left control displayed by the view.
	public let leftControl: StatefulControl<LeftControl>

	/// The playback control displayed by the view.
	public let playbackControl: StatefulControl<PlaybackControl>

	/// The right control displayed by the view.
	public let rightControl: StatefulControl<RightControl>

	/// The subtitle displayed by the view.
	public let subtitle: String

	/// The title displayed by the view.
	public let title: String

	/// Creates a lock screen player view explicit input to render.
	/// - Parameters:
	///   - assetKind: The asset kind to display.
	///   - audioRouteName: The audio route name to display.
	///   - leftControl: The left control to display.
	///   - playbackControl: The playback control to display.accessibility
	///   - rightControl: The right control to display.accessibility
	///   - subtitle: The subtitle to display.accessibility
	///   - title: The title to display.
	public init(assetKind: AssetKind = .onDemand(progress: 0.5, elapsedTime: "2:57", remainingTime: "-2:57"),
							audioRouteName: String = "iPhone",
							leftControl: StatefulControl<LeftControl> = .enabled(.skipBackward15),
							playbackControl: StatefulControl<PlaybackControl> = .enabled(.play),
							rightControl: StatefulControl<RightControl> = .enabled(.skipForward15),
							subtitle: String = "Queen – A Night at the Opera",
							title: String = "Bohemian Rhapsody") {
		self.assetKind = assetKind
		self.audioRouteName = audioRouteName
		self.leftControl = leftControl
		self.playbackControl = playbackControl
		self.rightControl = rightControl
		self.subtitle = subtitle
		self.title = title
	}

	/// Creates a lock screen player view by inferring the parameters form the specified now playing info and remote command center
	///
	/// To use the default now playing info and remote controls you should create the view using `init(remoteCommandCenter: .shared()).`
	/// Alternatively, you can directly specify the now playing info dictionary with the `nowPlayingInfo` parameter.
	///
	/// See `MediaPlayer/MPNowPlayingInfoCenter` for all possible keys but note that only a subset is currently used here.
	///
	/// - Parameters:
	///   - nowPlayingInfo: A dictionary using `MPNowPlayingInfoProperty*` or `MPMediaItemProperty*` keys. Defaults to the default now playing info center's dictionary.
	///   - remoteCommandCenter: The remote command center to derive the playback controls from. Most likely this is the `.shared()` instance.
	public init(nowPlayingInfo: [String: Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:],
							remoteCommandCenter: MPRemoteCommandCenter) {
		let assetKind: AssetKind
		let playbackControl: PlaybackControl

		let isLivestream = nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] as? Bool == true
		let isPlaying = (nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] as? Double ?? 0.0) != 0.0
		let title = nowPlayingInfo[MPMediaItemPropertyTitle] as? String ?? "App Name" // if no title is provided the app name is used
		let artist = nowPlayingInfo[MPMediaItemPropertyArtist] as? String
		let albumTitle = nowPlayingInfo[MPMediaItemPropertyAlbumTitle] as? String
		let subtitle = [artist, albumTitle]
			.compactMap { $0 }
			.joined(separator: " – ")

		if isLivestream {
			assetKind = .livestream
		} else if let elapsedTime = nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] as? Double,
							let duration = nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] as? Double {
			assetKind = .onDemand(
				progress: elapsedTime / duration,
				elapsedTime: Self.elapsedTimeText(from: elapsedTime),
				remainingTime: Self.remainingTimeText(from: max(0, duration - elapsedTime))
			)
		} else {
			assetKind = .livestream
		}

		// stop is only displayed for playing livestreams
		if isLivestream && isPlaying && remoteCommandCenter.stopCommand.isEnabled {
			playbackControl = .stop
		} else {
			playbackControl = isPlaying ? .pause : .play
		}

		self.init(
			assetKind: assetKind,
			leftControl: remoteCommandCenter.leftControl,
			playbackControl: .enabled(playbackControl),
			rightControl: remoteCommandCenter.rightControl,
			subtitle: subtitle,
			title: title
		)
	}

	public var body: some View {
			VStack {
				HStack {
					Image(systemName: "photo.fill")
						.resizable()
						.frame(width: 70.0, height: 70.0)
					VStack(alignment: .leading) {
						Text(audioRouteName)
							.font(.caption)
							.bold()
							.foregroundColor(Color(.secondaryLabel))
						Text(title)
							.bold()
						Text(subtitle)
					}
					.lineLimit(1)
					Spacer()
					Image(systemName: "airplayaudio")
						.resizable()
						.frame(width: 20.0, height: 20.0)

						.font(.caption)
				}

				if let (progress, elapsedTime, remainingTime) = assetKind.onDemand {
					SwiftUISlider(
						thumbImage: UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10)),
						minTrackColor: .label,
						maxTrackColor: .secondaryLabel,
						value: .constant(progress)
					)
					.accentColor(Color(.label))
					HStack {
						Text(elapsedTime)
							.font(.footnote)
						Spacer()
						Text(remainingTime)
							.font(.footnote)
					}

				} else {
					LiveBar()
				}
				PlayerControlsView(leftControl: leftControl, playbackControl: playbackControl, rightControl: rightControl)
					.padding([.top, .bottom], 16.0)
				HStack {
					Image(systemName: "speaker.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(height: 10.0)
					SwiftUISlider(
						thumbColor: .white,
						minTrackColor: .label,
						maxTrackColor: .secondaryLabel.withAlphaComponent(0.2),
						value: .constant(0.5)
					)
					Image(systemName: "speaker.wave.3.fill")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(height: 10.0)
				}
			}
			.padding()
			.background(Blur(style: .systemThinMaterial))
			.cornerRadius(15.0)
	}

	private static var dateComponentsFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		formatter.formattingContext = .standalone
		return formatter
	}()

	private static func elapsedTimeText(from seconds: Double) -> String {
		Self.dateComponentsFormatter.allowedUnits = seconds <= 3600 ? [.minute, .second] : [.hour, .minute, .second]
		return Self.dateComponentsFormatter.string(from: seconds)!
	}

	private static func remainingTimeText(from seconds: Double) -> String {
		Self.dateComponentsFormatter.allowedUnits = seconds <= 3600 ? [.minute, .second] : [.hour, .minute, .second]
		Self.dateComponentsFormatter.collapsesLargestUnit = false
		return "\(seconds > 0 ? "" : "-")" + Self.dateComponentsFormatter.string(from: seconds)!
	}
}

#if DEBUG
struct Preview_LockScreenPlayerView: PreviewProvider {
	static var previews: some View {
		Group {
			LockScreenPlayerView()
				.environment(\.colorScheme, .dark)
			LockScreenPlayerView()
			LockScreenPlayerView(
				assetKind: .livestream,
				audioRouteName: "AirPods",
				leftControl: .enabled(.previousTrack),
				playbackControl: .enabled(.stop),
				rightControl: .disabled(.nextTrack)
			)
			LockScreenPlayerView(
				assetKind: .livestream,
				audioRouteName: "AirPods",
				leftControl: .enabled(.previousTrack),
				playbackControl: .enabled(.stop),
				rightControl: .disabled(.nextTrack)
			)
				.environment(\.colorScheme, .dark)
		}
	}
}
#endif

private struct Blur: UIViewRepresentable {
	var style: UIBlurEffect.Style = .systemMaterial
	func makeUIView(context: Context) -> UIVisualEffectView {
		return UIVisualEffectView(effect: UIBlurEffect(style: style))
	}
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		uiView.effect = UIBlurEffect(style: style)
	}
}

private extension MPRemoteCommandCenter {
	var leftControl: StatefulControl<LeftControl> {
		// if both controls are disabled the previous track control is displayed grayed out
		if !skipBackwardCommand.isEnabled && !previousTrackCommand.isEnabled {
			return .disabled(.previousTrack)
		} else if skipBackwardCommand.isEnabled {
			return .enabled(
				(skipBackwardCommand.preferredIntervals.first?.doubleValue).flatMap { LeftControl(seconds: $0) } ?? .skipBackward10
			)
		} else if previousTrackCommand.isEnabled {
			return .enabled(.previousTrack)
		} else {
			return .disabled(.previousTrack)
		}
	}

	var rightControl: StatefulControl<RightControl> {
		// if both controls are disabled the next track control is displayed grayed out
		if !skipForwardCommand.isEnabled && !nextTrackCommand.isEnabled {
			return .disabled(.nextTrack)
		} else if skipBackwardCommand.isEnabled {
			return .enabled(
				(skipForwardCommand.preferredIntervals.first?.doubleValue).flatMap { RightControl(seconds: $0) } ?? .skipForward10
			)
		} else if nextTrackCommand.isEnabled {
			return .enabled(.nextTrack)
		} else {
			return .disabled(.nextTrack)
		}
	}
}
