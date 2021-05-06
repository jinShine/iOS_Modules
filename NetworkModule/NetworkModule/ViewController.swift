//
//  ViewController.swift
//  NetworkModule
//
//  Created by buzz on 2021/05/03.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let networkService = NetworkService<ConsumerRouter>()
    networkService.request(to: .test, decode: CommonResponse<Model>.self)
      .subscribe(onSuccess: { response in

      }, onError: { error in

      })
      .disposed(by: rx.disposeBag)
  }


}

