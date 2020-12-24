//
//  SensorsAnalyticsSDK.h
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorsAnalyticsSDK: NSObject

/**
 @abstract
 获取SDK实例
 @return
 SDK单例对象
 */
+ (SensorsAnalyticsSDK *)sharedInstance;

@end


#pragma mark - Track

@interface SensorsAnalyticsSDK (Track)
/**
 @abstract
 调用Track接口触发事件
 @discussion
 properties是一个字典其中key是NSString类型的属性名称value是属性内容
 @param eventName 事件名称
 @param properties 事件属性
 */
-(void)track:(NSString *)eventName properties:(nullable NSDictionary<NSString *, id> *)properties;

@end

NS_ASSUME_NONNULL_END
