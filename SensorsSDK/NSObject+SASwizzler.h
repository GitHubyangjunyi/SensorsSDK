//
//  NSObject+NSObject_SASwizzler.h
//  SensorsSDK
//
//  Created by 杨俊艺 on 2020/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SASwizzler)

/**
 交换方法名为originalSEL和alternateSEL两个方法的实现
 @param originalSEL 原始方法
 @param alternateSEL 要交换的方法
 */
+(BOOL)sensorsdata_swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL;

@end

NS_ASSUME_NONNULL_END
