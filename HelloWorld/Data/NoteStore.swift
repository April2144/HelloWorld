//
//  NoteStore.swift
//  HelloWorld
//
//  📝 对应笔记：2.5 枚举与协议（协议作为类型、面向协议编程）
//           2.6 错误处理与可选类型（throws / do-catch）
//           4.5 本地数据设计（用协议抽象存储方案）
//
//  要点记录：
//  - 上层界面只依赖 protocol，不依赖具体实现 → 换存储方案不用改界面（4.5 的设计原则）
//  - 用 throws 抛出错误，调用方用 do-catch 处理（2.6 错误处理）
//

import Foundation

/// 笔记存储统一接口。
/// 三种实现见：UserDefaultsNoteStore(4.1) / FileJSONNoteStore(4.2) / CoreDataNoteStore(4.3)
protocol NoteStore: AnyObject {
    /// 存储方案的名字，用于界面显示
    var displayName: String { get }

    func loadAll() throws -> [Note]
    func saveAll(_ notes: [Note]) throws
    func add(_ note: Note) throws
    func update(_ note: Note) throws
    func delete(id: UUID) throws
}

/// 存储层可能出的错（2.6 自定义错误）
enum NoteStoreError: LocalizedError {
    case encodeFailed(Error)
    case decodeFailed(Error)
    case writeFailed(Error)
    case notFound(UUID)

    var errorDescription: String? {
        switch self {
        case .encodeFailed(let e): return "编码失败：\(e.localizedDescription)"
        case .decodeFailed(let e): return "解码失败：\(e.localizedDescription)"
        case .writeFailed(let e):  return "写入失败：\(e.localizedDescription)"
        case .notFound(let id):    return "未找到笔记：\(id.uuidString)"
        }
    }
}
