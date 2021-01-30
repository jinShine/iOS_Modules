//
//  Switch.swift
//  Common
//
//  Created by buzz on 2021/01/27.
//

import UIKit

public class Switch: UISwitch {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    onTintColor = Theme.color.purple
    thumbTintColor = Theme.color.white
    applySketchShadow(color: .black, alpha: 0.3, x: 0, y: 4, blur: 8)
    
    updateUI()
  }
  
  private func updateUI() {
    setNeedsDisplay()
  }

}
