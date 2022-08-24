//
//  CodeScannerError.swift
//  CodeScanner
//
//  Created by Seungjin on 10/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation

public enum CodeScannerError: Error {

  case permissionDenied
  case notSupported
  case cameraInput
  case notAvailableFlash

  func message() -> String {
    switch self {
    case .permissionDenied:
      return "Failed to get the camera permission"
    case .notSupported:
      return "Failed to get the camera device"
    case .cameraInput:
      return "Failed to input CaptureSession"
    case .notAvailableFlash:
      return "Flash is not available."
    }
  }
}
