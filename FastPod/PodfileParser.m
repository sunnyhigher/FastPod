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
//    NSString *pwd = @"/Users/PonyCui_Home/Desktop/mmm/";
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
        if ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] hasPrefix:@"pod "]) {
            NSTextCheckingResult *result = [expression firstMatchInString:obj
                                                                  options:NSMatchingReportCompletion
                                                                    range:NSMakeRange(0, [obj length])];
            if (result != nil) {
                SpecEntity *item = [SpecEntity new];
                if (1 < result.numberOfRanges) {
                    item.name = [obj substringWithRange:[result rangeAtIndex:1]];
                }
                NSArray<NSString *> *coms = [obj componentsSeparatedByString:@","];
                [coms enumerateObjectsUsingBlock:^(NSString * _Nonnull com, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == 0) {
                        return;
                    }
                    com = [com stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if ([com hasPrefix:@":"]) {
                        
                    }
                    else {
                        com = [com stringByReplacingOccurrencesOfString:@"['\"]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [com length])];
                        // version
                        if ([com hasPrefix:@">="]) {
                            item.compareType = @">=";
                        }
                        else if ([com hasPrefix:@">"]) {
                            item.compareType = @">";
                        }
                        else if ([com hasPrefix:@"<="]) {
                            item.compareType = @"<=";
                        }
                        else if ([com hasPrefix:@"<"]) {
                            item.compareType = @"<";
                        }
                        else if ([com hasPrefix:@"~>"]) {
                            item.compareType = @"~>";
                        }
                        else {
                            item.compareType = @"=";
                        }
                        item.version = [com stringByReplacingOccurrencesOfString:@"[>=<~]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [com length])];
                    }
                }];
                [items addObject:item];
            }
        }
    }];
    return [items copy];
}

@end
