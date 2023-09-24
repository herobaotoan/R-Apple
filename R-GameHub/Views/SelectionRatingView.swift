//
//  UserRatingView.swift
//  R-GameHub
//
//  Created by Стивен on 24/09/2023.
//

import SwiftUI

struct SelectionRatingView: View {
    @State var rating: Int
    var size: CGFloat
    var color: Color
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) {number in
                showStar(for: number)
                    .foregroundColor(number <= rating ? color : color.opacity(0.3))
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(.system(size: size))
        }
    }
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}

struct SelectionRatingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionRatingView(rating: 4, size: 50, color: CustomColor.secondaryColor)
    }
}

