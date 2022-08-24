//
//  AVManager.swift
//  CodeScanner
//
//  Created by Seungjin on 06/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import AVFoundation

class AVManager: NSObject {
  
  let captureSession = AVCaptureSession()
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  var captureInput: AVCaptureDeviceInput!
  var captureOutput: AVCaptureMetadataOutput!
  var cameraPosition: AVCaptureDevice.Position = .back {
    didSet { setupCamera() }
  }
  var cameraFlashMode: AVCaptureDevice.TorchMode = .off {
    didSet { setupCamera() }
  }
  weak var delegate: CodeScannerDelegate?
  
  private var containerView: UIView
  private var scannerType: ScannerType
  
  var resultHandler: ((AVMetadataMachineReadableCodeObject?, CodeScannerError?) -> Void)?
  
  init(containerView: UIView, scannerType: ScannerType) {
    self.containerView = containerView
    self.scannerType = scannerType
    super.init()
    
    setupVideoPreviewLayer()
    authorization()
  }
  
  private func setupCamera() {
    removeAllInput()
    removeAllOutput()
    
    cameraDevice {
      cameraInput(device: $0)
      cameraOutput()
      cameraTorch(device: $0)
    }
  }
  
  private func authorization() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      setupCamera()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          self.setupCamera()
          return
        }
        self.resultHandler?(nil, .permissionDenied)
      }
    case .denied, .restricted:
      resultHandler?(nil, .permissionDenied)
    default:
      fatalError("unknow")
    }
  }
  
  private func cameraDevice(completion: (AVCaptureDevice) -> Void) {
    guard
      let captureDevice = AVCaptureDevice.default(
        .builtInWideAngleCamera, for: .video, position: cameraPosition
      )
      else {
        print("Failed to get the camera device")
        resultHandler?(nil, CodeScannerError.notSupported)
        return
    }

    completion(captureDevice)
  }
  
  private func cameraTorch(device: AVCaptureDevice) {
    do {
      if device.hasTorch {
        try device.lockForConfiguration()
        try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
        device.torchMode = cameraFlashMode
        device.unlockForConfiguration()
      }
    } catch {
      print("Torch could not be used")
      resultHandler?(nil, CodeScannerError.notAvailableFlash)
    }
  }
  
  private func cameraInput(device: AVCaptureDevice) {
    do {
      captureInput = try AVCaptureDeviceInput(device: device)
      captureSession.addInput(captureInput)
    } catch {
      print("Failed to input CaptureSession")
      resultHandler?(nil, CodeScannerError.cameraInput)
    }
  }
  
  private func cameraOutput() {
    captureOutput = AVCaptureMetadataOutput()
    captureSession.addOutput(captureOutput)
    captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    
    switch scannerType {
    case .qrCode:
      captureOutput.metadataObjectTypes = [
        .qr
      ]
    case .barCode:
      captureOutput.metadataObjectTypes = [
        .upce,
        .code39,
        .code39Mod43,
        .code93,
        .code128,
        .ean8,
        .ean13,
        .aztec,
        .pdf417,
        .itf14,
        .interleaved2of5,
        .dataMatrix
      ]
    }
  }
  
  private func setupVideoPreviewLayer() {
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    videoPreviewLayer.frame = containerView.layer.bounds
  }
  
  private func removeAllInput() {
    if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
      inputs.forEach { captureSession.removeInput($0) }
    }
  }
  
  private func removeAllOutput() {
    if let outputs = captureSession.outputs as? [AVCaptureMetadataOutput] {
      outputs.forEach { captureSession.removeOutput($0) }
    }
  }
  
}

extension AVManager: AVCaptureMetadataOutputObjectsDelegate {
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if captureSession.isRunning {
      if let metadataObject = metadataObjects.first {
        guard let object =  metadataObject as? AVMetadataMachineReadableCodeObject else { return }
        resultHandler?(object, nil)
      }
    }
  }
  
}
