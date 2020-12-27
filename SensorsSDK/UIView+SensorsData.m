//
//  UIView+SensorsData.m
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/25.
//

#import "UIView+SensorsData.h"

@implementation UIView (SensorsData)

-(NSString *)sensorsdata_elementType
{
    return NSStringFromClass([self class]);
}

-(NSString *)sensorsdata_elementContent
{
    return nil;
}

- (UIViewController *)sensorsdata_viewController
{
    UIResponder *responder = self;
    
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end

#pragma mark - UIButton
@implementation UIButton (SensorsData)

- (NSString *)sensorsdata_elementContent
{
    return self.titleLabel.text;
}

@end

#pragma mark - UISwitch
@implementation UISwitch (SensorsData)

- (NSString *)sensorsdata_elementContent
{
    return self.on ? @"checked" : @"unchecked";
}

@end

#pragma mark - UISlider
@implementation UISlider (SensorsData)

- (NSString *)sensorsdata_elementContent
{
    return [NSString stringWithFormat:@"%.2f", self.value];
}

@end

#pragma mark - UIStepper
@implementation UIStepper (SensorsData)

- (NSString *)sensorsdata_elementContent
{
    return [NSString stringWithFormat:@"%g", self.value];
}

@end

#pragma mark - UISegmentedControl
@implementation UISegmentedControl (SensorsData)

- (NSString *)sensorsdata_elementContent
{
    return [self titleForSegmentAtIndex:self.selectedSegmentIndex];
}

@end
