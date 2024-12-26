//
//  HomeNavigationView.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 24/12/24.
//

import SwiftUI

struct HomeNavigationView: View {
    @Binding var isShowingPortfolio: Bool
    var leadingButtonAction: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            CircularButtonView(iconName: isShowingPortfolio ? "plus" : "info")
                .onTapGesture {
                    leadingButtonAction()
                }
                .background(
                    CircleButtonAnimationView(animate: $isShowingPortfolio)
                )
            Spacer()
            Text(isShowingPortfolio ? "Holdings" : "Live Market")
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
            .animation(.none)
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

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: animate)
    }
}

#Preview {
    Group {
        HomeNavigationView(isShowingPortfolio: .constant(false)){}
            .preferredColorScheme(.dark)
        
        HomeNavigationView(isShowingPortfolio: .constant(true)){}
            .preferredColorScheme(.light)
    }
}
