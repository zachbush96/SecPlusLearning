//
//  DebugLogger.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

func logDebug(_ message: String) {
    #if DEBUG
    print("[DEBUG]: \(message)")
    #endif
}