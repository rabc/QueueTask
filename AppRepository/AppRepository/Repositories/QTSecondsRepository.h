// Created on 02/03/2020

#import <Foundation/Foundation.h>
#import "QTSeconds.h"

NS_ASSUME_NONNULL_BEGIN

@interface QTSecondsRepository : NSObject

@property (nonatomic, readonly) NSOperationQueue *queue;

+ (QTSecondsRepository *)shared;
- (void)sendDate:(NSDate *)date callback:(void (^)(QTSeconds *))callback NS_SWIFT_NAME(sendDate(_:callback:));
- (void)flush;

@end

NS_ASSUME_NONNULL_END
