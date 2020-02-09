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
  
  let resourceNames = ["10 Great iPhone Tips.pdf",
                       "camera-photo-tips.html",
                       "foggy.jpg",
                       "Hello World.ppt",
                       "no more complaint.png",
                       "Why Appcoda.doc"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resourceNames.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    cell.textLabel?.text = resourceNames[indexPath.row]
    cell.imageView?.image = UIImage(named: "icon\(indexPath.row)");
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedFile = resourceNames[indexPath.row]
    showEmail(attachment: selectedFile)
  }
  
}

//MARK: - email
extension AttachmentTableViewController: MFMailComposeViewControllerDelegate {
  
  func showEmail(attachment: String) {
    guard canSendMail() else { return }
    
    let emailTitle = "이메일 타이틀"
    let messageBody = "메세지 본문~~~!!"
    let toRecipients = ["seungjin429@gmail.com"]
    
    setupMailCompose(emailTitle: emailTitle,
                     messageBody: messageBody,
                     toRecipients: toRecipients)
    { [weak self] mailCompose in
      
      guard
        let fileParts = self?.fileParts(for: attachment),
        let filePath = self?.filePath(for: fileParts.name, ext: fileParts.ext),
        let fileData = self?.fileData(for: filePath),
        let mimeType = self?.mimeType(type: fileParts.ext) else { return }
      
      self?.addAttachment(mailComposer: mailCompose, fileData: fileData, mimeType: mimeType, fileName: fileParts.name)
      
      self?.present(mailCompose, animated: true, completion: nil)
    }
  }
  
  // 이메일을 보낼수 있는 디바이스인지 체크
  func canSendMail() -> Bool {
    guard MFMailComposeViewController.canSendMail() else {
      print("This device doesn't allow you to send mail.")
      return false
    }
    
    return true
  }
  
  // 이메일 설정
  func setupMailCompose(emailTitle: String, messageBody: String, toRecipients: [String],
                        completion: @escaping ((MFMailComposeViewController) -> Void)) {
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setSubject(emailTitle)
    mailComposer.setMessageBody(messageBody, isHTML: false)
    mailComposer.setToRecipients(toRecipients)
    completion(mailComposer)
  }
  
  // 파일 이름, 확장자 추출
  func fileParts(for attachment: String) -> (name: String, ext: String)? {
    let fileparts = attachment.components(separatedBy: ".")
    guard let fileName = fileparts.first,
      let fileExtension = fileparts.last else {
        return nil
    }
    
    return (fileName, fileExtension)
  }
  
  // 파일 위치 추출
  func filePath(for name: String?, ext: String?) -> String? {
    guard let filePath = Bundle.main.path(forResource: name, ofType: ext) else {
      return nil
    }
    
    return filePath
  }
  
  // 파일 데이터로 변환
  func fileData(for filePath: String) -> Data? {
    guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
      return nil
    }
    
    return fileData
  }
  
  // MIME type 추출
  func mimeType(type: String) -> MIMEType? {
    guard let type = MIMEType(type: type) else {
      return nil
    }
    
    return type
  }
  
  // 첨부파일 추가
  func addAttachment(mailComposer: MFMailComposeViewController, fileData: Data, mimeType: MIMEType, fileName: String) {
    mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: fileName)
  }
  
  // MFMailComposeViewController delegate
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
