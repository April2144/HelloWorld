//
//  05 枚举与协议
//  📝 对应笔记：2.5
//
//  Swift 的枚举比其它语言强得多（能带方法、带关联值）；
//  协议 + 扩展 = 面向协议编程，是 Swift 的招牌特性。
//

import Foundation

print("=== 2.5 枚举与协议 ===\n")

// ─────────────────────────────────────────
// 一、枚举基础
// ─────────────────────────────────────────

enum CompassDirection {
    case north
    case south
    case east
    case west
}

var heading = CompassDirection.west
heading = .north        // 类型已知时可以省略前缀
print("① 枚举基础：heading =", heading)

// switch 匹配枚举（必须穷举所有 case，或写 default）
switch heading {
case .north: print("   向北：目标在前方")
case .south: print("   向南：往回走")
case .east:  print("   向东：日出方向")
case .west:  print("   向西：日落方向")
}

// ─────────────────────────────────────────
// 二、原始值 Raw Value（每个 case 绑定一个固定值）
// ─────────────────────────────────────────

enum Planet: Int {
    case mercury = 1, venus, earth, mars   // 后面的自动递增：2、3、4
}

print("\n② 原始值：")
print("   Planet.earth.rawValue =", Planet.earth.rawValue)
print("   从原始值反查：Planet(rawValue: 3) =", Planet(rawValue: 3) ?? "nil")   // 返回可选类型
print("   越界的原始值：Planet(rawValue: 99) =", Planet(rawValue: 99) == nil ? "nil（不存在）" : "有值")

enum Currency: String {
    case cny = "CNY", usd = "USD", jpy = "JPY"
}
print("   Currency.usd.rawValue =", Currency.usd.rawValue)

// ─────────────────────────────────────────
// 三、关联值（每个 case 可以携带不同的数据）
// ─────────────────────────────────────────

enum Barcode {
    case upc(Int, Int, Int, Int)      // 条形码：4 个数字
    case qrCode(String)               // 二维码：一段文字
}

let productCode = Barcode.upc(8, 85909, 51226, 3)
let websiteCode = Barcode.qrCode("https://hacore.cn")

print("\n③ 关联值：")
for code in [productCode, websiteCode] {
    switch code {
    case .upc(let a, let b, let c, let d):
        print("   UPC 条形码：\(a)-\(b)-\(c)-\(d)")
    case .qrCode(let url):
        print("   QR 二维码：\(url)")
    }
}

// 真实场景：网络结果（很多第三方库的雏形）
enum NetworkResult {
    case success(data: String)
    case failure(code: Int, message: String)
}
let response = NetworkResult.failure(code: 404, message: "Not Found")
switch response {
case .success(let data):
    print("   请求成功：\(data)")
case .failure(let code, let message):
    print("   请求失败：\(code) \(message)")
}

// ─────────────────────────────────────────
// 四、枚举可以有属性和方法
// ─────────────────────────────────────────

enum BatteryLevel: Int {
    case empty = 0, low = 20, half = 50, full = 100

    // 计算属性
    var needsCharge: Bool { rawValue < 50 }

    // 方法
    func description() -> String {
        "电量 \(rawValue)%"
    }

    // mutating 方法可以改 self
    mutating func charge() {
        self = .full
    }
}

var battery = BatteryLevel.low
print("\n④ 枚举的方法：")
print("   \(battery.description()) ｜ 需要充电吗：\(battery.needsCharge ? "是" : "否")")
battery.charge()
print("   充电后：\(battery.description()) ｜ 需要充电吗：\(battery.needsCharge ? "是" : "否")")

// ─────────────────────────────────────────
// 五、CaseIterable（自动获得所有 case 的集合）
// ─────────────────────────────────────────

enum Fruit: String, CaseIterable {
    case apple = "🍎", orange = "🍊", grape = "🍇"
}
print("\n⑤ CaseIterable：")
print("   全部水果：", Fruit.allCases.map { $0.rawValue }.joined(separator: " "))
print("   数量：", Fruit.allCases.count)
// 常见用法：直接生成分段控件的选项
for fruit in Fruit.allCases {
    print("   选项：\(fruit.rawValue) \(fruit)")
}

// ─────────────────────────────────────────
// 六～十二、协议
// ─────────────────────────────────────────

print("\n⑥ 协议：")

protocol Describable {
    var summary: String { get }     // 要求提供一个可读属性
    func describe()                 // 要求实现这个方法
}

struct Book: Describable {
    let title: String
    let author: String

    var summary: String { "《\(title)》 by \(author)" }
    func describe() { print("   书籍：\(summary)") }
}

class Movie: Describable {
    let title: String
    let year: Int

    init(title: String, year: Int) { self.title = title; self.year = year }
    var summary: String { "\(title) (\(year))" }
    func describe() { print("   电影：\(summary)") }
}

// 协议作为类型：不管具体是什么，只要符合协议就能放进同一个数组
let items: [Describable] = [Book(title: "Swift 编程", author: "April"), Movie(title: "盗梦空间", year: 2010)]
for item in items {
    item.describe()     // 同一行代码，表现出不同行为 —— 这就是多态
}

// 协议继承
protocol Titled {
    var title: String { get }
}
protocol Detailed: Titled {          // Detailed 继承了 Titled 的要求
    var detail: String { get }
}

// 协议扩展：给所有符合者"免费"加上默认实现（Swift 的招牌功能）
extension Describable {
    func loudDescribe() {           // 不需要每个类型各自实现
        print("   【默认实现】" + summary.uppercased())
    }
}
print("\n⑦ 协议扩展（默认实现）：")
Book(title: "iOS 开发", author: "April").loudDescribe()
Movie(title: "星际穿越", year: 2014).loudDescribe()

// 协议组合：要求同时符合多个协议
protocol Named { var name: String { get } }
protocol Aged { var age: Int { get } }

struct Student: Named, Aged {
    let name: String
    let age: Int
}
func introduce(_ someone: Named & Aged) {     // & 组合多个协议
    print("   组合：我叫 \(someone.name)，\(someone.age) 岁")
}
print("\n⑧ 协议组合：")
introduce(Student(name: "小明", age: 18))

// ─────────────────────────────────────────
// 十三、⭐️ 面向协议编程（POP）实战
// ─────────────────────────────────────────

print("\n⑨ ⭐️ 面向协议编程实战：")

// 需求：多种支付方式都要能付钱，且共享同一个"打小票"的能力。
protocol Payable {
    var amount: Double { get }
    func pay() -> Bool
}

// 用扩展共享实现 —— 不用继承，也不会有"父类越来越臃肿"的问题
extension Payable {
    func receipt() -> String {
        "小票：金额 ¥\(String(format: "%.2f", amount))"
    }
}

struct Alipay: Payable {
    let amount: Double
    func pay() -> Bool { print("   支付宝支付 ¥\(amount)"); return true }
}

struct WechatPay: Payable {
    let amount: Double
    func pay() -> Bool { print("   微信支付 ¥\(amount)"); return true }
}

struct ApplePay: Payable {
    let amount: Double
    func pay() -> Bool { print("   Apple Pay 支付 ¥\(amount)"); return true }
}

// 上层只认协议 → 以后加新的支付方式，这里一行都不用改
func checkout(with methods: [Payable], total: Double) {
    print("   订单总额 ¥\(total)")
    var remain = total
    for method in methods {
        if remain <= 0 { break }
        _ = method.pay()
        print("      \(method.receipt())")     // 共享的扩展实现
        remain -= method.amount
    }
    print("   还需支付 ¥\(String(format: "%.2f", max(0, remain)))")
}

checkout(with: [Alipay(amount: 30), WechatPay(amount: 20)], total: 88)

print("\n✅ 2.5 完。对比一下：如果用「继承」实现上面的支付场景，是不是得先造一个 PaymentBase 父类？ Swift 推荐「协议 + 扩展」而不是深层继承。")
