//
//  MainPagerTabViewController.swift
//  Common
//
//  Created by buzz on 2021/02/28.
//

import UIKit
import XLPagerTabStrip

/**
 [UI 제플린에서 보기](https://zpl.io/be6OABp)
 */

open class MainPagerTabViewController: ButtonBarPagerTabStripViewController {
  
  // MARK: - UI Properties
  
  public lazy var pagerTabView: PagerTabView = {
    let pagerTabView = PagerTabView()
    pagerTabView.setupPargerViewStyle(.main, with: buttonBarView)
    return pagerTabView
  }()
  
  // MARK: - Life cycle
  
  open override func viewDidLoad() {
    setupPagerTabViewStyle()
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Setup
  
  private func setupUI() {
    view.addSubview(pagerTabView)
    setupConstraints()
  }
  
  private func setupConstraints() {
    pagerTabView.snp.makeConstraints {
      $0.height.equalTo(UIConstants.size48)
    }
  }
  
  private func setupPagerTabViewStyle() {
    settings.style.buttonBarBackgroundColor = .clear
    settings.style.buttonBarItemBackgroundColor = .clear
    settings.style.buttonBarMinimumInteritemSpacing = 28
    settings.style.buttonBarLeftContentInset = 24
    settings.style.buttonBarRightContentInset = 24
    settings.style.selectedBarVerticalAlignment = .bottom
    settings.style.buttonBarItemTitleColor = Theme.color.black
    settings.style.buttonBarItemFont = Theme.font.body1Regular
    settings.style.buttonBarItemsShouldFillAvailableWidth = false
    settings.style.buttonBarItemLeftRightMargin = 0
    settings.style.selectedBarHeight = 2
    
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = Theme.color.black
      oldCell?.label.font = Theme.font.body1Regular
      newCell?.label.textColor = Theme.color.black
      newCell?.label.font = Theme.font.body1Bold
    }
  }
}
