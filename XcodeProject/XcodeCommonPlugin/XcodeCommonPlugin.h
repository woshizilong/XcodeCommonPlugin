//
//  XcodeCommonPlugin.h
//  XcodeCommonPlugin
//
//  Created by 宋子龙 on 15/3/3.
//  Copyright (c) 2015年 woshizilong@hotmail.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface XcodeCommonPlugin : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end