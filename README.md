# HelloWorld —— 《iOS 开发：从 0 到上架》配套 Demo

> 这是专题 **「iOS 开发：从 0 到上架」前五章（基础篇）** 的可运行配套工程。
> 每个 Swift 文件的顶部都写了 `📚 对应章节：x.x …`，照着章节找文件即可。

## 怎么用

1. 用 Xcode 打开 `HelloWorld.xcodeproj`
2. 选一个模拟器（iPhone 16 及以上）→ `⌘R` 运行
3. 想看某个知识点：看文件顶部注释 → 跳到对应章节

App 一共三个 Tab：

| Tab | 看什么 | 对应章节 |
|---|---|---|
| **笔记** | 列表 → 详情 → 编辑，整套导航与增删改查 | 3.5、3.6、2.6 |
| **组件** | UI 手册：布局与常用组件的写法对照 | 3.2、3.3 |
| **设置** | ⭐️ 状态管理全家桶 + 三种存储方案切换 | 3.4、4.1、4.2、4.3、4.5 |

> 首次进「笔记」是空的，点 **「载入示例数据」** 即可看到效果。

## 目录结构 × 章节映射

```
HelloWorld/
├─ HelloWorldApp.swift              @main 入口（1.4）
├─ ContentView.swift                1.4 你的第一个 Hello World（保留作为起点纪念）
│
├─ App/
│  ├─ RootTabView.swift             3.5 TabView ｜ 3.4 @StateObject / @EnvironmentObject
│  └─ AppSettings.swift             3.4 @Published ｜ 4.1 UserDefaults 封装
│
├─ Data/
│  ├─ Note.swift                    2.4 struct 值类型 ｜ 2.5 Codable
│  ├─ NoteStore.swift               2.5 协议抽象 ｜ 2.6 throws / 自定义错误
│  ├─ UserDefaultsNoteStore.swift   4.1 UserDefaults（含存储自定义对象）
│  ├─ FileJSONNoteStore.swift       4.2 沙盒 / 文件路径 / JSON 读写
│  └─ CoreDataNoteStore.swift       4.3 Core Data（代码构造 model，无需 .xcdatamodeld）
│
└─ Features/
   ├─ Notes/
   │  ├─ NoteListView.swift         3.5 List / ForEach / NavigationStack / NavigationPath
   │  ├─ NoteDetailView.swift       3.5 导航传值 / 标题与工具栏
   │  └─ NoteEditView.swift         3.6 Form / TextField / 表单验证
   ├─ Settings/
   │  └─ SettingsView.swift         ⭐️ 3.4 @State·@Binding·@EnvironmentObject·@AppStorage
   ├─ Gallery/
   │  ├─ ComponentGalleryView.swift      3.2 布局 ｜ 3.3 组件与组合（含各演示入口）
   │  └─ FormControlsView.swift          3.6 全表单控件 + 表单验证
   └─ Playground/
      ├─ OptionalErrorPlaygroundView.swift  2.6 可选类型与错误处理（代码→真跑出的结果）
      └─ LoginDemoView.swift                3.4 状态提升 / 单向数据流（登录表单）
```

## 按章节的学习顺序（建议）

| 章节 | 先看哪个文件 | 重点看什么 |
|---|---|---|
| 1.4 第一个项目 | `ContentView.swift` | 你最初的 Hello World |
| 2.4 / 2.5 结构体与协议 | `Data/Note.swift`、`Data/NoteStore.swift` | 为什么用 struct；协议怎么让上层不依赖实现 |
| **2.6 可选类型 / 错误处理** | `Features/Playground/OptionalErrorPlaygroundView.swift` | ⭐️ 12 个知识点，结果都是真跑出来的，可改代码试 |
| 2.6 在真实场景里 | `Features/Notes/NoteListView.swift` 的 `do-catch` | 存储出错时怎么兜底 |
| **3.4 状态管理** | `Features/Settings/SettingsView.swift` | ⭐️ 五个属性包装器的分工（文件里有对照表） |
| 3.4 状态提升 / 单向数据流 | `Features/Playground/LoginDemoView.swift` | ⭐️ 为什么值要放父视图、子组件只拿 @Binding |
| **3.5 列表与导航** | `Features/Notes/NoteListView.swift` | NavigationPath 多级跳转 |
| 3.6 表单与输入 | `Features/Gallery/FormControlsView.swift` | ⭐️ 全控件（TextField/SecureField/Toggle/Picker/Stepper/Slider/DatePicker）+ 验证 |
| 3.6 在真实场景里 | `Features/Notes/NoteEditView.swift` | 新建/编辑笔记的表单 |
| 3.2 / 3.3 布局与组件 | `Features/Gallery/ComponentGalleryView.swift` | 当 UI 手册查 |
| **4.1 / 4.2 / 4.3** | `Data/` 下三个 Store | 在「设置」里切换，同一套界面不同存储 |
| 4.5 本地数据设计 | `App/AppSettings.swift` 的 `makeStore()` | 面向协议带来的可替换性 |
| 5.x 打包上架 | —— | 流程类内容，建议看专题图文 + 录屏，不做进代码 |

## 两个刻意的设计

1. **Core Data 用代码构造模型**（`CoreDataNoteStore.makeModel()`）
   真实项目请在 Xcode 里建 `.xcdatamodeld`（见 4.3「三、创建数据模型」）；
   本 demo 为了「clone 下来就能编译」才用代码构造，省掉一个资源文件依赖。

2. **只做离线，不接网络**
   基础篇的目标是「独立完成并上架一个**离线** App」，所以没有网络层；
   网络、内购、性能等属于进阶篇，后续再加。

## 后续可加（进阶篇预告）

- 6.x 架构：把 `NoteStore` 再往上抽一层 `NoteRepository` + 依赖注入
- 7.x 网络层：`URLSession` + `Codable` + `async/await`
- 8.x 性能：列表懒加载、图片缓存
- 9.x 内购：StoreKit 2
