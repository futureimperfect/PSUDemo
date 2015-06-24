//
//  AppDelegate.m
//  PSUDemo
//
//  Created by James Barclay on 6/1/15.
//  Copyright (c) 2015 James Barclay. All rights reserved.
//

#import "AppDelegate.h"
#import "CowsayInstaller.h"
#import "CowSayer.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

NSString *const theCowHerself = @"theCowHerself";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self checkForCowsay];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:theCowHerself]) {
        [_cowsayTextView setString:[defaults stringForKey:theCowHerself]];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure you want to quit CowSayer?"];
    [alert setInformativeText:@"Life will be miserable without it."];

    if ([alert runModal] == NSAlertSecondButtonReturn) {
        return NSTerminateCancel;
    }

    return NSTerminateNow;
}

- (void)checkForCowsay
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cowsayExecutable = @"/usr/local/bin/cowsay";
    if ([fm isExecutableFileAtPath:cowsayExecutable]) {
        [_cowsayInstalledStatusIndicator setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
        [_cowsayInstalledLabel setStringValue:@"cowsay is installed."];
        [_installCowsayButton setEnabled:NO];
    } else {
        [_sayItButton setEnabled:NO];
    }
}

- (void)installCowsay
{
    CowsayInstaller *installer = [[CowsayInstaller alloc] init];

    [_cowsayInstalledStatusIndicator setHidden:YES];
    [_cowsayProgressIndicator setHidden:NO];
    [_cowsayProgressIndicator startAnimation:self];

    [installer setInstalled:^(BOOL success) {
        [_cowsayProgressIndicator setHidden:YES];
        [_cowsayProgressIndicator startAnimation:self];
        [_cowsayInstalledStatusIndicator setHidden:NO];

        if (success) {
            [_cowsayInstalledStatusIndicator setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
            [_cowsayInstalledLabel setStringValue:@"cowsay is installed."];
            [_installCowsayButton setEnabled:NO];
            [_sayItButton setEnabled:YES];
        } else {
            [_cowsayInstalledStatusIndicator setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
        }
    }];

    [installer downloadAndInstallCowsay];
}

- (IBAction)installCowsay:(id)sender
{
    [self installCowsay];
}

- (IBAction)sayIt:(id)sender
{
    CowSayer *sayer = [[CowSayer alloc] init];
    NSString *results = [sayer getCowsayTextFrom:[_whatShouldTheCowsay stringValue]];
    [_cowsayTextView setString:results];
    [[NSUserDefaults standardUserDefaults] setObject:results forKey:theCowHerself];
}

@end
