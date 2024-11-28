import SwiftUI

struct SettingsView: View {
    @State private var themeColor: Color = .blue
    @State private var showAlert = false

    var body: some View {
        Form {
            Section(header: Text("主题设置")) {
                ColorPicker("选择主题颜色", selection: $themeColor)
            }

            Section {
                Button("清空所有数据") {
                    showAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("设置")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("清空数据"),
                message: Text("确定要清空所有历史记录吗？此操作无法撤销。"),
                primaryButton: .destructive(Text("清空")) {
                    clearAllData()
                },
                secondaryButton: .cancel()
            )
        }
    }

    func clearAllData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "history")
    }
} 