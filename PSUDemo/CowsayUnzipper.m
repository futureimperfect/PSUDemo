//
//  CowsayUnzipper.m
//  PSUDemo
//
//  Created by James Barclay on 6/1/15.
//  Copyright (c) 2015 James Barclay. All rights reserved.
//

#import "CowsayUnzipper.h"

@implementation CowsayUnzipper

- (void)unzip:(NSString *)source to:(NSString *)destination
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;

    BOOL isDir;
    if ([fm fileExistsAtPath:destination isDirectory:&isDir] && isDir) {
        NSLog(@"%@ already exists. So we'll remove it like crazy people.", destination);
        [fm removeItemAtPath:destination error:&error];

        if (error) {
            NSLog(@"Error: %@.", error.localizedDescription);
            return;
        }
    }

    [fm createDirectoryAtPath:destination
  withIntermediateDirectories:YES
                   attributes:nil
                        error:&error];

    if (error) {
        NSLog(@"Error: %@.", error.localizedDescription);
        return;
    }

    NSTask *task = [[NSTask alloc] init];
    NSArray *args = [NSArray arrayWithObjects:@"-u", @"-d", destination, source, nil];
    [task setLaunchPath:@"/usr/bin/unzip"];
    [task setCurrentDirectoryPath:destination];
    [task setArguments:args];
    [task launch];
    [task waitUntilExit];
}

@end
