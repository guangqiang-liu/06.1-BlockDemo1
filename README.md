# 06.1-block变量的捕获

在讲解block变量的捕获之前，我们先来看看OC中的变量大致分为哪几类：

* 局部变量
	* 自动变量
	* 静态变量
* 全局变量

我们在`main`函数内创建一个auto变量`age`和一个static变量`height`，`main`函数外创建一个全局变量`weight`，代码如下：

```
// 全局变量
int weight = 30;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // 自动变量，默认省略了`auto`关键字
        int age = 10;
        
        // 静态变量
        static int height = 20;
        
        void (^block)(void) = ^() {
            NSLog(@"%d", age); // 10
            NSLog(@"%d", height); // 200
            NSLog(@"%d", weight); // 300
        };
        
        age = 100;
        height = 200;
        weight = 300;
        
        block();
    }
    return 0;
}
```

我们执行命令，将`main.m`转换为c++代码

```
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        int age = 10;
        static int height = 20;

        void (*block)(void) = &__main_block_impl_0(
                                                   __main_block_func_0,
                                                   &__main_block_desc_0_DATA,
                                                   age,
                                                   // 可以看到height这里是将变量的内存地址作为参数传递
                                                   &height
                                                );
        age = 100;
        height = 200;
        weight = 300;

        block->FuncPtr(block);
    }
    return 0;
}
```

`block`结构体对象：

```
// 全局变量
int weight = 30;

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  
  // auto变量
  int age;
  
  // static变量
  int *height;
  
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int *_height, int flags=0) : age(_age), height(_height) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

我们在创建一个`Person`类验证变量的捕获，代码如下：

```
@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

- (void)test;
@end

@implementation Person

- (void)test {

    void (^block)(void) = ^{
    		// 注意：block内虽然没有写self，但是_name等价于 self->_name
        NSLog(@"--%@", _name); // 111
    };
    
    block();
}
@end
```

我们修改下`main`函数代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [[Person alloc] init];
        person.name = @"111";
        
        [person test];
    }
    return 0;
}
```

然后我们将`Person.m`文件转换为c++代码如下：

`test`函数：

```
/**
	这里我们发现test函数默认有两个参数`self`和_cmd，这两个参数是函数的默认隐式参数。
	self：调用当前函数的对象
	_cmd：函数名
*/
static void _I_Person_test(Person * self, SEL _cmd) {

	void (*block)(void) = &__Person__test_block_impl_0(
                                                       __Person__test_block_func_0,
                                                       &__Person__test_block_desc_0_DATA,
                                                       self,
                                                       570425344
                                                       );
    block->FuncPtr(block);
}
```

`__Person__test_block_impl_0`block结构体：

```
struct __Person__test_block_impl_0 {
  struct __block_impl impl;
  struct __Person__test_block_desc_0* Desc;
  
  // 将当前Person对象self捕获到block结构体内
  Person *self;
  
  __Person__test_block_impl_0(void *fp, struct __Person__test_block_desc_0 *desc, Person *_self, int flags=0) : self(_self) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

从上面转换的底层c++代码分析，我们可以得出结论入下图所示：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200205-150436@2x.png)


讲解示例Demo地址：[https://github.com/guangqiang-liu/06.1-BlockDemo1]()


## 更多文章
* ReactNative开源项目OneM(1200+star)：**[https://github.com/guangqiang-liu/OneM](https://github.com/guangqiang-liu/OneM)**：欢迎小伙伴们 **star**
* iOS组件化开发实战项目(500+star)：**[https://github.com/guangqiang-liu/iOS-Component-Pro]()**：欢迎小伙伴们 **star**
* 简书主页：包含多篇iOS和RN开发相关的技术文章[http://www.jianshu.com/u/023338566ca5](http://www.jianshu.com/u/023338566ca5) 欢迎小伙伴们：**多多关注，点赞**
* ReactNative QQ技术交流群(2000人)：**620792950** 欢迎小伙伴进群交流学习
* iOS QQ技术交流群：**678441305** 欢迎小伙伴进群交流学习