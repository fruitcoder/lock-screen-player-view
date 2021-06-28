//
//  LiveBar.swift
//  
//
//  Created by fruitcoder on 23.06.21.
//

import SwiftUI

/// A view that displays the live bar for livestream assets.
public struct LiveBar: View {
	public var body: some View {
		HStack(spacing: 0.0) {
			Rectangle()
				.fill(
					LinearGradient(
						gradient: Gradient(
							stops: [
								.init(color: Color(.secondaryLabel), location: 0.0),
								.init(color: Color(.secondaryLabel), location: 0.9),
								.init(color: .clear, location: 1.0)
							]
						),
						startPoint: .leading,
						endPoint: .trailing
					)
				)
				.frame(height: 4.0)
				.cornerRadius(2.0, corners: [.topLeft, .bottomLeft])
			Text("LIVE")
				.font(.footnote)
				.bold()
			Rectangle()
				.fill(
					LinearGradient(
						gradient: Gradient(
							stops: [
								.init(color: .clear, location: 0.0),
								.init(color: Color(.secondaryLabel), location: 0.1),
								.init(color: Color(.secondaryLabel), location: 1.0),
							]
						),
						startPoint: .leading,
						endPoint: .trailing
					)
				)
				.frame(height: 4.0)
				.cornerRadius(2.0, corners: [.topRight, .bottomRight])
		}
	}
}
