//
//  SensorsSDK.h
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/1.
//

#import <Foundation/Foundation.h>

//! Project version number for SensorsSDK.
FOUNDATION_EXPORT double SensorsSDKVersionNumber;

//! Project version string for SensorsSDK.
FOUNDATION_EXPORT const unsigned char SensorsSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SensorsSDK/PublicHeader.h>

#import <SensorsSDK/SensorsAnalyticsSDK.h>


//目前存在的问题
//页面浏览事件埋点存在问题：
//1.应用从后台恢复不会触发$AppViewScreen事件
//2.UIViewController子类如果重写了viewDidAppear:方法则必须调用[super viewDidAppear:animated];
