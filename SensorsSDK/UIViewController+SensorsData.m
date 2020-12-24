//
//  UIViewController+SensorsData.m
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/20.
//

#import "UIViewController+SensorsData.h"
#import "SensorsAnalyticsSDK.h"
#import "NSObject+SASwizzler.h"

static NSString *const kSensorsDataBlackListFileName = @"sensorsdata_black_list";

@implementation UIViewController (SensorsData)

-(void)sensorsdata_viewDidAppear:(BOOL)animated
{
    //不会形成递归循环是因为方法实现交换了
    [self sensorsdata_viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if ([self shouldTrackAppViewScreen]) {
        NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:NSStringFromClass([self class]) forKey:@"$screen_name"];
        //navigationItem.titleView的优先级高于navigationItem.title
        NSString *title = [self contentFromView:self.navigationItem.titleView];
        if (title.length == 0) {
            title = self.navigationItem.title;
        }
        [properties setValue:self.navigationItem.title forKey:@"title"];
        [[SensorsAnalyticsSDK sharedInstance] track:@"$AppViewScreen" properties:properties];
    }
}

+(void)load
{
    [UIViewController sensorsdata_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(sensorsdata_viewDidAppear:)];
}

-(BOOL)shouldTrackAppViewScreen
{
    //静态变量配合dispatch_once避免频繁读写
    static NSSet *blackList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //根据当前类获取NSBundle
        NSString *path = [[NSBundle bundleForClass:SensorsAnalyticsSDK.class] pathForResource:kSensorsDataBlackListFileName ofType:@"plist"];
        NSArray *className = [NSArray arrayWithContentsOfFile:path];
        NSMutableSet *set = [NSMutableSet setWithCapacity:className.count];
        for (NSString *name in className) {
            [set addObject:NSClassFromString(name)];
        }
        blackList = [set copy];
    });
    
    //黑名单中的视图控制器不采集浏览事件
    for (Class cla in blackList) {
        //是否是cla类或其子类
        if ([self isKindOfClass:cla]) {
            return false;
        }
    }
    return true;
}

//收集各级标题
-(NSString *)contentFromView:(UIView *)rootView
{
    if (rootView.isHidden) {
        return nil;
    }
    
    NSMutableString *elementContent = [NSMutableString string];
    
    if ([rootView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)rootView;
        NSString *title = button.titleLabel.text;
        if (title.length > 0) {
            [elementContent appendString:title];
        }
    } else if ([rootView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)rootView;
        NSString *title = label.text;
        if (title.length > 0) {
            [elementContent appendString:title];
        }
    } else if ([rootView isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)rootView;
        NSString *title = textView.text;
        if (title.length > 0) {
            [elementContent appendString:title];
        }
    } else {
        NSMutableArray<NSString *> *elementContentArray = [NSMutableArray array];
        for (UIView *subView in rootView.subviews) {
            NSString *temp = [self contentFromView:subView];
            if (temp.length > 0) {
                [elementContentArray addObject:temp];
            }
        }
        if (elementContentArray.count > 0) {
            [elementContent appendString:[elementContentArray componentsJoinedByString:@"-"]];
        }
    }
    
    return [elementContent copy];
}

@end
