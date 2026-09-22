//
//  FileJSONNoteStore.swift
//  HelloWorld
//
//  📝 对应笔记：4.2 文件读写（沙盒机制、获取目录路径、JSON 文件读写、封装文件管理类）
//           2.6 错误处理与可选类型（do-catch / try? / 可选绑定）
//
//  要点记录：
//  - iOS 沙盒：每个 App 只能访问自己的目录（4.2「一、iOS 沙盒机制」）
//  - 用 FileManager 拿 Documents 目录（4.2「二、获取目录路径」）
//  - JSON 读写 = JSONEncoder / JSONDecoder + Data 写入（4.2「七、JSON 文件读写」）
//

import Foundation

final class FileJSONNoteStore: NoteStore {
    var displayName: String { "JSON 文件（4.2）" }

    /// 4.2 封装：文件路径集中计算，不散落
    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("notes.json")
    }

    func loadAll() throws -> [Note] {
        // 4.2 首次启动时文件不存在 → 返回空数组（不是错误）
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        do {
            return try JSONDecoder().decode([Note].self, from: data)
        } catch {
            throw NoteStoreError.decodeFailed(error)
        }
    }

    func saveAll(_ notes: [Note]) throws {
        let data: Data
        do {
            // 输出格式化 JSON，方便在 Finder 里打开看（方便自己查看）
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            data = try encoder.encode(notes)
        } catch {
            throw NoteStoreError.encodeFailed(error)
        }
        do {
            // .atomic = 先写临时文件再替换，避免写一半崩溃导致数据损坏（4.2 性能与安全）
            try data.write(to: fileURL, options: .atomic)
        } catch {
            throw NoteStoreError.writeFailed(error)
        }
    }

    func add(_ note: Note) throws {
        var all = try loadAll()
        all.append(note)
        try saveAll(all)
    }

    func update(_ note: Note) throws {
        var all = try loadAll()
        guard let idx = all.firstIndex(where: { $0.id == note.id }) else {
            throw NoteStoreError.notFound(note.id)
        }
        all[idx] = note
        try saveAll(all)
    }

    func delete(id: UUID) throws {
        var all = try loadAll()
        all.removeAll { $0.id == id }
        try saveAll(all)
    }
}
