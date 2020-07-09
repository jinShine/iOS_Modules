//
//  MovieViewController.swift
//  TestStoryboard
//
//  Created by Jinnify on 2020/07/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
  
  var viewModel: MovieViewModel!
  var navigator: Navigator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func pop(_ sender: UIButton) {
    
  }
  
  @IBAction func push(_ sender: UIButton) {
    let vm = DetailViewModel()
    navigator.push(storyboard: UIStoryboard(name: "Main", bundle: nil), scene: .detail(viewModel: vm), sender: self.navigationController, animated: true)
    
  }
}
