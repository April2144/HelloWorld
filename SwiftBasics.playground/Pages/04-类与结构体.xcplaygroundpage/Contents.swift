//
//  04 面向对象：类与结构体
//  📝 对应笔记：2.4
//
//  本页最重要的一件事：**搞懂值类型 vs 引用类型**（第六节务必动手试）
//

import Foundation

print("=== 2.4 类与结构体 ===\n")

// ─────────────────────────────────────────
// 一、基础定义
// ─────────────────────────────────────────

struct Point {          // 结构体：值类型
    var x: Int
    var y: Int
}

class Person {          // 类：引用类型
    var name: String
    var age: Int

    init(name: String, age: Int) {   // 类必须自己写初始化器
        self.name = name
        self.age = age
    }
}

let p = Point(x: 3, y: 4)            // 结构体有自动生成的成员初始化器
let person = Person(name: "禾安", age: 30)
print("① 结构体 \(p) ｜ 类 \(person.name) \(person.age) 岁")

// ─────────────────────────────────────────
// 二、属性
// ─────────────────────────────────────────

struct Circle {
    // 存储属性
    var radius: Double

    // 常量存储属性（初始化后不可改）
    let pi = 3.14159

    // 计算属性：不存值，每次都算
    var area: Double {
        pi * radius * radius
    }

    // 计算属性也可以 set
    var diameter: Double {
        get { radius * 2 }
        set { radius = newValue / 2 }
    }

    // 类型属性（属于类型本身，所有实例共享）
    static let description = "一个圆"
}

var circle = Circle(radius: 5)
print("② 属性：半径 \(circle.radius) → 面积 \(String(format: "%.2f", circle.area))")
circle.diameter = 20        // 走 set，反过来改 radius
print("   设置直径 20 → 半径变成 \(circle.radius)")
print("   类型属性：\(Circle.description)")

// 属性观察器 willSet / didSet
class Temperature {
    var celsius: Double = 0 {
        willSet { print("   即将从 \(celsius) 变成 \(newValue)") }
        didSet  { print("   已经从 \(oldValue) 变成 \(celsius)") }
    }
}
print("③ 属性观察器：")
let temp = Temperature()
temp.celsius = 26
temp.celsius = 30

// ─────────────────────────────────────────
// 三、方法
// ─────────────────────────────────────────

struct Counter {
    var count = 0

    // 结构体里改自身属性，必须标 mutating
    mutating func increment() {
        count += 1
    }
    mutating func add(_ n: Int) {
        count += n
    }

    // 类型方法
    static func makeZero() -> Counter { Counter() }
}

var counter = Counter()
counter.increment()
counter.add(10)
print("④ mutating 方法：count =", counter.count, "｜类型方法：", Counter.makeZero().count)

class Stepper {
    var value = 0
    func step() { value += 1 }      // 类里改属性不需要 mutating
}

// ─────────────────────────────────────────
// 四、初始化器与析构器
// ─────────────────────────────────────────

class Vehicle {
    var wheels: Int

    init(wheels: Int) {             // 指定初始化器
        self.wheels = wheels
    }

    convenience init() {            // 便利初始化器：必须调用指定初始化器
        self.init(wheels: 4)
    }

    deinit {                        // 析构器：实例被释放时调用（只有类有）
        print("    Vehicle 被释放了")
    }
}

class Bike: Vehicle {               // 继承
    var hasBasket: Bool

    init(hasBasket: Bool) {
        self.hasBasket = hasBasket  // 先初始化自己的属性
        super.init(wheels: 2)       // 再调父类初始化器
    }
}
print("⑤ 初始化器：默认车 \(Vehicle().wheels) 轮 ｜ 自行车 \(Bike(hasBasket: true).wheels) 轮，带篮子 = \(Bike(hasBasket: true).hasBasket)")

// 可失败初始化器 init?：条件不满足返回 nil
struct Account {
    let id: String
    init?(id: String) {
        guard id.count >= 3 else { return nil }
        self.id = id
    }
}
print("⑥ 可失败初始化器：Account(id: \"ab\") =", Account(id: "ab") == nil ? "nil（太短）" : "成功",
      "｜Account(id: \"abc123\") =", Account(id: "abc123")?.id ?? "nil")

// ─────────────────────────────────────────
// 五、继承
// ─────────────────────────────────────────

class Animal {
    var name: String
    init(name: String) { self.name = name }
    func speak() { print("   \(name) 发出声音") }
    final func breathe() { print("   \(name) 在呼吸") }   // final：禁止子类重写
}

class Dog: Animal {
    override func speak() {         // 重写必须写 override
        print("   \(name)：汪汪！")
    }
}
print("⑦ 继承与重写：")
let dog = Dog(name: "旺财")
dog.speak()
dog.breathe()

// 用 final 修饰的类不能被继承
final class Utility { }
// class SubUtility: Utility { }    // ← 取消注释会报错

// ─────────────────────────────────────────
// 六、⭐️ 值类型 vs 引用类型（必看）
// ─────────────────────────────────────────

print("\n⑧ ⭐️ 值类型 vs 引用类型：")

var pointA = Point(x: 1, y: 1)
var pointB = pointA            // 结构体：拷贝一份全新的
pointB.x = 99
print("   结构体：A.x =", pointA.x, "｜B.x =", pointB.x, "→ 互不影响（各自独立）")

var personA = Person(name: "张三", age: 20)
var personB = personA          // 类：只复制指针，指向同一个实例
personB.name = "李四"
print("   类：A.name =", personA.name, "｜B.name =", personB.name, "→ 改一个，两个都变了（共享同一个对象）")

// 恒等运算符 ===：判断两个引用是否指向同一个实例
print("   personA === personB ?", personA === personB)
let personC = Person(name: "王五", age: 22)
print("   personA === personC ?", personA === personC)

// let 的差异：let 的结构体完全不可变；let 的类仍可改内部属性
let fixedPoint = Point(x: 0, y: 0)
// fixedPoint.x = 5     // ← 报错：let 的结构体属性也不能改
let fixedPerson = Person(name: "赵六", age: 40)
fixedPerson.age = 41    // ✅ 可以：let 只锁住指针，不锁对象内容
print("   let 修饰的类实例，属性仍可改：赵六现在 \(fixedPerson.age) 岁")

// 什么时候用哪个？
print("""
   📌 选型建议：
   - 结构体 struct：描述"数据"（坐标、金额、配置项）—— Swift 标准库里绝大多数类型都是 struct
   - 类 class：需要"身份"或"共享状态"（ViewController、Model 对象、需要继承）
""")

print("✅ 2.4 完。随手改改看：把 struct 改成 class 再跑第⑧节，看看输出有什么不同 —— 这是理解 Swift 最关键的一步。")
