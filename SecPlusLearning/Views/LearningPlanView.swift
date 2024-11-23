//
//  LearningPlanView.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import SwiftUI

struct LearningPlanView: View {
    let learningPlan: LearningPlanModel
    let onReset: () -> Void

    var body: some View {
        VStack {
            Text("Learning Plan")
                .font(.title)
                .padding()

            ScrollView {
                VStack(alignment: .leading) {
                    Text("**Strengths**")
                        .font(.headline)
                        .padding(.bottom, 5)

                    ForEach(learningPlan.strengths, id: \.self) { strength in
                        Text("• \(strength)")
                    }
                    .padding(.bottom)

                    Text("**Weaknesses**")
                        .font(.headline)
                        .padding(.bottom, 5)

                    ForEach(learningPlan.weaknesses, id: \.self) { weakness in
                        Text("• \(weakness)")
                    }
                    .padding(.bottom)

                    Text("**Recommendations**")
                        .font(.headline)
                        .padding(.bottom, 5)

                    ForEach(learningPlan.recommendations, id: \.self) { recommendation in
                        Text("• \(recommendation)")
                    }
                }
                .padding()
            }

            Button(action: onReset) {
                Text("Restart Quiz")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}
