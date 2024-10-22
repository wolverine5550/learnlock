//
//  ContentView.swift
//  LearnLock
//
//  Created by Adam Pascarella on 10/21/24.
//
// The initial UI for the app.

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @State private var selectedBook = ""
    @State private var optimizationGoal = ""
    @State private var showingActionPlan = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Selection")) {
                    TextField("Enter a book title", text: $selectedBook)
                }
                
                Section(header: Text("Optimization Goal")) {
                    TextField("Enter your goal (e.g., upcoming meeting)", text: $optimizationGoal)
                }
                
                Button(action: {
                    // TODO: Implement AI integration
                    showingActionPlan = true
                }) {
                    Text("Generate Action Plan")
                }
                .disabled(selectedBook.isEmpty || optimizationGoal.isEmpty)
            }
            .navigationTitle("Book Lessons")
            .sheet(isPresented: $showingActionPlan) {
                ActionPlanView(book: selectedBook, goal: optimizationGoal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
