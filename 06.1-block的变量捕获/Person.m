//
//  Person.m
//  06.1-block的变量捕获
//
//  Created by 刘光强 on 2020/2/5.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)test {
    void (^block)(void) = ^{
        NSLog(@"--%@", _name);
    };
    
    block();
}
@end
