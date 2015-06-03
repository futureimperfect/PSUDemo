//
//  AppDelegate.h
//  PSUDemo
//
//  Created by James Barclay on 6/1/15.
//  Copyright (c) 2015 James Barclay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *cowsayInstalledLabel;
@property (weak) IBOutlet NSImageView *cowsayInstalledStatusIndicator;
@property (weak) IBOutlet NSButton *installCowsayButton;
@property (weak) IBOutlet NSProgressIndicator *cowsayProgressIndicator;
@property (weak) IBOutlet NSTextField *whatShouldTheCowsay;
@property (unsafe_unretained) IBOutlet NSTextView *cowsayTextView;
@property (weak) IBOutlet NSButton *sayItButton;

- (IBAction)installCowsay:(id)sender;
- (IBAction)sayIt:(id)sender;

@end
