//
//  SKLifeItem.h
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 10.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKLifeItem : NSObject

@property int x;
@property int y;
// кол-во соседей
@property int countNear;

-(id) init;

-(id) initWithX: (int) _x Y: (int) _y ;


@end
