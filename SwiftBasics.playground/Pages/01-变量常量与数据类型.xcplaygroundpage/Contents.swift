//
//  01 变量、常量与数据类型
//  📚 对应章节：2.1
//
//  玩法：Xcode 里打开 SwiftBasics.playground，选这一页按 ▶ 运行；
//      看右侧「结果」栏的输出，改一改数值再运行，观察变化。
//

import Foundation

print("=== 2.1 变量、常量与数据类型 ===\n")

// ─────────────────────────────────────────
// 一、变量与常量
// ─────────────────────────────────────────

// var = 可变
var score = 90
score = 95
print("① var 变量可以改：score =", score)

// let = 不可变（推荐优先用 let）
let maxScore = 100
print("② let 常量不可改：maxScore =", maxScore)
// maxScore = 120   // ← 取消注释会报错：不能给 let 赋值

// Swift 的哲学：能用 let 就用 let，编译器会帮你避免误改

// ─────────────────────────────────────────
// 二、类型推断与类型注解
// ─────────────────────────────────────────

let inferredInt = 42          // 编译器推断为 Int
let inferredDouble = 3.14     // 推断为 Double
let explicitDouble: Double = 3 // 显式注解后，3 会被当成 Double
print("\n③ 类型推断：inferredInt 是 Int，inferredDouble 是 Double")
print("   显式注解：explicitDouble =", explicitDouble, "（写成 let x = 3 就是 Int 了）")

// Hover 看类型的小技巧：按住 Option 点变量名

// ─────────────────────────────────────────
// 三、基本数据类型
// ─────────────────────────────────────────

let age: Int = 28                       // 整数
let price: Double = 19.9                // 双精度浮点（默认浮点类型）
let ratio: Float = 0.25                 // 单精度浮点
let isVIP = true                        // 布尔
let greeting = "你好，Swift"             // 字符串
let firstLetter: Character = "S"        // 字符（单个）

print("\n④ 基本类型：")
print("   Int      age =", age)
print("   Double   price =", price)
print("   Float    ratio =", ratio)
print("   Bool     isVIP =", isVIP)
print("   String   greeting =", greeting)
print("   Character firstLetter =", firstLetter)

// 整数的进制写法
let binary = 0b1010        // 二进制 = 10
let octal = 0o17           // 八进制 = 15
let hex = 0xFF             // 十六进制 = 255
let bigNumber = 1_000_000  // 下划线只为可读性，值仍是 1000000
print("   进制：0b1010 =", binary, "｜0o17 =", octal, "｜0xFF =", hex, "｜1_000_000 =", bigNumber)

// ─────────────────────────────────────────
// 四、类型转换（Swift 不会隐式转换，必须显式）
// ─────────────────────────────────────────

let intValue = 10
let doubleValue = 3.5
// let sum = intValue + doubleValue   // ← 报错：Int 和 Double 不能直接相加
let sum = Double(intValue) + doubleValue     // 转成同一类型再算
let intSum = intValue + Int(doubleValue)     // 转成 Int（小数部分会被截掉）

print("\n⑤ 类型转换：")
print("   Double(10) + 3.5 =", sum)
print("   10 + Int(3.5) =", intSum, "（注意：3.5 转 Int 变成 3，小数被截断）")

// 数字 ↔ 字符串
let countText = String(42)              // 数字 → 字符串
let maybeNumber = Int("42")             // 字符串 → 数字（可能失败 → 返回可选类型）
print("   String(42) =", countText, "｜Int(\"42\") =", String(describing: maybeNumber))

// ─────────────────────────────────────────
// 五、类型别名 typealias
// ─────────────────────────────────────────

typealias UserID = Int      // 给已有类型起个更有意义的名字
let myID: UserID = 10086
print("\n⑥ typealias：UserID 其实就是 Int，myID =", myID)

// ─────────────────────────────────────────
// 六、元组 Tuple
// ─────────────────────────────────────────

let httpStatus = (code: 200, message: "OK")
print("\n⑦ 元组：")
print("   整体取值：", httpStatus)
print("   按下标：\(httpStatus.0) \(httpStatus.1)")
print("   按名字：\(httpStatus.code) \(httpStatus.message)")

// 元组解包（一次性取出多个值）
let (statusCode, statusMessage) = httpStatus
print("   解包后：code =", statusCode, "｜message =", statusMessage)

// 函数返回多个值时非常好用
func parseName(_ full: String) -> (first: String, last: String) {
    let parts = full.split(separator: " ")
    return (String(parts[0]), String(parts[1]))
}
let name = parseName("He An")
print("   函数返回元组：first =", name.first, "｜last =", name.last)

// ─────────────────────────────────────────
// 七、字符串常用操作（顺手必会）
// ─────────────────────────────────────────

var sentence = "Swift"
sentence += " 很有趣"
print("\n⑧ 字符串：")
print("   拼接：", sentence)
print("   长度：", sentence.count)
print("   插值：我有 \(sentence.count) 个字符")
print("   多行：下面这一段用了三个双引号")
let multiline = """
第一行
第二行
第三行
"""
print(multiline)

print("\n✅ 2.1 完。动手试试：把 let 改成 var 再改值、或让 Int 和 Double 相加看报什么错。")
