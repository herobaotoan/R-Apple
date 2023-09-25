/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: R-Apple (Bui Nguyen Ngoc Tuan | Vo Tran Khanh Linh | Tran Chi Toan | Nguyen Thi Ha Giang | Nguyen Tuan Thang)
  ID: s3877673 | s3878600 | s3891637 | s3914108 | s3877039
  Created  date: 15/09/2023
  Last modified: 25/09/2023
  Acknowledgement: Previous assignments of members | Firebase lectures on Canvas | YouTube | Stackoverflow
*/

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

