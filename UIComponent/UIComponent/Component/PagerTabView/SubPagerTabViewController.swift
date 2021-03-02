//
//  SubPagerTabViewController.swift
//  Common
//
//  Created by buzz on 2021/02/27.
//

import UIKit
import XLPagerTabStrip

// TODO: BaseViewController로 변경해야됨
open class SubPagerTabViewController: UIViewController {

  var item: Any?
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}

// MARK: - Helper methods

extension SubPagerTabViewController: Resetable {
  
  public func reset() {
    
  }
}

// MARK: - Required

extension SubPagerTabViewController: IndicatorInfoProvider {
  
  public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "")
  }
}
