//
//  ViewController.swift
//  TestStoryboard
//
//  Created by Jinnify on 2020/07/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  @IBAction func tap(_ sender: UIButton) {
    let vm = MovieViewModel()
    navigator.show(name: .main, scene: .movie(viewModel: vm), sender: self, animated: true)
  }
  
  @IBAction func goSearch(_ sender: UIButton) {
    let vm = SearchViewModel()
    navigator.show(name: .search, scene: .search(viewModel: vm), sender: self, animated: true)
  }
  
}

