//
//  CowsayInstaller.h
//  PSUDemo
//
//  Created by James Barclay on 6/1/15.
//  Copyright (c) 2015 James Barclay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CowsayInstaller : NSObject

@property (copy, nonatomic) void (^installed)(BOOL installed);

- (void)downloadAndInstallCowsay;

@end
