//
//  AppDelegate.m
//  CurrencyLive
//
//  Created by Slawek Dlugosz on 01.08.2014.
//  Copyright (c) 2014 nethead. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

+ (void)initialize {
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:@"5" forKey:@"interval"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [_intervalField setStringValue:[prefs objectForKey:@"interval"]];
}

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:menu];
    [statusItem setTitle:@"Loading..."];
    [statusItem setHighlightMode:NO];
     NSImage *iconImage = [NSImage imageNamed:@"icon"];
    [iconImage setSize:NSMakeSize(16, 16)];
    [statusItem setImage:iconImage];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSTimeInterval intervalForTimer = [prefs integerForKey:@"interval"] * 60;
    
    [NSTimer scheduledTimerWithTimeInterval:intervalForTimer
                                   target:self
                                   selector:@selector(updateRate)
                                   userInfo:nil
                                    repeats:YES];
    [self updateRate];
}

- (void)updateRate {

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kantor.aliorbank.pl/forex/json/current"]];
    
    NSError *errorcode = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorcode];
    
    if(errorcode != nil) {
        NSLog(@"Connection Error: %@", errorcode);
        return;
    }
    
    NSError *jsonParsingError = nil;
    NSArray *currencies = [[NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError] objectForKey:@"currencies"];
    
    if(jsonParsingError != nil) {
        NSLog(@"Json parsing Error: %@", jsonParsingError);
        return;
    }
    
    NSDictionary *currency;
    
    for(int i=0; i<[currencies count];i++)
    {
        currency= [currencies objectAtIndex:i];
        //        NSLog(@"Rate: %@ to %@ = %@", [currency objectForKey:@"currency1"], [currency objectForKey:@"currency2"], [currency objectForKey:@"buy"]);
        
        if ([[currency objectForKey:@"currency1"] isEqualToString:@"PLN"] &&
            [[currency objectForKey:@"currency2"] isEqualToString:@"EUR"]) {
            //NSLog(@"SELECTED: %@ to %@ = %@", [currency objectForKey:@"currency1"], [currency objectForKey:@"currency2"], [currency objectForKey:@"buy"]);
            NSString *label = [currency objectForKey:@"buy"];
            [statusItem setTitle:label];
            
            break;
        }
    }
    
}

- (IBAction)showSettings:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [_window makeKeyAndOrderFront:nil];
}

- (IBAction)saveSettings:(id)sender {
    NSLog(@"save!");
    NSLog(@"%@", [_intervalField stringValue]);
    [[NSUserDefaults standardUserDefaults] setObject:[_intervalField stringValue] forKey:@"interval"];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:nil];
}

@end
