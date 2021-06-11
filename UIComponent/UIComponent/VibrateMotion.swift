//
//  VibrateMotion.swift
//  UIComponent
//
//  Created by buzz on 2021/06/11.
//

import UIKit

class General {

  func doVibrate() {

    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
  }
}
