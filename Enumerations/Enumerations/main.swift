//
//  main.swift
//  Enumerations
//
//  Created by Yubin on 2017/1/19.
//  Copyright © 2017年 X. All rights reserved.
//

import Foundation

// MARK:- 枚举
enum CompassPoint {
    case north
    case south
    case east
    case west
}

//MARK:- 多个成员在同一行上
enum Plant
{
    case mercury, venus,earth, mars, jupiter,saturn, uranus, neptune
}

var directionToHead = CompassPoint.west

directionToHead = .east
print(directionToHead)

// MARK:- Switch 匹配枚举值
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

// MARK:- 关联值
enum BarCode {
    case upc(Int,Int,Int,Int)
    case qrCode(String)
}

var productBarCode = BarCode.upc(8, 85909, 51226, 3)
productBarCode = .qrCode("我是二维码的内容")
print(productBarCode)


// 关联值可以被提取出来作为 switch 语句的一部分。
// 你可以在switch的 case 分支代码中提取每个关联值作为一个常量（用let前缀）或者作为一个变量（用var前缀）来使用：
switch productBarCode
{
case .upc(let numberSystem,let manufacturer,let product,let check):
    print("UPC:\(numberSystem),\(manufacturer),\(product),\(check)")
case .qrCode(let productCode):
    print("QR code: \(productCode)")
}

// 如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个let或者var：
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

// MARK:- 原始值（原始值的类型必须相同）
enum ASCIIControlCharacter:Character
{
    case tab            = "\t"
    case lineFeed       = "\n"
    case carriageReturn = "\r"
}

// MARK:- 原始值隐式赋值
/*-----------------------------------------------------------------------------------------------------------
 | 1: 在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。
 | 2: 当使用整数作为原始值时，隐式赋值的值依次递增1。如果第一个枚举成员没有设置原始值，其原始值将为0。
 | 3: 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
 -----------------------------------------------------------------------------------------------------------*/
// 数字类型的枚举值
enum Plants:Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
// 字符串类型的枚举值
enum CompassPointRaw:String {
    case north,south,east,west
}

print(Plants.mercury.rawValue)
print(CompassPointRaw.north.rawValue)


// MARK:- 使用原始值初始化枚举实例
/*-----------------------------------------------------------------------------------------------------------
 | 1: 如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做rawValue的参数，参数类型即为原始值类型，返回值则是枚举成员或nil。你可以使用这个初始化方法来创建一个新的枚举实例。
 | 2: 原始值构造器是一个可失败构造器，因为并不是每一个原始值都有与之对应的枚举成员。
 -----------------------------------------------------------------------------------------------------------*/
let possiblePlant = Plants(rawValue: 7)
print(possiblePlant)

// 如果你试图寻找一个位置为11的行星，通过原始值构造器返回的可选Planet值将是nil：
let positionToFind = 11
if let somePlant = Plants(rawValue: positionToFind)
{
    switch somePlant {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
}
else
{
    print("There isn't a plant at position \(positionToFind)")
}
// 输出 "There isn't a planet at position 11

// MARK:- 递归枚举
/*-----------------------------------------------------------------------------------------------------------
 | 1: 递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。
 | 2: 使用递归枚举时，编译器会插入一个间接层。
 | 3: 你可以在枚举成员前加上indirect来表示该成员可递归。
 -----------------------------------------------------------------------------------------------------------*/

// 你也可以在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的：
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression,ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression,ArithmeticExpression)
}
// 下面的代码展示了使用ArithmeticExpression这个递归枚举创建表达式(5 + 4) * 2
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

// 要操作具有递归性质的数据结构，使用递归函数是一种直截了当的方式。
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

