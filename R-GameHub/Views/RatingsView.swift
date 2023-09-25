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

struct RatingsView: View {
    var rating: Double
    var color: Color
    var width: CGFloat
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(1...5/* 5 stars */, id: \.self) {_ in
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
                        .foregroundColor(color)
                }
            }
            .mask(stars)
        )
        .foregroundColor(color.opacity(0.3))
        .frame(width: width)
    }
}

struct RatingsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsView(rating: 3.5, color: CustomColor.secondaryColor, width: 175)
    }
}
