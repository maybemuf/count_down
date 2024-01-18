//
//  CountDownTickerView.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 29.12.2023.
//

import SwiftUI

struct CountDownTickerItemView: View {
    let value: Int?
    let text: String?
    
    var body: some View {
        VStack {
            Text("\(value ?? 0)")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(K.Colors.primary1)
            Text(text ?? "")
                .font(.headline)
                .fontWeight(.light)
                .foregroundStyle(K.Colors.primary2)
                .underline()
        }
        .frame(width: 50)
    }
}

struct CountDownTickerView: View {
    let dateComponents: DateComponents
    
    var body: some View {
        HStack {
            CountDownTickerItemView(value: dateComponents.year, text: "Y")
            Spacer()
            CountDownTickerItemView(value: dateComponents.month, text: "M")
            Spacer()
            CountDownTickerItemView(value: dateComponents.day, text: "D")
            Spacer()
            CountDownTickerItemView(value: dateComponents.hour, text: "H")
            Spacer()
            CountDownTickerItemView(value: dateComponents.minute, text: "M")
            Spacer()
            CountDownTickerItemView(value: dateComponents.second, text: "S")
        }
        .padding(.vertical)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CountDownTickerView(dateComponents: DateComponents())
}
