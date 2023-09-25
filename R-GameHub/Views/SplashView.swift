//
//  SplashView.swift
//  R-GameHub
//
//  Created by Стивен on 25/09/2023.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {horizontalSizeClass == .compact}
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State private var isActive = false
    @State private var size = 0.7
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            LogInView()
        } else {
            ZStack {
                CustomColor.primaryColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        Image("app-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: isCompact ? 200 : 400, height: isCompact ? 200 : 400)
                        Text("R-GameHub")
                            .font(.system(size: isCompact ? 36 : 66))
                            .fontWeight(.bold)
                            .foregroundColor(CustomColor.secondaryColor)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
