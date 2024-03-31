//
//  ContentView.swift
//  BoxOut
//
//  Created by: Grant Perry on 12/26/22.
//    Modified: Friday December 15, 2023 at 7:45:03 PM
//
import SwiftUI
import HealthKit

struct outOfBoxView: View {

   @Environment(\.colorScheme) var colorScheme
   @State var showingAlert = false // Indicates if an alert is being shown
   @State var disableDiceBtn = false // Controls the dice button's enabled state
   @State var noTilesLeft = false // Indicates if there are no tiles left
   @State var playAnimation = false // Triggers animations
   @State var showMapTop = false // Controls the visibility of the map at the top
   @State var firstTime = true // Indicates if it's the first time the view is displayed
   @State var debugStr = "" // Contains debugging information
   @State var txtTooHigh = "" // Displays a warning if input is too high
   @State var btnTxt = "Roll Dice" // Text displayed on the dice button
   @State var file1FileName = "Dice1"
   @State var file2FileName = "Dice2"
   @State var dice1FileName = "Dice1"
   @State var dice2FileName = "Dice2"
   @State var combinations = [DiceCombination]() // Stores dice combinations
   @State var btnActive = Array(repeating: false, count: 12) // Tracks active buttons
   @State var buttons = Array(repeating: false, count: 12) // Tracks button states
   @State var sumOfBtnsPressed = [Int](repeating: 0, count: 13) // Sum of pressed buttons
   @State var targetNumber = Int.random(in: 2...12) // The target number to hit
   @State var numAllGameTilesPressed = 0 // Total number of game tiles pressed
   @State var rollCnt = 0 // Counts the number of rolls
   @State var holdCount = 0 // Holds the count
   @State var numTilesPressed = 0 // Number of tiles pressed
   @State var reamingBtnsAvailable = 0 // Remaining buttons available
   @State var remainTiles = 0 // Remaining tiles
   @State var dice1Val = 0 // Value of the first dice
   @State var dice2Val = 0 // Value of the second dice
   @State var numRolls = 0 // Number of rolls performed
   @State var gamesPlayed = 0 // Number of games played
   @State var btnComboCnt = 0 // Button combination count
   @State var sumOfBtnsPressedx = 0 // Alternate sum of buttons pressed
   @State var steps = 0 // Steps taken
   @State var winPct = 0.0 // Winning percentage
   @State var pctTotal = 0.0 // Total percentage
   @State var totDieRolled = 1 // Total dice rolled
   @State var Die1 = 1 // Value of die 1
   @State var Die2 = 2 // Value of die 2
   @State var isAnimatingDice = false
   @State var showingMetricsView = false

   // MARK: - UI Appearance Variables
   let diceImages = ["Dice1", "Dice2", "Dice3", "Dice4", "Dice5", "Dice6"] // Dice image names
   let cornerRad: CGFloat = 10 // Corner radius for UI elements
   var txtSize = 20 // Text size
   var width: CGFloat = 25 // Width for UI elements
   var height: CGFloat = 25 // Height for UI elements
   var numBtns = 12 // Number of buttons
   var thisGradient = Gradient(colors: [.blue, .green, .pink]) // Gradient colors

   // MARK: - Alert Variables
   var debug = false // Flag for debugging mode
   var alertTitle = "Maximum available tiles exceeded" // Alert title
   var alertMessage = "\nYou can continue by pressing the Continue button below" // Alert message
   var alertButtonText = "Continue"


   let backOff = Color.blue // Background color when off
   let backOn = Color.red
   let backColor = Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
   let onColor = Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
   let offColor = Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))
   let reddish = Color(#colorLiteral(red: 0.8156862745, green: 0.03137254902, blue: 0.02745098039, alpha: 1))
   let offColorTop = Color(#colorLiteral(red: 0.8699219823, green: 0.9528884292, blue: 0.8191569448, alpha: 1))
   let offColorBottom = Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
   let onColorTop = Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
   let onColorBottom = Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
  

   let foreColor = Color.white
   let fontType = Font.footnote



   
   var body: some View {
	  VStack(spacing: 0) {
		 VStack {
// MARK: - [ Begin Button Build (createBoxes)]
			VStack(alignment: .center) {
			   //					if showMapTop { MapView() }
			   HStack(spacing: 0) {
				  ForEach(0..<numBtns, id: \.self) { i in
					 HStack(spacing:0) {
						Button(action: {
// MARK: - Combinations Math
						   // tile is pressed already
						   if btnActive[i] {  return  } // user has already pressed this button don't let them unpress it

						   if self.buttons[i] { // user resetting tile - changing mind
							  btnComboCnt -= i + 1
							  numTilesPressed -= 1
							  self.buttons[i].toggle()
						   } else {
							  if btnComboCnt + i + 1 > totDieRolled  { // this tile + any other pressed would be > dice total
								 txtTooHigh = "Too Much"
								 return
							  } else { // go ahead and add thile total to the btnComboCnt
								 txtTooHigh = ""
								 btnComboCnt += i + 1
								 self.buttons[i].toggle()
							  }
							  if self.buttons[i]  { // if tile is pressed, add it to sum of tiles pressed thid game
								 numTilesPressed += 1
								 if btnComboCnt > totDieRolled {
									self.buttons[i].toggle()
								 }
							  } else {
								 // subtract because user unpressed the tile
								 txtTooHigh = "Resetting "
								 btnComboCnt -= i + 1
								 numTilesPressed -= 1
							  }
						   }
						   disableDiceBtn = btnComboCnt >= totDieRolled ? false : true
						}) {
						   // the button grows based on click logic here
						   Text("\(i + 1)") 				// shows the button value on the tile
							  .disabled(btnActive[i]) // make it so the user can't unselect tile after pressing Roll Dice
							  .font(fontType)
							  .fontWeight(.bold)
							  .frame(maxWidth: 30,
									 maxHeight: 120,
									 alignment: .center)
							  .foregroundColor(foreColor)
							  .padding(.leading, 1)
							  .background(self.buttons[i] ? backOn : backOff)
							  .cornerRadius(cornerRad)
						   //							  .clipShape(Circle())

						}
						// top section holding the buttons
						//						.background(
						//						   LinearGradient(
						//							  gradient: Gradient(colors: noTilesLeft ? [offColorTop, offColorBottom] : [onColorTop, onColorBottom]),
						//							  startPoint: .top,
						//							  endPoint: .bottom
						//						   )
						//						)
						//						.background(noTilesLeft ? offColor : onColor)
						.frame(maxWidth: 35,
							   maxHeight: self.buttons[i] ? .infinity : 35,
							   alignment: .center)
					 }
				  }
			   }
			   // top HStack modifiers
			   .frame(maxWidth: .infinity, maxHeight: 150)
			   //			   .background(noTilesLeft ? offColor : onColor)
			   .background(
				  LinearGradient(
					 gradient: Gradient(colors: noTilesLeft ? [offColorTop, offColorBottom] : [onColorTop, onColorBottom]),
					 startPoint: .top,
					 endPoint: .bottom
				  )
			   )
			   //               .background(backColor)
			   VStack(alignment: .trailing) {
				  VStack {
					 Text(txtTooHigh)
						.font(noTilesLeft ? .title : .footnote)
						.foregroundColor(Color.white)
				  }
				  VStack {
					 HStack {
 // MARK: - Reset Button
						gameResetBtn()
					 }
				  }
				  .frame(maxWidth: 70, maxHeight: 30)
				  .caption(font: .title3,
						   backgroundColor: .blue,
						   foregroundColor: .white,
						   fontWeight: .regular)
				  //                  .cornerRadius(10)
			   }
			   VStack { // spacer VStack
			   }
			   .frame(maxWidth: 0, maxHeight: 25, alignment: .trailing)
			   .overlay(
				  Circle()
					 .fill(Color.blue)
					 .frame(width:rollCnt > 9 ? width + 6 : width, height: height)
					 .padding()
					 .overlay(
						Text(String(rollCnt))
						   .font(.subheadline)
						   .fontWeight(.bold)
						   .foregroundColor(.white))
				  , alignment: .leadingLastTextBaseline)
			   VStack {
				  if debug {
					 Text("Tile Total: \(btnComboCnt) -- \(reamingBtnsAvailable)")
						.font(.footnote)
						.fontWeight(.bold)
				  }
			   }
			}
		 }
		 VStack(alignment: .center, spacing: 0) {
			VStack(alignment: .center,  spacing: 0) {
			   HStack(spacing: 0) {
				  HStack(alignment: .center, spacing: 0)  {
// MARK: - Gauges
					 Gauge(value: Double(buttons.filter { $0 == true }.count),
						   in: 0.0...Double(numBtns)) {
						Text("Closed")
					 } currentValueLabel: {
						Text("\(buttons.filter { $0 == true }.count)")
					 }
					 .gaugeStyle(.accessoryCircular)
					 .tint(thisGradient)
				  }
				  .padding()
				  HStack(alignment: .center, spacing: 0) {
					 Gauge(value: Double(numBtns - buttons.filter { $0 == true }.count),
						   in: 0.0...Double(numBtns)) {
						Text("Left")
					 } currentValueLabel: {
						Text("\(numBtns - buttons.filter { $0 == true }.count)")
					 }
					 .gaugeStyle(.accessoryCircular)
					 .tint(thisGradient)
					 //               Text("Steps taken today: \(steps)")
				  }
				  .padding()
//				  .onAppear(perform: queryStepCount)
			   }
			}
// MARK: - Dice Images
			VStack(alignment: .center, spacing: 0) {
			   VStack(alignment: .center, spacing: 0) {
 //                        let dice = getRndDice()
				  HStack(alignment: .top) {
					 HStack {
						withAnimation(.spring(response: 0.35, dampingFraction: 0.095, blendDuration: 0.5)) {
						   Image(dice1FileName)
							  .resizable()
							  .aspectRatio(1, contentMode: .fit)
							  .padding()
						}
					 }
					 HStack {
						withAnimation(.spring(response: 0.55, dampingFraction: 0.825, blendDuration: 0.5)) {
						   Image(dice2FileName)
							  .resizable()
							  .aspectRatio(1, contentMode: .fit)
							  .padding()
						}
					 }
				  }
				  // scale the dice
				  .scaleEffect(0.95)
				  .frame(maxWidth: .infinity, maxHeight: 100)
 // MARK: - Dice Total above dice images
				  VStack {
					 if debug {
						Text("Total: \(totDieRolled) & \(targetNumber) - \(buttons[totDieRolled - 1] ? "ON" : "OFF")")
						   .frame(maxWidth: 140, alignment: .leading)
						   .font(.title3)
						   .foregroundColor(.blue)
						   .disabled(true)
					 }
				  }
			   }
// MARK: - Sum of dice rolled text circle
			   VStack(spacing: 0) {
				  if totDieRolled > 1 || showingAlert {
					 if targetNumber > 1 || showingAlert {
						Text("\(String(totDieRolled))") // display the rolled dice sum
						   .frame(maxWidth: .infinity,
								  alignment: .center)
						   .font(.system(size: 35,
										 weight: .bold))
						   .foregroundColor(colorScheme == .dark ? .blue : .blue)
						   .background(.white)
						   .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
						   .opacity(colorScheme == .dark ? 0.75 : 0.45)
						   .padding(.top, -35)
						   .padding()
						   .disabled(true)
					 }
				  }
			   }
// MARK: - ALERT BUTTON / Maximum Available display
//			   Button("Show Metrics") {
//				  showingMetricsView = true
//			   }
			   .sheet(isPresented: $showingAlert) {
				  MetricsView(totDieRolled: totDieRolled,
							  btnsTurned: buttons.filter { $0 == true }.count, 
							  btnsRemaining: numBtns - buttons.filter { $0 == true }.count)

				  Button("Play Again...") {
					 showingMetricsView = false
					 showingAlert = false
					 resetVars(fullReset: false)
				  }
			   }

//			   Button(action: {
//				  //                  showingAlert = true
//			   }) {
//				  Text("")
//			   }.alert(Text(alertTitle),
//					   isPresented: $showingAlert,
//					   actions: {
//				  Button(alertButtonText) {
//					 resetVars()
////					 queryStepCount()
//				  }
//			   }, message: {Text("You rolled a ") + Text("\(totDieRolled)").foregroundColor(reddish).fontWeight(.bold) + Text("\nYou pressed ") + Text("\(holdCount)").foregroundColor(reddish).fontWeight(.bold) + Text(" tiles\nand left ") + Text("\(numBtns - holdCount)").foregroundColor(reddish).fontWeight(.bold) + Text(".\n" + alertMessage)
//			   })
 // MARK: - ROLL DICE BUTTON
			   /* Button section...
				combinations.forEach { combination in
				the combination.die1 is the dice 1 # so it needs to be 1 less for the buttons[index]
				Check each combination's comboDie1 and comboDie2 and see if the corresponding tile is off [meaning it's available]
				and if it is then add 1 to the cntRemainBtnsOff

				So anything < 2 means it is NOT an available pair so disregard it
				if !self.buttons[combination.comboDie1 - 1] {
				reamingBtnsAvailable += 1
				}
				if !self.buttons[combination.comboDie2 - 1] {
				reamingBtnsAvailable += 1
				}
				NEXT LINE checks to see if it's < 2
				If there are no pairs, then make cntRemainBtnsOff = 0 | there are no pairs of buttons left
				reamingBtnsAvailable < 2 { reamingBtnsAvailable = 0 }
				Another way to do that could be...  if cntRemainBtnsOff % 2 > 0 { cntRemainBtnsOff = 0 } because it's odd
				}
				If there are no pairs of button combos AND the actual single tile representing the dice combo is still available
				if self.reamingBtnsAvailable < 2 && buttons[targetNumber - 1]  {
				Replaced the above forEach loop with the following  2 lines.
				*/
			   Button(btnTxt) {
				  dice1Val = Int.random(in: 1...6)
				  dice2Val = Int.random(in: 1...6)
				  // check to see if there are any more tiles to flip

				  self.targetNumber = dice1Val + dice2Val
				  self.combinations = self.generateCombinations().filter { $0.comboDie1 + $0.comboDie2 == self.targetNumber }
				  (remainTiles, reamingBtnsAvailable) = (0, 0)

// MARK: - No More Tiles Left
				  let availableCombinations = combinations.filter {
					 !buttons[$0.comboDie1 - 1] &&
					 !buttons[$0.comboDie2 - 1]
				  }

				  if availableCombinations.count == 0 && buttons[targetNumber - 1]  {
					 //
					 // no more tiles left
					 holdCount = buttons.filter { $0 == true }.count // for alert
					 totDieRolled = dice1Val + dice2Val
					 noTilesLeft = true
					 disableDiceBtn = true
					 txtTooHigh = "Rolled: \(targetNumber)\nNo Tiles Left"
					 debugStr = "IN QUIT\ncntBtnsOff: \(reamingBtnsAvailable)" + "\nbuttons[\(targetNumber - 1)]: \(self.buttons[targetNumber - 1])"
//					 queryStepCount()
					 showingAlert = true // show alert
				  } else {
					 // put vars together to create image name for each dice
					 totDieRolled = dice1Val + dice2Val
					 debugStr = "cntBtnsOff: \(reamingBtnsAvailable)" +
					 "\nbuttons[\(targetNumber - 1)]: \(self.buttons[targetNumber - 1])"
					 self.btnComboCnt = 0
					 self.txtTooHigh = ""
					 dice1FileName = "Dice\(dice1Val)" // concatenated name for the image
					 dice2FileName = "Dice\(dice2Val)"
					 // rollCnt counter for the blue circle - keeps track of the # of rolls in this round
					 rollCnt += 1
					 disableDiceBtn 	= true

					 for isBtnActive in 0..<numBtns {
						if buttons[isBtnActive] {
						   btnActive[isBtnActive] = true
						}
					 }
				  }
			   }
			   .padding()
			   .caption(font: .title2,
						backgroundColor: disableDiceBtn ? Color.gray : Color.blue,
						foregroundColor: .white,
						fontWeight: .bold)
			   .opacity(disableDiceBtn ? 0.5 : 1)
			   .disabled(disableDiceBtn)
// MARK: -> Show Statistics

			}
			showStats()
		 }
		 VStack {
			if debug {
			   List(combinations, id: \.self) { combination in
				  HStack(alignment: .center) {
					 ScrollView {
						HStack {
						   Text("Tiles: \(combination.comboDie1) & \(combination.comboDie2)  \(checkButtonStatus(dieIndex: combination.comboDie1 - 1, btns: buttons)) -- \(checkButtonStatus(dieIndex: combination.comboDie2 - 1, btns: buttons))")
							  .font(.callout)
						}
						.frame(maxWidth: .infinity,
							   alignment: .center)
						.caption(font: .subheadline, foregroundColor: .red)
						//						.font(.subheadline)
						.fixedSize()
						.foregroundColor(.red)
					 }
					 .frame(height: 20)
				  }
			   }
			   //               Text("Rolled: \(totDieRolled)\n\(debugStr)")
			   //                  .font(.footnote)
			}
		 }
		 Spacer()
	  }
	  .background(
		 LinearGradient(
			gradient: Gradient(colors: noTilesLeft ? [offColorTop, offColorBottom] : [onColorTop, onColorBottom]),
			startPoint: .top,
			endPoint: .bottom
		 )
	  )
	  //	  .gradientBackground(gradient: .blueGrad)
	  //      .background(Color(.white))
   }

   // MARK: - Helpers

   func showStats() -> VStack<VStack<(some View)?>> {
//	  return // MARK: - Winning Stats
	  VStack(spacing: 0) {
		 VStack {
			if gamesPlayed > 0 {
			   Text("\n\n\nGames Played: \(gamesPlayed)\nOverall Winning: \(String(format: "%.1f", winPct))%")
				  .font(.footnote)
				  .padding()
				  .foregroundColor(colorScheme == .dark ? .white : .white)

//			   Spacer()
			}
		 }
	  }
   }


   func queryStepCount() {
	  // the code to get the step counter
	  let healthStore = HKHealthStore()
	  let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
	  let now = Date()
	  let startOfDay = Calendar.current.startOfDay(for: now)
	  let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
	  let dataTypesToRead = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
	  let dataTypesToWrite = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
	  healthStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { (success, error) in
		 if !success {
			print("Error requesting authorization: \(error?.localizedDescription ?? "Unknown error")")
		 }
		 let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
			guard let result = result, let sum = result.sumQuantity() else {
			   print("Error: \(error?.localizedDescription ?? "Unknown error")")
			   return
			}
			let steps = sum.doubleValue(for: HKUnit.count())
			self.steps = Int(steps)
		 }
		 healthStore.execute(query)
	  }
   }

   func gameResetBtn() -> Button<Text> {

	  return Button("Reset") {
		 // Reset btnClear to 0 when the button is pressed
		 resetVars(fullReset: true)
		 //         noTilesLeft = false
//		 queryStepCount()
	  }
   }

   func resetVars(fullReset: Bool) {
	  // called when the reset button OR Roll Dice button are pressed to do housekeeping on several variables
	  if !fullReset {
		 gamesPlayed += 1
		 numAllGameTilesPressed += buttons.filter { $0 == true }.count
		 winPct = (Double(numAllGameTilesPressed) / Double(numBtns)) * 100 / Double(gamesPlayed)
		 print("Games Played: \(gamesPlayed)")
	  } else { // reset games
		 gamesPlayed = 0
		 numAllGameTilesPressed = 0
		 winPct = 0
	  }

	  rollCnt = 0 // blue circle counter
	  buttons = Array(repeating: false, count: 12)
	  btnComboCnt = 0
	  totDieRolled = 1
	  remainTiles = 0
	  reamingBtnsAvailable = 0
	  debugStr = ""
	  txtTooHigh = ""
	  disableDiceBtn = false
	  self.noTilesLeft = false
	  for i in 0..<btnActive.count {
		 btnActive[i] = false
	  }
   }

   func generateCombinations() -> [DiceCombination] {
	  // Code to generate the combinations of tiles that sum to the dice combo
	  let dice = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
	  var combinations: [DiceCombination] = []

	  for die1 in dice {
		 for die2 in dice {
			if (die1 != die2) {
			   // don't add same 2 dice numbers
			   if combinations.contains(DiceCombination(comboDie1: die2, comboDie2: die1))  {
			   } else {
				  combinations.append(DiceCombination(comboDie1: die1, comboDie2: die2))
			   }
			}
		 }
	  }
	  return combinations
   }

   func checkButtonStatus(dieIndex: Int, btns: [Bool]) -> String {
	  if btns[dieIndex] {
		 return String(dieIndex + 1) + ": ON"
	  } else {
		 return String(dieIndex + 1) + ": OFF"
	  }
   }

   func containsValueAndButtonFalse(i: Int, combinations: [DiceCombination], buttons: [Bool]) -> Int {
	  var cntBtnsOff = 0
	  combinations.forEach { combination in
		 if buttons[combination.comboDie1 - 1] {
			cntBtnsOff += 1
		 }
		 if buttons[combination.comboDie2 - 1] {
			cntBtnsOff += 1
		 }
	  }
	  //      if !buttons[i] { cntBtnsOff += 1 }
	  return cntBtnsOff
   }
}

// MARK:- Caption ViewModifier
struct Caption: ViewModifier {
   let font: Font
   let backgroundColor: Color
   let foregroundColor: Color
   let fontWeight: Font.Weight

   func body(content: Content) -> some View {
	  content
		 .font(font)
		 .padding([.leading, .trailing], 5.0)
		 .background(backgroundColor)
		 .foregroundColor(foregroundColor)
		 .fontWeight(fontWeight)
		 .cornerRadius(20)
   }
}

extension View {
   public func caption(font: Font = .caption,
					   backgroundColor: Color = Color(.secondarySystemBackground),
					   foregroundColor: Color = Color(.white),
					   fontWeight: Font.Weight = .regular)
   -> some View {
	  modifier(Caption(font: font,
					   backgroundColor: backgroundColor,
					   foregroundColor: foregroundColor,
					   fontWeight: fontWeight))
   }
}


struct DiceCombination: Hashable {
   let comboDie1: Int
   let comboDie2: Int
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
	  outOfBoxView()
   }
}

