//
//  Signal.h
//  ReactiveOCDemo
//
//  Created by yomark on 2018/1/6.
//  Copyright © 2018年 yomark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "extobjc/extobjc.h"

@interface Signal<__covariant T> : NSObject

typedef NSString SignalToken;
typedef void (^subscribeBlock)(T value);

@property (nonatomic, strong, readonly) T value;

- (instancetype)initWithValue:(T)value;

- (SignalToken *)subscribeNext:(subscribeBlock)subscriber;
- (SignalToken *)subscribeNextWithReplayLast:(subscribeBlock)subscriber;
- (void)unscrible:(SignalToken *)token;

- (SignalToken *)bind:(Signal<T> *)signal;
- (void)unbind:(SignalToken *)token;

- (void)update:(T)value;
- (T)peek;

@end
