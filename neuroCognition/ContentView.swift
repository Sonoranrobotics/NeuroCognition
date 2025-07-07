import SwiftUI

struct ContentView: View {
    @State private var showReactionButton = false
    @State private var reactionTimes: [Double] = []
    @State private var startTime: Date?
    @State private var testStarted = false
    @State private var showResults = false
    @State private var currentRound = 0
    @State private var buttonPosition = CGPoint(x: 200, y: 400)

    let totalRounds = 5
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()

            if !testStarted && !showResults {
                VStack(spacing: 20) {
                    Text("Reaction Time Test")
                        .font(.largeTitle)
                        .bold()

                    Text("Tap the green button as fast as you can when it appears.\nYou’ll do this 5 times.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button("Start Test") {
                        testStarted = true
                        startNextRound()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .font(.title2)
                }
                .padding()
            }

            if testStarted && showReactionButton {
                Button("Tap me!") {
                    if let start = startTime {
                        let reaction = Date().timeIntervalSince(start)
                        reactionTimes.append(reaction)
                        showReactionButton = false
                        currentRound += 1

                        if currentRound < totalRounds {
                            startNextRound()
                        } else {
                            testStarted = false
                            showResults = true
                        }
                    }
                }
                .frame(width: 120, height: 120)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
                .font(.title)
                .position(buttonPosition)
                .animation(.easeInOut(duration: 0.3), value: buttonPosition)
            }

            if showResults {
                VStack(spacing: 20) {
                    Text("Results")
                        .font(.largeTitle)
                        .bold()

                    ForEach(0..<reactionTimes.count, id: \.self) { index in
                        Text("Attempt \(index + 1): \(String(format: "%.0f", reactionTimes[index] * 1000)) ms")
                            .font(.title3)
                    }

                    Button("Try Again") {
                        resetTest()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .font(.title2)
                }
                .padding()
            }
        }
    }

    func startNextRound() {
        let delay = Double.random(in: 2...4)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if testStarted {
                let newX = CGFloat.random(in: 70...(screenWidth - 70))
                let newY = CGFloat.random(in: 200...(screenHeight - 200))
                buttonPosition = CGPoint(x: newX, y: newY)
                startTime = Date()
                showReactionButton = true
            }
        }
    }

    func resetTest() {
        reactionTimes = []
        showReactionButton = false
        testStarted = false
        showResults = false
        currentRound = 0
    }
}
