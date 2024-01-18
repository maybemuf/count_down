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

                            ForEach(viewModel.state.filteredCountDownds) { countDown in
                                NavigationLink {
                                    CountDownDetailsView(countDown: countDown)
                                } label: {
                                    Text(countDown.name)
                                }
                            }
                            .onDelete(perform: preformDelete)
                        }
                    
                }
                
            }
            .sheet(isPresented: $isSheetPresented) {
                AddCountDownView()
            }
            .onAppear(perform: viewModel.getCountDowns)
            .navigationTitle(K.Strings.countDownTitle)
            .toolbarBackground(K.Colors.primary2, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
    
    private func preformDelete(at index: IndexSet) {
        if let index = index.first {
            viewModel.deleteCountDown(viewModel.state.countDowns[index])
        }
    }
}

#Preview {
    CountDownView()
}
