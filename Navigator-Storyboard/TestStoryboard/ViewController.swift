//
//  ViewController.swift
//  TestStoryboard
//
//  Created by Jinnify on 2020/07/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let navigator = Navigator.default
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func tap(_ sender: UIButton) {
    let vm = MovieViewModel()
    navigator.show(storyboard: UIStoryboard(name: "Main", bundle: nil), scene: .movie(viewModel: vm), sender: self, animated: true)
  }
  
  @IBAction func goSearch(_ sender: UIButton) {
    let vm = SearchViewModel()
    navigator.show(storyboard: UIStoryboard(name: "Main", bundle: nil), scene: .search(viewModel: vm), sender: self, animated: true)
  }
  
}

