//
//  OverlayView.swift
//  CodeScanner
//
//  Created by Seungjin on 06/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

public class OverlayView: UIView {
  
  public var focusView: FocusView!
  private var scannerType: ScannerType
  
  init(frame: CGRect, scannerType: ScannerType) {
    self.scannerType = scannerType
    super.init(frame: frame)
    setupOverlayView()
    addMask()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension OverlayView {
  
  func setupOverlayView() {
    let size = focusSize(self, scannerType: scannerType)
    focusView = FocusView(frame: CGRect(
      x: center.x - (size.width / 2),
      y: center.y - (size.height / 2),
      width: size.width,
      height: size.height))
    addSubview(focusView)
  }
  
  func addMask() {
    backgroundColor = UIColor.black.withAlphaComponent(0.4)
    mask(withRect: focusView.frame, inverse: true)
  }
}
