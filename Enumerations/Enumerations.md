<span id="top"></span>
# 枚举（Enumerations）
* [枚举语法](#枚举语法)  
* [使用Switch语句匹配枚举值](#使用Switch语句匹配枚举值)    
* [关联值](#关联值)  
* [原始值](#原始值)    
 *	[原始值的隐式赋值](#原始值的隐式赋值)  
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



## <span id="原始值">原始值</span>

### <span id="原始值的隐式赋值">原始值的隐式赋值</span>

## <span id="递归枚举">递归枚举</span>










<div style="position: fixed;bottom: 100px;left: 50%;margin-left: 400px;">
    <a href="#top" style ="display: block;width: 38px;height: 38px;background-color: #ddd;border-radius: 3px;border: 0;cursor: pointer;position: relative;display: block;">
        <div style ="position: relative;width: 0;height: 0;top: -1px;border: 9px solid transparent;border-bottom-color: #aaa; margin-left: 10px;"></div>
        <div style ="position: relative;width: 8px;height: 14px;top: -1px;border-radius: 1px;background-color: #aaa;margin-left: 15px;"></div>
    </a>
</div>