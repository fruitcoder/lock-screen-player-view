//
//  AssetKind.swift
//  
//
//  Created by fruitcoder on 23.06.21.
//

import Foundation

/// The kind of asset to be used in a `LockScreenPlayerView`.
public enum AssetKind {
	/// A livestream asset.
	case livestream

	/// An on demand asset.
	///
	/// Associated values specify the playback progress of the on demand asset:
	/// - progress: The playback progress between `0.0` and `1.0`.
	/// - elapsedTime: The elapsed time text, i.e. "3:10".
	/// - remainingTime: The remaining time text, i.e. "-3:10".
	case onDemand(progress: Double, elapsedTime: String, remainingTime: String)

	/// The associated values contained in a tuple  of an `.onDemand` asset kind. `nil` for `.livestream` cases.
	///
	///  The tuple values represent the `progress`, `elapsedTime` and `remainingTime` values, respectively.
	public var onDemand: (Double, String, String)? {
		switch self {
		case let .onDemand(progress, elapsedTime, remainingTime):
			return (progress, elapsedTime, remainingTime)
		default:
			return nil
		}
	}
}
