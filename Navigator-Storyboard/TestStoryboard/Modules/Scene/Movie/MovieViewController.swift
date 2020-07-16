//
//  MovieViewController.swift
//  TestStoryboard
//
//  Created by Jinnify on 2020/07/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class MovieViewController: BaseViewController {
  
  var viewModel: MovieViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func pop(_ sender: UIButton) {
    
  }
  
  @IBAction func push(_ sender: UIButton) {
    let vm = DetailViewModel()
    navigator.push(name: .main, scene: .detail(viewModel: vm), sender: self.navigationController, animated: true)
  }
}
