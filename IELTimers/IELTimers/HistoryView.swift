import SwiftUI

struct HistoryView: View {
    @State private var history: [[String: Any]] = []
    @State private var showEditSheet = false
    @State private var editingIndex: Int?

    var body: some View {
        NavigationView {
            List {
                ForEach(history.indices, id: \.self) { index in
                    let record = history[index]
                    VStack(alignment: .leading, spacing: 5) {
                        Text("项目名称: \(record["projectName"] as? String ?? "")")
                            .font(.headline)
                        if let startTime = record["startTime"] as? Date {
                            Text("开始时间: \(formatDate(startTime))")
                                .font(.subheadline)
                        }
                        Text("阅读篇号: \(record["readingCode"] as? String ?? "")")
                            .font(.subheadline)
                        Text("总题目数: \(record["totalQuestions"] as? String ?? "")")
                            .font(.subheadline)
                        Text("正确题目数: \(record["correctQuestions"] as? String ?? "")")
                            .font(.subheadline)
                        Text("用时: \(formatTime(record["elapsedTime"] as? TimeInterval ?? 0))")
                            .font(.subheadline)
                        if let total = Int(record["totalQuestions"] as? String ?? ""),
                           let correct = Int(record["correctQuestions"] as? String ?? "") {
                            let accuracy = Double(correct) / Double(total) * 100
                            Text("正确率: \(String(format: "%.2f", accuracy))%")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 5)
                    .contextMenu {
                        Button(action: {
                            editRecord(at: index)
                        }) {
                            Label("编辑", systemImage: "pencil")
                        }

                        Button(role: .destructive, action: {
                            deleteRecord(at: index)
                        }) {
                            Label("删除", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("历史记录")
            .onAppear(perform: loadHistory)
            .sheet(isPresented: $showEditSheet) {
                if let index = editingIndex {
                    EditRecordView(record: $history[index], onSave: saveHistory)
                }
            }
        }
    }

    func loadHistory() {
        let defaults = UserDefaults.standard
        history = (defaults.array(forKey: "history") as? [[String: Any]] ?? []).sorted {
            guard let date1 = $0["startTime"] as? Date, let date2 = $1["startTime"] as? Date else { return false }
            return date1 > date2
        }
    }

    func deleteRecord(at index: Int) {
        history.remove(at: index)
        saveHistory()
    }

    func editRecord(at index: Int) {
        editingIndex = index
        showEditSheet = true
    }

    func saveHistory() {
        let defaults = UserDefaults.standard
        defaults.set(history, forKey: "history")
    }

    func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 