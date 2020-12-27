//
//  UIControl+SensorsData.m
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/27.
//

#import "UIControl+SensorsData.h"
#import "SensorsAnalyticsSDK.h"
#import "NSObject+SASwizzler.h"

@implementation UIControl (SensorsData)

-(void)sensorsdata_didMoveToSuperView
{
    [self sensorsdata_didMoveToSuperView];
    
    //判断是否是特殊的不响应UIControlEventTouchDown事件的控件
    if ([self isKindOfClass:UISwitch.class] || [self isKindOfClass:UIStepper.class] ||
        [self isKindOfClass:UISegmentedControl.class] || [self isKindOfClass:UISlider.class]) {
        [self addTarget:self action:@selector(sensorsdata_valueChangedAction:event:) forControlEvents:UIControlEventValueChanged];
    } else {
        [self addTarget:self action:@selector(sensorsdata_touchDownAction:event:) forControlEvents:UIControlEventTouchDown];
    }
}

-(BOOL)sensorsdata_isAddMultipleTargetActionsWithDefaultControlEvent:(UIControlEvents)defaultControlEvent
{
    //说明添加了多个Target说明添加了Target可以正常触发
    if (self.allTargets.count >= 2) {
        return true;
    }
    //如果控件本身为目标并且添加了除了defaultControlEvent类型的Action则说明开发者添加了Action可以正常触发
    if ((self.allControlEvents & UIControlEventAllEvents) != defaultControlEvent) {
        return true;
    }
    //如果控件本身为目标并且添加了两个以上的defaultControlEvent类型的Action说明开发者添加了Action可以正常触发
    if ([self actionsForTarget:self forControlEvent:defaultControlEvent].count >= 2) {
        return true;
    }
    return false;
}

-(void)sensorsdata_touchDownAction:(UIControl *)sender event:(UIEvent *)event
{
    if ([self sensorsdata_isAddMultipleTargetActionsWithDefaultControlEvent:UIControlEventTouchDown]) {
        [[SensorsAnalyticsSDK sharedInstance] trackAppClickWithView:sender properties:nil];
    }
}

-(void)sensorsdata_valueChangedAction:(UIControl *)sender event:(UIEvent *)event
{
    //只有在手抬起时触发采集事件
    if ([sender isKindOfClass:UISlider.class] && event.allTouches.anyObject.phase != UITouchPhaseEnded) {
        return;
    }
    
    if ([self sensorsdata_isAddMultipleTargetActionsWithDefaultControlEvent:UIControlEventValueChanged]) {
        [[SensorsAnalyticsSDK sharedInstance] trackAppClickWithView:sender properties:nil];
    }
}

+(void)load
{
    [UIControl sensorsdata_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(sensorsdata_didMoveToSuperView)];
}

@end
