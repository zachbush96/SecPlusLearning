//
//  LearningPlanController.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

class LearningPlanController {
    private let apiManager = APIManager.shared

    /// Generates a learning plan based on the user's answers.
    /// - Parameters:
    ///   - questions: The list of questions presented to the user.
    ///   - userAnswers: The user's selected answers, mapped by question ID.
    ///   - completion: A callback with the `LearningPlanModel` or an error if the request fails.
    func generateLearningPlan(
        questions: [QuestionModel],
        userAnswers: [Int: String],
        completion: @escaping (LearningPlanModel?, Error?) -> Void
    ) {
        // Ensure all questions have an answer
        guard userAnswers.count == questions.count else {
            let error = NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "All questions must be answered."]
            )
            completion(nil, error)
            return
        }

        // Prepare user answers in the same order as the questions
        let orderedUserAnswers = questions.map { question -> String in
            userAnswers[question.id] ?? ""
        }

        // Perform the API call to generate the learning plan
        apiManager.fetchLearningPlan(questions: questions, userAnswers: orderedUserAnswers) { learningPlan, error in
            DispatchQueue.main.async {
                if let learningPlan = learningPlan {
                    completion(learningPlan, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
}