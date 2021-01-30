//
//  TextField.swift
//  Common
//
//  Created by buzz on 2021/01/28.
//

import UIKit

public class TextField: UITextField {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    // Font size 적용 해야됨
    attributedPlaceholder = NSAttributedString(string: "", attributes: [
      NSAttributedString.Key.foregroundColor: Theme.color.ttGray010
    ])
  }
  
  private func updateUI() {
    setNeedsDisplay()
  }
  
}
