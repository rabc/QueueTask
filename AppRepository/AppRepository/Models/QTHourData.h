// Created on 03/03/2020

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QTHourData : NSObject

@property (nonatomic, strong) NSString *seconds;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, assign) BOOL sent;

- (id)initWithSeconds:(NSString *)seconds hour:(NSString *)hour sent:(BOOL)sent;

@end

NS_ASSUME_NONNULL_END
