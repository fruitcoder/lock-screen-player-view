//
//  Slider.swift
//  
//
//  Created by fruitcoder on 23.06.21.
//

import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
	final class Coordinator: NSObject {
		var value: Binding<Double>

		init(value: Binding<Double>) {
			self.value = value
		}

		@objc func valueChanged(_ sender: UISlider) {
			self.value.wrappedValue = Double(sender.value)
		}
	}

	var thumbColor: UIColor = .white
	var thumbImage: UIImage?
	var minTrackColor: UIColor?
	var maxTrackColor: UIColor?

	@Binding var value: Double

	func makeUIView(context: Context) -> UISlider {
		let slider = UISlider(frame: .zero)
		slider.thumbTintColor = thumbColor
		if let customImage = thumbImage {
			slider.setThumbImage(customImage, for: .normal)
		}
		slider.minimumTrackTintColor = minTrackColor
		slider.maximumTrackTintColor = maxTrackColor
		slider.value = Float(value)

		slider.addTarget(
			context.coordinator,
			action: #selector(Coordinator.valueChanged(_:)),
			for: .valueChanged
		)

		return slider
	}

	func updateUIView(_ uiView: UISlider, context: Context) {
		// Coordinating data between UIView and SwiftUI view
		uiView.value = Float(self.value)
	}

	func makeCoordinator() -> SwiftUISlider.Coordinator {
		Coordinator(value: $value)
	}
}
