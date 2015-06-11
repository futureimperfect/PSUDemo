//
//  CowSayer.m
//  PSUDemo
//
//  Created by James Barclay on 6/2/15.
//  Copyright (c) 2015 James Barclay. All rights reserved.
//

#import "CowSayer.h"

@implementation CowSayer

- (NSString *)getCowsayTextFrom:(NSString *)string
{
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    NSArray *args = [NSArray arrayWithObjects:string, nil];
    NSFileHandle *fh = [pipe fileHandleForReading];
    [task setLaunchPath:@"/usr/local/bin/cowsay"];
    [task setArguments:args];
    [task setStandardOutput:pipe];
    [task launch];
    [task waitUntilExit];

    NSData *data = [fh readDataToEndOfFile];
    NSString *results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sayWhatTheCowSays:string withVoice:@"Alex"];

    return results;
}

- (void)sayWhatTheCowSays:(NSString *)whatSheSaid withVoice:(NSString *)voice
{
    NSTask *task = [[NSTask alloc] init];
    NSArray *positionalArgs = [whatSheSaid componentsSeparatedByString:@" "];
    NSMutableArray *args = [NSMutableArray arrayWithObjects:@"-v", voice, nil];
    [args addObjectsFromArray:positionalArgs];
    [task setLaunchPath:@"/usr/bin/say"];
    [task setArguments:args];
    [task launch];
}

@end
