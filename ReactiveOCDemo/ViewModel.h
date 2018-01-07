//
//  ViewModel.h
//  ReactiveOCDemo
//
//  Created by yomark on 2018/1/7.
//  Copyright © 2018年 yomark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Signal.h"

@class ViewController;

@interface ViewModel : NSObject

@property (nonatomic, strong, readonly) Signal<NSNumber *> *loginEnableSignal;

- (instancetype)initWithView:(ViewController *)view;

@end
