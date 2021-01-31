//
//  PaddingLabel.swift
//  UIComponent
//
//  Created by buzz on 2021/01/31.
//

import UIKit

public class PaddingLabel: UILabel {
  
  var topInset: CGFloat = 0
  var leftInset: CGFloat = 0
  var bottomInset: CGFloat = 0
  var rightInset: CGFloat = 0
  
  public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
    self.topInset = top
    self.leftInset = left
    self.bottomInset = bottom
    self.rightInset = right
    super.init(frame: .zero)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  public override func drawText(in rect: CGRect) {
    let inset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: inset))
  }
  
  public override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + leftInset + rightInset,
      height: size.height + topInset + bottomInset
    )
  }
  
  public override var bounds: CGRect {
    didSet {
      preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
    }
  }
  
}
