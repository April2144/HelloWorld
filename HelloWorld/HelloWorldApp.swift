//
//  HelloWorldApp.swift
//  HelloWorld
//
//  Created by lmz on 2026/9/22.
//

import SwiftUI

@main
struct HelloWorldApp: App {
    var body: some Scene {
        WindowGroup {
            // 1.4 的 Hello World 保留在 ContentView.swift（那是你的第一个界面，别删）；
            // 从这里开始进入笔记 App 主体：TabView + 笔记 + 组件速查 + 设置。
            RootTabView()
        }
    }
}
