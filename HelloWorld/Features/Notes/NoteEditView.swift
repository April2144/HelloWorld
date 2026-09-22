//
//  NoteEditView.swift
//  HelloWorld
//
//  📚 对应章节：3.6 表单与输入（Form / TextField / 表单验证）
//           3.4 状态管理（@State 本地状态、@Environment 读取 dismiss）
//           2.6 可选类型（note 为 nil 表示新建）
//
//  教学要点：
//  - Form 是 iOS 设置类界面的标准容器（3.6 一）
//  - TextField 双向绑定用 $（3.6 二）
//  - 表单验证：非法时禁用保存按钮 + 给出提示（3.6 九）
//  - @Environment(\.dismiss)：关闭当前 sheet（3.4 六）
//

import SwiftUI

struct NoteEditView: View {
    /// nil = 新建笔记；有值 = 编辑（2.6 可选类型）
    let note: Note?
    let onSave: (Note) -> Void

    @Environment(\.dismiss) private var dismiss

    // 3.4 @State：只在当前视图内部使用的临时状态
    @State private var titleText = ""
    @State private var contentText = ""
    @State private var markAsPinned = false

    /// 3.6「九、表单验证」
    private var isValid: Bool {
        !titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("标题（必填）", text: $titleText)
                    Toggle("标记为常用", isOn: $markAsPinned)
                }

                Section("内容") {
                    TextEditor(text: $contentText)
                        .frame(minHeight: 160)
                }

                if !isValid {
                    Section {
                        Label("标题不能为空", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .navigationTitle(note == nil ? "新建笔记" : "编辑笔记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .disabled(!isValid)
                }
            }
            .onAppear {
                // 2.6 可选绑定：有值才填充
                if let note {
                    titleText = note.title
                    contentText = note.content
                }
            }
        }
    }

    private func save() {
        let saved = Note(
            id: note?.id ?? UUID(),          // 2.6 nil 合并运算符 ??
            title: titleText.trimmingCharacters(in: .whitespacesAndNewlines),
            content: contentText,
            updatedAt: Date()
        )
        onSave(saved)
        dismiss()
    }
}

#Preview {
    NoteEditView(note: nil, onSave: { _ in })
}
