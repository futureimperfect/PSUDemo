//
//  CowsayInstaller.m
//  PSUDemo
//
//  Created by James Barclay on 6/1/15.
//  Copyright (c) 2015 James Barclay. All rights reserved.
//

#import "CowsayInstaller.h"
#import "CowsayUnzipper.h"

@implementation CowsayInstaller {
    BOOL _complete;
}

- (void)downloadAndInstallCowsay
{
    NSString *cowsayURL = @"https://github.com/schacon/cowsay/archive/master.zip";
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:cowsayURL]
      completionHandler:^(NSData *data,
                          NSURLResponse *response,
                          NSError *error) {
          NSString *tmpZipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cowsay.zip"];
          NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cowsay"];
          [data writeToFile:tmpZipPath atomically:YES];
          CowsayUnzipper *unzipper = [[CowsayUnzipper alloc] init];
          [unzipper unzip:tmpZipPath to:tmpPath];
          if (error) { NSLog(@"An error occurred while unzipping cowsay."); return; }
          NSString *installScriptPath = [tmpPath stringByAppendingPathComponent:@"/cowsay-master/install.sh"];
          [self installCowsayFromScript:installScriptPath];
      }] resume];
}

- (void)installCowsayFromScript:(NSString *)path
{
    NSTask *task = [[NSTask alloc] init];
    NSArray *args = [NSArray arrayWithObjects:path, @"/usr/local", nil];
    [task setLaunchPath:@"/bin/sh"];
    [task setArguments:args];
    [task setCurrentDirectoryPath:[path stringByDeletingLastPathComponent]];
    [task launch];
    [task waitUntilExit];

    if ([task terminationStatus] == 0) {
        NSLog(@"Successfully installed cowsay.");
        [self installDidComplteWithSuccess:YES];
    } else {
        [self installDidComplteWithSuccess:NO];
    }
}

- (void)installDidComplteWithSuccess:(BOOL)success
{
    if (_installed && !_complete) {
        _installed(success);
        _complete = YES;
    }
}

@end
