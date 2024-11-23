// //
// //  QuestionView.swift
// //  SecPlusLearning
// //
// //  Created by Zach Bush on 11/23/24.
// //

// import SwiftUI

// struct QuestionView: View {
//     @State private var questions: [QuestionModel] = []
//     @State private var userAnswers: [Int: String] = [:]
//     @State private var isLoading = false
//     @State private var errorMessage: String? = nil

//     var body: some View {
//         VStack {
//             if isLoading {
//                 LoadingView()
//             } else if let errorMessage = errorMessage {
//                 Text(errorMessage)
//                     .foregroundColor(.red)
//                     .padding()
//                 Button("Retry") {
//                     loadQuestions()
//                 }
//                 .padding()
//             } else {
//                 VStack {
//                     Text("Security+ Quiz")
//                         .font(.title)
//                         .padding()

//                     if questions.isEmpty {
//                         ProgressView("Loading...")
//                             .progressViewStyle(CircularProgressViewStyle())
//                     } else {
//                         ProgressView(value: Double(userAnswers.count), total: Double(questions.count))
//                             .padding()
//                     }

//                     ScrollView {
//                         LazyVStack(alignment: .leading) {
//                             ForEach(questions, id: \.id) { question in
//                                 VStack(alignment: .leading) {
//                                     Text("\(question.id). \(question.question)")
//                                         .font(.headline)
//                                         .padding(.bottom, 5)

//                                     ForEach(question.choices, id: \.self) { choice in
//                                         Button(action: {
//                                             userAnswers[question.id] = choice
//                                             let generator = UIImpactFeedbackGenerator(style: .medium)
//                                             generator.impactOccurred()
//                                         }) {
//                                             HStack {
//                                                 Text(choice)
//                                                 Spacer()
//                                                 if userAnswers[question.id] == choice {
//                                                     Image(systemName: "checkmark.circle.fill")
//                                                 }
//                                             }
//                                             .padding()
//                                             .background(userAnswers[question.id] == choice
//                                                             ? Color.blue.opacity(0.3)
//                                                             : Color.gray.opacity(0.1))
//                                             .cornerRadius(8)
//                                         }
//                                     }
//                                 }
//                                 .padding()
//                             }
//                         }
//                     }

//                     Button("Submit") {
//                         submitAnswers()
//                     }
//                     .disabled(userAnswers.count < questions.count)
//                     .padding()
//                     .background(Color.blue)
//                     .opacity(userAnswers.count < questions.count ? 0.5 : 1.0)
//                     .cornerRadius(8)
//                 }
//             }
//         }
//         .onAppear(perform: loadQuestions)
//     }

//     func loadQuestions() {
//         isLoading = true
//         errorMessage = nil
//         APIManager.shared.fetchQuestions { fetchedQuestions, error in
//             DispatchQueue.main.async {
//                 self.isLoading = false
//                 if let fetchedQuestions = fetchedQuestions {
//                     self.questions = fetchedQuestions
//                 } else {
//                     self.errorMessage = error?.localizedDescription ?? "Failed to load questions."
//                 }
//             }
//         }
//     }

//     func submitAnswers() {
//         // Handle submission logic here
//     }
// }


import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var questionController: QuestionController

    var body: some View {
        VStack {
            if questionController.isLoading {
                LoadingView()
            } else if let errorMessage = questionController.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                Button("Retry") {
                    questionController.loadQuestions()
                }
                .padding()
            } else {
                VStack {
                    Text("Security+ Quiz")
                        .font(.title)
                        .padding()

                    if questionController.questions.isEmpty {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        ProgressView(value: Double(questionController.userAnswers.count), total: Double(questionController.questions.count))
                            .padding()
                    }

                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(questionController.questions, id: \.id) { question in
                                VStack(alignment: .leading) {
                                    Text("\(question.id). \(question.question)")
                                        .font(.headline)
                                        .padding(.bottom, 5)

                                    ForEach(question.choices, id: \.self) { choice in
                                        Button(action: {
                                            questionController.userAnswers[question.id] = choice
                                            let generator = UIImpactFeedbackGenerator(style: .medium)
                                            generator.impactOccurred()
                                        }) {
                                            HStack {
                                                Text(choice)
                                                Spacer()
                                                if questionController.userAnswers[question.id] == choice {
                                                    Image(systemName: "checkmark.circle.fill")
                                                }
                                            }
                                            .padding()
                                            .background(questionController.userAnswers[question.id] == choice
                                                            ? Color.blue.opacity(0.3)
                                                            : Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }

                    Button("Submit") {
                        questionController.submitAnswers {
                            // Handle post-submission actions if needed
                        }
                    }
                    .disabled(questionController.userAnswers.count < questionController.questions.count)
                    .padding()
                    .background(Color.blue)
                    .opacity(questionController.userAnswers.count < questionController.questions.count ? 0.5 : 1.0)
                    .cornerRadius(8)
                }
            }
        }
    }
}
