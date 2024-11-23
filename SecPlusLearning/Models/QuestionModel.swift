//
//  QuestionModel.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

struct QuestionModel: Codable, Identifiable {
    let id: Int
    let question: String
    let choices: [String]
    let answer: String
    //let correct: String
}
