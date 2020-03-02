// Created on 02/03/2020

#import "QTSecondsRepository.h"

NS_ASSUME_NONNULL_BEGIN

@interface QTSeconds : NSObject
@property (nonatomic, strong) NSInteger identifier;
@property (nonatomic, strong) NSString *seconds;
@end

@implementation QTSeconds
@end

@interface QTSecondsRepository()

@end

@interface QTDateFormatCacheManager : NSObject

@property (nonatomic, strong) NSDateFormatter *fullHourFormat;
@property (nonatomic, strong) NSDateFormatter *secondsFormat;

+ (id)sharedManager;

@end

@implementation QTDateFormatCacheManager

+ (id)sharedManager {
    static QTDateFormatCacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
  if (self = [super init]) {
      self.fullHourFormat = [[NSDateFormatter alloc] init]
      self.fullHourFormat.dateFormat = @"HH:mm:ss";
      
      self.secondsFormat = [[NSDateFormatter alloc] init]
      self.secondsFormat.dateFormat = @"ss";
  }
  return self;
}

@end

@implementation QTSecondsRepository

- (void)sendDate:(NSDate *)date callback:(void (^)(QTSeconds *))callback {
    
    QTDateFormatCacheManager *formatter = [QTDateFormatCacheManager sharedManager];
    
    NSString *hour = [formatter.fullHourFormat stringFromDate:date];
    NSString *seconds = [formatter.secondsFormat stringFromDate:date];
    
    @synchronized(self) {
        
    }
    
}

@end

NS_ASSUME_NONNULL_END
