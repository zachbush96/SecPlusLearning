//
//  QuestionController.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

class QuestionController: ObservableObject {
    @Published var questions: [QuestionModel] = []
    @Published var isLoading = false
    @Published var userAnswers: [Int: String] = [:]
    @Published var learningPlan: LearningPlanModel?
    @Published var errorMessage: String?

    private let learningPlanController = LearningPlanController()

    /// Loads questions from the API.
    func loadQuestions() {
        isLoading = true
        errorMessage = nil
        logDebug("Loading questions...")
        // logDebug the status of isLoading and errorMessage
        logDebug("isLoading: \(isLoading)")
        logDebug("errorMessage: \(errorMessage ?? "nil")")
        APIManager.shared.fetchQuestions { fetchedQuestions, error in
            DispatchQueue.main.async {
                self.isLoading = false
                logDebug("Fetched questions: \(fetchedQuestions?.count ?? 0)")
                if let fetchedQuestions = fetchedQuestions {
                    logDebug("Questions loaded successfully.")
                    self.questions = fetchedQuestions
                } else if let error = error {
                    logDebug("Error loading questions: \(error.localizedDescription)")
                    self.errorMessage = "Failed to load questions: \(error.localizedDescription)"
                    print("Error loading questions: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Submits answers and requests a learning plan from the API.
    /// - Parameter completion: Callback executed when the learning plan is successfully generated.
    func submitAnswers(completion: @escaping () -> Void) {
        guard userAnswers.count == questions.count else {
            errorMessage = "Please answer all questions before submitting."
            return
        }

        isLoading = true
        errorMessage = nil

        learningPlanController.generateLearningPlan(questions: questions, userAnswers: userAnswers) { fetchedLearningPlan, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let fetchedLearningPlan = fetchedLearningPlan {
                    self.learningPlan = fetchedLearningPlan
                    completion()
                } else if let error = error {
                    self.errorMessage = "Failed to generate learning plan: \(error.localizedDescription)"
                    print("Error generating learning plan: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Resets the controller's state for a new quiz session.
    func resetQuiz() {
        questions = []
        userAnswers = [:]
        learningPlan = nil
        errorMessage = nil
        APIManager.shared.resetFetch()
    }
}
