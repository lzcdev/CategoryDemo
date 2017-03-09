//
//  ViewController.m
//  Category
//
//  Created by LuzhiChao on 17/3/9.
//  Copyright © 2017年 LuzhiChao. All rights reserved.
//

#import "ViewController.h"
#import "MyClass.h"
#import "MyClass+MyAddition.h"
#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyClass *class = [[MyClass alloc]init];
    [class printName]; //执行分类的方法打印的是myAdditionClass
    
    
    Class currentClass = [MyClass class];
    MyClass *my = [[MyClass alloc] init];
    if (currentClass) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);// 方法列表（包含主类和分类中的方法）
        IMP lastImp = NULL;
        SEL lastSel = NULL;
        
        Method method = methodList[methodCount-1]; // 直接找到最后一个方法，因为我们已经知道了方法列表中分类的方法在主类方法的前面。
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                                  encoding:NSUTF8StringEncoding]; // 方法名
        if ([@"printName" isEqualToString:methodName]) {// 找到我们需要找的方法，得到方法实现的指针和方法名的指针
            lastImp = method_getImplementation(method);
            lastSel = method_getName(method);
        }
        
        typedef void (*fn)(id,SEL); // 定义一个函数
        
        if (lastImp != NULL) {
            fn f = (fn)lastImp;
            f(my,lastSel); // 执行找到的主类的方法，打印的是myClass
        }
        free(methodList);
    }
}



@end
