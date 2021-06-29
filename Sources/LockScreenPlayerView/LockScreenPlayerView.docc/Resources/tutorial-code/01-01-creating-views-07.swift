import LockScreenPlayerView
import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			LockScreenPlayerView()
			LockScreenPlayerView(
				assetKind: .livestream,
				leftControl: .enabled(.previousTrack),
				playbackControl: .enabled(.stop),
				rightControl: .enabled(.nextTrack)
			)
		}.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environment(\.colorScheme, .dark)
	}
}
