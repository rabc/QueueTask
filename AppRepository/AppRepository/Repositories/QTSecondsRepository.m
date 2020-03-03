// Created on 02/03/2020

#import "QTSecondsRepository.h"
#import "QTDateFormatCacheManager.h"
#import "QTHourData.h"
#import <AppServices/AppServices.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const kUserDefaultsHourKey = @"hour";

@interface QTSecondsRepository()

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic) dispatch_queue_t dispatch;

@end

@implementation QTSecondsRepository

- (id)init {
    if(self = [super init]) {
        self.dispatch = dispatch_queue_create("seconds.dispatch.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (QTSecondsRepository *)shared {
    static QTSecondsRepository *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)sendDate:(NSDate *)date callback:(void (^)(QTSeconds *))callback {
    
    QTDateFormatCacheManager *formatter = [QTDateFormatCacheManager sharedManager];
    
    NSString *hour = [formatter.fullHourFormat stringFromDate:date];
    NSString *seconds = [formatter.secondsFormat stringFromDate:date];
    
//    dispatch_sync(self.dispatch, ^{
    @synchronized (self) {
        
        NSMutableArray<QTHourData *> *hoursData = [NSMutableArray arrayWithArray:[self allHoursData]];
        QTHourData *currentDate = [self findHour:hour inArray:hoursData];
        
        NSArray<NSString *> *allOperationsNames = [self allOperationsNames];
        if (currentDate && (currentDate.sent || [allOperationsNames containsObject:currentDate.hour])) {
            NSLog(@"Not sending again %@", currentDate.hour);
            return;
        }
        
        [hoursData addObject:[[QTHourData alloc] initWithSeconds:seconds hour:hour sent:NO]];
        [self saveNewData:hoursData];
        [self queueOperationWithName:hour hour:hour seconds:seconds callback:callback];
    }
}

- (void)queueOperationWithName:(NSString *)name hour:(NSString *)hour
                       seconds:(NSString *)seconds callback:(void (^)(QTSeconds *))callback {
    
    QTSecondsRepository __weak *weakSelf = self;
    
    QTRequestOperation *operation = [[QTRequestOperation alloc] initWithName:name
                                                                     seconds:seconds
                                                                     success:^(NSData *data) {
        NSMutableArray<QTHourData *> *hoursData = [NSMutableArray arrayWithArray:[weakSelf allHoursData]];
        QTHourData *currentDate = [self findHour:hour inArray:hoursData];
        
        if (currentDate) {
            NSInteger idx = [hoursData indexOfObject:currentDate];
            hoursData[idx].sent = YES;
            [weakSelf saveNewData:hoursData];
            
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            QTSeconds *seconds = [[QTSeconds alloc] init];
            seconds.identifier = [response[@"id"] integerValue];
            seconds.seconds = response[@"seconds"];
            
            callback(seconds);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error while sending %@: %@", hour, error);
    }];
    
    NSLog(@"Queue %@", hour);
    [self.queue addOperations:@[operation] waitUntilFinished:NO];
}

- (void)flush {
    NSMutableArray<NSString *> *allOperationsNames = [NSMutableArray arrayWithArray:[self allOperationsNames]];
    
    QTSecondsRepository __weak *weakSelf = self;
    
    NSArray<QTHourData *> *hoursData = [self allHoursData];
    for (QTHourData *hourData in hoursData) {
        if (!hourData.sent && ![allOperationsNames containsObject:hourData.hour]) {
            [self queueOperationWithName:hourData.hour hour:hourData.hour
                                 seconds:hourData.seconds callback:^(QTSeconds *response) {
                NSMutableArray<QTHourData *> *hoursData = [NSMutableArray arrayWithArray:[weakSelf allHoursData]];
                QTHourData *currentDate = [self findHour:hourData.hour inArray:hoursData];
                
                if (currentDate) {
                    NSInteger idx = [hoursData indexOfObject:currentDate];
                    hoursData[idx].sent = YES;
                    [weakSelf saveNewData:hoursData];
                }
            }];
        }
    }
}

- (NSArray<NSString *> *)allOperationsNames {
    NSMutableArray<NSString *> *operationsNames = [NSMutableArray array];
    [self.queue.operations enumerateObjectsUsingBlock:^(NSOperation *obj, NSUInteger idx, BOOL *stop) {
        [operationsNames addObject:obj.name];
    }];
    
    return operationsNames;
}

- (nullable QTHourData *)findHour:(NSString *)hour inArray:(NSMutableArray<QTHourData *> *)hoursData {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hour == %@", hour];
    QTHourData *currentDate = [hoursData filteredArrayUsingPredicate:predicate].firstObject;
    
    return currentDate;
}

- (void)saveNewData:(NSArray<QTHourData *> *)hoursData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:hoursData requiringSecureCoding:NO error:nil];
    if (data) {
        [self.userDefaults setObject:data forKey:kUserDefaultsHourKey];
    }
}

- (NSArray<QTHourData *> *)allHoursData {
    NSData *data = [self.userDefaults objectForKey:kUserDefaultsHourKey];
    
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
        unarchiver.requiresSecureCoding = NO;
        NSArray<QTHourData *> *storedData = [unarchiver decodeTopLevelObjectForKey:NSKeyedArchiveRootObjectKey error:nil];

        if (storedData) {
            return storedData;
        }
    }
    
    return @[];
    
}

- (NSUserDefaults *)userDefaults {
    if (_userDefaults == nil) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    
    return _queue;
}

@end

NS_ASSUME_NONNULL_END
