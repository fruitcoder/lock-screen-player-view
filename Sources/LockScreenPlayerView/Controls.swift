//
//  Controls.swift
//  
//
//  Created by fruitcoder on 23.06.21.
//

import Foundation
import SwiftUI

/// A tye that declares the symbol image of a control.
public protocol ControlType {
	/// The visual representation of a control.
	var image: Image { get }
}

/// The controls that can be used on the left side of the lock screen view.
///
/// Even though the lock screen player can render intervals that differ from the cases here we
/// use SF Symbols to render the cases so we limited the cases to the icons that are currently available.
public enum LeftControl: ControlType {
	/// The 10 seconds skip backward control.
	case skipBackward10

	/// The 15 seconds skip backward control.
	case skipBackward15

	/// The 30 seconds skip backward control.
	case skipBackward30

	/// The 45 seconds skip backward control.
	case skipBackward45

	/// The 60 seconds skip backward control.
	case skipBackward60

	/// The previous track control.
	case previousTrack

	/// Creates a control with the specified number of seconds.
	///
	/// Returns a valid skip backward control if the input can be mapped to the available cases, `nil` otherwise.
	public init?(seconds: Double) {
		switch seconds {
		case 10:
			self = .skipBackward10
		case 15:
			self = .skipBackward15
		case 30:
			self = .skipBackward30
		case 45:
			self = .skipBackward45
		case 60:
			self = .skipBackward60
		default:
			return nil
		}
	}

	public var image: Image {
		switch self {
		case .skipBackward10:
			return Image(systemName: "gobackward.10")
		case .skipBackward15:
			return Image(systemName: "gobackward.15")
		case .skipBackward30:
			return Image(systemName: "gobackward.30")
		case .skipBackward45:
			return Image(systemName: "gobackward.45")
		case .skipBackward60:
			return Image(systemName: "gobackward.60")
		case .previousTrack:
			return Image(systemName: "backward.fill")
		}
	}
}

/// The controls that can be used on the right side of the lock screen view.
///
/// Even though the lock screen player can render intervals that differ from the cases here we
/// use SF Symbols to render the cases so we limited the cases to the icons that are currently available.
public enum RightControl: ControlType {
	/// The 10 seconds skip forward control.
	case skipForward10

	/// The 15 seconds skip forward control.
	case skipForward15

	/// The 30 seconds skip forward control.
	case skipForward30

	/// The 45 seconds skip forward control.
	case skipForward45

	/// The 60 seconds skip forward control.
	case skipForward60

	/// The next track control.
	case nextTrack

	/// Creates a control with the specified number of seconds.
	///
	/// Returns a valid skip forward control if the input can be mapped to the available cases, `nil` otherwise.
	public init?(seconds: Double) {
		switch seconds {
		case 10:
			self = .skipForward10
		case 15:
			self = .skipForward15
		case 30:
			self = .skipForward30
		case 45:
			self = .skipForward45
		case 60:
			self = .skipForward60
		default:
			return nil
		}
	}

	public var image: Image {
		switch self {
		case .skipForward10:
			return Image(systemName: "goforward.10")
		case .skipForward15:
			return Image(systemName: "goforward.15")
		case .skipForward30:
			return Image(systemName: "goforward.30")
		case .skipForward45:
			return Image(systemName: "goforward.45")
		case .skipForward60:
			return Image(systemName: "goforward.60")
		case .nextTrack:
			return Image(systemName: "forward.fill")
		}
	}
}

/// The playback controls that can be used in the middle of the lock screen view.
public enum PlaybackControl: ControlType {
	/// The play control.
	case play

	/// The pause control.
	case pause

	/// The stop control.
	case stop

	public var image: Image {
		switch self {
		case .play:
			return Image(systemName: "play.fill")
		case .pause:
			return Image(systemName: "pause.fill")
		case .stop:
			return Image(systemName: "stop.fill")
		}
	}
}

/// A control that can be enabled or disabled.
public enum StatefulControl<C: ControlType> {
	/// The enabled control.
	case enabled(C)

	/// The disabled control.
	case disabled(C)

	/// The wrapped control.
	public var control: C {
		switch self {
		case let .disabled(control), let .enabled(control):
			return control
		}
	}

	/// An indicator of whether the control is disabled.
	public var isDisabled: Bool {
		switch self {
		case .disabled:
			return true
		default:
			return false
		}
	}
}
