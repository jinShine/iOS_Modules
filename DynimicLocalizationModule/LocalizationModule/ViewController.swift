//
//  ViewController.swift
//  LocalizationModule
//
//  Created by Buzz.Kim on 2020/07/28.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var languageDownloadSwitch: UISwitch!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var pickerView: UIPickerView!
  
  @IBOutlet weak var label1: UILabel!
  @IBOutlet weak var label2: UILabel!
  @IBOutlet weak var label3: UILabel!
  @IBOutlet weak var label4: UILabel!
  @IBOutlet weak var label5: UILabel!
  @IBOutlet weak var label6: UILabel!
  
  var languages: [Language] = []
  var country: [String] = ["en", "ta", "hi"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    updateView()
  }
  
  private func setupUI() {
    languageDownloadSwitch.setOn(false, animated: false)
    indicator.isHidden = true
    pickerView.isHidden = true
    pickerView.backgroundColor = .gray
  }
  
  private func updateView() {
    LocalizationManager.shared.setCurrnetBundle(for: UserDefaults.selectedLanguage)
    
    label1.text = localizedString("key1")
    label2.text = localizedString("key2")
    label3.text = localizedString("key3")
    label4.text = localizedString("key4")
    label5.text = localizedString("key5")
    label6.text = localizedString("key6")
  }
  
  @IBAction func downloadToggle(_ sender: UISwitch) {
    
    if sender.isOn {
      indicator.startAnimating()
      indicator.isHidden = false
      
      LanguageServiceManager.shared.fetchLanguageFromServer(url: dummyURL) { (success, json) in

        _ = try? LocalizationManager.shared.writeToBundle(languages: json?.languages ?? [])
        
        DispatchQueue.main.async {
          self.indicator.stopAnimating()
          self.indicator.isHidden = true
          self.languages.removeAll(keepingCapacity: true)
          self.languages.append(contentsOf: json?.languages ?? [])
          self.pickerView.reloadAllComponents()
          self.updateView()
        }
      }
    }
  }
  
  @IBAction func changeLanguage(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected {
      pickerView.isHidden = false
    } else {
      pickerView.isHidden = true
    }
  }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return country.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return country[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    UserDefaults.selectedLanguage = country[row]
    updateView()
  }
  
}

func localizedString(_ key: String) -> String {
    return NSLocalizedString(key, bundle: LocalizationManager.shared.currentBundle, value: "", comment: "")
}

extension UserDefaults {
  
  class var selectedLanguage: String {
    get {
      if (standard.string(forKey: "SelectedLanguage") == nil) {
        return "en"
      }
      else {
        return standard.string(forKey: "SelectedLanguage")!
      }
    }
    set {
      standard.set(newValue, forKey: "SelectedLanguage")
      standard.synchronize()
    }
  }
}
