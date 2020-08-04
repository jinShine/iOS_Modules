//
//  LocalizationManager.swift
//  LocalizationModule
//
//  Created by Buzz.Kim on 2020/08/04.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import UIKit

class LocalizationManager: NSObject {
  
  ///Singleton
  static let shared = LocalizationManager()
  
  let componentName = "LocalizableBundle"
  let localizableName = "Localizable"
  
  var currentBundle = Bundle.main
  let fileManager = FileManager.default
  
  lazy var bundlePath: URL = {
    let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
    let bundlePath = documents.appendingPathComponent(componentName)
    return bundlePath
  }()
  
  func writeToBundle(languages: [Language]) throws -> Bundle {
    
    if !fileManager.fileExists(atPath: bundlePath.path) {
      try fileManager.createDirectory(at: bundlePath, withIntermediateDirectories: true, attributes: [FileAttributeKey.protectionKey : FileProtectionType.complete])
    }
    
    try languages.forEach { language in
      let countryCode = language.code
      let languageDirectory = bundlePath.appendingPathComponent("\(countryCode).lproj", isDirectory: true)
      
      if !fileManager.fileExists(atPath: languageDirectory.path) {
        try fileManager.createDirectory(at: languageDirectory, withIntermediateDirectories: true, attributes: [FileAttributeKey.protectionKey : FileProtectionType.complete])
      }
      
      let reproductionValue = language.translations.reduce("", { $0 + "\"\($1.key)\" = \"\($1.value)\";\n" })
      let filePath = languageDirectory.appendingPathComponent("\(localizableName).strings")
      let data = reproductionValue.data(using: .utf32)
      fileManager.createFile(atPath: filePath.path,
                             contents: data,
                             attributes: [FileAttributeKey.protectionKey : FileProtectionType.complete])
    }
    
    let localBundle = Bundle(url: bundlePath)!
    print(localBundle)
    return localBundle
  }
  
  func readLanguage(for countryCode: String) throws -> Bundle {
    if !fileManager.fileExists(atPath: bundlePath.path) {
      return Bundle()
    }
    
    do {
      let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
      _ = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      let enumerator = FileManager.default.enumerator(at: bundlePath ,
                                                      includingPropertiesForKeys: resourceKeys,
                                                      options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                        return true
      })!
      for case let folderURL as URL in enumerator {
        _ = try folderURL.resourceValues(forKeys: Set(resourceKeys))
        if folderURL.lastPathComponent == ("\(countryCode).lproj") {
          let enumerator2 = FileManager.default.enumerator(at: folderURL,
                                                           includingPropertiesForKeys: resourceKeys,
                                                           options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                            return true
          })!
          for case let fileURL as URL in enumerator2 {
            _ = try fileURL.resourceValues(forKeys: Set(resourceKeys))
            if fileURL.lastPathComponent == "Localizable.strings" {
              return Bundle(url: folderURL)!
            }
          }
        }
      }
    } catch {
      return Bundle(path: getPathLocal(for: countryCode))!
    }
    
    return Bundle(path: getPathLocal(for: countryCode)) ?? Bundle()
  }
  
  func setCurrnetBundle(for countryCode: String){
    do {
      currentBundle = try readLanguage(for: countryCode)
    } catch {
      currentBundle = Bundle(path: getPathLocal(for: "en"))!
    }
  }
  
  private func getPathLocal(for language: String) -> String {
    return Bundle.main.path(forResource: language, ofType: "lproj") ?? ""
  }
  
  
  func clean() throws {
    // TODO: There can be multiple table names in the same Bundle. So only remove the bundle if there is no more string files.
    var _: Dictionary<String, Int> = [:]
    
    for _ in fileManager.enumerator(at: bundlePath, includingPropertiesForKeys: nil, options: [.skipsPackageDescendants])! {
    }
    if fileManager.fileExists(atPath: bundlePath.path) {
      try fileManager.removeItem(at: bundlePath)
    }
  }
  
  
}
