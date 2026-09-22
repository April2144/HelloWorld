//
//  ComponentGalleryView.swift
//  HelloWorld
//
//  📚 对应章节：3.2 UI 布局（VStack / HStack / ZStack / Spacer / padding / frame / 布局优先级）
//           3.3 常用组件（Text / Image / Button / 颜色系统 / 字体与排版 / 组件组合）
//
//  用法：把这个页面当成「UI 手册」—— 看到某个效果想不起来怎么写，来这里对照。
//

import SwiftUI

struct ComponentGalleryView: View {
    var body: some View {
        NavigationStack {
            List {
                // MARK: - 其它章节的演示入口
                Section {
                    NavigationLink {
                        FormControlsView()
                    } label: {
                        Label("表单控件（3.6）", systemImage: "textformat")
                    }
                    NavigationLink {
                        OptionalErrorPlaygroundView()
                    } label: {
                        Label("可选类型与错误处理（2.6）", systemImage: "questionmark.circle")
                    }
                    NavigationLink {
                        LoginDemoView()
                    } label: {
                        Label("登录表单：状态提升（3.4）", systemImage: "person.badge.key")
                    }
                } header: {
                    Text("更多章节演示")
                } footer: {
                    Text("本页放不下的知识点单独成页，点进去看。")
                }

                // MARK: - 3.2 布局
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("VStack：纵向排列").font(.headline)
                        Text("第一行").foregroundStyle(.secondary)
                        Text("第二行").foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("HStack：")
                        Text("横向").foregroundStyle(.blue)
                        Text("排列").foregroundStyle(.orange)
                    }

                    ZStack(alignment: .bottomTrailing) {
                        Rectangle()
                            .fill(.blue.gradient)
                            .frame(height: 90)
                        Text("ZStack：叠在上面")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(.black.opacity(0.35), in: .capsule)
                            .padding(8)
                    }

                    HStack {
                        Text("Spacer 把我推到左")
                        Spacer()
                        Text("我在右")
                    }
                    .font(.footnote)

                    Text("padding + frame(maxWidth)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.tint.opacity(0.12), in: .rect(cornerRadius: 10))
                } header: {
                    Text("3.2 布局")
                }

                // MARK: - 3.3 组件
                Section {
                    Text("Text：大标题").font(.largeTitle)
                    Text("Text：正文，foregroundStyle 改颜色").foregroundStyle(.secondary)
                    Text("Text：字重与斜体").fontWeight(.semibold).italic()

                    Label("Image + Text（SF Symbols）", systemImage: "swift")

                    Button("主按钮（borderedProminent）") {}
                        .buttonStyle(.borderedProminent)
                    Button("次按钮（bordered）") {}
                        .buttonStyle(.bordered)
                } header: {
                    Text("3.3 常用组件")
                }

                // MARK: - 3.3 组件组合
                Section {
                    TagRow()             // 标签
                    IconTextRow()        // 图标 + 文字
                    AvatarInfoRow()      // 带头像的信息行
                    PrimarySecondaryRow() // 主按钮与次按钮
                } header: {
                    Text("3.3 组件组合")
                } footer: {
                    Text("真实界面就是这几种组合的堆叠 —— 单看组件没感觉，组合起来才是页面。")
                }
            }
            .navigationTitle("组件手册")
        }
    }
}

// MARK: - 3.3「六、常见组件组合」

/// 标签
private struct TagRow: View {
    var body: some View {
        HStack(spacing: 8) {
            Text("SwiftUI").tagStyle(color: .orange)
            Text("iOS 27").tagStyle(color: .blue)
            Text("离线优先").tagStyle(color: .green)
        }
    }
}

/// 图标 + 文字
private struct IconTextRow: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "folder.fill").foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text("图标 + 两行文字").font(.subheadline)
                Text("副标题用 secondary 颜色").font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

/// 带头像的信息行
private struct AvatarInfoRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.purple.gradient)
                .frame(width: 40, height: 40)
                .overlay { Text("禾").foregroundStyle(.white) }
            VStack(alignment: .leading, spacing: 2) {
                Text("禾安").font(.headline)
                Text("独立开发者 · iOS 10 年").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
    }
}

/// 主按钮与次按钮
private struct PrimarySecondaryRow: View {
    var body: some View {
        HStack {
            Button("取消") {}.buttonStyle(.bordered)
            Spacer()
            Button("保存") {}.buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - 小工具

private extension Text {
    func tagStyle(color: Color) -> some View {
        self
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15), in: .capsule)
            .foregroundStyle(color)
    }
}

#Preview {
    ComponentGalleryView()
}
