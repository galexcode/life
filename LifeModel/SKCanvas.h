//
//  SKCanvas.h
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 08.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKLifeItem.h"

@interface SKCanvas : UIView

@property int maxX;
@property int maxY;

@property NSMutableArray *points;
@property NSMutableArray *pointsX;
@property NSMutableArray *pointsY;

@end
