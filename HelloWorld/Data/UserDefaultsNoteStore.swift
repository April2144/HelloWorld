//
//  UserDefaultsNoteStore.swift
//  HelloWorld
//
//  📝 对应笔记：4.1 UserDefaults 轻量存储（存储自定义对象、封装管理类）
//
//  要点记录：
//  - UserDefaults 只适合"少量、轻量"的数据（设置项、开关），不适合大量笔记
//  - 存自定义对象要先 Codable → JSON Data（4.1「六、存储自定义对象」）
//  - 把 key 集中管理，别散落在各处（4.1「七、封装 UserDefaults 管理类」）
//

import Foundation

final class UserDefaultsNoteStore: NoteStore {
    var displayName: String { "UserDefaults（4.1）" }

    /// 4.1 封装：把所有 key 收拢到一个枚举里，避免字符串写错
    private enum Keys {
        static let notes = "hean.notes.userdefaults"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadAll() throws -> [Note] {
        guard let data = defaults.data(forKey: Keys.notes) else { return [] }
        do {
            return try JSONDecoder().decode([Note].self, from: data)
        } catch {
            throw NoteStoreError.decodeFailed(error)
        }
    }

    func saveAll(_ notes: [Note]) throws {
        let data: Data
        do {
            data = try JSONEncoder().encode(notes)
        } catch {
            throw NoteStoreError.encodeFailed(error)
        }
        defaults.set(data, forKey: Keys.notes)
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
