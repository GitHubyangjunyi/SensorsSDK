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
    
    //获取原始方法的实现及其类型
    IMP originalIMP = method_getImplementation(originalMethod);
    const char *originalMethodType = method_getTypeEncoding(originalMethod);
    if (class_addMethod(self, originalSEL, originalIMP, originalMethodType)) {
        //如果添加方法成功
        originalMethod = class_getInstanceMethod(self, originalSEL);
    }
    
    //获取要交换的方法的实现及其类型
    IMP alternateIMP = method_getImplementation(alternateMethod);
    const char *alternateMethodType = method_getTypeEncoding(alternateMethod);
    if (class_addMethod(self, alternateSEL, alternateIMP, alternateMethodType)) {
        alternateMethod = class_getInstanceMethod(self, alternateSEL);
    }
    
    //交换方法
    method_exchangeImplementations(originalMethod, alternateMethod);
    return true;
}

@end
