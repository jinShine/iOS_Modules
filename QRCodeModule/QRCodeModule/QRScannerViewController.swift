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
  var qrCodeFrameView: UIImageView?
  var scanView = UIView()


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

      scanView.frame = self.view.frame
      scanView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      view.addSubview(scanView)
      view.bringSubviewToFront(scanView)

//      setupScanImage()

      qrCodeFrameView = UIImageView()
      if let qrCodeFrameView = qrCodeFrameView {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        qrCodeFrameView.frame = CGRect(x: view.center.x, y: view.center.y, width: 300, height: 300)
        scanView.addSubview(qrCodeFrameView)
        scanView.bringSubviewToFront(qrCodeFrameView)
      }

      scanView.mask(withRect: CGRect(x: 50, y: 100, width: 300, height: 201), inverse: true)
//      setScanZoneLineBorder(CGRect(x: 100, y: 100, width: 200, height: 200))
//      setupScanImage()

    } catch {
      print(error)
      return
    }
  }

  var leftTopLayer = CAShapeLayer()
  var rightTopLayer = CAShapeLayer()
  var leftBottomLayer = CAShapeLayer()
  var rightBottomLayer = CAShapeLayer()

  func setupScanImage() {
    let leftTopImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    leftTopImageView.image = UIImage(named: "ScanQR1_16x16_")
    leftTopImageView.backgroundColor = .clear
    qrCodeFrameView!.addSubview(leftTopImageView)

    let rightopImageView = UIImageView.init(frame: CGRect(x: scanView.frame.width - 20, y: 0, width: 20, height: 20))
    rightopImageView.image = UIImage(named: "ScanQR2_16x16_")
    rightopImageView.backgroundColor = UIColor.clear
    qrCodeFrameView!.addSubview(rightopImageView)
  }

  func setScanZoneLineBorder(_ scanRect : CGRect) {
      leftTopLayer.removeFromSuperlayer()
      rightTopLayer.removeFromSuperlayer()
      leftBottomLayer.removeFromSuperlayer()
      rightBottomLayer.removeFromSuperlayer()
      //左上角的框
      let leftTopBezierPath = UIBezierPath()
      leftTopBezierPath.move(to: CGPoint(x: scanRect.minX + 15, y: scanRect.minY - 2))
      leftTopBezierPath.addLine(to: CGPoint(x: scanRect.minX - 2, y: scanRect.minY - 2))
      leftTopBezierPath.addLine(to: CGPoint(x: scanRect.minX - 2, y: scanRect.minY + 15))
      leftTopLayer.path = leftTopBezierPath.cgPath
      leftTopLayer.lineWidth = 4
      leftTopLayer.strokeColor = UIColor.green.cgColor
      leftTopLayer.fillColor = UIColor.clear.cgColor
    self.view.layer.addSublayer(leftTopLayer)

      //右上角的框
      let rightTopBezierPath = UIBezierPath()
      rightTopBezierPath.move(to: CGPoint(x: scanRect.maxX - 15, y: scanRect.minY - 2))
      rightTopBezierPath.addLine(to: CGPoint(x: scanRect.maxX + 2, y: scanRect.minY - 2))
      rightTopBezierPath.addLine(to: CGPoint(x: scanRect.maxX + 2, y: scanRect.minY + 15))
      rightTopLayer.path = rightTopBezierPath.cgPath
      rightTopLayer.lineWidth = 4
      rightTopLayer.strokeColor = UIColor.green.cgColor
      rightTopLayer.fillColor = UIColor.clear.cgColor
      self.view.layer.addSublayer(rightTopLayer)

      //左下角
      let leftBottomBezierPath = UIBezierPath()
      leftBottomBezierPath.move(to: CGPoint(x: scanRect.minX + 15, y: scanRect.maxY + 2))
      leftBottomBezierPath.addLine(to: CGPoint(x: scanRect.minX - 2, y: scanRect.maxY + 2))
      leftBottomBezierPath.addLine(to: CGPoint(x: scanRect.minX - 2, y: scanRect.maxY - 15))
      leftBottomLayer.path = leftBottomBezierPath.cgPath
      leftBottomLayer.lineWidth = 4
      leftBottomLayer.strokeColor = UIColor.green.cgColor
      leftBottomLayer.fillColor = UIColor.clear.cgColor
      self.view.layer.addSublayer(leftBottomLayer)


      //右下角
      let rightBottomBezierPath = UIBezierPath()
      rightBottomBezierPath.move(to: CGPoint(x: scanRect.maxX + 2, y: scanRect.maxY - 15))
      rightBottomBezierPath.addLine(to: CGPoint(x: scanRect.maxX + 2, y: scanRect.maxY + 2))
      rightBottomBezierPath.addLine(to: CGPoint(x: scanRect.maxX - 15, y: scanRect.maxY + 2))
      rightBottomLayer.path = rightBottomBezierPath.cgPath
      rightBottomLayer.lineWidth = 4
      rightBottomLayer.strokeColor = UIColor.green.cgColor
      rightBottomLayer.fillColor = UIColor.clear.cgColor
      self.view.layer.addSublayer(rightBottomLayer)

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

extension UIView {

    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
          maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }

    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
          maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }
}
