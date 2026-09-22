//
//  RootTabView.swift
//  HelloWorld
//
//  📝 对应笔记：3.5 列表与导航（九、标签页 TabView）
//           3.4 状态管理（@StateObject 创建、@EnvironmentObject 注入）
//
//  要点记录：
//  - TabView 是大多数 App 的骨架（3.5）
//  - @StateObject：在这里"创建"全局设置（只创建一次，App 期间一直存活）
//  - .environmentObject：注入后，任意层级的子页面都能用 @EnvironmentObject 拿到（3.4）
//

import SwiftUI

struct RootTabView: View {
    /// 3.4：@StateObject —— 本视图"拥有"这个对象，负责创建与持有
    @StateObject private var settings = AppSettings()

    var body: some View {
        TabView {
            NoteListView()
                .tabItem {
                    Label("笔记", systemImage: "note.text")
                }

            ComponentGalleryView()
                .tabItem {
                    Label("组件", systemImage: "square.grid.2x2")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
        // 3.4：注入环境对象 → 三个 Tab 及其所有子页面共享同一份设置
        .environmentObject(settings)
    }
}

#Preview {
    RootTabView()
}
