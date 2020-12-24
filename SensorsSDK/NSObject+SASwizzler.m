//
//  NSObject+NSObject_SASwizzler.m
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/20.
//

#import "NSObject+SASwizzler.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (SASwizzler)

+(BOOL)sensorsdata_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL
{
    //获取原始方法
    Method originalMethod = class_getInstanceMethod(self, originalSEL);
    if (!originalSEL) {
        return false;
    }
    //获取要交换的方法
    Method alternateMethod = class_getInstanceMethod(self, alternateSEL);
    if (!alternateMethod) {
        return false;
    }
    //交换方法
    method_exchangeImplementations(originalMethod, alternateMethod);
    return true;
}

@end
