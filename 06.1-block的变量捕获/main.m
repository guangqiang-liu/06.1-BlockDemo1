//
//  main.m
//  06.1-block的变量捕获
//
//  Created by 刘光强 on 2020/2/5.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int weight = 30;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        int age = 10;
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
        
        Person *person = [[Person alloc] init];
        person.name = @"111";
        
        [person test];
    }
    return 0;
}
