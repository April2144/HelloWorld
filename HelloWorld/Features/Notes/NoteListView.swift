//
//  NoteListView.swift
//  HelloWorld
//
//  📚 对应章节：3.5 列表与导航（List / ForEach / NavigationStack / NavigationPath / 导航传值）
//           2.6 错误处理与可选类型（do-catch / 可选绑定 guard let）
//           4.5 本地数据设计（上层只依赖协议）
//
//  教学要点：
//  - List + ForEach：展示集合数据（3.5 一、二）
//  - NavigationStack(path:)：用 NavigationPath 管理多级跳转（3.5 四、八）
//  - NavigationLink(value:) + .navigationDestination(for:)：类型安全的传值（3.5 五）
//  - 所有存储操作都包在 do-catch 里（2.6）
//

import SwiftUI

/// 3.5「八、NavigationPath 多级跳转」：二级页面的路由
enum NotesRoute: Hashable {
    case storeInfo
}

struct NoteListView: View {
    /// 3.4：从 RootTabView 注入进来的共享设置
    @EnvironmentObject private var settings: AppSettings

    @State private var notes: [Note] = []
    @State private var path = NavigationPath()
    @State private var errorMessage: String?
    @State private var showingEditor = false
    @State private var editingNote: Note?

    /// 4.5：界面只认识 protocol，不关心底层是 UserDefaults 还是 Core Data
    private var store: any NoteStore { settings.makeStore() }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                if notes.isEmpty {
                    // 空状态：首次启动给一份示例数据，方便立刻看到效果
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "note.text").font(.largeTitle)
                            Text("还没有笔记").font(.headline)
                            Button("载入示例数据") { loadSamples() }
                                .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    }
                }

                Section("笔记（\(notes.count) 条）") {
                    // 3.5「二、ForEach」
                    ForEach(notes) { note in
                        // 3.5「五、导航传值」：直接把 note 作为 value 传下去
                        NavigationLink(value: note) {
                            NoteRow(note: note)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.map { notes[$0] }.forEach { delete($0) }
                    }
                }

                Section {
                    Button {
                        path.append(NotesRoute.storeInfo)
                    } label: {
                        Label("当前存储方案：\(settings.storeKind.label)", systemImage: "internaldrive")
                    }
                } footer: {
                    Text(settings.storeKind.hint)
                }
            }
            .navigationTitle("笔记")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { editingNote = nil; showingEditor = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // 3.5：按类型分发目标页面
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(note: note, onEdit: { editingNote = note; showingEditor = true })
            }
            .navigationDestination(for: NotesRoute.self) { _ in
                StoreInfoView()
            }
            .sheet(isPresented: $showingEditor) {
                NoteEditView(note: editingNote) { saved in
                    upsert(saved)
                }
            }
            .alert("出错了", isPresented: .constant(errorMessage != nil)) {
                Button("知道了") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
            .task { reload() }
            // 切换存储方案后自动重新加载
            .onChange(of: settings.storeKind) { reload() }
        }
    }

    // MARK: - 数据操作（2.6 do-catch）

    private func reload() {
        do {
            notes = try store.loadAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadSamples() {
        do {
            try store.saveAll(Note.samples)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func upsert(_ note: Note) {
        do {
            if notes.contains(where: { $0.id == note.id }) {
                try store.update(note)
            } else {
                try store.add(note)
            }
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete(_ note: Note) {
        do {
            try store.delete(id: note.id)
            reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

/// 3.5「三、列表行交互」+ 3.2 布局（HStack/VStack/Spacer）
private struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title.isEmpty ? "（无标题）" : note.title)
                .font(.headline)
                .lineLimit(1)
            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 2)
    }
}

/// 3.5「八、NavigationPath 多级跳转」的二级页面
private struct StoreInfoView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        List {
            Section("当前方案") {
                Text(settings.storeKind.label)
                Text(settings.storeKind.hint).font(.footnote)
            }
            Section("4.5 选型建议") {
                Text("小数据用 UserDefaults、整份文档用文件、需要查询排序用 Core Data。")
                Text("关键是：上层只依赖 NoteStore 协议，换实现不改界面。")
            }
        }
        .navigationTitle("存储方案")
    }
}

#Preview {
    NoteListView()
        .environmentObject(AppSettings())
}
