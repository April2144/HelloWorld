//
//  FormControlsView.swift
//  HelloWorld
//
//  📚 对应章节：3.6 表单与输入（全控件 + 表单验证 + 综合示例）
//
//  教学要点：
//  - 3.6 从头到尾的所有输入控件，一页看全：
//    TextField / SecureField / Toggle / Picker / Stepper / Slider / DatePicker
//  - 3.6「九、表单验证」：边输边校验，不合法就禁用提交并给出原因
//  - 3.4 @State：这些输入值都是本页的临时状态
//

import SwiftUI

struct FormControlsView: View {
    // MARK: - 3.6 各控件的绑定值
    @State private var nickname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var receivePush = true
    @State private var theme: Theme = .system
    @State private var fontSize = 16.0
    @State private var maxCache = 3
    @State private var reminderDate = Date()

    // 提交结果的展示（3.6 提交后的反馈）
    @State private var submittedSummary: String?

    var body: some View {
        Form {
            // MARK: 文本输入
            Section {
                TextField("昵称", text: $nickname)
                    // 3.3：给输入框加图标（prefix 内容）
                TextField("邮箱", text: $email)
                    .keyboardType(.emailAddress)          // 键盘类型
                    .textInputAutocapitalization(.never)  // 关闭首字母大写
                    .autocorrectionDisabled()             // 关闭自动更正
                SecureField("密码（至少 6 位）", text: $password)
            } header: {
                Text("3.6 二、三 · 文本输入")
            } footer: {
                Text("TextField 明文、SecureField 密文；键盘类型与自动更正建议按字段设置。")
            }

            // MARK: 开关与选择
            Section {
                Toggle("接收推送通知", isOn: $receivePush)

                Picker("主题", selection: $theme) {
                    ForEach(Theme.allCases) { t in
                        Text(t.label).tag(t)
                    }
                }
                .pickerStyle(.segmented)   // 3.6：分段样式

                Picker("缓存上限", selection: $maxCache) {
                    ForEach([1, 3, 5, 10], id: \.self) { n in
                        Text("\(n) 天").tag(n)
                    }
                }
                .pickerStyle(.menu)        // 3.6：菜单样式
            } header: {
                Text("3.6 四、五 · Toggle 与 Picker")
            }

            // MARK: 数值与日期
            Section {
                VStack(alignment: .leading) {
                    Text("字号：\(Int(fontSize))")
                    Slider(value: $fontSize, in: 12...24, step: 1)
                }
                Stepper("提醒提前天数：\(maxCache) 天", value: $maxCache, in: 1...10)
                DatePicker("提醒时间", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
            } header: {
                Text("3.6 六、七、八 · Stepper / Slider / DatePicker")
            }

            // MARK: 3.6 九、表单验证
            Section {
                if let problem = validationProblem {
                    Label(problem, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                } else {
                    Label("填写合法，可以提交", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }

                Button("提交") { submit() }
                    .disabled(validationProblem != nil)

                if let submittedSummary {
                    Text(submittedSummary)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("3.6 九 · 表单验证")
            } footer: {
                Text("校验规则：昵称非空、邮箱含 @、密码 ≥ 6 位。不满足就禁用提交按钮并说明原因。")
            }
        }
        .navigationTitle("表单控件（3.6）")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 校验（3.6 九）

    /// 返回第一条不通过的原因；全部通过返回 nil（2.6 可选类型：nil 表示"没问题"）
    private var validationProblem: String? {
        if nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "昵称不能为空"
        }
        if !email.contains("@") {
            return "邮箱格式不正确（需要包含 @）"
        }
        if password.count < 6 {
            return "密码至少 6 位（当前 \(password.count) 位）"
        }
        return nil
    }

    private func submit() {
        // 3.6：提交后给反馈，别让用户猜有没有成功
        submittedSummary = """
        已提交：\(nickname) / \(email)
        主题：\(theme.label) ｜ 字号：\(Int(fontSize)) ｜ 推送：\(receivePush ? "开" : "关")
        提醒：\(reminderDate.formatted(date: .abbreviated, time: .shortened))
        """
    }
}

// MARK: - 3.6 Picker 用的选项（2.5 枚举 + CaseIterable + Identifiable）

private enum Theme: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { rawValue }

    var label: String {
        switch self {
        case .light:  return "浅色"
        case .dark:   return "深色"
        case .system: return "跟随系统"
        }
    }
}

#Preview {
    NavigationStack {
        FormControlsView()
    }
}
