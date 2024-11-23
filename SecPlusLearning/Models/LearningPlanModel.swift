//
//  LearningPlanModel.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

struct LearningPlanModel: Codable {
    let strengths: [String]
    let weaknesses: [String]
    let recommendations: [String]
}