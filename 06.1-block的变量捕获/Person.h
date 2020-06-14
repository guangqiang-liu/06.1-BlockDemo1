//
//  Person.h
//  06.1-block的变量捕获
//
//  Created by 刘光强 on 2020/2/5.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

- (void)test;
@end

NS_ASSUME_NONNULL_END
