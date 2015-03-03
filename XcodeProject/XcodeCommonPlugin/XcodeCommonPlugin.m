//
//  XcodeCommonPlugin.m
//  XcodeCommonPlugin
//
//  Created by 宋子龙 on 15/3/3.
//  Copyright (c) 2015年 woshizilong@hotmail.com. All rights reserved.
//

#import "XcodeCommonPlugin.h"

static XcodeCommonPlugin *sharedPlugin;

@interface XcodeCommonPlugin ()

@property(nonatomic, strong, readwrite) NSBundle *bundle;

@property(nonatomic, copy) NSString *selectedText;

@end

@implementation XcodeCommonPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin {
  static dispatch_once_t onceToken;
  NSString *currentApplicationName =
      [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
  if ([currentApplicationName isEqual:@"Xcode"]) {
    dispatch_once(&onceToken, ^{
      sharedPlugin = [[self alloc] initWithBundle:plugin];
    });
  }
}

+ (instancetype)sharedPlugin {
  return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
  if (self = [super init]) {
    // reference to plugin's bundle, for resource access
    self.bundle = plugin;

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(applicationDidFinishLaunching:)
               name:NSApplicationDidFinishLaunchingNotification
             object:nil];
  }
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(selectionDidChange:)
             name:NSTextViewDidChangeSelectionNotification
           object:nil];
  // Create menu items, initialize UI, etc.

  // Sample Menu Item:
  NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
  if (menuItem) {
    [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
    NSMenuItem *actionMenuItem =
        [[NSMenuItem alloc] initWithTitle:@"Do Action"
                                   action:@selector(doMenuAction)
                            keyEquivalent:@""];
    [actionMenuItem setTarget:self];

    //设置勾选的默认状态
    //[actionMenuItem setState:NSOnState];

    [[menuItem submenu] addItem:actionMenuItem];
  }
}

// Sample Action, for menu item:
- (void)doMenuAction {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:self.selectedText];
  [alert runModal];
}

- (void)selectionDidChange:(NSNotification *)notification {
  if ([[notification object] isKindOfClass:[NSTextView class]]) {
    NSTextView *textView = (NSTextView *)[notification object];

    NSArray *selectedRanges = [textView selectedRanges];
    if (selectedRanges.count == 0) {
      return;
    }

    NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
    NSString *text = textView.textStorage.string;
    self.selectedText = [text substringWithRange:selectedRange];
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
