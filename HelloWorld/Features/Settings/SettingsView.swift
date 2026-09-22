//
//  SettingsView.swift
//  HelloWorld
//
//  ⭐️ 这是这个文件最值得对照笔记 3.4「状态管理」看的一个页面 ⭐️
//
//  📝 对应笔记：3.4 状态管理（@State / @Binding / @StateObject / @EnvironmentObject / @Published）
//           3.6 表单与输入（Toggle / Slider / Stepper / Picker）
//           4.1 UserDefaults（@AppStorage 属性包装器封装）
//
//  一张表看懂 3.4 的五个属性包装器：
//  ┌─────────────────────┬──────────────────────┬─────────────────────┐
//  │ 包装器              │ 谁创建数据           │ 用在哪               │
//  ├─────────────────────┼──────────────────────┼─────────────────────┤
//  │ @State              │ 本视图自己           │ 临时 UI 状态         │
//  │ @Binding            │ 别人（父视图）       │ 子组件改父级数据     │
//  │ @StateObject        │ 本视图（创建并持有） │ 见 RootTabView       │
//  │ @EnvironmentObject  │ 祖先注入             │ 跨页面共享（本页）   │
//  │ @AppStorage         │ UserDefaults         │ 见最下面一行         │
//  └─────────────────────┴──────────────────────┴─────────────────────┘
//

import SwiftUI

struct SettingsView: View {
    /// 3.4：由 RootTabView 通过 .environmentObject 注入 —— 跨页面共享的同一份对象
    @EnvironmentObject private var settings: AppSettings

    /// 3.4：@State —— 只属于本页的临时状态
    @State private var showingResetConfirm = false

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - 3.4 @EnvironmentObject + 双向绑定
                Section {
                    TextField("昵称", text: $settings.displayName)
                    Text("改一下上面的昵称，然后切到别的 Tab 再回来 —— 值还在（因为共享的是同一个对象）。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("个人资料（@EnvironmentObject）")
                }

                // MARK: - 3.4 @Binding（子组件改父级数据）
                Section {
                    ToggleRow(title: "高对比度", isOn: $settings.prefersHighContrast)
                    FontSizeRow(value: $settings.fontSize)
                    Text("这两个子组件自己不持有数据，只通过 @Binding 读写父级的 settings。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("阅读偏好（@Binding）")
                }

                // MARK: - 4.x 存储方案切换（3.6 Picker）
                Section {
                    Picker("存储方案", selection: $settings.storeKind) {
                        ForEach(StoreKind.allCases) { kind in
                            Text(kind.label).tag(kind)
                        }
                    }
                    Text(settings.storeKind.hint)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("切换后回到「笔记」Tab，列表会自动重新加载 —— 同一份界面，三种存储实现（4.5 面向协议）。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("存储方案（4.1 / 4.2 / 4.3）")
                }

                // MARK: - 4.1 @AppStorage
                Section {
                    AppStorageRow()
                    Text("@AppStorage 是 UserDefaults 的属性包装器封装（4.1 八），适合单个开关/计数这种小数据。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("UserDefaults（4.1）")
                }

                Section {
                    Button("恢复默认设置", role: .destructive) {
                        showingResetConfirm = true
                    }
                }
            }
            .navigationTitle("设置")
            .confirmationDialog("确定恢复默认设置？", isPresented: $showingResetConfirm, titleVisibility: .visible) {
                Button("恢复", role: .destructive) {
                    settings.displayName = "禾安"
                    settings.fontSize = 16
                    settings.prefersHighContrast = false
                    settings.storeKind = .fileJSON
                }
                Button("取消", role: .cancel) {}
            }
        }
    }
}

// MARK: - 3.4 @Binding 组件

/// 自己不持有数据，通过 @Binding 读写父级的值
private struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
    }
}

/// 3.6：Slider + Stepper 绑定同一个值
private struct FontSizeRow: View {
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("字号：\(Int(value))")
            Slider(value: $value, in: 12...24, step: 1)
            Stepper("微调", value: $value, in: 12...24, step: 1)
        }
    }
}

// MARK: - 4.1 @AppStorage组件

private struct AppStorageRow: View {
    /// 4.1「八、属性包装器封装」：@AppStorage 直接把 UserDefaults 变成可读写的状态
    @AppStorage("hean.settings.tapCount") private var tapCount = 0

    var body: some View {
        HStack {
            Text("点击次数：\(tapCount)")
            Spacer()
            Button("+1") { tapCount += 1 }
                .buttonStyle(.bordered)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings())
}
