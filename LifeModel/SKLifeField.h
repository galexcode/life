//
//  SKLifeField.h
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 13.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLifeItem.h"

@interface SKLifeField : NSObject

@property NSUInteger sizeX;
@property NSUInteger sizeY;

@property NSMutableArray *points;



-(id) init;

-(id) initWithSizeX: (int) _x SizeY: (int) _y ;

-(BOOL) addPointWithX:(int) _x Y:(int) _y;

-(void) recountField;
@end
