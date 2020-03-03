// Created on 03/03/2020

#import "QTDateFormatCacheManager.h"

@implementation QTDateFormatCacheManager

+ (id)sharedManager {
    static QTDateFormatCacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSDateFormatter *)fullHourFormat {
    if (_fullHourFormat == nil) {
        _fullHourFormat = [[NSDateFormatter alloc] init];
        _fullHourFormat.dateFormat = @"HH:mm:ss";
    }
    return _fullHourFormat;
}

- (NSDateFormatter *)secondsFormat {
    if (_secondsFormat == nil) {
        _secondsFormat = [[NSDateFormatter alloc] init];
        _secondsFormat.dateFormat = @"ss";
    }
    return _secondsFormat;
}

@end
