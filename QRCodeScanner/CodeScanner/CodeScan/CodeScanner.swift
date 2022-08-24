//
//  CodeScanner.swift
//  CodeScanner
//
//  Created by Seungjin on 06/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import AVFoundation

public class CodeScanner: NSObject {
  
  weak var delegate: CodeScannerDelegate?
  
  public let containerView: UIView
  public var overlayView: OverlayView
  public var focusView: FocusView? {
    set { overlayView.focusView = newValue }
    get { return overlayView.focusView }
    
  }
  public var showOverlayView: Bool = true {
    didSet {
      if !showOverlayView {
        removeOverlay()
      }
    }
  }
  
  private var avManager: AVManager
  private let scannerType: ScannerType
  
  public init(_ view: UIView, scannerType: ScannerType) {
    self.containerView = view
    self.scannerType = scannerType
    self.overlayView = OverlayView(frame: containerView.frame, scannerType: scannerType)
    self.avManager = AVManager(containerView: containerView, scannerType: scannerType)
    super.init()
    
    setupScanner()
  }
  
  private func setupScanner() {
    containerView.layer.addSublayer(avManager.videoPreviewLayer)
    containerView.addSubview(overlayView)
  }
  
  private func removeOverlay() {
    self.overlayView.removeFromSuperview()
    let size = focusSize(containerView, scannerType: scannerType)
    self.focusView = FocusView(frame: CGRect(
      x: containerView.center.x - (size.width / 2),
      y: containerView.center.y - (size.height / 2),
      width: size.width,
      height: size.height)
    )

    containerView.addSubview(self.focusView!)
    containerView.bringSubviewToFront(self.focusView!)
    
    bounceAnimation()
  }
  
  private func bounceAnimation() {
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      options: [.repeat, .autoreverse],
      animations: {
        self.focusView?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
    }, completion: nil)
  }
  
  private func resultHandler() {
    avManager.resultHandler = { [weak self] object, error in
      guard let self = self else { return }
    
      if let error = error {
        self.delegate?.codeScanner(self, didFail: error, scannerType: self.scannerType)
        return
      }
      
      if let object = object {
        self.delegate?.codeScanner(self, didOutput: object.stringValue, scannerType: self.scannerType)
      }
    }
  }
 
  public func startScanning() {
    resultHandler()
    avManager.captureSession.startRunning()
  }
  
  public func stopScanning() {
    avManager.captureSession.stopRunning()
  }
  
  public func cameraPosition(_ position: AVCaptureDevice.Position) {
    avManager.cameraPosition = position
  }
  
  public func cameraFlash(_ mode: AVCaptureDevice.TorchMode) {
    avManager.cameraFlashMode = mode
  }
}
