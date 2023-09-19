//
//  RatingsView.swift
//  R-GameHub
//
//  Created by Стивен on 19/09/2023.
//

import SwiftUI

struct RatingsView: View {
    var rating: Double
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<5/* 5 stars */, id: \.self) {_ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader {reader in
                let width = rating / 5 /* out of 5 stars */ * reader.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(CustomColor.secondaryColor)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.white.opacity(0.3))
    }
}

struct RatingsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsView(rating: 3.5)
    }
}
