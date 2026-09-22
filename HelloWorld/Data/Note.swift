//
//  Note.swift
//  HelloWorld
//
//  📝 对应笔记：2.4 面向对象：类与结构体（struct 值类型）
//           2.5 枚举与协议（Codable 协议、面向协议编程）
//
//  要点记录：
//  - 用 struct 而不是 class：笔记是"值"，拷贝时互不影响（2.4 值类型 vs 引用类型）
//  - Identifiable：让 SwiftUI 的 List / ForEach 能识别每一行（3.5）
//  - Codable：既能存 UserDefaults（4.1）也能存 JSON 文件（4.2）
//

import Foundation

/// 一条笔记（这个 App 的核心数据模型）
struct Note: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var content: String
    var updatedAt: Date

    init(id: UUID = UUID(), title: String, content: String, updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.updatedAt = updatedAt
    }
}

extension Note {
    /// 首次启动时用的示例数据
    static let samples: [Note] = [
        Note(title: "欢迎来到 HeAn Notes",
             content: "这是我学 iOS 时顺手记的笔记 App。\n\n每个文件顶部都标注了它对应的章节。"),
        Note(title: "3.4 状态管理在哪看？",
             content: "打开「设置」页：那里同时用到了 @State / @Binding / @StateObject / @EnvironmentObject。"),
        Note(title: "4.x 数据持久化在哪看？",
             content: "设置页可以切换存储方案：UserDefaults(4.1) / JSON 文件(4.2) / Core Data(4.3)。"),
    ]
}
