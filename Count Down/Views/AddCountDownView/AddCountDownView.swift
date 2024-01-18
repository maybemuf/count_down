//
//  AddCountDownView.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 23.12.2023.
//

import SwiftUI

struct AddCountDownView: View {
    @ObservedObject var viewModel: AddCountDownViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(countDown: CountDown? = nil) {
        if let countDown {
            _viewModel = ObservedObject(wrappedValue: AddCountDownViewModel(countDown: countDown))
        } else {
            _viewModel = ObservedObject(wrappedValue: AddCountDownViewModel())
        }
    }
    
    var body: some View {
    
        NavigationStack {
            Form {
                Section(header: Text("About")) {
                    VStack(alignment: .leading) {
                        TextField(
                            "Name",
                            text: viewModel.binding(\.name)
                        )
                        .autocorrectionDisabled()
                        .onSubmit {
                            
                        }
                        if !viewModel.state.nameErrorText.isEmpty {
                            Text(viewModel.state.nameErrorText)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    TextField(
                        "Description",
                        text: viewModel.binding(\.description)
                    )
                    .autocorrectionDisabled()
                    .onSubmit {
                        
                    }
                }
                
                Section(header: Text("Time")) {
                    VStack(alignment: .leading) {
                        DatePicker(
                            "Date",
                            selection: viewModel.binding(\.dateTo),
                            in: viewModel.fromToday,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        if !viewModel.state.dateErrorText.isEmpty {
                            Text(viewModel.state.dateErrorText)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                
                }
               
                Section {
                    Button(viewModel.state.isEditingExisting ? "Save" : "Add") {
                        viewModel.addCountDown() {
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
            }
            .configureNavigationBar(title: viewModel.state.isEditingExisting ? "Edit Count Down" : "Add New Count Down")
        }
        
        
        
    }
}

#Preview {
    AddCountDownView()
}
