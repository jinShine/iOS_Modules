//
//  Slider.swift
//  Common
//
//  Created by buzz on 2021/01/28.
//

import UIKit

public class Slider: UISlider {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  public override func trackRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.minX, y: bounds.midY, width: bounds.width, height: 2)
  }
  
  private func setupUI() {
    tintColor = Theme.color.purple
    thumbTintColor = Theme.color.white
    
    updateUI()
  }
  
  private func updateUI() {
    setNeedsDisplay()
  }
  
}
