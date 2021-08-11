//
//  ViewController.swift
//  PopTipMessageViewModule
//
//  Created by buzz on 2021/08/11.
//

import UIKit

class ViewController: UIViewController {

  let someButton = UIButton()

  lazy var popTipMessageView: PopTipMessageView = {
    let view = PopTipMessageView()
    view.setup(
      target: self,
      inView: someButton,
      direction: .up,
      directionMargin: 6,
      height: 50,
      leadingInset: 16,
      trailingInset: 16
    )
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    popTipMessageView.show(message: "500P 적립")

    popTipMessageView.hide()

    popTipMessageView.tap
      .subscribe(onNext: {
        print("Tap", $0)
      }).disposed(by: rx.disposeBag)
  }
}
