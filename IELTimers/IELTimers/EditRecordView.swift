import SwiftUI

struct EditRecordView: View {
    @Binding var record: [String: Any]
    var onSave: () -> Void

    @State private var projectName: String = ""
    @State private var readingCode: String = ""
    @State private var totalQuestions: String = ""
    @State private var correctQuestions: String = ""

    var body: some View {
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
                saveChanges()
                onSave()
            }
            .font(.title2)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            loadRecordData()
        }
    }

    func loadRecordData() {
        projectName = record["projectName"] as? String ?? ""
        readingCode = record["readingCode"] as? String ?? ""
        totalQuestions = record["totalQuestions"] as? String ?? ""
        correctQuestions = record["correctQuestions"] as? String ?? ""
    }

    func saveChanges() {
        record["projectName"] = projectName
        record["readingCode"] = readingCode
        record["totalQuestions"] = totalQuestions
        record["correctQuestions"] = correctQuestions
    }
} 