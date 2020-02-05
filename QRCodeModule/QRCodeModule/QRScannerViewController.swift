//
//  QRScannerViewController.swift
//  QRCodeModule
//
//  Created by Seungjin on 05/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {

  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var resultLabel: UILabel!

  /*
   AVCaptureSession은 카메라와 마이크와 같은 캡처 장치에서 입력 데이터를 수신한다.
   입력을 수신한 후 AVCaptureSession은 처리하기 위해 해당 데이터를 적절한 출력으로 마스킹하여 결과적으로 동영상 파일이나 스틸 사진을 생성한다.
   캡처 세션의 입력 및 출력을 구성한 후 start() 및 나중에 stop() 지시하십시오.
   */
  var captureSession = AVCaptureSession()
  /*
   VideoPreview로 콘텐츠를 스트리밍하도록 카메라 캡처 세션을 구성한다.
   Preview는 AVCaptureVideoPreviewLayer가 지원하는 사용자 지정 UIView 하위 클래스 입니다
   */
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?


  override func viewDidLoad() {
    super.viewDidLoad()

    /*
     AVCaptureDevice.default는 특정 장치 유형과 일치하는 기본 캡처 장치를 찾도록 설계된다.
     */
    guard
      let captureDevice = AVCaptureDevice.default(
        AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .back
      ) else {
        print("Failed to get the camera device")
        return
    }

    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      /*
       Input
       */
      captureSession.addInput(input)
      /*
       이 경우 세션 출력은 AVCaptureMetaDataOutput 객체로 설정된다.
       AVCaptureMetaDataOutput 클래스는 QR 코드 판독의 핵심 부분이다.
       이 클래스는 AVCaptureMetadata와 함께 사용됨OutputObjectsDelegate 프로토콜은 입력 장치에서 발견된 메타데이터(장치 카메라에서 캡처한 QR 코드)를 가로채
       사람이 읽을 수 있는 형식으로 변환하는 데 사용된다.
       */
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetadataOutput)

      // set kind of metadata
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.salientObject]

      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      videoPreviewLayer?.frame = view.layer.bounds
      view.layer.addSublayer(videoPreviewLayer!)

      // start
      captureSession.startRunning()

      view.bringSubviewToFront(closeButton)
      view.bringSubviewToFront(resultLabel)

      qrCodeFrameView = UIView()
      if let qrCodeFrameView = qrCodeFrameView {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView)
        view.bringSubviewToFront(qrCodeFrameView)
      }

    } catch {
      print(error)
      return
    }
  }

}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

    print(metadataObjects)
    /*
     [
      <AVMetadataMachineReadableCodeObject: 0x281c3d040, type="org.iso.QRCode", bounds={ 0.3,0.4 0.1x0.2 }>corners { 0.3,0.6 0.5,0.6 0.5,0.4 0.4,0.4 },
      time 1836491341075875,
      stringValue "http://www.appcoda.com"
     ]
     */
//    guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
//    if metadataObj.type == AVMetadataObject.ObjectType.qr {
//      let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//      qrCodeFrameView?.frame = barcodeObject?.bounds ?? CGRect.zero
//
//      if let resultValue = metadataObj.stringValue {
//        resultLabel.text = resultValue
//      }
//    }

    guard let metadataObj = metadataObjects.first as? AVMetadataSalientObject else { return }
//    if metadataObj.type == AVMetadataObject.ObjectType.qr {
      let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
      qrCodeFrameView?.frame = barcodeObject?.bounds ?? CGRect.zero

//      if let resultValue = metadataObj.stringValue {
//        resultLabel.text = resultValue
//      }
//    }
  }
}

