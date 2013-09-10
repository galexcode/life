//
//  SKLifeItem.m
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 10.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import "SKLifeItem.h"

@implementation SKLifeItem

@synthesize x,y, countNear;

-(id) init {
	self = [super init];
	if (self != nil) {
        self.x = 0;
        self.y = 0;
    }
    return self;
}

-(id) initWithX: (int) _x Y: (int) _y {
	self = [super init];
	if (self != nil) {
        self.x = _x;
        self.y = _y;
    }
    return self;
}

-(id) initWithScreenX:(float) _x ScreenY: (float) _y {
	self = [super init];
	if (self != nil) {
        self.x = div(_x-15, 20).quot;
        self.y = div(_y-15,20).quot;
        NSLog(@"init with screen %f %f %i %i", _x , _y, self.x , self.y);
        // как-то преобразуем координаты
//        self.x = 1;
//        self.y = 1;
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"{%i %i}", self.x, self.y];
}


@end
