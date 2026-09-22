//
//  AppSettings.swift
//  HelloWorld
//
//  📝 对应笔记：3.4 状态管理（@Published / @StateObject / @EnvironmentObject）
//           4.1 UserDefaults 轻量存储（与 SwiftUI 结合、封装属性包装器）
//
//  要点记录（对应笔记 3.4，这个文件最值得看）：
//  1. @Published：属性一变，用到它的视图自动刷新
//  2. 由 RootTabView 用 @StateObject 创建（生命周期跟 App 一致，只创建一次）
//  3. 子页面用 @EnvironmentObject 读取（跨页面共享，不用一层层传参）
//  4. 值改动后写进 UserDefaults（4.1），下次启动还是上次的设置
//

import Combine   // @Published 来自 Combine（新版编译器要求显式导入，别漏）
import SwiftUI

/// 存储方案（对应 4.1 / 4.2 / 4.3，可在设置页切换对比）
enum StoreKind: String, CaseIterable, Identifiable {
    case userDefaults
    case fileJSON
    case coreData

    var id: String { rawValue }

    var label: String {
        switch self {
        case .userDefaults: return "UserDefaults（4.1）"
        case .fileJSON:     return "JSON 文件（4.2）"
        case .coreData:     return "Core Data（4.3）"
        }
    }

    /// 4.5 选型提示：记一下什么时候该用哪个
    var hint: String {
        switch self {
        case .userDefaults: return "适合：设置项、开关、少量轻量数据"
        case .fileJSON:     return "适合：整份文档、导出/备份、结构化数据"
        case .coreData:     return "适合：大量数据、需要查询/排序/关系"
        }
    }
}

@MainActor
final class AppSettings: ObservableObject {
    // MARK: - 4.1 UserDefaults 的 key 集中管理
    private enum Keys {
        static let displayName = "hean.settings.displayName"
        static let fontSize = "hean.settings.fontSize"
        static let prefersHighContrast = "hean.settings.prefersHighContrast"
        static let storeKind = "hean.settings.storeKind"
    }

    // MARK: - 3.4 @Published：值变化 → 视图自动刷新

    @Published var displayName: String {
        didSet { UserDefaults.standard.set(displayName, forKey: Keys.displayName) }
    }

    @Published var fontSize: Double {
        didSet { UserDefaults.standard.set(fontSize, forKey: Keys.fontSize) }
    }

    @Published var prefersHighContrast: Bool {
        didSet { UserDefaults.standard.set(prefersHighContrast, forKey: Keys.prefersHighContrast) }
    }

    @Published var storeKind: StoreKind {
        didSet { UserDefaults.standard.set(storeKind.rawValue, forKey: Keys.storeKind) }
    }

    init() {
        let d = UserDefaults.standard
        // 4.1「四、默认值处理」：没存过就用默认值（register(defaults:) 也行）
        self.displayName = d.string(forKey: Keys.displayName) ?? "禾安"
        self.fontSize = d.object(forKey: Keys.fontSize) as? Double ?? 16
        self.prefersHighContrast = d.bool(forKey: Keys.prefersHighContrast)
        self.storeKind = StoreKind(rawValue: d.string(forKey: Keys.storeKind) ?? "") ?? .fileJSON
    }

    /// 当前选中的存储实现（4.5 面向协议：上层只拿 protocol，不关心具体实现）
    func makeStore() -> any NoteStore {
        switch storeKind {
        case .userDefaults: return UserDefaultsNoteStore()
        case .fileJSON:     return FileJSONNoteStore()
        case .coreData:     return CoreDataNoteStore()
        }
    }
}
