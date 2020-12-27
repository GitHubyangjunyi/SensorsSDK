//
//  UIView+SensorsData.h
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SensorsData)
//控件类别
@property (nonatomic, copy, readonly) NSString *sensorsdata_elementType;
//控件文本
@property (nonatomic, copy, readonly) NSString *sensorsdata_elementContent;
//控件所在视图控制器
@property (nonatomic, readonly) UIViewController *sensorsdata_viewController;

@end

#pragma mark - UIButton
@interface UIButton (SensorsData)

@end

#pragma mark - UISwitch
@interface UISwitch (SensorsData)

@end

#pragma mark - UISlider
@interface UISlider (SensorsData)

@end

#pragma mark - UIStepper
@interface UIStepper (SensorsData)

@end

#pragma mark - UISegmentedControl
@interface UISegmentedControl (SensorsData)

@end

NS_ASSUME_NONNULL_END
