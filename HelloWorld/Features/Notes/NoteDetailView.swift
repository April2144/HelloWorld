//
//  NoteDetailView.swift
//  HelloWorld
//
//  📚 对应章节：3.5 列表与导航（导航传值、导航标题与工具栏、导航返回）
//           3.2 UI 布局（VStack / padding / frame）
//
//  教学要点：
//  - 上一级用 NavigationLink(value: note) 传进来，这里直接拿到模型（3.5 五）
//  - .navigationTitle / .toolbar：导航栏标题与按钮（3.5 六）
//  - 由父视图控制编辑（sheet），自己不持有数据 → 单向数据流（3.4 八）
//

import SwiftUI

struct NoteDetailView: View {
    let note: Note
    let onEdit: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(note.title.isEmpty ? "（无标题）" : note.title)
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack(spacing: 8) {
                    Image(systemName: "clock").foregroundStyle(.secondary)
                    Text(note.updatedAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Divider()

                Text(note.content.isEmpty ? "（空内容）" : note.content)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("编辑") { onEdit() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: Note.samples[0], onEdit: {})
    }
}
