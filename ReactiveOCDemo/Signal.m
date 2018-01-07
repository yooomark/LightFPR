//
//  Signal.m
//  ReactiveOCDemo
//
//  Created by yomark on 2018/1/6.
//  Copyright © 2018年 yomark. All rights reserved.
//

#import "Signal.h"

static NSString *kQueueLabel = @"com.yomark.signal.queue";

@interface Signal<__covariant T> ()

@property (nonatomic, strong, readwrite) T value;
@property (nonatomic, strong) NSMutableDictionary *subscribers;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation Signal

- (instancetype)initWithValue:(id)value
{
    if (self = [super init])
    {
        _value = value;
        _queue = dispatch_queue_create(kQueueLabel.UTF8String, DISPATCH_QUEUE_SERIAL);
        _subscribers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (SignalToken *)subscribeNext:(subscribeBlock)subscriber
{
    return [self _subscribeNext:subscriber replayLast:NO];
}

- (SignalToken *)subscribeNextWithReplayLast:(subscribeBlock)subscriber
{
    return [self _subscribeNext:subscriber replayLast:YES];
}

- (void)unscrible:(SignalToken *)token
{
    dispatch_sync(self.queue, ^{
        [self.subscribers removeObjectForKey:token];
    });
}

- (SignalToken *)bind:(Signal *)signal
{
    NSString *token = [self subscribeNext:^(id value) {
        [signal update:value];
    }];
 
    return token;
}

- (void)unbind:(SignalToken *)token
{
    [self unscrible:token];
}

- (void)update:(id)value
{
    dispatch_sync(self.queue, ^{
        self.value = value;
        NSEnumerator *enumerator = [self.subscribers objectEnumerator];
        subscribeBlock subscriber;
        while ((subscriber = [enumerator nextObject]))
        {
            subscriber(value);
        }
    });
}

- (id)peek
{
    return self.value;
}

#pragma mark - Private

- (SignalToken *)_subscribeNext:(subscribeBlock)subscriber replayLast:(BOOL)replayLast
{
    __block SignalToken *token;
    
    dispatch_sync(self.queue, ^{
        token = [[NSNumber numberWithInteger:(self.subscribers.allKeys.count + 1)] stringValue];
        [self.subscribers setObject:subscriber forKey:token];
        
        if (replayLast)
        {
            subscriber(self.value);
        }
    });
    
    return token;
}

@end
