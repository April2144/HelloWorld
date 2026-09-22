//
//  CoreDataNoteStore.swift
//  HelloWorld
//
//  📚 对应章节：4.3 Core Data 入门（核心概念、PersistentContainer、增删改查）
//
//  教学要点：
//  - 标准做法是在 Xcode 里建 .xcdatamodeld 模型文件；
//    本 demo 为了"零新增资源文件、clone 即可编译"，改用**代码构造 NSManagedObjectModel**。
//    ⚠️ 你在真实项目里请用 Xcode 的 Data Model 编辑器（4.3「三、创建数据模型」）。
//  - 增删改查四件套：insert / fetch / 改属性后 save / delete 后 save（4.3 五~八）
//

import CoreData
import Foundation

final class CoreDataNoteStore: NoteStore {
    var displayName: String { "Core Data（4.3）" }

    private let container: NSPersistentContainer

    init() {
        // 4.3「四、初始化 PersistentContainer」：用代码构造的 model 初始化
        container = NSPersistentContainer(name: "HeAnNotes",
                                          managedObjectModel: Self.makeModel())
        container.loadPersistentStores { _, error in
            if let error {
                // 教学演示：真实项目应做降级或提示，而不是默默 print
                print("⚠️ Core Data 加载失败：\(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - 代码构造数据模型（替代 .xcdatamodeld）

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "NoteEntity"
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)

        func attribute(_ name: String, _ type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        entity.properties = [
            attribute("id", .UUIDAttributeType),
            attribute("title", .stringAttributeType),
            attribute("body", .stringAttributeType),
            attribute("updatedAt", .dateAttributeType),
        ]

        model.entities = [entity]
        return model
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
        // 演示用：全量覆盖 —— 先删再插
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
