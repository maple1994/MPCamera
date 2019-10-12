//
//  GPUImageMovieWriter+BugFix.m
//  CCBeautifulCamera
//
//  Created by CC老师 on 2019/6/18.
//  Copyright © 2019年 CC老师. All rights reserved.
//

#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>

#import "CCGPUImageMovieWriter.h"

#import "GPUImageMovieWriter+BugFix.h"

@implementation GPUImageMovieWriter (BugFix)

/**
 GPUImageMovieWriter 保存存在黑屏问题，
 在不修改源码的基础上，在 CCGPUImageMovieWriter 上修改， 然后通过方法交换的方式，
 修改 GPUImageMovieWriter 的 initWithMovieURL:size:fileType:outputSettings: 方法，
 将此方法创建的对象的 isa 指针，指向 CCGPUImageMovieWriter，
 则之后这些对象调用的方法是修复后的方法。
 CCGPUImageMovieWriter 的修改方式参考链接：https://www.jianshu.com/p/443e8ea7b0c5
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RSSwizzleInstanceMethod([self class],
                                @selector(initWithMovieURL:size:fileType:outputSettings:),
                                RSSWReturnType(id),
                                RSSWArguments(NSURL *newMovieURL, CGSize newSize, NSString *newFileType, NSDictionary *outputSettings),
                                RSSWReplacement({
            
            id obj = RSSWCallOriginal(newMovieURL, newSize, newFileType, outputSettings);
            object_setClass(obj, [CCGPUImageMovieWriter class]);
            return obj;
            
        }), RSSwizzleModeAlways, NULL);
    });
}

@end
