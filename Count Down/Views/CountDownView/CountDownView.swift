//
//  ContentView.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 23.12.2023.
//

import SwiftUI

struct CountDownView: View {
    @ObservedObject private var viewModel = CountDownViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.state.countDowns.isEmpty {
                    EmptyCountDownView()
                } else {
                    List {
                        
                        Section {
                            Toggle("Show completed:", isOn: viewModel.binding(\.isShowingCompleted))
                        }
                        
                        let activeCountDowns = viewModel.state.filteredCountDownds.filter { !$0.isPassed }
                        Section(header: Text(activeCountDowns.isEmpty ? "No active items" : "Active")) {
                            ForEach(activeCountDowns) { countDown in
                                CountDownListItemView(countDown: countDown)
                                    .swipeActions {
                                        Button("", systemImage: "trash", role: .destructive) {
                                            viewModel.deleteCountDown(countDown)
                                        }
                                    }
                            }
                        }
                        
                        
                        if viewModel.state.isShowingCompleted {
                            let passedCountDowns = viewModel.state.filteredCountDownds.filter { $0.isPassed }
                            Section(header: Text(passedCountDowns.isEmpty ? "No passed items" : "Passed")) {
                                ForEach(passedCountDowns) { countDown in
                                    CountDownListItemView(countDown: countDown)
                                        .swipeActions {
                                            Button("", systemImage: "trash", role: .destructive) {
                                                viewModel.deleteCountDown(countDown)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            .configureNavigationBar(title: K.Strings.countDownTitle)
            .onAppear(perform: viewModel.getCountDowns)
            .sheet(isPresented: $isSheetPresented) {
                AddCountDownView()
            }
            .toolbar {
                if !viewModel.state.countDowns.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isSheetPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CountDownView()
}
