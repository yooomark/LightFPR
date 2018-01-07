//
//  ViewController.m
//  ReactiveOCDemo
//
//  Created by yomark on 2018/1/6.
//  Copyright © 2018年 yomark. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong, readwrite) Signal<NSString *> *userNameSignal;
@property (nonatomic, strong, readwrite) Signal<NSString *> *passwordSignal;

@property (nonatomic, strong) ViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.userNameSignal = [[Signal<NSString *> alloc] initWithValue:self.userNameTextField.text];
    self.passwordSignal = [[Signal<NSString *> alloc] initWithValue:self.passwordTextField.text];
    
    self.viewModel = [[ViewModel alloc] initWithView:self];
    
    @weakify(self);
    [self.viewModel.loginEnableSignal subscribeNext:^(NSNumber *value) {
        @strongify(self);
        BOOL isEnable = [value boolValue];
        self.loginButton.enabled = isEnable;
    }];
    
    [self.userNameTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [self.passwordTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventAllEditingEvents];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textDidChanged:(id)sender
{
    if (sender == self.userNameTextField)
    {
        [self.userNameSignal update:self.userNameTextField.text];
    }
    else if (sender == self.passwordTextField)
    {
        [self.passwordSignal update:self.passwordTextField.text];
    }
}

@end
