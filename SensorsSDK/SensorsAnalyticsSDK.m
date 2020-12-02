//
//  SensorsAnalyticsSDK.m
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/1.
//

#import "SensorsAnalyticsSDK.h"
#include <sys/sysctl.h>

static NSString *const SensorsAnalyticsVersion = @"1.0.0";

@interface SensorsAnalyticsSDK ()

//由SDK默认采集的预置属性
@property (nonatomic, strong) NSDictionary<NSString *, id> *automaticProperties;

@end

@implementation SensorsAnalyticsSDK

+ (SensorsAnalyticsSDK *)sharedInstance
{
    static dispatch_once_t onceToken;
    static SensorsAnalyticsSDK *sdk = nil;
    dispatch_once(&onceToken, ^{
        sdk = [[SensorsAnalyticsSDK alloc] init];
    });
    return sdk;
}

- (NSDictionary<NSString *, id> *)collectAutomaticProperties
{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    properties[@"$os"] = @"iOS";
    properties[@"$lib"] = @"iOS";
    properties[@"$manufacturer"] = @"Apple";
    properties[@"$lib_version"] = SensorsAnalyticsVersion;
    properties[@"$os_version"] = UIDevice.currentDevice.systemVersion;
    properties[@"$app_version"] = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    properties[@"$model"] = [self deviceModel];
    
    return [properties copy];
}

- (NSString *)deviceModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char answer[size];
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    return @(answer);
}

- (instancetype)init
{
    if ([super init])
    {
        _automaticProperties = [self collectAutomaticProperties];
    }
    return self;
}

-(void)printEvent:(NSDictionary *)event {
#if DEBUG
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:event options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return NSLog(@"JSON Serialized Error: %@", error);
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"[Event]: %@", json);
#endif
}

@end

@implementation SensorsAnalyticsSDK (Track)

- (void)track:(NSString *)eventName properties:(NSDictionary<NSString *,id> *)properties
{
    
    
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    //事件名称
    event[@"event"] = eventName;
    //事件时间戳
    event[@"time"] = [NSNumber numberWithLong:NSDate.date.timeIntervalSince1970 * 1000];
    
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
        //添加预置属性
    [eventProperties addEntriesFromDictionary:self.automaticProperties];
        //自定义事件属性
    [eventProperties addEntriesFromDictionary:properties];
    //事件属性
    event[@"properties"] = eventProperties;
    
    //在Xcode控制台中打印事件日志
    [self printEvent:event];
}

@end

