//
//  CodeScannerDelegate.swift
//  CodeScanner
//
//  Created by Seungjin on 10/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import AVFoundation

public protocol CodeScannerDelegate: class {

  func codeScanner(_ codeScanner: CodeScanner, didOutput value: String?, scannerType: ScannerType)
  func codeScanner(_ codeScanner: CodeScanner, didFail error: CodeScannerError, scannerType: ScannerType)
}
