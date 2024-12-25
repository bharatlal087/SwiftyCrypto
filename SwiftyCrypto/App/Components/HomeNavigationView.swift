//
//  HomeNavigationView.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import SwiftUI

struct HomeNavigationView: View {
    @Binding var isShowingPortfolio: Bool

    var body: some View {
        HStack(spacing: .zero) {
            CircularButtonView(iconName: isShowingPortfolio ? "plus" : "info")
            Spacer()
            Text(isShowingPortfolio ? "Holding" : "Live")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.accentColor)
                .animation(.none)
            Spacer()
            CircularButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: isShowingPortfolio ? 180: 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        isShowingPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
}


struct CircularButtonView: View {
    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.accentColor)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.background)
            )
            .shadow(
                color: Color.accentColor.opacity(0.25),
                radius: 10, x: 0, y: 0)
            .padding()
    }
}


#Preview {
    Group {
        HomeNavigationView(isShowingPortfolio: .constant(false))
            .preferredColorScheme(.dark)
        
        HomeNavigationView(isShowingPortfolio: .constant(true))
            .preferredColorScheme(.light)
    }
}
