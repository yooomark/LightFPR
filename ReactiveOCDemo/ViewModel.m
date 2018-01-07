//
//  ViewModel.m
//  ReactiveOCDemo
//
//  Created by yomark on 2018/1/7.
//  Copyright © 2018年 yomark. All rights reserved.
//

#import "ViewModel.h"
#import "ViewController.h"

@interface ViewModel ()

@property (nonatomic, weak) ViewController *view;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

@end

@implementation ViewModel

- (instancetype)initWithView:(ViewController *)view
{
    if (self = [super init])
    {
        _view = view;
        
        _loginEnableSignal = [[Signal<NSNumber *> alloc] initWithValue:@NO];
        
        @weakify(self);
        [_view.userNameSignal subscribeNextWithReplayLast:^(NSString *value) {
            @strongify(self);
            self.userName = value;
            [self checkLoginValid];
        }];
        
        [_view.passwordSignal subscribeNextWithReplayLast:^(NSString *value) {
            @strongify(self);
            self.password = value;
            [self checkLoginValid];
        }];
    }
    return self;
}

#pragma mark - Private

- (void)checkLoginValid
{
    if ([self.userName length] == 0 || [self.password length] == 0)
    {
        [self.loginEnableSignal update:@NO];
    }
    else if ([self.userName isEqualToString:@"admin"] && [self.password isEqualToString:@"Abc123"])
    {
        [self.loginEnableSignal update:@YES];
    }
    else
    {
        [self.loginEnableSignal update:@NO];
    }
}

@end
