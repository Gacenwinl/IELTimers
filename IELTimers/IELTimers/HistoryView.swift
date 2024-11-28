import SwiftUI

struct HistoryView: View {
    @State private var history: [[String: Any]] = []

    var body: some View {
        NavigationView {
            List(history.indices, id: \.self) { index in
                let record = history[index]
                VStack(alignment: .leading) {
                    Text("项目名称: \(record["projectName"] as? String ?? "")")
                    Text("阅读篇号: \(record["readingCode"] as? String ?? "")")
                    Text("总题目数: \(record["totalQuestions"] as? String ?? "")")
                    Text("正确题目数: \(record["correctQuestions"] as? String ?? "")")
                    Text("用时: \(formatTime(record["elapsedTime"] as? TimeInterval ?? 0))")
                }
            }
            .navigationTitle("历史记录")
            .onAppear(perform: loadHistory)
        }
    }

    func loadHistory() {
        let defaults = UserDefaults.standard
        history = defaults.array(forKey: "history") as? [[String: Any]] ?? []
    }

    func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
} 