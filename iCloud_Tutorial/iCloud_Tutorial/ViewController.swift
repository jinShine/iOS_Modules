//
//  ViewController.swift
//  iCloud_Tutorial
//
//  Created by Buzz.Kim on 2020/11/16.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var feeds: [CKRecord] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "리스트"
    setupTableView()
    fetchRecordFromCloud()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func fetchRecordFromCloud() {
    let container = CKContainer.default()
    let publicDatabase = container.publicCloudDatabase
    
    let predicate = NSPredicate(value: true)
    let sort = NSSortDescriptor(key: "creationDate", ascending: false)
    let query = CKQuery(recordType: "Feed", predicate: predicate)
    query.sortDescriptors = [sort]
    
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.desiredKeys = ["image", "title"]
    queryOperation.queuePriority = .veryHigh
    queryOperation.resultsLimit = 30
    
    self.feeds.removeAll()
    queryOperation.recordFetchedBlock = { [weak self] record in
      DispatchQueue.main.async {
        self?.feeds.append(record)
      }
    }
    
    queryOperation.queryCompletionBlock = { [weak self] cursor, error in
      if let error = error {
        print("Failed fetch from cloud - \(error.localizedDescription)")
        return
      }
      
      print("Success fetch from cloud")
      
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    publicDatabase.add(queryOperation)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEnrollment" {
      if let enrollmentVC = segue.destination as? EnrollmentViewController {
        enrollmentVC.feedDelegate = self
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feeds.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell

    let feed = feeds[indexPath.row]
    
    if let image = feed.object(forKey: "image"),
       let imageAsset = image as? CKAsset,
       let imageURL = imageAsset.fileURL {
      if let imageData = try? Data(contentsOf: imageURL) {
        cell.contentImageView.image = UIImage(data: imageData)
        cell.setNeedsLayout()
      }
    }
    
    if let title = feed.object(forKey: "title") as? String {
      cell.titleLabel.text = title
    }
    
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  
}

extension ViewController: FeedProtocol {
  
  func feed(record: CKRecord?) {
    if let feed = record {
      self.feeds.insert(feed, at: 0)
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
}
