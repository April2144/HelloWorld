//
//  OptionalErrorPlaygroundView.swift
//  HelloWorld
//
//  📚 对应章节：2.6 错误处理与可选类型（全篇）
//
//  教学要点：
//  - 这一页的「运行结果」不是写死的文字，而是**页面里真跑出来的**（见 buildSnippets()）
//  - 覆盖 2.6 全部知识点：可选绑定 / guard / 可选链 / nil 合并 / 隐式解包 /
//    do-catch / try 的三种形式 / throws 传播 / Result / defer / 自定义错误
//  - 建议边看边在 Xcode 里改代码试：改一处，结果立刻变
//

import SwiftUI

struct OptionalErrorPlaygroundView: View {
    /// 每条 = 一个知识点：代码 + 真跑出来的结果 + 一句话说明
    private let items: [Snippet] = Self.buildSnippets()

    var body: some View {
        List {
            Section {
                Text("下面每条的「结果」都是本页代码真实运行出来的，不是写死的。改代码 → 结果跟着变。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title).font(.headline)

                    // 代码（等宽字体，像在 Xcode 里看）
                    Text(item.code)
                        .font(.system(.caption, design: .monospaced))
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.quaternary.opacity(0.35), in: .rect(cornerRadius: 8))

                    // 结果
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("结果").font(.caption2).foregroundStyle(.secondary)
                        Text(item.result)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.blue)
                    }

                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("可选类型与错误（2.6）")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 数据构造（真的在这里运行了一遍）

extension OptionalErrorPlaygroundView {
    struct Snippet: Identifiable {
        let id = UUID()
        let title: String
        let code: String
        let result: String
        let note: String
    }

    /// 2.6 自定义错误
    private enum DemoError: Error, LocalizedError {
        case emptyName
        case tooShort(Int)

        var errorDescription: String? {
            switch self {
            case .emptyName:        return "名字为空"
            case .tooShort(let n):  return "长度不足，需要至少 \(n) 位"
            }
        }
    }

    /// 2.6 throws 函数
    private static func validate(_ name: String, minLength: Int = 2) throws -> String {
        guard !name.isEmpty else { throw DemoError.emptyName }
        guard name.count >= minLength else { throw DemoError.tooShort(minLength) }
        return "校验通过：\(name)"
    }

    /// 2.6 defer：函数返回前一定执行
    private static func withDefer() -> String {
        var log = ""
        defer { log += " → defer 最后执行" }
        log += "先执行主体"
        return log
    }

    static func buildSnippets() -> [Snippet] {
        var out: [Snippet] = []

        // ① 可选类型基础
        let maybeName: String? = "禾安"
        out.append(Snippet(
            title: "① 可选类型是什么",
            code: "let maybeName: String? = \"禾安\"\nprint(maybeName)",
            result: String(describing: maybeName),
            note: "Optional(\"禾安\") —— 有值，但被包了一层"
        ))

        // ② 强制解包（危险）
        out.append(Snippet(
            title: "② 强制解包 !（能不用就不用）",
            code: "maybeName!",
            result: maybeName!,
            note: "值为 nil 时会直接崩溃 —— 这是新手最常见的闪退来源"
        ))

        // ③ if let 可选绑定
        var ifLetResult = ""
        if let name = maybeName {
            ifLetResult = "解包成功 → \(name)"
        } else {
            ifLetResult = "值是 nil"
        }
        out.append(Snippet(
            title: "③ 可选绑定 if let（推荐）",
            code: "if let name = maybeName {\n    // 这里 name 是确定的 String\n} else {\n    // nil 分支\n}",
            result: ifLetResult,
            note: "最安全、最常用的写法"
        ))

        // ④ guard let（提前返回）
        func greet(_ name: String?) -> String {
            guard let name else { return "没有名字，提前返回" }
            return "你好，\(name)"
        }
        out.append(Snippet(
            title: "④ guard let（提前退出）",
            code: "func greet(_ name: String?) -> String {\n    guard let name else { return \"没有名字\" }\n    return \"你好，\\(name)\"\n}",
            result: "greet(\"禾安\") = \(greet("禾安")) ｜ greet(nil) = \(greet(nil))",
            note: "guard 之后 name 在整个函数里都可用，避免嵌套 if"
        ))

        // ⑤ 可选链
        struct DemoUser { var city: String? }
        let user: DemoUser? = DemoUser(city: "深圳")
        let nilUser: DemoUser? = nil
        out.append(Snippet(
            title: "⑤ 可选链 ?.",
            code: "user?.city        // user 有值\nnilUser?.city     // user 是 nil",
            result: "\(String(describing: user?.city)) ｜ \(String(describing: nilUser?.city))",
            note: "链条中任意一环为 nil，整体就是 nil，不会崩"
        ))

        // ⑥ nil 合并
        let nickname: String? = nil
        out.append(Snippet(
            title: "⑥ nil 合并运算符 ??",
            code: "let nickname: String? = nil\nnickname ?? \"默认昵称\"",
            result: nickname ?? "默认昵称",
            note: "给可选值一个兜底默认值的首选写法"
        ))

        // ⑦ 隐式解包
        let implicit: String! = "我很确定有值"
        out.append(Snippet(
            title: "⑦ 隐式解包可选 !",
            code: "let implicit: String! = \"我很确定有值\"\nimplicit + \"（直接用）\"",
            result: implicit + "（直接用）",
            note: "主要用于 @IBOutlet 这类「初始化时为空、之后一定有值」的场景，滥用会崩"
        ))

        // ⑧ do-catch
        var catchResult = ""
        do {
            catchResult = try validate("", minLength: 2)
        } catch {
            catchResult = "捕获到错误：\(error.localizedDescription)"
        }
        out.append(Snippet(
            title: "⑧ do-catch 捕获错误",
            code: "do {\n    try validate(\"\", minLength: 2)\n} catch {\n    // 处理\n}",
            result: catchResult,
            note: "try 必须写在 do 里（或函数本身 throws）"
        ))

        // ⑨ try? / try!
        let tryQuestion: String? = try? validate("", minLength: 2)
        let trySuccess: String? = try? validate("禾安", minLength: 2)
        out.append(Snippet(
            title: "⑨ try 的三种形式",
            code: "(try? validate(\"\"))  // 失败变 nil\n(try? validate(\"禾安\"))",
            result: "失败：\(String(describing: tryQuestion)) ｜ 成功：\(String(describing: trySuccess))",
            note: "try? 失败返回 nil；try! 失败直接崩（除非你 100% 确定会成功）"
        ))

        // ⑩ Result 类型
        let failure: Result<String, Error> = Result { try validate("", minLength: 2) }
        let success: Result<String, Error> = Result { try validate("禾安", minLength: 2) }
        func describe(_ r: Result<String, Error>) -> String {
            switch r {
            case .success(let v): return "success(\(v))"
            case .failure(let e): return "failure(\(e.localizedDescription))"
            }
        }
        out.append(Snippet(
            title: "⑩ Result 类型",
            code: "let r: Result<String, Error> = Result { try validate(...) }\nswitch r { case .success / .failure }",
            result: "\(describe(failure)) ｜ \(describe(success))",
            note: "适合把结果存起来稍后处理（如 completion 回调、异步场景）"
        ))

        // ⑪ defer
        out.append(Snippet(
            title: "⑪ defer（收尾必执行）",
            code: "func withDefer() -> String {\n    var log = \"\"\n    defer { log += \" → defer 最后执行\" }\n    log += \"先执行主体\"\n    return log\n}",
            result: withDefer(),
            note: "常用于关闭文件、解锁、释放资源"
        ))

        // ⑫ throws 传播
        func outer() throws -> String {
            try validate("禾安", minLength: 2)   // 不处理，继续往上抛
        }
        var propagate = ""
        do { propagate = try outer() } catch { propagate = "错误：\(error.localizedDescription)" }
        out.append(Snippet(
            title: "⑫ throws 向上传播",
            code: "func outer() throws -> String {\n    try validate(\"禾安\")   // 不 catch，继续抛给调用方\n}",
            result: propagate,
            note: "底层函数 throws → 上层可以自己处理，也可以继续往上抛"
        ))

        return out
    }
}

#Preview {
    NavigationStack {
        OptionalErrorPlaygroundView()
    }
}
