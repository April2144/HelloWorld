//
//  CoreDataNoteStore.swift
//  HelloWorld
//
//  📝 对应笔记：4.3 Core Data 入门（核心概念、PersistentContainer、增删改查）
//
//  要点记录：
//  - 数据模型在同目录的 **HeAnNotes.xcdatamodeld** —— Xcode 里点开就是模型编辑器
//    （4.3「三、创建数据模型」，实体、属性、关系都在那里定义）
//  - 初始化 PersistentContainer 时，name 对得上就会自动去 Bundle 里找同名模型：
//    "HeAnNotes" → HeAnNotes.xcdatamodeld → 包内的 HeAnNotes.momd（4.3 四）
//  - 增删改查四件套：insert / fetch / 改属性后 save / delete 后 save（4.3 五~八）
//

import CoreData
import Foundation

final class CoreDataNoteStore: NoteStore {
    var displayName: String { "Core Data（4.3）" }

    private let container: NSPersistentContainer

    init() {
        // 4.3「四、初始化 PersistentContainer」：
        // 只给 name，Core Data 会自动在 Bundle 里找 HeAnNotes.momd（由 .xcdatamodeld 编译而来）
        container = NSPersistentContainer(name: "HeAnNotes")
        container.loadPersistentStores { _, error in
            if let error {
                // 这里先简单 print，真实项目应做降级或提示
                print("⚠️ Core Data 加载失败：\(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - NoteStore

    func loadAll() throws -> [Note] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        // 4.3「九、排序与分页」：按更新时间倒序
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        let rows = try container.viewContext.fetch(request)
        return rows.compactMap { obj -> Note? in
            guard let id = obj.value(forKey: "id") as? UUID else { return nil }
            return Note(
                id: id,
                title: (obj.value(forKey: "title") as? String) ?? "",
                content: (obj.value(forKey: "body") as? String) ?? "",
                updatedAt: (obj.value(forKey: "updatedAt") as? Date) ?? Date()
            )
        }
    }

    func saveAll(_ notes: [Note]) throws {
        // 这里用全量覆盖 —— 先删再插
        let context = container.viewContext
        let existing = try context.fetch(NSFetchRequest<NSManagedObject>(entityName: "NoteEntity"))
        existing.forEach { context.delete($0) }
        notes.forEach { note in
            let obj = NSEntityDescription.insertNewObject(forEntityName: "NoteEntity", into: context)
            obj.setValue(note.id, forKey: "id")
            obj.setValue(note.title, forKey: "title")
            obj.setValue(note.content, forKey: "body")
            obj.setValue(note.updatedAt, forKey: "updatedAt")
        }
        try context.save()
    }

    func add(_ note: Note) throws {
        let context = container.viewContext
        let obj = NSEntityDescription.insertNewObject(forEntityName: "NoteEntity", into: context)
        obj.setValue(note.id, forKey: "id")
        obj.setValue(note.title, forKey: "title")
        obj.setValue(note.content, forKey: "body")
        obj.setValue(note.updatedAt, forKey: "updatedAt")
        try context.save()
    }

    func update(_ note: Note) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        request.fetchLimit = 1
        let rows = try container.viewContext.fetch(request)
        guard let obj = rows.first else { throw NoteStoreError.notFound(note.id) }
        obj.setValue(note.title, forKey: "title")
        obj.setValue(note.content, forKey: "body")
        obj.setValue(note.updatedAt, forKey: "updatedAt")
        try container.viewContext.save()
    }

    func delete(id: UUID) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        let rows = try container.viewContext.fetch(request)
        guard let obj = rows.first else { throw NoteStoreError.notFound(id) }
        container.viewContext.delete(obj)
        try container.viewContext.save()
    }
}
