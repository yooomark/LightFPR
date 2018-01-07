//
//  ViewController.h
//  ReactiveOCDemo
//
//  Created by yomark on 2018/1/6.
//  Copyright © 2018年 yomark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Signal.h"

@interface ViewController : UIViewController

@property (nonatomic, strong, readonly) Signal<NSString *> *userNameSignal;
@property (nonatomic, strong, readonly) Signal<NSString *> *passwordSignal;

@end

