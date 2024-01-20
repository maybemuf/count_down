//
//  NotifyContextMenu.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 19.01.2024.
//

import SwiftUI

struct NotifyMenu: View {
    @State private var shouldShowMenu = false
    var body: some View {
        Button("Notify"){
            shouldShowMenu.toggle()
        }
        .contextMenu {
            
                Button {
                    print("one")
                } label: {
                    Text("1 hour before")
                }
            
        }
        
    }
}

#Preview {
    NotifyMenu()
}
