<span id="top"></span>
# 枚举（Enumerations）
* [枚举语法](#枚举语法)  
* [使用Switch语句匹配枚举值](#使用Switch语句匹配枚举值)    
* [关联值](#关联值)  
* [原始值](#原始值)    
 *	[原始值的隐式赋值](#原始值的隐式赋值)  
 * [使用原始值初始化枚举实例](#使用原始值初始化枚举实例)
* [递归枚举](#递归枚举)  

* 枚举为一组相关的值定义了一个共同的类型，使你可以在你的代码中以类型安全的方式来使用这些值。
* Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。如果给枚举成员提供一个值（称为“原始”值），则该值的类型可以是字符串，字符，或是一个整型值或浮点数。
* 枚举成员可以指定***任意***类型的关联值存储到枚举成员中，就像其他语言中的联合体（unions）和变体（variants）。你可以在一个枚举中定义一组相关的枚举成员，每一个枚举成员都可以有适当类型的关联值。
* 枚举类型是一等（first-class）类型。它们采用了很多在传统上只被类（class）所支持的特性，例如计算属性（computed properties），用于提供枚举值的附加信息，实例方法（instance methods），用于提供和枚举值相关联的功能。
* 枚举也可以定义构造函数（initializers）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（protocols）来提供标准的功能。

##  <span id="枚举语法">枚举语法</span>

```swift
enum SomeEnumeration 
{
   // 枚举定义放在这里
}
```
* 下面的例子使用枚举表示指南针的四个方向的例子：      

```swift
enum CompassPoint
{
  	case north
  	case south
  	case east
  	case west
}
```
> 注意
>
> 与 C 和 Objective-C 不同，Swift 的枚举成员在被创建时不会被赋予一个默认的整型值。
>
> 在上面的`CompassPoint`例子中，`north`，`south`，`east`和`west`不会被隐式地赋值为`0`，`1`，`2`和`3`。相反，这些枚举成员本身就是完备的值，这些值的类型是已经明确定义好的`CompassPoint`类型。

* 多个枚举成员可以出现在同一行上，用逗号隔开：

```swift
enum Planet {
	case mercury, venus,earth, mars, jupiter,saturn, uranus, neptune
}
```

* 每个枚举定义了一个全新的类型。像 Swift 中其他类型一样，它们的名字（例如`CompassPoint`和`Planet`）应该以一个大写字母开头。给枚举类型起一个单数名字而不是复数名字，以便于读起来更加容易理解：

```swift
var directionToHead = CompassPoint.west
```
`directionToHead`的类型可以在它被`CompassPoint`的某个值初始化时推断出来，一旦`directionToHead`被声明为`CompassPoint`类型，你可以使用更剪短的点语法将其设置为另一个`CompassPoint`的值

```swift
directionToHead = .east
```
> 1. 当directionToHead的类型已知时，再次为其赋值可以省略枚举类型名。
> 2. 在使用具有显式类型的枚举值时(`CompassPoint.east`)，这种写法让代码具有更好的可读性。

## <span id="使用Switch语句匹配枚举值">使用Switch语句匹配枚举值</span>  
* 你可以使用switch语句匹配单个枚举值：

```swift
directionToHead = .south

switch directionToHead {
case .north:
    print("北方")
case .south:
    print("南方")
case .east:
    print("东方")
case .west:
    print("西方")
}

// 打印出"南方"
```
> 枚举是条件完备的类型，不需要写`default`分支。当不需要匹配每个枚举成员的时候，你可以提供一个default分支来涵盖所有未明确处理的枚举成员

## <span id="关联值">关联值</span> 

* 有时候能够把其他类型的关联值和成员值一起存储起来会很有用。这能让你连同成员值一起存储额外的自定义信息，并且你每次在代码中使用该枚举成员时，还可以修改这个关联值。 
* 可以定义 Swift 枚举来存储任意类型的关联值，如果需要的话，每个枚举成员的关联值类型可以各不相同。

例如，假设一个库存跟踪系统需要利用两种不同类型的条形码来跟踪商品。有些商品上标有使用0到9的数字的 UPC 格式的一维条形码。每一个条形码都有一个代表“数字系统”的数字，该数字后接五位代表“厂商代码”的数字，接下来是五位代表“产品代码”的数字。最后一个数字是“检查”位，用来验证代码是否被正确扫描：


其他商品上标有 QR 码格式的二维码，它可以使用任何 ISO 8859-1 字符，并且可以编码一个最多拥有 2,953 个字符的字符串：


这便于库存跟踪系统用包含四个整型值的元组存储 UPC 码，以及用任意长度的字符串储存 QR 码。  
在 Swift 中，使用如下方式定义表示两种商品条形码的枚举：

```swift
enum BarCode {
    case upc(Int,Int,Int,Int)
    case qrCode(String)
}

var productBarCode = BarCode.upc(8, 85909, 51226, 3)
productBarCode = .qrCode("我是二维码的内容")
print(productBarCode)

```

* 关联值可以被提取出来作为 switch 语句的一部分。
* 你可以在switch的 case 分支代码中提取每个关联值作为一个常量（用let前缀）或者作为一个变量（用var前缀）来使用：


```swift
switch productBarCode
{
case .upc(let numberSystem,let manufacturer,let product,let check):
    print("UPC:\(numberSystem),\(manufacturer),\(product),\(check)")
case .qrCode(let productCode):
    print("QR code: \(productCode)")
}

```

* 如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个let或者var：

```swift
switch productBarCode
{
case let .upc(numberSystem,manufacturer,product,check):
    print("UPC:\(numberSystem),\(manufacturer),\(product),\(check)")
case var .qrCode(productCode):
    print("QR code: \(productCode)")
    productCode = "ABC"
    print(productBarCode)
    print(productCode)
    productBarCode = .qrCode("另一个二维码")
}
```

## <span id="原始值">原始值</span>

* 作为关联值的替代选择，枚举成员可以被默认值（称为原始值）预填充，这些原始值的类型必须相同。

```
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```

> 枚举类型ASCIIControlCharacter的原始值类型被定义为Character，并设置了一些比较常见的 ASCII 控制字符  
> 原始值可以是字符串，字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的  
> 
> __注意__  
> 原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。

### <span id="原始值的隐式赋值">原始值的隐式赋值</span>

* 在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。
* 当使用整数作为原始值时，隐式赋值的值依次递增1。如果第一个枚举成员没有设置原始值，其原始值将为0。
* 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。

下面的枚举是对之前Planet这个枚举的一个细化，利用整型的原始值来表示每个行星在太阳系中的顺序：

```swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```
> 在上面的例子中，Plant.mercury的显式原始值为1，Planet.venus的隐式原始值为2，依次类推。


下面的例子是CompassPoint枚举的细化，使用字符串类型的原始值来表示各个方向的名称：

```swift
enum CompassPoint: String {
    case north, south, east, west
}
```
> 上面例子中，CompassPoint.south拥有隐式原始值south，依次类推。

* 使用枚举成员的rawValue属性可以访问该枚举成员的原始值：

```swift
let earthsOrder = Planet.earth.rawValue
// earthsOrder 值为 3

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection 值为 "west"
```
#### <span id="使用原始值初始化枚举实例">使用原始值初始化枚举实例</span>

* 如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做rawValue的参数，参数类型即为原始值类型，返回值则是枚举成员或nil。
* 你可以使用这个初始化方法来创建一个新的枚举实例。

这个例子利用原始值7创建了枚举成员uranus：

```
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet 类型为 Planet? 值为 Planet.uranus
```

* 然而，并非所有Int值都可以找到一个匹配的行星。
* 因此，原始值构造器总是返回一个可选的枚举成员。
* 在上面的例子中，possiblePlanet是Planet?类型，或者说“可选的Planet”。

> __注意__  
> 原始值构造器是一个可失败构造器，因为并不是每一个原始值都有与之对应的枚举成员。


* 如果你试图寻找一个位置为11的行星，通过原始值构造器返回的可选`Planet`值将是`nil`：

```swift
let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
// 输出 "There isn't a planet at position 11
```

这个例子使用了可选绑定（optional binding），试图通过原始值11来访问一个行星。`if let somePlanet = Planet(rawValue: 11)`语句创建了一个可选`Planet`，如果可选`Planet`的值存在，就会赋值给`somePlanet`。在这个例子中，无法检索到位置为11的行星，所以else分支被执行。






## <span id="递归枚举">递归枚举</span>

* 递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。
* 使用递归枚举时，编译器会插入一个间接层。
* 你可以在枚举成员前加上indirect来表示该成员可递归。


例如，下面的例子中，枚举类型存储了简单的算术表达式：

```swift
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

你也可以在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的：

```swift
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

```swift
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
```

要操作具有递归性质的数据结构，使用递归函数是一种直截了当的方式。例如，下面是一个对算术表达式求值的函数：

```swift
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
// 打印 "18"
```
该函数如果遇到纯数字，就直接返回该数字的值。如果遇到的是加法或乘法运算，则分别计算左边表达式和右边表达式的值，然后相加或相乘。







<div style="position: fixed;bottom: 100px;left: 50%;margin-left: 400px;">
    <a href="#top" style ="display: block;width: 38px;height: 38px;background-color: #ddd;border-radius: 3px;border: 0;cursor: pointer;position: relative;display: block;">
        <div style ="position: relative;width: 0;height: 0;top: -1px;border: 9px solid transparent;border-bottom-color: #aaa; margin-left: 10px;"></div>
        <div style ="position: relative;width: 8px;height: 14px;top: -1px;border-radius: 1px;background-color: #aaa;margin-left: 15px;"></div>
    </a>
</div>