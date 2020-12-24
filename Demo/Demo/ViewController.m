//
//  ViewController.m
//  Demo
//
//  Created by 杨俊艺 on 2020/12/1.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:UIColor.lightGrayColor];
    
    
    self.title = @"标题1";
    self.navigationItem.title = @"标题2";
    
    UILabel *customTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    customTitleView.text = @"标题3";
    customTitleView.font = [UIFont systemFontOfSize:18];
    customTitleView.textColor = [UIColor blackColor];
    customTitleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customTitleView;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"重写时必须调用[super viewDidAppear:animated]否则不会触发页面浏览事件");
}

@end
