import LockScreenPlayerView
import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			LockScreenPlayerView()
		}.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
