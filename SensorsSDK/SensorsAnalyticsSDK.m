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
//是否已经收到过UIApplicationWillResignActiveNotification
@property (nonatomic) BOOL applicationWillResignActive;
//是否被动启动
@property (nonatomic, getter=isLaunchedPassively) BOOL launchedPassively;

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

- (instancetype)init
{
    if ([super init])
    {
        //采集预置属性
        _automaticProperties = [self collectAutomaticProperties];
        //设置是否被动启动标志位
        _launchedPassively = UIApplication.sharedApplication.backgroundTimeRemaining != UIApplicationBackgroundFetchIntervalNever;
        //注册通知中心监听
        [self setupListeners];
    }
    return self;
}


- (NSDictionary<NSString *, id> *)collectAutomaticProperties
{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    properties[@"$os"] = @"iOS";
    properties[@"$lib"] = @"iOS";
    properties[@"$manufacturer"] = @"Apple";
    properties[@"$model"] = [self deviceModel];
    properties[@"$lib_version"] = SensorsAnalyticsVersion;
    properties[@"$os_version"] = UIDevice.currentDevice.systemVersion;
    properties[@"$app_version"] = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    
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

-(void)setupListeners {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //在通知中心注册 应用程序启动完成 通知
    [center addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    //在通知中心注册 应用程序已经进入前台并活跃 通知
    [center addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //在通知中心注册 应用程序将要放弃活跃 通知
    [center addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    //在通知中心注册 应用程序已经进入后台 通知
    [center addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSLog(@"应用程序已经启动");
    //如果应用程序在后台运行时触发被动启动事件
    if (self.isLaunchedPassively) {
        [self track:@"$AppStartPassively" properties:nil];
    }
}

-(void)applicationDidBecomeActive:(NSNotification *)notification {
    NSLog(@"应用程序已经进入前台并活跃");
    //之前是否收到过即将放弃活跃通知
    if (self.applicationWillResignActive) {
        self.applicationWillResignActive = false;
        return;
    }
    //将被动启动标志位还原以正常记录事件
    self.launchedPassively = false;
    [self track:@"$AppStart" properties:nil];
}

-(void)applicationWillResignActive:(NSNotification *)notification {
    NSLog(@"应用程序即将放弃活跃");
    self.applicationWillResignActive = true;
}

-(void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"应用程序已经进入后台");
    //重置收到过即将放弃活跃通知标志位以正常触发$AppStart事件
    self.applicationWillResignActive = false;
    [self track:@"$AppEnd" properties:nil];
}

-(void)dealloc {
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)printEvent:(NSDictionary *)event {
#if DEBUG
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:event options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return NSLog(@"JSON Serialized Error: %@", error);
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"[事件信息]: %@", json);
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
    //事件属性
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    event[@"properties"] = eventProperties;
        //添加预置属性
        [eventProperties addEntriesFromDictionary:self.automaticProperties];
        //自定义事件属性
        [eventProperties addEntriesFromDictionary:properties];
    //如果是被动启动则额外添加一个属性
    if (self.isLaunchedPassively) {
        eventProperties[@"$app_state"] = @"background";
    }
    
    //在Xcode控制台中打印事件日志
    [self printEvent:event];
}

@end

