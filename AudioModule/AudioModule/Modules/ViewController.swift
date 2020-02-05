//
//  ViewController.swift
//  AudioModule
//
//  Created by Seungjin on 30/01/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  private let sectionItems = [
    "Single Track Playback and Recording", "Multitrack Playback and Recording"
  ]
  private let items = [
    ["AVAudioPlayer", "AVAudioRecoder"], ["AVAudioEngine"]
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }

  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension ViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionItems.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = items[indexPath.section][indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionItems[section]
  }

}

extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: items[indexPath.section][indexPath.row], sender: nil)
  }
}
