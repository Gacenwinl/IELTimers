import SwiftUI

struct ScoreCalculatorView: View {
    @State private var correctAnswers: String = ""
    @State private var bandScore: String = ""

    var body: some View {
        VStack {
            TextField("正确题目数", text: $correctAnswers)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("计算分数") {
                calculateBandScore()
            }
            .font(.title2)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if !bandScore.isEmpty {
                Text("雅思阅读分数: \(bandScore)")
                    .font(.title)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("分数计算器")
    }

    func calculateBandScore() {
        guard let correct = Int(correctAnswers) else {
            bandScore = "请输入有效的正确题目数"
            return
        }

        switch correct {
        case 39...40:
            bandScore = "9.0"
        case 37...38:
            bandScore = "8.5"
        case 35...36:
            bandScore = "8.0"
        case 33...34:
            bandScore = "7.5"
        case 30...32:
            bandScore = "7.0"
        case 27...29:
            bandScore = "6.5"
        case 23...26:
            bandScore = "6.0"
        case 20...22:
            bandScore = "5.5"
        case 16...19:
            bandScore = "5.0"
        case 13...15:
            bandScore = "4.5"
        case 10...12:
            bandScore = "4.0"
        case 6...9:
            bandScore = "3.5"
        case 4...5:
            bandScore = "3.0"
        case 3:
            bandScore = "2.5"
        case 2:
            bandScore = "2.0"
        case 1:
            bandScore = "1.0"
        case 0:
            bandScore = "0.0"
        default:
            bandScore = "请输入有效的正确题目数"
        }
    }
} 