//
//  ViewController.swift
//  CustomActionSheetModule
//
//  Created by Buzz.Kim on 2020/07/31.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let transparentView = UIView()
  let tableView = UITableView()

  let height: CGFloat = 250
  
  var settingArray = ["Profile", "Favorite", "Notification", "Change Password", "Logout"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.isScrollEnabled = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
  }

  @IBAction func onClickMenu(_ sender: UIBarButtonItem) {
    
    let window: UIWindow?
    
    if #available(iOS 13.0, *) {
      window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    } else {
      window = UIApplication.shared.keyWindow
    }
    
    transparentView.backgroundColor = UIColor.black.withAlphaComponent(0)
    transparentView.frame = self.view.frame
    window?.addSubview(transparentView)
    
    let screenSize = UIScreen.main.bounds.size
    tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
    window?.addSubview(tableView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
    transparentView.addGestureRecognizer(tapGesture)
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
      self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.24)
      self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
    }, completion: nil)
  }
  
  @objc func onClickTransparentView() {
    
    let screenSize = UIScreen.main.bounds.size

    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
      self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0)
      self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
    }, completion: nil)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settingArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      as? CustomTableViewCell else {
      return UITableViewCell()
    }
    
    cell.lbl.text = settingArray[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
