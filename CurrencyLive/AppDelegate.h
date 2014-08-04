//
//  AppDelegate.h
//  CurrencyLive
//
//  Created by Slawek Dlugosz on 01.08.2014.
//  Copyright (c) 2014 nethead. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
    IBOutlet NSMenu *menu;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextFieldCell *intervalField;

@end
