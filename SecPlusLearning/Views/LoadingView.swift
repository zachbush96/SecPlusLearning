//
//  LoadingView.swift
//  SecPlusLearning
//
//  Created by Zach Bush on 11/23/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }
}