//
//  02 运算符与流程控制
//  📝 对应笔记：2.2
//

import Foundation

print("=== 2.2 运算符与流程控制 ===\n")

// ─────────────────────────────────────────
// 一～六、运算符
// ─────────────────────────────────────────

let a = 10, b = 3
print("① 算术运算符：")
print("   \(a) + \(b) =", a + b)
print("   \(a) - \(b) =", a - b)
print("   \(a) * \(b) =", a * b)
print("   \(a) / \(b) =", a / b, "（整数除法会取整）")
print("   \(a) % \(b) =", a % b, "（取余）")

print("\n② 比较运算符：")
print("   \(a) > \(b) =", a > b, "｜\(a) == \(b) =", a == b, "｜\(a) != \(b) =", a != b)

print("\n③ 逻辑运算符：")
let isLoggedIn = true
let hasPermission = false
print("   !true =", !isLoggedIn)
print("   true && false =", isLoggedIn && hasPermission)
print("   true || false =", isLoggedIn || hasPermission)

print("\n④ 区间运算符：")
print("   闭区间 1...3：")
for i in 1...3 { print("      ", i) }
print("   半开区间 1..<3（不含 3）：")
for i in 1..<3 { print("      ", i) }
print("   单侧区间 [2...]：")
let numbers = [10, 20, 30, 40]
print("      numbers[2...] =", numbers[2...])

print("\n⑤ 三元运算符：")
let score = 85
let result = score >= 60 ? "及格" : "不及格"
print("   score = \(score) →", result)

// nil 合并运算符（2.6 详讲，这里先见个面）
let inputName: String? = nil
print("   nil 合并：inputName ?? \"匿名\" =", inputName ?? "匿名")

// ─────────────────────────────────────────
// 七、条件语句
// ─────────────────────────────────────────

print("\n⑥ if / else if / else：")
let temperature = 28
if temperature > 30 {
    print("   很热")
} else if temperature > 20 {
    print("   舒适（当前 \(temperature)℃）")
} else {
    print("   有点冷")
}

// guard：条件不满足就提前退出（避免层层嵌套）
print("\n⑦ guard（提前退出）：")
func checkAge(_ age: Int) {
    guard age >= 18 else {
        print("   未满 18 岁，直接返回")
        return
    }
    print("   年满 \(age) 岁，继续执行")
}
checkAge(16)
checkAge(25)

// ─────────────────────────────────────────
// 八、switch（Swift 的 switch 非常强大）
// ─────────────────────────────────────────

print("\n⑧ switch：")
let grade = "B"
switch grade {
case "A":
    print("   优秀")
case "B":
    print("   良好")     // 命中这里，自动 break（不会贯穿到下一 case）
case "C":
    print("   及格")
default:
    print("   其它")
}

// 区间匹配
let testScore = 85
switch testScore {
case 90...100:
    print("   \(testScore) 分 → 优秀")
case 75..<90:
    print("   \(testScore) 分 → 良好")
case 60..<75:
    print("   \(testScore) 分 → 及格")
default:
    print("   \(testScore) 分 → 需要加油")
}

// 元组匹配
let point = (1, 1)
switch point {
case (0, 0):
    print("   原点")
case (_, 0):
    print("   在 x 轴上")
case (0, _):
    print("   在 y 轴上")
default:
    print("   在其它位置：\(point)")
}

// ─────────────────────────────────────────
// 九、循环
// ─────────────────────────────────────────

print("\n⑨ 循环：")

print("   for-in 遍历数组：", terminator: "")
for fruit in ["🍎", "🍊", "🍇"] {
    print(fruit, terminator: " ")
}
print()

print("   for-in 遍历字典：")
let capitals = ["中国": "北京", "日本": "东京"]
for (country, city) in capitals {
    print("      \(country) 的首都是 \(city)")
}

print("   stride 跳着走：", terminator: "")
for i in stride(from: 0, to: 10, by: 3) {
    print(i, terminator: " ")
}
print()

print("   while：", terminator: "")
var countdown = 3
while countdown > 0 {
    print(countdown, terminator: " ")
    countdown -= 1
}
print()

print("   repeat-while（至少执行一次）：", terminator: "")
var n = 0
repeat {
    print(n, terminator: " ")
    n += 1
} while n < 3
print()

// break 与 continue
print("   break / continue：", terminator: "")
for i in 1...6 {
    if i == 5 { break }        // 直接结束整个循环
    if i % 2 == 0 { continue } // 跳过本次，继续下一轮
    print(i, terminator: " ")
}
print()

// 带标签的 break（跳出多层）
print("   带标签 break：")
outer: for i in 1...3 {
    for j in 1...3 {
        if i * j > 4 {
            print("      在 i=\(i), j=\(j) 处跳出外层循环")
            break outer
        }
    }
}

print("\n✅ 2.2 完。随手改改看：把 switch 的 default 删掉看编译器怎么提醒你、或写个会贯穿的 case 试试。")
