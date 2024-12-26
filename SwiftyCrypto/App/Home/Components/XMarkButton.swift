//
//  XMarkButton.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 25/12/24.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
          dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}
