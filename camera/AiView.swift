//
//  AiView.swift
//  camera
//
//  Created by 高畠眞子 on 2026/07/10.
//

import SwiftUI

struct AiView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Ai美容診断画面")
                .font(.largeTitle)
            
        }
    }
}

#Preview {
    AiView()
}
