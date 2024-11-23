//
//  RegexParser.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

func extractJSON(from response: String) -> String? {
    logDebug("Input string: \(response)")
    let regex = "\\{.*\\}" // Match any JSON-like object
    do {
        let regex = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
        if let match = regex.firstMatch(in: response, options: [], range: NSRange(location: 0, length: response.utf16.count)) {
            let range = Range(match.range, in: response)
            return range.flatMap { String(response[$0]) }
        }
    } catch {
        print("Error creating regex: \(error)")
    }
    return nil
}
