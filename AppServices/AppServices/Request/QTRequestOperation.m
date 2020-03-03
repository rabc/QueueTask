// Created on 02/03/2020

#import "QTRequestOperation.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const kEndpointURL = @"https://jsonplaceholder.typicode.com/posts";
NSString * const kErrorDomain = @"app.services.error";

@interface QTRequestOperation()

@property (nonatomic, copy) void (^successCallback)(NSData *);
@property (nonatomic, copy) void (^failureCallback)(NSError *);
@property (nonatomic, strong) NSString *secondsValue;

@end

@implementation QTRequestOperation

-(id) initWithName:(NSString *)name
           seconds:(NSString *)secondsValue
             success:(void (^)(NSData *))success
         failure:(void (^)(NSError *))failure {
    if (self = [super init]) {
        self.name = name;
        self.secondsValue = secondsValue;
        self.successCallback = success;
        self.failureCallback = failure;
    }
    return self;
}

-(void) main {
    
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"seconds": self.secondsValue}
                                                   options:NSJSONWritingSortedKeys error:&error];
    
    NSURL *url = [NSURL URLWithString:kEndpointURL];
    
    if (!url || !data) {
        NSError *error = [NSError errorWithDomain:kErrorDomain code:1 userInfo:nil];
        self.failureCallback(error);
        return;
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLRequest *request = [self buildRequestWithData:data url:url];
    
    QTRequestOperation __weak *weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        /* Uncomment the line below to simulate a (big) delay */
        sleep(2);

        if (!data) {
            NSError *error = [NSError errorWithDomain:kErrorDomain code:2 userInfo:nil];
            weakSelf.failureCallback(error);
        } else {
            weakSelf.successCallback(data);
        }
        
        dispatch_semaphore_signal(semaphore);
        
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

- (NSURLRequest *)buildRequestWithData:(NSData *)body url:(NSURL *)url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    
    return request;
}
     
@end
NS_ASSUME_NONNULL_END
