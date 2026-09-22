//
//  06 可选类型与错误处理
//  📚 对应章节：2.6
//
//  这大概是 Swift 新手最容易崩溃（字面意思）的一章：
//  「可选类型」就是 Swift 用来消灭空指针异常的机制。
//

import Foundation

print("=== 2.6 可选类型与错误处理 ===\n")

// ─────────────────────────────────────────
// 一、可选类型是什么
// ─────────────────────────────────────────

var optionalName: String? = "禾安"
print("① 可选类型：optionalName =", String(describing: optionalName))
optionalName = nil
print("   赋值为 nil 后：", String(describing: optionalName))
print("   💡 Optional 就像「一个盒子」：要么装着值，要么是空的（nil）")

// 非可选类型永远不能为 nil
// let mustHaveValue: String = nil    // ← 报错：非可选类型不能赋值 nil

// ─────────────────────────────────────────
// 二、强制解包（危险！）
// ─────────────────────────────────────────

var riskyName: String? = "禾安"
print("\n② 强制解包 !：")
print("   有值时 riskyName! =", riskyName!)
// riskyName = nil
// print(riskyName!)      // ← 取消注释会崩溃：Unexpectedly found nil
print("   ⚠️ 值为 nil 时强制解包会直接崩溃 —— 这是新手闪退的头号原因")

// ─────────────────────────────────────────
// 三、可选绑定（推荐的安全写法）
// ─────────────────────────────────────────

print("\n③ 可选绑定 if let：")
var maybeName: String? = "禾安"
if let name = maybeName {
    print("   解包成功：\(name)（这里 name 是确定的 String，不是可选）")
} else {
    print("   值是 nil")
}

// 同时解包多个（都成功才进）
let maybeAge: Int? = 30
if let name = maybeName, let age = maybeAge {
    print("   多值解包成功：\(name) \(age) 岁")
}

// Swift 5.7+ 简写：省略右边的变量名
if let maybeName {
    print("   简写形式：\(maybeName)")
}

// ─────────────────────────────────────────
// 四、guard let（提前退出）
// ─────────────────────────────────────────

print("\n④ guard let（提前退出）：")
func printUppercased(_ text: String?) {
    guard let text else {
        print("   没有内容，直接返回")
        return
    }
    // 从这里开始，text 在整个函数作用域内都是非可选值
    print("   结果：\(text.uppercased())")
}
printUppercased("hello")
printUppercased(nil)
print("   💡 好处：避免层层嵌套的 if，函数主干保持在最外层")

// ─────────────────────────────────────────
// 五、可选链 ?.
// ─────────────────────────────────────────

struct Address { var city: String? }
struct User {
    var name: String
    var address: Address?
}

print("\n⑤ 可选链 ?.：")
let user1 = User(name: "禾安", address: Address(city: "深圳"))
let user2 = User(name: "小明", address: nil)

print("   user1.address?.city =", String(describing: user1.address?.city))
print("   user2.address?.city =", String(describing: user2.address?.city), "（链条中任一环为 nil，整体就是 nil，不会崩）")

// 可选链赋值：只有整条链都通才生效
var user3 = user1
user3.address?.city = "北京"
print("   可选链赋值后：", user3.address?.city ?? "无")

// ─────────────────────────────────────────
// 六、nil 合并运算符 ??
// ─────────────────────────────────────────

print("\n⑥ nil 合并 ??：")
let nickname: String? = nil
print("   nickname ?? \"匿名用户\" =", nickname ?? "匿名用户")
let configuredTimeout: Int? = nil
let timeout = configuredTimeout ?? 30
print("   未配置时用默认超时：", timeout, "秒")

// ?? 可以串起来
let finalName = nickname ?? maybeName ?? "兜底名字"
print("   串联：", finalName)

// ─────────────────────────────────────────
// 七、隐式解包可选 !（谨慎使用）
// ─────────────────────────────────────────

print("\n⑦ 隐式解包可选 String!：")
let assumedName: String! = "一定会有值"
print("   可以直接用：", assumedName + "（无需解包）")
print("   ⚠️ 但如果它是 nil，一用就崩 —— 主要用于 @IBOutlet 这类「初始化时为空、之后必然有值」的场景")

// ─────────────────────────────────────────
// 八～十二、错误处理
// ─────────────────────────────────────────

// 自定义错误：遵循 Error（通常用枚举，LocalizedError 提供可读描述）
enum LoginError: Error, LocalizedError {
    case emptyUsername
    case passwordTooShort(minLength: Int)
    case userBanned(reason: String)

    var errorDescription: String? {
        switch self {
        case .emptyUsername:                 return "用户名为空"
        case .passwordTooShort(let n):       return "密码至少需要 \(n) 位"
        case .userBanned(let reason):        return "账号被封禁：\(reason)"
        }
    }
}

// throws 函数
func login(username: String, password: String) throws -> String {
    guard !username.isEmpty else { throw LoginError.emptyUsername }
    guard password.count >= 6 else { throw LoginError.passwordTooShort(minLength: 6) }
    if username == "hacker" { throw LoginError.userBanned(reason: "异常登录") }
    return "登录成功，欢迎 \(username)"
}

print("\n⑧ do-catch：")
do {
    let result = try login(username: "禾安", password: "123456")
    print("   \(result)")
} catch {
    print("   捕获错误：\(error.localizedDescription)")
}

do {
    _ = try login(username: "", password: "123456")
} catch LoginError.emptyUsername {
    print("   精确捕获：用户名为空（匹配到具体 case）")
} catch let error as LoginError {
    print("   其它登录错误：\(error.localizedDescription)")
} catch {
    print("   兜底：\(error)")
}

print("\n⑨ try 的三种形式：")
print("   try? 失败返回 nil：", try? login(username: "hacker", password: "123456") as Any)
print("   try? 成功返回值：", try? login(username: "禾安", password: "123456") as Any)
print("   try! 失败会崩溃 —— 除非 100% 确定会成功，否则别用")

print("\n⑩ Result 类型（把结果存起来稍后处理）：")
func safeLogin(username: String, password: String) -> Result<String, Error> {
    Result { try login(username: username, password: password) }
}
let r1 = safeLogin(username: "禾安", password: "123456")
let r2 = safeLogin(username: "", password: "")

for r in [r1, r2] {
    switch r {
    case .success(let value): print("   ✅", value)
    case .failure(let error): print("   ❌", error.localizedDescription)
    }
}
// Result 也有函数式写法
let uppercased = r1.map { $0.uppercased() }
print("   map 转换成功后：", (try? uppercased.get()) ?? "无")

print("\n⑪ throws 向上传播：")
func outerProcess() throws -> String {
    // 自己不 catch，继续抛给调用方
    try login(username: "hacker", password: "123456")
}
do {
    _ = try outerProcess()
} catch {
    print("   最外层捕获：\(error.localizedDescription)")
}

print("\n⑫ defer（收尾必执行）：")
func readFile() {
    print("   打开文件")
    defer { print("   → defer：关闭文件（无论中途是否出错都会执行）") }
    print("   读取内容")
    // 即使这里 return，defer 依然会跑
}
readFile()

// 多个 defer 的执行顺序：后进先出
func multipleDefer() {
    defer { print("   defer 1") }
    defer { print("   defer 2") }
    print("   函数主体")
}
print("   多个 defer（注意顺序是反的）：")
multipleDefer()

print("\n✅ 2.6 完。记住三条铁律：")
print("   1️⃣  少用 ! 强制解包，多用 if let / guard let")
print("   2️⃣  值为 nil 是合法状态，不是错误 —— 用可选类型把它表达清楚")
print("   3️⃣  真的出了错才 throw，别用错误代替流程控制")
