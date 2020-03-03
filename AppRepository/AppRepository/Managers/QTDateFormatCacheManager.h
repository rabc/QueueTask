// Created on 03/03/2020

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QTDateFormatCacheManager : NSObject

@property (nonatomic, strong) NSDateFormatter *fullHourFormat;
@property (nonatomic, strong) NSDateFormatter *secondsFormat;

+ (id)sharedManager;

@end

NS_ASSUME_NONNULL_END
