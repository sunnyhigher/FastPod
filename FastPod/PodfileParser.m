//
//  PodfileParser.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import "PodfileParser.h"

@implementation PodfileParser

static NSRegularExpression *expression;

+ (void)load {
    expression = [NSRegularExpression regularExpressionWithPattern:@"pod [\"|'](.*?)[\"|']"
                                                           options:kNilOptions
                                                             error:nil];
}

+ (NSArray<SpecEntity *> *)startParsing {
    NSString *pwd = [[NSProcessInfo processInfo] environment][@"PWD"];
//    NSString *pwd = @"/Users/saiakirahui/Desktop/ttt/";
    NSString *filePath = [pwd stringByAppendingString:@"/Podfile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [pwd stringByAppendingString:@"/podfile"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"Podfile not exists.");
            exit(-1);
        }
    }
    NSString *contents = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    if (contents == nil) {
        return nil;
    }
    NSMutableArray *items = [NSMutableArray array];
    NSArray *lines = [contents componentsSeparatedByString:@"\n"];
    [lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"pod "]) {
            NSTextCheckingResult *result = [expression firstMatchInString:obj
                                                                  options:NSMatchingReportCompletion
                                                                    range:NSMakeRange(0, [obj length])];
            if (result != nil) {
                SpecEntity *item = [SpecEntity new];
                if (1 < result.numberOfRanges) {
                    item.name = [obj substringWithRange:[result rangeAtIndex:1]];
                }
                [items addObject:item];
            }
        }
    }];
    return [items copy];
}

@end
