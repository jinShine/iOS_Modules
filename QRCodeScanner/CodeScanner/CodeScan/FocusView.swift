//
//  FocusView.swift
//  CodeScanner
//
//  Created by Seungjin on 06/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

public class FocusView: UIImageView {
  
  //MARK:- Outlets
  
  private let leftTopLayer = CAShapeLayer()
  private let rightTopLayer = CAShapeLayer()
  private let leftBottomLayer = CAShapeLayer()
  private let rightBottomLayer = CAShapeLayer()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

//MARK:- Methods
extension FocusView {
  
  // Line Draw with UIBezierPath
  public func scanLineBorder(_ rect: CGRect? = nil, color: UIColor, lineWidth: CGFloat) {
    leftTopLayer.removeFromSuperlayer()
    rightTopLayer.removeFromSuperlayer()
    leftBottomLayer.removeFromSuperlayer()
    rightBottomLayer.removeFromSuperlayer()
    
    guard let rect = rect else {
      let leftTopBezierPath = UIBezierPath()
      leftTopBezierPath.move(to: CGPoint(x: bounds.minX + 15, y: bounds.minY - 2))
      leftTopBezierPath.addLine(to: CGPoint(x: bounds.minX - 2, y: bounds.minY - 2))
      leftTopBezierPath.addLine(to: CGPoint(x: bounds.minX - 2, y: bounds.minY + 15))
      leftTopLayer.path = leftTopBezierPath.cgPath
      leftTopLayer.lineWidth = lineWidth
      leftTopLayer.strokeColor = color.cgColor
      leftTopLayer.fillColor = UIColor.clear.cgColor
      layer.addSublayer(leftTopLayer)
      
      let rightTopBezierPath = UIBezierPath()
      rightTopBezierPath.move(to: CGPoint(x: bounds.maxX - 15, y: bounds.minY - 2))
      rightTopBezierPath.addLine(to: CGPoint(x: bounds.maxX + 2, y: bounds.minY - 2))
      rightTopBezierPath.addLine(to: CGPoint(x: bounds.maxX + 2, y: bounds.minY + 15))
      rightTopLayer.path = rightTopBezierPath.cgPath
      rightTopLayer.lineWidth = lineWidth
      rightTopLayer.strokeColor = color.cgColor
      rightTopLayer.fillColor = UIColor.clear.cgColor
      layer.addSublayer(rightTopLayer)
      
      let leftBottomBezierPath = UIBezierPath()
      leftBottomBezierPath.move(to: CGPoint(x: bounds.minX + 15, y: bounds.maxY + 2))
      leftBottomBezierPath.addLine(to: CGPoint(x: bounds.minX - 2, y: bounds.maxY + 2))
      leftBottomBezierPath.addLine(to: CGPoint(x: bounds.minX - 2, y: bounds.maxY - 15))
      leftBottomLayer.path = leftBottomBezierPath.cgPath
      leftBottomLayer.lineWidth = lineWidth
      leftBottomLayer.strokeColor = color.cgColor
      leftBottomLayer.fillColor = UIColor.clear.cgColor
      layer.addSublayer(leftBottomLayer)
      
      let rightBottomBezierPath = UIBezierPath()
      rightBottomBezierPath.move(to: CGPoint(x: bounds.maxX + 2, y: bounds.maxY - 15))
      rightBottomBezierPath.addLine(to: CGPoint(x: bounds.maxX + 2, y: bounds.maxY + 2))
      rightBottomBezierPath.addLine(to: CGPoint(x: bounds.maxX - 15, y: bounds.maxY + 2))
      rightBottomLayer.path = rightBottomBezierPath.cgPath
      rightBottomLayer.lineWidth = lineWidth
      rightBottomLayer.strokeColor = color.cgColor
      rightBottomLayer.fillColor = UIColor.clear.cgColor
      layer.addSublayer(rightBottomLayer)
      return
    }
    
    let leftTopBezierPath = UIBezierPath()
    leftTopBezierPath.move(to: CGPoint(x: rect.minX + 15, y: rect.minY - 2))
    leftTopBezierPath.addLine(to: CGPoint(x: rect.minX - 2, y: rect.minY - 2))
    leftTopBezierPath.addLine(to: CGPoint(x: rect.minX - 2, y: rect.minY + 15))
    leftTopLayer.path = leftTopBezierPath.cgPath
    leftTopLayer.lineWidth = lineWidth
    leftTopLayer.strokeColor = color.cgColor
    leftTopLayer.fillColor = UIColor.clear.cgColor
    layer.addSublayer(leftTopLayer)
    
    let rightTopBezierPath = UIBezierPath()
    rightTopBezierPath.move(to: CGPoint(x: rect.maxX - 15, y: rect.minY - 2))
    rightTopBezierPath.addLine(to: CGPoint(x: rect.maxX + 2, y: rect.minY - 2))
    rightTopBezierPath.addLine(to: CGPoint(x: rect.maxX + 2, y: rect.minY + 15))
    rightTopLayer.path = rightTopBezierPath.cgPath
    rightTopLayer.lineWidth = lineWidth
    rightTopLayer.strokeColor = color.cgColor
    rightTopLayer.fillColor = UIColor.clear.cgColor
    layer.addSublayer(rightTopLayer)
    
    let leftBottomBezierPath = UIBezierPath()
    leftBottomBezierPath.move(to: CGPoint(x: rect.minX + 15, y: rect.maxY + 2))
    leftBottomBezierPath.addLine(to: CGPoint(x: rect.minX - 2, y: rect.maxY + 2))
    leftBottomBezierPath.addLine(to: CGPoint(x: rect.minX - 2, y: rect.maxY - 15))
    leftBottomLayer.path = leftBottomBezierPath.cgPath
    leftBottomLayer.lineWidth = lineWidth
    leftBottomLayer.strokeColor = color.cgColor
    leftBottomLayer.fillColor = UIColor.clear.cgColor
    layer.addSublayer(leftBottomLayer)
    
    let rightBottomBezierPath = UIBezierPath()
    rightBottomBezierPath.move(to: CGPoint(x: rect.maxX + 2, y: rect.maxY - 15))
    rightBottomBezierPath.addLine(to: CGPoint(x: rect.maxX + 2, y: rect.maxY + 2))
    rightBottomBezierPath.addLine(to: CGPoint(x: rect.maxX - 15, y: rect.maxY + 2))
    rightBottomLayer.path = rightBottomBezierPath.cgPath
    rightBottomLayer.lineWidth = lineWidth
    rightBottomLayer.strokeColor = color.cgColor
    rightBottomLayer.fillColor = UIColor.clear.cgColor
    layer.addSublayer(rightBottomLayer)
  }
}

