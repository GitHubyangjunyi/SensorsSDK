//
//  UIApplication+SensorsData.m
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/25.
//

#import "UIApplication+SensorsData.h"
#import "SensorsAnalyticsSDK.h"
#import "NSObject+SASwizzler.h"
#import "UIView+SensorsData.h"

@implementation UIApplication (SensorsData)

//这是空间点击事件采集的第一种实现
-(BOOL)sensorsdata_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event
{
    //触发$AppClick事件
    //UISlider只会在滑动结束时进行处理
    if ([sender isKindOfClass:UISwitch.class] ||
        [sender isKindOfClass:UIStepper.class] ||
        [sender isKindOfClass:UISegmentedControl.class] || event.allTouches.anyObject.phase == UITouchPhaseEnded) {
        [[SensorsAnalyticsSDK sharedInstance] trackAppClickWithView:sender properties:nil];
    }
    //调用原有的实现
    return [self sensorsdata_sendAction:action to:target from:sender forEvent:event];
}

//这是空间点击事件采集的第一种实现
//+(void)load
//{
//    [UIApplication sensorsdata_swizzleMethod:@selector(sendAction:to:from:forEvent:) withMethod:@selector(sensorsdata_sendAction:to:from:forEvent:)];
//}

@end
