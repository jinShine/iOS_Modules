//
//  CommonUtils.swift
//  CodeScanner
//
//  Created by Seungjin on 06/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Common

func focusSize(_ view: UIView, scannerType: ScannerType) -> CGSize {

  let device = UIDevice.current.userInterfaceIdiom
  let size: CGSize

  switch device {
  case .phone:
    switch scannerType {
    case .qrCode:
      let width = view.bounds.width * 0.5
      size = CGSize(width: width, height: width)
      return size
    case .barCode:
      let width = view.bounds.width * 0.8
      let height = ((width * 3) / 4) - 80.0
      size = CGSize(width: width, height: height)
      return size
    }
  case .pad:
    switch scannerType {
    case .qrCode:
      let width = view.bounds.width * 0.7
      size = CGSize(width: width, height: width)
      return size
    case .barCode:
      let width = view.bounds.width * 0.7
      let height = ((width * 3) / 4) - 80
      size = CGSize(width: width, height: height)
      return size
    }
  default:
    size = CGSize.zero
  }

  return size
}


//MARK:- UIView Extension

extension UIView {

  func mask(withRect rect: CGRect, inverse: Bool = false) {
    let path = UIBezierPath(rect: rect)
    let maskLayer = CAShapeLayer()
    if inverse {
      path.append(UIBezierPath(rect: self.bounds))
      maskLayer.fillRule = .evenOdd
    }

    maskLayer.path = path.cgPath
    self.layer.mask = maskLayer
  }
}
