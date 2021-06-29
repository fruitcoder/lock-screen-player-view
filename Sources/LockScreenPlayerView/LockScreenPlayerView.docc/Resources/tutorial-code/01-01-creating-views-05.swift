import LockScreenPlayerView
import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			LockScreenPlayerView()
			LockScreenPlayerView(
				assetKind: <#T##AssetKind#>,
				audioRouteName: <#T##String#>,
				leftControl: <#T##StatefulControl<LeftControl>#>,
				playbackControl: <#T##StatefulControl<PlaybackControl>#>,
				rightControl: <#T##StatefulControl<RightControl>#>,
				subtitle: <#T##String#>,
				title: <#T##String#>
			)
		}.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
