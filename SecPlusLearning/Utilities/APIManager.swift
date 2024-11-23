//
//  APIManager.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let apiKey = getAPIKey()
    private var hasBeenFetched = false

    private func createRequest(url: URL, body: [String: Any]) -> URLRequest {
        logDebug("Creating request for URL: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        logDebug("Request created with headers and body")
        return request
    }

    func fetchQuestions(completion: @escaping ([QuestionModel]?, Error?) -> Void) {
        guard !hasBeenFetched else {
            logDebug("Questions have already been fetched")
            return
        }
        // Set the flag to prevent multiple fetches
        hasBeenFetched = true


        logDebug("Starting fetchQuestions process")
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            logDebug("Invalid URL for fetchQuestions")
            return
        }

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "user",
                    "content": "Provide 20 Extreamly HARD Security+ exam questions with answers and correct answers. These questions should cover a wide variety of topics relevant to the COMPTIA Security+ Certificate. Format as JSON: {\"questions\": [{\"id\": 1, \"question\": \"...\", \"choices\": [\"A\", \"B\", \"C\", \"D\"], \"answer\": \"A\"}]}"
                ]
            ],
            "temperature": 0.85,
            //"max_tokens": 500
        ]

        let request = createRequest(url: url, body: body)
        logDebug("Sending fetchQuestions request")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                logDebug("Error received in fetchQuestions: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                logDebug("No data received in fetchQuestions")
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }

            logDebug("Data received, attempting to parse JSON")
            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let choices = json["choices"] as? [[String: Any]],
                let message = choices.first?["message"] as? [String: Any],
                let rawContent = message["content"] as? String {

                    logDebug("Raw content received: \(rawContent)")

                    // Extract clean JSON from raw content using RegexParser
                    if let extractedJSON = extractJSON(from: rawContent) {
                        logDebug("Extracted JSON content: \(extractedJSON)")

                        // Parse the extracted JSON string into a dictionary
                        if let contentData = extractedJSON.data(using: .utf8) {
                            do {
                                // Parse the root structure for questions
                                let root = try JSONDecoder().decode([String: [QuestionModel]].self, from: contentData)
                                logDebug("Decoded root structure: \(root)")

                                // Extract the questions array
                                if let questions = root["questions"] {
                                    logDebug("Successfully parsed questions: \(questions)")
                                    completion(questions, nil)
                                } else {
                                    logDebug("Questions key not found in decoded root")
                                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Questions key not found"]))
                                }
                            } catch let decodingError {
                                logDebug("Error decoding extracted JSON: \(decodingError.localizedDescription)")
                                completion(nil, decodingError)
                            }
                        } else {
                            logDebug("Failed to convert extracted JSON content to Data")
                            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON content"]))
                        }
                    } else {
                        logDebug("Failed to extract JSON content")
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No valid JSON content found"]))
                    }
                } else {
                    logDebug("Unexpected JSON structure")
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected JSON structure"]))
                }
            } catch {
                logDebug("Error parsing JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        }

        task.resume()
        logDebug("fetchQuestions task resumed")
    }

    // func fetchLearningPlan(questions: [QuestionModel], userAnswers: [String], completion: @escaping (LearningPlanModel?, Error?) -> Void) {
    //     logDebug("Starting fetchLearningPlan process")
    //     guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
    //         logDebug("Invalid URL for fetchLearningPlan")
    //         return
    //     }

    //     logDebug("Constructing request body for fetchLearningPlan")
    //     let input: [String: Any] = [
    //         "questions": questions.map { [
    //             //"id": $0.id,
    //             "question": $0.question,
    //             "choices": $0.choices,
    //             "answer": $0.answer
    //         ] },
    //         "user_answers": userAnswers
    //     ]
    //     logDebug("Input dictionary for fetchLearningPlan: \(input)")

    //     let body: [String: Any] = [
    //         "model": "gpt-4o-mini",
    //         "messages": [
    //             [
    //                 "role": "user",
    //                 "content": "Analyze the user's performance on these Security+ questions and provide a detailed learning plan. Input: \(input). Format as JSON: {\"strengths\": [\"...\"], \"weaknesses\": [\"...\"], \"recommendations\": [\"...\"]}. Reply back with only this JSON object, no additional text."
    //             ]
    //         ],
    //         "temperature": 0.7
    //     ]

    //     let request = createRequest(url: url, body: body)
    //     logDebug("Sending fetchLearningPlan request")

    //     let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //         if let error = error {
    //             logDebug("Error received in fetchLearningPlan: \(error.localizedDescription)")
    //             completion(nil, error)
    //             return
    //         }

    //         guard let data = data else {
    //             logDebug("No data received in fetchLearningPlan")
    //             completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
    //             return
    //         }

    //         logDebug("Data received, attempting to parse JSON for learning plan content")
    //         do {
    //             // Parse the JSON response
    //             if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
    //             let choices = json["choices"] as? [[String: Any]],
    //             let message = choices.first?["message"] as? [String: Any],
    //             let rawContent = message["content"] as? String {
    //                 logDebug("Successfully extracted content: \(rawContent)")

    //                 // Parse the raw content into a LearningPlanModel
    //                 if let contentData = rawContent.data(using: .utf8) {
    //                     do {
    //                         let learningPlan = try JSONDecoder().decode(LearningPlanModel.self, from: contentData)
    //                         logDebug("Successfully decoded LearningPlanModel: \(learningPlan)")
    //                         completion(learningPlan, nil)
    //                     } catch {
    //                         logDebug("Error decoding LearningPlanModel: \(error.localizedDescription)")
    //                         completion(nil, error)
    //                     }
    //                 } else {
    //                     logDebug("Failed to convert extracted content to Data")
    //                     completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON content"]))
    //                 }
    //             } else {
    //                 logDebug("Unexpected JSON structure in fetchLearningPlan")
    //                 completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected JSON structure"]))
    //             }
    //         } catch {
    //             logDebug("Error parsing JSON: \(error.localizedDescription)")
    //             completion(nil, error)
    //         }
    //     }

    //     task.resume()
    //     logDebug("fetchLearningPlan task resumed")
    // }
    
    func fetchLearningPlan(questions: [QuestionModel], userAnswers: [String], completion: @escaping (LearningPlanModel?, Error?) -> Void) {
        logDebug("Starting fetchLearningPlan process")
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            logDebug("Invalid URL for fetchLearningPlan")
            return
        }

        logDebug("Constructing request body for fetchLearningPlan")
        let input: [String: Any] = [
            "questions": questions.map { [
                //"id": $0.id,
                "question": $0.question,
                "choices": $0.choices,
                "answer": $0.answer
            ] },
            "user_answers": userAnswers
        ]
        logDebug("Input dictionary for fetchLearningPlan: \(input)")

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                [
                    "role": "user",
                    "content": "Analyze the user's performance on these Security+ questions and provide a detailed learning plan. Input: \(input). Format as JSON: {\"strengths\": [\"...\"], \"weaknesses\": [\"...\"], \"recommendations\": [\"...\"]}. Reply back with only this JSON object, no additional text."
                ]
            ],
            "temperature": 0.7
        ]

        let request = createRequest(url: url, body: body)
        logDebug("Sending fetchLearningPlan request")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                logDebug("Error received in fetchLearningPlan: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                logDebug("No data received in fetchLearningPlan")
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }

            logDebug("Data received, attempting to parse JSON for learning plan content")
            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let choices = json["choices"] as? [[String: Any]],
                let message = choices.first?["message"] as? [String: Any],
                let rawContent = message["content"] as? String {

                    logDebug("Raw content received: \(rawContent)")

                    // Extract clean JSON from raw content using RegexParser
                    if let extractedJSON = extractJSON(from: rawContent) {
                        logDebug("Extracted JSON content: \(extractedJSON)")

                        // Parse the extracted JSON string into a LearningPlanModel
                        if let contentData = extractedJSON.data(using: .utf8) {
                            do {
                                let learningPlan = try JSONDecoder().decode(LearningPlanModel.self, from: contentData)
                                logDebug("Successfully decoded LearningPlanModel: \(learningPlan)")
                                completion(learningPlan, nil)
                            } catch {
                                logDebug("Error decoding extracted JSON: \(error.localizedDescription)")
                                completion(nil, error)
                            }
                        } else {
                            logDebug("Failed to convert extracted JSON content to Data")
                            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON content"]))
                        }
                    } else {
                        logDebug("Failed to extract JSON content")
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No valid JSON content found"]))
                    }
                } else {
                    logDebug("Unexpected JSON structure in fetchLearningPlan")
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected JSON structure"]))
                }
            } catch {
                logDebug("Error parsing JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        }

        task.resume()
        logDebug("fetchLearningPlan task resumed")
    }

    // Function to set hasBeenFetched to false for when the user resets the quiz
    func resetFetch() {
        hasBeenFetched = false
    }
}
