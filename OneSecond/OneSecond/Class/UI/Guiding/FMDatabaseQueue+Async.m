//
//  FMDatabaseQueue+Async.m
//  OneSecond
//
//  Created by 饶骏华 on 2019/12/13.
//  Copyright © 2019 com.homeboy. All rights reserved.
//

#import "FMDatabaseQueue+Async.h"



@implementation FMDatabaseQueue (Async)

- (dispatch_queue_t)queue {
    return _queue;
}

@end
