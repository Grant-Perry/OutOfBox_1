//   metricsView.swift
//   OutOfBox_1
//
//   Created by: Grant Perry on 3/29/24 at 10:54 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct MetricsView: View {
   let totDieRolled: Int
   let btnsTurned: Int
   let btnsRemaining: Int
   let screenWidth: CGFloat = UIScreen.main.bounds.width // get the screen width
   var card1Top = Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
   var card1Bot = Color(#colorLiteral(red: 0.844440043, green: 0.6348294616, blue: 0.9835032821, alpha: 1))
   var card2Top = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
   var card2Bot = Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
   var card3Top = Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
   var card3Bot = Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1))

   var body: some View {
	  HStack(spacing: 20) { // Add 20 points of spacing between the two main VStacks
							// Left side for the "Maximum Available Tiles Exceeded" text
		 VStack(alignment: .trailing, spacing: 3) {
			ForEach(["No", "Tiles", "Remain"], id: \.self) { word in
			   Text(word)
				  .font(.system(size: 35, weight: .bold))
				  .opacity(0.75)
				  .padding(.leading, 15)
			}
		 }
		 .frame(width: screenWidth * 0.40, alignment: .trailing) // Half the screen's width, right justified

		 // Right side for the metrics bubbles
		 VStack(alignment: .trailing, spacing: 5) {
			MetricBox(title: "Last\nRolled:", value: "\(totDieRolled)", topColor: card1Top, bottomColor: card1Bot)
			MetricBox(title: "Tiles\nTurned:", value: "\(btnsTurned)", topColor: card2Top, bottomColor: card2Bot)
			MetricBox(title: "Tiles\nLeft:", value: "\(btnsRemaining)", topColor: card3Top, bottomColor: card3Bot)
		 }
		 .frame(width: screenWidth * 0.52) //  width for metrics boxes
		 .padding(.trailing, screenWidth * 0.05) // Add some padding to push the boxes away from the text

		 Spacer() // Push everything to the left
	  }
//	  .padding(.horizontal)

   }
}

struct MetricBox: View {
   let title: String
   let value: String
   let topColor: Color
   let bottomColor: Color

   var body: some View {
	  HStack {
		 Text(title)
			.font(.body)
			.fontWeight(.bold)
			.foregroundColor(.white)
			.frame(maxWidth: .infinity, alignment: .leading) // Right-justified within the container
		 Spacer() // Pushes the texts apart to each side
		 Text(value)
			.font(.system(size: 35, weight: .bold))
			.foregroundColor(.white)
			.opacity(0.75)
			.frame(maxWidth: .infinity, alignment: .center) // Left-justified within the container
	  }
	  .padding()
	  .background(
		 LinearGradient(
			gradient: Gradient(colors: [topColor,
										bottomColor]),
			startPoint: .top,
			endPoint: .bottom
		 )
	  )
	  .cornerRadius(10)
   }
}

//
//#Preview {
//   MetricsView()
//}
