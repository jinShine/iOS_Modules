//
//  EnrollmentViewController.swift
//  iCloud_Tutorial
//
//  Created by Buzz.Kim on 2020/11/16.
//

import UIKit
import CloudKit

class EnrollmentViewController: UIViewController {

  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var selectedImageView: UIImageView!
  
  var selectedImageURL: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }

  @IBAction func didTapAddImage(_ sender: UIButton) {
    
    let pickerController = UIImagePickerController()
    pickerController.delegate = self
    
    self.present(pickerController, animated: true, completion: nil)
  }
  
  @IBAction func didTapDone(_ sender: UIBarButtonItem) {
    guard selectedImageView.image != nil && !titleTextField.text!.isEmpty else {
      print("이미지 및 타이틀을 입력해주세요")
      return
    }

    saveFeedToCloud()
  }
  
  func saveFeedToCloud() {
    let record = CKRecord(recordType: "Feed")
    
    if let imageURL = selectedImageURL {
      let imageAsset = CKAsset(fileURL: imageURL)
      record.setValue(imageAsset, forKey: "image")
    }
    
    if let titleText = titleTextField.text {
      record.setValue(titleText, forKey: "title")
    }
    
    // Get the public iCloud Database
    let container = CKContainer.default()
    let publicDatabase = container.publicCloudDatabase
    
    // Save
    publicDatabase.save(record) { (record, error) in
      if let error = error {
        print("Failed upload to cloud - \(error.localizedDescription)")
        return
      }
      
      print("Success upload to cloud")
      self.navigationController?.popViewController(animated: true)
    }
  }
  
}

extension EnrollmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    if let mediaType = info[.mediaType] as? String,
       mediaType == "public.image" {
      
      let originalImage = info[.originalImage] as? UIImage
      selectedImageView.image = originalImage
      
      selectedImageURL = info[.imageURL] as? URL
    }
    
    self.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
}
