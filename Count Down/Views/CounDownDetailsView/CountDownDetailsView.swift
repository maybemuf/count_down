//
//  CountDownDetailsView.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 29.12.2023.
//

import SwiftUI

struct CountDownDetailsView: View {
    @StateObject private var viewModel: CountDownDetailsViewModel
    
    init(countDown: CountDown) {
        _viewModel = StateObject(wrappedValue: CountDownDetailsViewModel(initialState: CountDownDetailsState(countDown: countDown)))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                K.Colors.secondary2
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Untill")
                            Text(viewModel.state.countDown.name)
                                .underline()
                            
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        
                        Text(viewModel.state.countDown.descriptionText ?? "")
                    }.foregroundStyle(K.Colors.primary1)
                    
                    Spacer().frame(height: 100)
                    
                    
                    if let timeDifference = viewModel.state.timeDifference {
                        CountDownTickerView(dateComponents: timeDifference)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }.onAppear {
                viewModel.setupCountDown()
            }
            .navigationTitle("CountDown Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(K.Colors.primary2, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        viewModel.startEditing()
                    }
                }
            }
        }.sheet(isPresented: viewModel.binding(\.isEditing), content: {
            AddCountDownView(countDown: viewModel.state.countDown)
        })
    }
}

#Preview {
    CountDownDetailsView(countDown: CountDown.generate())
}
