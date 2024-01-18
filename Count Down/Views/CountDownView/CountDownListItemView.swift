//
//  CountDownListItemView.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 18.01.2024.
//

import SwiftUI

struct CountDownListItemView: View {
    let countDown: CountDown
    
    var body: some View {
        NavigationLink {
            CountDownDetailsView(countDown: countDown)
        } label: {
            Text(countDown.name)
        }
    }
}

#Preview {
    CountDownListItemView(countDown: CountDown.generate())
}
