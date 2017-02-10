//
//  Util.m
//  Game
//
//  Created by One on 09/01/2017.
//  Copyright © 2017 One. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSInteger) randomWithMin: (NSInteger) min max:(NSInteger) max {
    // определяет random диапазон значений
    return arc4random() % (max - min) + min;
}

@end
