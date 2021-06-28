//
//  PlayerControlsView.swift
//  
//
//  Created by fruitcoder on 23.06.21.
//

import Foundation
import SwiftUI

/// A view that displays the live bar for livestream assets.
public struct PlayerControlsView: View {
	let leftControl: StatefulControl<LeftControl>
	let playbackControl: StatefulControl<PlaybackControl>
	let rightControl: StatefulControl<RightControl>


	/// Creates a player controls viewwith the specified controls.
	/// - Parameters:
	///   - leftControl: The enabled or disabled left control.
	///   - playbackControl: The enabled or disabled playback control.
	///   - rightControl: The enabled or disabled right control.
	public init(leftControl: StatefulControl<LeftControl>,
							playbackControl: StatefulControl<PlaybackControl>,
							rightControl: StatefulControl<RightControl>) {
		self.leftControl = leftControl
		self.playbackControl = playbackControl
		self.rightControl = rightControl
	}

	public var body: some View {
		HStack {
			Spacer()
				.frame(width: 25)
			leftControl.control.image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 25)
				.opacity(leftControl.isDisabled ? 0.3 : 1.0)
			Spacer()
			playbackControl.control.image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 45)
				.opacity(playbackControl.isDisabled ? 0.3 : 1.0)
			Spacer()
			rightControl.control.image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: 25)
				.opacity(rightControl.isDisabled ? 0.3 : 1.0)
			Spacer()
				.frame(width: 25)
		}
	}
}
