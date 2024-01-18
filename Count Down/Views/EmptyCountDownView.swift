//
//  EmptyCountDownView.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 23.12.2023.
//

import SwiftUI

struct EmptyCountDownView: View {
    @State private var isPresent = false
    var body: some View {
        VStack {
            Text(K.Strings.emptyCountDownTitle).padding()
            Button {
                self.isPresent.toggle()
            } label: {
                Text(K.Strings.addCountDown)
            }

        }.sheet(isPresented: $isPresent) {
            AddCountDownView()
        }
    }
}

#Preview {
    EmptyCountDownView()
}
