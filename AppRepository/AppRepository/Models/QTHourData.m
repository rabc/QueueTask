// Created on 03/03/2020

#import "QTHourData.h"

@implementation QTHourData

- (id)initWithSeconds:(NSString *)seconds hour:(NSString *)hour sent:(BOOL)sent {
    if(self = [super init]) {
        self.seconds = seconds;
        self.hour = hour;
        self.sent = sent;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.seconds forKey:@"seconds"];
    [encoder encodeObject:self.hour forKey:@"hour"];
    [encoder encodeBool:self.sent  forKey:@"sent"];
}

- (nullable id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        self.seconds = [decoder decodeObjectForKey:@"seconds"];
        self.hour = [decoder decodeObjectForKey:@"hour"];
        self.sent = [decoder decodeBoolForKey:@"sent"];
    }
    return self;
}

@end
