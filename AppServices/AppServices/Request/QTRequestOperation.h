// Created on 02/03/2020

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QTRequestOperation : NSOperation

-(id) initWithName:(NSString *)name
           seconds:(NSString *)secondsValue
           success:(void (^)(NSData *))success
           failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
