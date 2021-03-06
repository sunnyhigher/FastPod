//
//  FastPod.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import "FastPod.h"

@implementation FastPod

+ (NSString *)apiBase {
//    return @"http://localhost/app/";
    return @"http://182.92.85.54/app/";
}

+ (NSString *)specBase {
    NSString *appBase = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory,
                                                             NSUserDomainMask,
                                                             YES) firstObject];
    return [appBase stringByReplacingOccurrencesOfString:@"/Applications"
                                              withString:@"/.cocoapods/repos/master/Specs/"];
}

+ (NSString *)loadType {
    if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--use-origin"]) {
        return @"0";
    }
    else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"--use-mirror"]) {
        return @"2";
    }
    else {
        return @"1";
    }
}

+ (void)podUpdate {
    [@"#!/bin/sh\npod update --no-repo-update" writeToFile:@"/tmp/runpod.sh"
                                                atomically:YES
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSTask *task = [NSTask new];
    task.launchPath = @"/bin/sh";
    task.arguments = @[@"/tmp/runpod.sh"];
    [task launch];
    [task setTerminationHandler:^(NSTask * _Nonnull task) {
        exit(-1);
    }];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
}

@end
