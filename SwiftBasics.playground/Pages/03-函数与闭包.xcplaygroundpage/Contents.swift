//
//  03 函数与闭包
//  📚 对应章节：2.3
//

import Foundation

print("=== 2.3 函数与闭包 ===\n")

// ─────────────────────────────────────────
// 一、函数基础
// ─────────────────────────────────────────

func greet(name: String) -> String {
    return "你好，\(name)"
}
print("① 基础函数：", greet(name: "禾安"))

// 无返回值（可以省略 -> Void）
func sayHello() {
    print("   无返回值的函数")
}
sayHello()

// 返回元组：一次返回多个值
func minMax(_ array: [Int]) -> (min: Int, max: Int)? {
    guard let first = array.first else { return nil }   // 空数组返回 nil
    var min = first, max = first
    for value in array {
        if value < min { min = value }
        if value > max { max = value }
    }
    return (min, max)
}
if let bounds = minMax([3, 9, 1, 7]) {
    print("② 返回元组：min =", bounds.min, "｜max =", bounds.max)
}

// ─────────────────────────────────────────
// 二～五、参数的几种花样
// ─────────────────────────────────────────

// 参数标签（外部名 ≠ 内部名）：让调用处像读英文
func sendMessage(from sender: String, to receiver: String) {
    print("③ 参数标签：\(sender) → \(receiver)")
}
sendMessage(from: "April", to: "禾安")

// 用 _ 省略外部标签
func add(_ x: Int, _ y: Int) -> Int { x + y }
print("④ 省略标签：add(3, 5) =", add(3, 5))

// 默认参数值
func orderCoffee(type: String = "美式", count: Int = 1) {
    print("⑤ 默认参数：点了 \(count) 杯\(type)")
}
orderCoffee()
orderCoffee(type: "拿铁", count: 2)

// 可变参数（传任意个）
func sum(_ numbers: Int...) -> Int {
    numbers.reduce(0, +)
}
print("⑥ 可变参数：sum(1,2,3) =", sum(1, 2, 3), "｜sum(10,20,30,40) =", sum(10, 20, 30, 40))

// 输入输出参数 inout（函数内部修改会影响外部变量）
func doubleIt(_ value: inout Int) {
    value *= 2
}
var number = 21
doubleIt(&number)    // 注意要加 &
print("⑦ inout：调用后 number =", number)

// ─────────────────────────────────────────
// 六、函数类型（函数也是一种类型，可以当变量、当参数）
// ─────────────────────────────────────────

let myFunction: (Int, Int) -> Int = add
print("⑧ 函数类型：把函数赋值给变量 →", myFunction(4, 6))

// 函数作为参数
func calculate(_ x: Int, _ y: Int, using operation: (Int, Int) -> Int) -> Int {
    operation(x, y)
}
print("   函数当参数：10 和 5 相减 =", calculate(10, 5, using: -))  // 运算符本身就是函数

// 函数作为返回值
func chooseOperation(isAdd: Bool) -> (Int, Int) -> Int {
    isAdd ? (+) : (-)
}
print("   函数当返回值：", chooseOperation(isAdd: true)(8, 3))

// ─────────────────────────────────────────
// 七、嵌套函数（函数里定义函数）
// ─────────────────────────────────────────

func makeCounter() -> () -> Int {
    var count = 0
    func increment() -> Int {     // 嵌套函数，能"记住"外面的 count
        count += 1
        return count
    }
    return increment
}
let counter = makeCounter()
print("⑨ 嵌套函数（闭包捕获）：", counter(), counter(), counter())

// ─────────────────────────────────────────
// 八～十一、闭包
// ─────────────────────────────────────────

let names = ["Charlie", "Alice", "Bob"]
print("\n⑩ 闭包：")

// 完整写法
let sortedFull = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 < s2
})
print("   完整写法：", sortedFull)

// 简化 1：类型可推断，不写参数和返回值类型
let sortedShort = names.sorted(by: { s1, s2 in s1 < s2 })
print("   省略类型：", sortedShort)

// 简化 2：用 $0 $1 代替参数名
let sortedShorter = names.sorted(by: { $0 < $1 })
print("   省略参数名：", sortedShorter)

// 简化 3：尾随闭包（闭包写在括号外面，Swift 里最常见）
let sortedTrailing = names.sorted { $0 < $1 }
print("   尾随闭包：", sortedTrailing)

// 逃逸闭包 @escaping：闭包在函数返回后才被调用（如网络回调）
func download(completion: @escaping (String) -> Void) {
    print("   开始下载…")
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        completion("下载完成")     // 函数在返回后才调用 → 必须标 @escaping
    }
}
download { result in
    print("⑪ 逃逸闭包回调：", result)
}

// 自动闭包 @autoclosure：把表达式自动包成闭包，延迟求值
func logIfTrue(_ condition: @autoclosure () -> Bool) {
    if condition() { print("⑫ 自动闭包：条件为真，才求值并打印") }
}
logIfTrue(2 > 1)

// ─────────────────────────────────────────
// 十二、常用高阶函数（日常开发 80% 的场景就这几个）
// ─────────────────────────────────────────

let scores = [65, 88, 92, 47, 73]
print("\n⑬ 高阶函数（基于 \(scores)）：")
print("   map（转换）：×2 =", scores.map { $0 * 2 })
print("   filter（过滤）：≥60 =", scores.filter { $0 >= 60 })
print("   sorted（排序）：", scores.sorted())
print("   reduce（归约）：求和 =", scores.reduce(0, +))
print("   compactMap（转换并丢掉 nil）：", ["1", "x", "3"].compactMap { Int($0) })
print("   flatMap（摊平）：", [[1, 2], [3, 4]].flatMap { $0 })
print("   first(where:)（找第一个符合条件的）：", scores.first(where: { $0 > 80 }) ?? "无")
print("   contains：是否有人不及格 =", scores.contains { $0 < 60 })

// 链式组合：先过滤 → 再转换 → 再求和
let bonusTotal = scores.filter { $0 >= 60 }.map { $0 / 10 }.reduce(0, +)
print("   链式：及格者的「分数/10」之和 =", bonusTotal)

sleep(1)   // 等一下逃逸闭包的异步回调打印完
print("\n✅ 2.3 完。动手试试：给 sum 传更多或少参数、或把 @escaping 去掉看报什么错。")
