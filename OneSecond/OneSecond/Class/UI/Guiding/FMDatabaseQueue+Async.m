//
//  FMDatabaseQueue+Async.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020 com.homeboy. All rights reserved.
//

#import "FMDatabaseQueue+Async.h"



@implementation FMDatabaseQueue (Async)

- (dispatch_queue_t)queue {
    return _queue;
}

@end
