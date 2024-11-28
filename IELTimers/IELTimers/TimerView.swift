import SwiftUI

struct TimerView: View {
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var segments: [TimeInterval] = []
    @State private var showInputSheet = false
    @State private var projectName: String = ""
    @State private var readingCode: String = ""
    @State private var totalQuestions: String = ""
    @State private var correctQuestions: String = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showSaveConfirmation = false

    var body: some View {
        VStack {
            Text("开始时间: \(startTime != nil ? "\(startTime!)" : "未开始")")
                .font(.headline)
                .padding(.top)

            Text("已记录时间: \(formatTime(elapsedTime))")
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .padding()

            List {
                ForEach(segments.indices, id: \.self) { index in
                    Text("分段 \(index + 1): \(formatTime(segments[index]))")
                        .font(.subheadline)
                }
            }
            .listStyle(PlainListStyle())

            HStack {
                Button(action: startTimer) {
                    Text("开始")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isRunning)

                Button(action: pauseTimer) {
                    Text("暂停")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!isRunning ? Color.gray : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isRunning)

                Button(action: stopTimer) {
                    Text("停止")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!isRunning ? Color.gray : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isRunning)
            }
            .padding()

            Button(action: addSegment) {
                Text("分段")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRunning ? Color.purple : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isRunning)
            .padding(.horizontal)
        }
        .padding()
        .onAppear(perform: loadData)
        .sheet(isPresented: $showInputSheet) {
            VStack {
                TextField("计时项目名称", text: $projectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("阅读篇号", text: $readingCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("总题目数", text: $totalQuestions)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("正确题目数", text: $correctQuestions)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("保存") {
                    validateAndSaveData()
                }
                .font(.title2)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("错误"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
        .alert(isPresented: $showSaveConfirmation) {
            Alert(title: Text("保存成功"), message: Text("计时数据已保存"), dismissButton: .default(Text("确定")))
        }
    }

    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        segments.removeAll()
        projectName = ""
        readingCode = ""
        totalQuestions = ""
        correctQuestions = ""
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        isRunning = false
    }

    func stopTimer() {
        timer?.invalidate()
        isRunning = false
        showInputSheet = true
    }

    func addSegment() {
        segments.append(elapsedTime)
    }

    func validateAndSaveData() {
        guard let total = Int(totalQuestions), let correct = Int(correctQuestions), correct <= total else {
            errorMessage = "请输入有效的题目数和正确题目数。"
            showErrorAlert = true
            return
        }
        saveData()
        showSaveConfirmation = true
        showInputSheet = false
        print("Data saved successfully")
    }

    func saveData() {
        let defaults = UserDefaults.standard
        var history = defaults.array(forKey: "history") as? [[String: Any]] ?? []
        let record: [String: Any] = [
            "elapsedTime": elapsedTime,
            "segments": segments,
            "projectName": projectName,
            "readingCode": readingCode,
            "totalQuestions": totalQuestions,
            "correctQuestions": correctQuestions
        ]
        history.append(record)
        defaults.set(history, forKey: "history")
        print("Data saved to UserDefaults")
    }

    func loadData() {
        let defaults = UserDefaults.standard
        elapsedTime = defaults.double(forKey: "lastElapsedTime")
        segments = defaults.array(forKey: "lastSegments") as? [TimeInterval] ?? []
        projectName = defaults.string(forKey: "projectName") ?? ""
        readingCode = defaults.string(forKey: "readingCode") ?? ""
        totalQuestions = defaults.string(forKey: "totalQuestions") ?? ""
        correctQuestions = defaults.string(forKey: "correctQuestions") ?? ""
    }

    func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
} 