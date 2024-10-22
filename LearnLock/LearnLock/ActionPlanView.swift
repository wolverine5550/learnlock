//
//  ActionPlanView.swift
//  LearnLock
//
//  Created by Adam Pascarella on 10/21/24.
//

import SwiftUI

struct ActionPlanView: View {
    let book: String
    let goal: String
    @State private var actionPlan = ""
    @State private var isLoading = false
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Action Plan for \(book)")
                    .font(.title)
                
                Text("Goal: \(goal)")
                    .font(.headline)
                
                if isLoading {
                    ProgressView()
                } else {
                    Text(actionPlan)
                        .font(.body)
                }
            }
            .padding()
        }
        .onAppear {
            generateActionPlan()
        }
    }
    
    private func generateActionPlan() {
        isLoading = true
        AIService.shared.generateActionPlan(for: book, goal: goal) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let plan):
                    actionPlan = plan
                    dataController.saveActionPlan(book: book, goal: goal, plan: plan)
                case .failure(let error):
                    actionPlan = "Error generating action plan: \(error.localizedDescription)"
                }
            }
        }
    }
}
