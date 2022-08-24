//
//  ViewController.swift
//  CodeScanner
//
//  Created by Seungjin on 10/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var storyboardView: UIView!
  var codeView = UIView()
  
  var codeScanner: CodeScanner?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    codeView.frame = view.frame
//    view.addSubview(codeView)
//
//    codeScanner = CodeScanner(codeView, scannerType: .qrCode)
//    //codeScanner = CodeScanner(codeView, scannerType: .barCode)
//    codeScanner?.delegate = self
//    codeScanner?.showOverlayView = false
//    codeScanner?.focusView?.scanLineBorder(color: .white, lineWidth: 5)
////    codeScanner?.cameraPosition(.front)
//    codeScanner?.cameraFlash(.on)
//
//    codeScanner?.startScanning()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // IBOutlet 객체는 viewDidLayoutSubViews() 에서 생성해 주어야된다.
    setupCodeScanner()
  }
  
  private func setupCodeScanner() {
    codeScanner = CodeScanner(storyboardView, scannerType: .qrCode)
    //codeScanner = CodeScanner(codeView, scannerType: .barCode)
    codeScanner?.delegate = self
//    codeScanner?.showOverlayView = false
//    codeScanner?.focusView?.scanLineBorder(color: .white, lineWidth: 5)
    //codeScanner?.cameraPosition(.front)
    
    codeScanner?.cameraFlash(.on)
    codeScanner?.startScanning()
    
  }
  
  @IBAction func flashAction(_ sender: UIButton) {
    print(123123123)
//    codeScanner?.cameraFlash(.on)
    
  }
  
}

extension ViewController: CodeScannerDelegate {
  
  func codeScanner(_ codeScanner: CodeScanner, didOutput value: String?, scannerType: ScannerType) {
    print(value)
  }
  
  func codeScanner(_ codeScanner: CodeScanner, didFail error: CodeScannerError, scannerType: ScannerType) {
    print(error)
    print(error.message())
  }
}
