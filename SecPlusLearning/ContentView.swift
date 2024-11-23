// import SwiftUI

// struct ContentView: View {
//     @EnvironmentObject var questionController: QuestionController
//     @State private var showLearningPlan = false

//     var body: some View {
//         ZStack {
//             if questionController.isLoading {
//                 LoadingView()
//             } else if showLearningPlan, let learningPlan = questionController.learningPlan {
//                 LearningPlanView(learningPlan: learningPlan) {
//                     restartQuiz()
//                 }
//             } else if !questionController.questions.isEmpty {
//                 VStack {
//                     if let errorMessage = questionController.errorMessage {
//                         Text(errorMessage)
//                             .foregroundColor(.red)
//                             .padding()
//                     }

//                     QuestionView()
//                         .onDisappear {
//                             if questionController.learningPlan != nil {
//                                 showLearningPlan = true
//                             }
//                         }
//                 }
//             } else {
//                 Text("No questions available. Please try again.")
//                     .foregroundColor(.gray)
//                     .padding()
//             }
//         }
//         .onAppear {
//             print("onAppear called")
//             print("isLoading: \(questionController.isLoading)")
//             print("learningPlan: \(String(describing: questionController.learningPlan))")
//             print("showLearningPlan: \(showLearningPlan)")
//             questionController.loadQuestions()
//         }
//     }

//     private func restartQuiz() {
//         questionController.resetQuiz()
//         showLearningPlan = false
//         questionController.loadQuestions()
//     }
// }
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var questionController: QuestionController
    @State private var showLearningPlan = false

    var body: some View {
        ZStack {
            if questionController.isLoading {
                LoadingView()
            } else if showLearningPlan, let learningPlan = questionController.learningPlan {
                LearningPlanView(learningPlan: learningPlan) {
                    restartQuiz()
                }
            } else if !questionController.questions.isEmpty {
                VStack {
                    if let errorMessage = questionController.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    QuestionView()
                        .onDisappear {
                            if questionController.learningPlan != nil {
                                showLearningPlan = true
                            }
                        }
                }
            } else {
                Text("No questions available. Please try again.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            logDebug("onAppear called")
            logDebug("isLoading: \(questionController.isLoading)")
            logDebug("learningPlan: \(String(describing: questionController.learningPlan))")
            logDebug("showLearningPlan: \(showLearningPlan)")
            questionController.loadQuestions()
        }
    }

    private func restartQuiz() {
        questionController.resetQuiz()
        showLearningPlan = false
        questionController.loadQuestions()
    }
}
