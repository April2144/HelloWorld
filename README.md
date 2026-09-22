# HelloWorld

一个**离线笔记 App**。是iOS开发专题的演示APP，可运行查看对应效果。

> 不是教程，也不以教学为目的 —— 只是自己的**笔记分享**。
> 每个 Swift 文件顶部都写了 `📝 对应笔记：x.x …`，指的是我写《iOS 开发：从 0 到上架》那组笔记时的对应篇目，方便回查。

## 里面有什么

| Tab | 记了什么 |
|---|---|
| **笔记** | 列表 → 详情 → 编辑，增删改查与导航 |
| **组件** | 一些 SwiftUI 布局与组件的写法速查，另有几个笔记页的入口 |
| **设置** | 状态管理相关的几种写法，以及三种本地存储方案的切换 |

> 首次打开「笔记」是空的，点 **「载入示例数据」** 可以看到效果。

## 目录

```
HelloWorld/
├─ HelloWorldApp.swift          入口
├─ ContentView.swift            第一个 Hello World 界面（留着做个念想）
├─ App/
│  ├─ RootTabView.swift         TabView + 环境对象的注入
│  └─ AppSettings.swift         全局设置（UserDefaults 持久化）+ 存储方案切换
├─ Data/
│  ├─ Note.swift                笔记模型
│  ├─ NoteStore.swift           存储协议与错误定义
│  ├─ UserDefaultsNoteStore.swift
│  ├─ FileJSONNoteStore.swift
│  └─ CoreDataNoteStore.swift
└─ Features/
   ├─ Notes/                    笔记列表 · 详情 · 编辑
   ├─ Settings/                 设置页（状态管理几种写法都在这里）
   ├─ Gallery/                  组件速查 · 表单控件
   └─ Playground/               可选类型与错误处理 · 登录表单
```

## 笔记索引

按我当时写笔记的顺序，对应到这里的目录：

| 笔记 | 文件 | 当时记的重点 |
|---|---|---|
| 1.4 第一个项目 | `ContentView.swift` | 最开始的 Hello World |
| 2.4 / 2.5 结构体与协议 | `Data/Note.swift`、`Data/NoteStore.swift` | 为什么用 struct；协议怎么让上层不依赖实现 |
| **2.6 可选类型与错误处理** | `Features/Playground/OptionalErrorPlaygroundView.swift` | 12 个知识点，结果由代码真实运行得出，可随手改 |
| 2.6 在真实场景 | `Features/Notes/NoteListView.swift` 的 `do-catch` | 读写出错时怎么兜底 |
| **3.2 / 3.3 布局与组件** | `Features/Gallery/ComponentGalleryView.swift` | 当速查表用 |
| **3.4 状态管理** | `Features/Settings/SettingsView.swift` | 几个属性包装器的分工（文件里有对照表） |
| 3.4 状态提升 | `Features/Playground/LoginFormView.swift` | 值放父视图、子组件只拿 Binding 的好处 |
| **3.5 列表与导航** | `Features/Notes/NoteListView.swift` | NavigationPath 多级跳转 |
| 3.6 表单与输入 | `Features/Gallery/FormControlsView.swift` | 各种输入控件 + 校验 |
| 3.6 在真实场景 | `Features/Notes/NoteEditView.swift` | 新建/编辑笔记的表单 |
| **4.1 / 4.2 / 4.3** | `Data/` 下三个 Store | 设置页可切换，同一套界面不同存储 |
| 4.5 本地数据设计 | `App/AppSettings.swift` 的 `makeStore()` | 面向协议带来的可替换性 |
| 5.x 打包上架 | —— | 流程类的内容我没放进代码 |

## Swift 语法笔记（第 2 章）

第 2 章的语法点比较碎，单独放在 Playground 里，不塞进 App。

```
SwiftBasics.playground/
├─ 01-变量常量与数据类型.xcplaygroundpage
├─ 02-运算符与流程控制.xcplaygroundpage
├─ 03-函数与闭包.xcplaygroundpage
├─ 04-类与结构体.xcplaygroundpage      值类型 vs 引用类型
├─ 05-枚举与协议.xcplaygroundpage      面向协议那套写法
└─ 06-可选类型与错误处理.xcplaygroundpage
```

双击 `SwiftBasics.playground`，左边选页，按 `▶` 跑，右边看输出。
每页都是「代码 + print 结果」，改一改就能看到变化。

## 两处刻意的处理

1. **Core Data 用 Xcode 模型文件**（`HelloWorld/Data/HeAnNotes.xcdatamodeld`）
   在 Xcode 里点开就是数据模型编辑器（实体 / 属性 / 关系都在那定义）。
   `CoreDataNoteStore` 只需 `NSPersistentContainer(name: "HeAnNotes")` 一行即可加载它。
2. **只做离线，不接网络**
   基础篇的目标本来就是做出一个纯离线 App，网络、内购那些后面再说。

## 顺手记下的两个坑

- `@Published` 来自 **Combine**，只写 `import SwiftUI` 在新版编译器下会报「类型不遵循 ObservableObject」。
- **字符串插值必须用半角 `)` 闭合**，写成中文全角 `）` 会报 `Unterminated string literal`，而且报错位置指不到真正原因 —— 中文输入法下很容易踩。

## License

[MIT](LICENSE) © 2026 April —— 个人笔记，仅供参考，随意取用。
