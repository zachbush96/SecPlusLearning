//
//  SecPlusLearningApp.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/22/24.
//

import SwiftUI

@main
struct SecurityPlusAppApp: App {
    @StateObject private var questionController = QuestionController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(questionController)
        }
    }
}
