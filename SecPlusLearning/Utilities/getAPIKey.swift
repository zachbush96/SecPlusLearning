//
//  getAPIKey.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

func getAPIKey() -> String {
    guard let path = Bundle.main.path(forResource: "secrets", ofType: "plist"),
          let dict = NSDictionary(contentsOfFile: path) else {
        fatalError("API Key not found in Secrets.plist")
    }
    return dict["OpenAIAPIKey"] as? String ?? ""
}
