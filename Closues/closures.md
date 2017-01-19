# 闭包(Closure)

## 一、 闭包表达式
### 1. 闭包类似匿名函数
* 闭包类似匿名函数  
* 当一个函数的参数是闭包时,可以传入一个函数名,函数的参数和返回值类型要和闭包的参数和返回值类型相同

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backword(s1:String,s2:String) ->Bool
{
    return s1 > s2
}
let names2 = names.sorted(by: backword)
print("\(names2)")
```
> 上面的方法是将一个字符串数组降序排列  
> 在此例中，数组的`sorted`方法接收一个接收两个`String`类型的参数并返回一个`Bool`类型的返回值闭包  
> 但是在此例中是将`backword`函数传入`sorted`方法中，由此可见，与闭包拥有相同的参数列表和返回值的函数可以当做闭包来使用

### 2. 闭包语法表达式

```
{ (parameters) -> returnType in

    // statements
}
```
> 1. 闭包表达式，由花括号括起来；  
> 2. 包含参数列表，返回值类型；  
> 3. 使用`in` 关键字引入闭包表达式

### 3. 标准闭包表达式

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
let sortedNames = names.sorted(by: { (s1:String,s2:String) -> Bool in return s1 > s2})
print("\(sortedNames)")
```

> 1. 参数有圆括号括起来
> 2. 参数类型可由编译器类型推断,也可显式标注
> 3. 返回值类型要显示声明  

### 4. 根据上下文推断类型

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
let sortedNames = names.sorted(by: {s1,s2 -> Bool in return s1 > s2})
print("\(sortedNames)")
```

> 1. 参数的类型以及返回值的类型都由编译器推断  
> 2. 省略参数的圆括号时,参数的类型一定不能显式类型标注,而要由编译器隐式推断,否则报编译时错误  
> 3. 当返回值的类型可以由编译器推断出来时,返回值得类型可写可不写  

### 5. 单表达式闭包隐式返回

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
let sortedNames = names.sorted(by: {s1,s2 in  s1 > s2})
print("\(sortedNames)")
```

>1. 闭包体中只有一行表达式
>2. 表达式的返回类型可以推断出来
>3. `return` 关键字可以省略

### 6. 参数名称缩写

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
let sortedNames = names.sorted(by: {$0 > $1})
print("\(sortedNames)")
```

> 1. 内联闭包可以提供了参数名缩写功能,直接可以通过 `$0` `$1` `$2` 来顺序调用闭包的参数  
> 2. 如果在闭包表达式中使用了参数名称缩写,则可以在定义闭包时省略参数列表,不省略时会报错  
> 3. 参数名称缩写的类型会通过接收闭包作为参数的函数中参数的声明类型进行推断  
> 4. `in` 关键字也可以省略 ,不省略会报错

### 7. 运算符方法

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
let sortedNames = names.sorted(by: >)
print("\(sortedNames)")
```

>1. String 类型定义了关于大于号（`>`）的字符串实现 (`>` 相当于一个方法,用来比较两个字符串的大小)
>2. (`>`)作为一个函数接受两个 `String` 类型的参数并返回 `Bool` 类型的值.而这正好与 `sorted(by:)` 方法的参数需要的函数类型相符合
>3. 因此,可以简单地传递一个大于号，Swift 可以自动推断出你想使用大于号的字符串函数实现

## 二、 尾随闭包

### 1. 尾随闭包使用

* 当函数的参数列表中含有闭包时，并且闭包是最后一个参数，那么当调用函数时，可以将闭包写在函数的调用后面；
* 闭包作为函数的参数，当闭包中的内容过多时，将闭包写在函数的参数列表中容易造成程序的可读性很差，代码难理解；
* 使用尾随闭包就能解决代码换乱可读性差的问题，增加程序的可读性；


```
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数体部分
}

// 以下是不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure(closure: {
    // 闭包主体部分
})

// 以下是使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    // 闭包主体部分
}

// 以下是使用尾随闭包进行函数调用,并且省略 ()
someFunctionThatTakesAClosure {
    // 闭包主体部分
}
```

> 1. 函数要将闭包参数写在参数列表的最后面才能使用尾随闭包
> 2. 尾随闭包是写在函数圆括号后面的闭包表达式
> 3. 使用尾随闭包时,闭包中不用写出它的参数表示
> 4. 如果闭包表达式是函数或方法的唯一参数，则当你使用尾随闭包时，你甚至可以把 () 省略掉

## 三、 值捕获

* 闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。

### 1. 嵌套函数的值捕获

* 嵌套函数可以捕获其外部函数所有的参数以及定义的常量和变量。

```
func makeIncrementer(forAmount amount:Int) -> ()->Int
{
    var runningTotal = 0
    func incrementer() -> Int
    {
        runningTotal += amount
        return runningTotal
    }
    
    return incrementer
}

var inc = makeIncrementer(forAmount: 2)
print(inc())
print(inc())
print(inc())
print(inc())
print(inc())

```
> 1. 上面的函数返回值是 `() -> Int` 类型,返回值是一个函数而不是普通的值  
> 2. 返回的函数不接收参数,每次调用返回一个`Int`数值  
> 3. 单独考虑嵌套函数 `incrementer()`，会发现它有些不同寻常  
> 4. `incrementer()` 函数并没有任何参数，但是在函数体内访问了 `runningTotal` 和 `amount` 变量  
> 5. 这是因为它从外围函数捕获了 `runningTotal` 和 `amount` 变量的 __引用__。  
> 6. 捕获引用保证了 `runningTotal` 和 `amount` 变量在调用完 `makeIncrementer` 后不会消失，并且保证了在下一次执行 `incrementer` 函数时，`runningTotal` 依旧存在。  

## 四、 闭包是引用类型

### 1. 闭包和函数都是引用类型

> 1. 函数和闭包都是引用类型。  
> 2. 无论你将函数或闭包赋值给一个常量还是变量，你实际上都是将常量或变量的值设置为对应函数或闭包的引用  
> 3. 上面的例子中，指向闭包的引用 <#inc#> 是一个常量，而并非闭包内容本身。
    
>> NB: 当闭包作为类的实例属性时,要注意循环引用(因为闭包是引用类型,类实例也是引用类型,两者相互引用会造成循环引用)  

## 五、 逃逸闭包

* 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸  
* 当你定义接受闭包作为参数的函数时，你可以在参数名之前标注 `@escaping`，用来指明这个闭包是允许“逃逸”出这个函数的。  
* 一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中  
* e.g: 举个例子，很多启动异步操作的函数接受一个闭包参数作为 completion handler。这类函数会在异步操作开始之后立刻返回，但是闭包直到异步操作结束后才会被调用。 在这种情况下，闭包需要“逃逸”出函数，因为闭包需要在函数返回之后被调用。

### 1. 逃逸闭包例子

```
var comletionHandlers:[()->Void] =  []
func someFunctionWithEscapingClosure(comletionHandler: @escaping ()->Void)
{
    comletionHandlers.append(comletionHandler)
}
```
> 1. `someFunctionWithEscapingClosure(_:)` 函数接受一个闭包作为参数，该闭包被添加到一个函数外定义的数组中
> 2. 如果你不将这个参数标记为 `@escaping`，就会得到一个编译错误。

### 2. 逃逸闭包必须显示引用`self`

* 将一个闭包标记为 `@escaping` 意味着你必须在闭包中显式地引用 `self`

```
func someFunctionWithNonescapingClosure(closure: ()->Void)
{
    closure()
}

class SomeClass {
    var x = 10;
    func doSomething(){
        someFunctionWithEscapingClosure { self.x = 100 } // 尾随逃逸闭包
        someFunctionWithNonescapingClosure { x = 100 }   // 普通尾随闭包
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
```
> 2. 在上面的代码中，传递到 `someFunctionWithEscapingClosure(_:)` 中的闭包是一个逃逸闭包，这意味着它需要显式地引用 `self`。省略`self`会报错。
> 3. 相对的，传递到 `someFunctionWithNonescapingClosure(_:)` 中的闭包是一个非逃逸闭包，这意味着它可以隐式引用 `self`。

## 六、 自动闭包

* 自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。  
* 这种闭包不接受任何参数，当它被调用的时候，会__返回被包装在其中的表达式的值__。  
* 这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。  
* 自动闭包让你能够延迟求值，因为直到你调用这个闭包，代码段才会被执行。  
* 延迟求值对于那些有副作用（Side Effect）和高计算成本的代码来说是很有益处的，因为它使得你能控制代码的执行时机。

### 1. 下面的代码展示了闭包如何延时求值。

```
var customersInLine = ["Chris","Alex","Ewa","Barry","Daniella"]
print(customersInLine.count)
// 打印出 "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// 打印出"5"

print("Now serving \(customerProvider())!")
// 打印出"Now serving Chris!"
print(customersInLine.count)
// 打印出"4"
```

> 1. 尽管在闭包的代码中，`customersInLine` 的第一个元素被移除了，不过在闭包被调用之前，这个元素是不会被移除的。  
> 2. 如果这个闭包永远不被调用，那么在闭包里面的表达式将永远不会执行，那意味着列表中的元素永远不会被移除。  
> NB: `customerProvider` 的类型不是 `String`，而是 `() -> String`，一个没有参数且返回值为 `String` 的函数。  

### 2. 闭包作为参数传递给函数时，能获得同样的延时求值行为

```
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// 打印出 "Now serving Alex!"
```
> 1. `serve(customer:)` 函数接受一个返回顾客名字的显式的闭包。

### 3. 自动闭包作为函数的参数

```
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure ()->String)
{
    print("Now serving \(customerProvider())")
}
serve(customer: customersInLine.remove(at: 0))
// 打印出"Now serving Ewa"
```

>1. 上面这个版本的 `serve(customer:)` 完成了相同的操作，不过它并没有接受一个显式的闭包，而是通过将参数标记为 `@autoclosure` 来接收一个自动闭包。  
>2. 现在你可以将该函数当作接受 `String` 类型参数（而非闭包）的函数来调用。  
>3. customerProvider 参数将自动转化为一个闭包，因为该参数被标记了 `@autoclosure` 特性。  
> NB: 过度使用 autoclosures 会让你的代码变得难以理解。上下文和函数名应该能够清晰地表明求值是被延迟执行的。  

## 七、 逃逸自动闭包

* 如果你想让一个自动闭包可以“逃逸”，则应该同时使用 `@autoclosure` 和 `@escaping` 属性。

```
// customersInLine i= ["Barry", "Daniella"]
var customerProviders:[()->String] = []
func collectCustomerProviders(_ customerProvider:@autoclosure @escaping ()->String)
{
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collect \(customerProviders.count) closures.");
// 打印"Collect 2 closures."
for customerProvider in customerProviders
{
    print("Now serving \(customerProvider())!")
}
// 打印 "Now serving Barry!"
// 打印 "Now serving Daniella!"
```

>1. 在下面的代码中，`collectCustomerProviders(_:)` 函数并没有调用传入的 `customerProvider` 闭包，而是将闭包追加到了 `customerProviders` 数组中。  
>2. 这个数组定义在函数作用域范围外，这意味着数组内的闭包能够在函数返回之后被调用  
>3. 因此，`customerProvider` 参数必须允许“逃逸”出函数作用域。  
