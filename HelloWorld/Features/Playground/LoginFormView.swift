//
//  LoginFormView.swift
//  HelloWorld
//
//  📝 对应笔记：3.4 状态管理（八、状态提升与单向数据流 ｜ 九、综合示例：登录表单）
//           3.6 表单与输入（TextField / SecureField / 表单验证）
//
//  这一页记的是「状态提升（State Hoisting）」这个最容易绕晕的概念：
//
//   ❌ 常见误区：每个输入框自己 @State 存值 → 父视图拿不到、也没法统一校验
//   ✅ 正确做法：值放在"共同父视图"，子组件只拿 @Binding（单向数据流）
//
//      LoginFormView（持有真数据）
//          │  $email ─────────►  LoginField（只负责显示和改）
//          │  $password ──────►  LoginField
//          │  ◄─── 通过 Binding 把改动写回来 ───┘
//
//  数据只有一个"真源"（Source of Truth），永远不会出现两边不一致。
//

import SwiftUI

struct LoginFormView: View {
    // MARK: - 真数据放在父视图（状态提升）
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var errorMessage: String?
    @State private var loggedInName: String?

    var body: some View {
        Form {
            Section {
                // 子组件只拿到 $ 绑定，自己不持有数据
                LoginField(title: "邮箱", text: $email, isSecure: false)
                LoginField(title: "密码", text: $password, isSecure: true)
                Toggle("记住我", isOn: $rememberMe)
            } header: {
                Text("3.4 · 输入（子组件用 @Binding）")
            } footer: {
                Text("这两个输入框自己不存数据 —— 它们通过 @Binding 读写父视图的 email / password。父视图是唯一的数据源。")
            }

            Section {
                if let problem = validationProblem {
                    Label(problem, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                } else {
                    Label("可以登录", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }

                Button("登录") { login() }
                    .disabled(validationProblem != nil)

                if let loggedInName {
                    // 注意：字符串插值必须用【半角 )】闭合；中文括号（）只是显示用的文字
                    Text("✅ 已登录：\(loggedInName)（记住我：\(rememberMe ? "开" : "关")）")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("3.6 · 校验与提交")
            }

            Section("为什么这么做（3.4 八）") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• 单向数据流：数据从父 → 子，改动通过 Binding 回到父，方向始终单一")
                    Text("• 单一真源：email / password 只存在一处，不会出现两个值打架")
                    Text("• 好测好改：校验逻辑集中在父视图，不用问「哪个输入框现在是什么值」")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("登录表单（3.4）")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 校验

    private var validationProblem: String? {
        if !email.contains("@") { return "邮箱格式不正确" }
        if password.count < 6 { return "密码至少 6 位（当前 \(password.count) 位）" }
        return nil
    }

    private func login() {
        // 真实项目这里会调接口；这里直接把邮箱前缀当作用户名
        loggedInName = email.components(separatedBy: "@").first ?? email
    }
}

// MARK: - 子组件：只负责显示与改动，不持有数据（3.4 @Binding）

private struct LoginField: View {
    let title: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        if isSecure {
            SecureField(title, text: $text)
        } else {
            TextField(title, text: $text)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    NavigationStack {
        LoginFormView()
    }
}
