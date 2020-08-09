//
//  LanguageServiceManager.swift
//  LocalizationModule
//
//  Created by Buzz.Kim on 2020/08/04.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import UIKit

let dummyURL: URL = URL(string: "https://api.jsonbin.io/b/5f12a6c1918061662843e6bc")!

class LanguageServiceManager: NSObject {
  
  ///Singleton
  static let shared = LanguageServiceManager()
  
  func fetchLanguageFromServer(url: URL, completion: @escaping (Bool, Languages?) -> Void) {
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "Response Error")
        completion(false, nil)
        return
      }
      
      do {
        let json = try JSONDecoder().decode(Languages.self, from: data)
        completion(true, json)
      } catch {
        print("Decodable Error")
        completion(false, nil)
      }
    }
    
    task.resume()
  }
}
