//
//  AttachmentTableViewController.swift
//  MessageUIModule
//
//  Created by seungjin on 2020/02/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import MessageUI

class AttachmentTableViewController: UITableViewController {
  
  let filenames = ["10 Great iPhone Tips.pdf",
                   "camera-photo-tips.html",
                   "foggy.jpg",
                   "Hello World.ppt",
                   "no more complaint.png",
                   "Why Appcoda.doc"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func showEmail(attachment: String) {
    //이메일을 보낼수 있는 디바이스인지 체크
    guard canSendMail() else { return }
    
    let emailTitle = "이메일 타이틀"
    let messageBody = "메세지 본문~~~!!"
    let toRecipients = ["seungjin429@gmail.com"]
    
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setSubject(emailTitle)
    mailComposer.setMessageBody(messageBody, isHTML: false)
    mailComposer.setToRecipients(toRecipients)
    
    let fileparts = attachment.components(separatedBy: ".")
  }
  
  func canSendMail() -> Bool {
    guard MFMailComposeViewController.canSendMail() else {
      print("This device doesn't allow you to send mail.")
      return false
    }
    
    return true
  }
  
  func setupMailCompose() {
    
  }
  
  func isFileContain(attachment: String) -> Bool {
    let fileparts = attachment.components(separatedBy: ".")
    let fileName = fileparts.first
    let fileExtension = fileparts.last
    
    guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
      return
    }
    
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // Return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows
    return filenames.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // Configure the cell...
    cell.textLabel?.text = filenames[indexPath.row]
    cell.imageView?.image = UIImage(named: "icon\(indexPath.row)");
    
    return cell
  }
  
}

extension AttachmentTableViewController: MFMailComposeViewControllerDelegate {
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    
    switch result {
    case .cancelled:
      print("\n------------------[Mail cancelled]------------------\n")
    case .saved:
      print("\n------------------[Mail saved]------------------\n")
    case .sent:
      print("\n------------------[Mail sent]------------------\n")
    case .failed:
      print("\n------------------[Mail failed]------------------\n")
      print("Failed to send : \(String(describing: error?.localizedDescription))")
    @unknown default:
      fatalError("unknown")
    }
    
    dismiss(animated: true, completion: nil)
  }
}
