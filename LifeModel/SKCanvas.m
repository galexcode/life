//
//  SKCanvas.m
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 08.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import "SKCanvas.h"

const CGFloat CELL_SIZE = 40.0;
@implementation SKCanvas
{
    NSTimer *myTicker;

    CGRect lifeField;
     
}

@synthesize points, maxX, maxY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }

    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

    CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 1.0f, 0.5f);

    [self drawCellsWithContext:ctx];

    for (SKLifeItem* cell in self.points) {
        float x = [self convertToScreenCellX:cell.x];
        float y = [self convertToScreenCellY:cell.y];

        CGRect rectangle = CGRectMake(x,y, CELL_SIZE - 4, CELL_SIZE - 4 );
        CGContextFillRect(ctx, rectangle);
    }


}
/**
 Преобразует экранную координатy в номер ячейки
 */
-(int) convertToCellScreenX:(CGFloat) _x {
    return div( _x - lifeField.origin.x , CELL_SIZE).quot;
}

/**
 Преобразует экранную координатy в номер ячейки
 */
-(int) convertToCellScreenY:(CGFloat) _y {
    return div( _y - lifeField.origin.y , CELL_SIZE).quot;
}


- (CGFloat) convertToScreenCellX:(int) _x {
    return _x*CELL_SIZE + lifeField.origin.x + 2;
}

- (CGFloat) convertToScreenCellY:(int) _y {
    return _y*CELL_SIZE + lifeField.origin.y + 2;
}


// рисует сетку
//
-(void) drawCellsWithContext: (CGContextRef)ctx {

    CGFloat screenWidth = self.bounds.size.width;
    CGFloat screenHeight = self.bounds.size.height - 40;

    div_t ret = div(screenWidth, CELL_SIZE);
    CGFloat len = (ret.quot - 1) * CELL_SIZE;
    CGFloat startX = (screenWidth - len) / 2;
    ret = div(screenHeight, CELL_SIZE);
    CGFloat hight = (ret.quot - 1) * CELL_SIZE;
    CGFloat startY = (screenHeight - hight) / 2;

    CGContextSetRGBStrokeColor(ctx, 0.5f, 0.5f, 0.5f, 1.0f);
    CGContextSetLineWidth(ctx, 1.0f);
    self.maxX = 0;
    self.maxY = 0;
    for (int x = startX; x <= startX + len; x += CELL_SIZE) {
        CGContextMoveToPoint(ctx, x, startY);
        CGContextAddLineToPoint(ctx, x, startY + hight );
        CGContextStrokePath(ctx);
    }

    for (int y = startY; y <= startY + hight; y += CELL_SIZE) {
        CGContextMoveToPoint(ctx, startX, y);
        CGContextAddLineToPoint(ctx, startX + len, y );
        CGContextStrokePath(ctx);
    }


    CGContextSetRGBStrokeColor(ctx, 1.5f, 1.5f, 1.5f, 1.0f);
    lifeField = CGRectMake(startX, startY, len, hight );
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextStrokeRect(ctx, lifeField);

    //NSLog(@" x = %i, y = %i", self.maxX, self.maxY);
}


- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint tp = [touch  locationInView: self];
    float x = tp.x;
    float y = tp.y;

    if (self.points == nil) {
        self.points = [NSMutableArray arrayWithCapacity:1];
    }
    if ([self.points count ] >= 10) {

        //NSLog(@"все");
//        [self twingle];
        myTicker = [NSTimer scheduledTimerWithTimeInterval:0.3 target: self
                                       selector:@selector(twingle)
                                       userInfo: nil
                                        repeats: YES];

    } else {
        if ( !CGRectContainsPoint(lifeField, tp) ) {
            return;
        }
        int cellX = [self convertToCellScreenX:x];
        int cellY = [self convertToCellScreenY:y];
//        NSLog(@"тык %f %f  %f %i  %f %i", x, y, startX , cellX,  startY, cellY);
        SKLifeItem* item = [[SKLifeItem alloc] initWithX: cellX Y: cellY  ];
        [self.points addObject: item ];
        [self setNeedsDisplay];
    }
}


-(BOOL) containsInPointsByX:(int) _x Y: (int) _y {
// это самый ресурсоемкий метод
    //NSLog(@"x = %i y = %i", _x, _y);
//    //NSLog(@"arrays %@ %@", self.pointsX, self.pointsY);

    for (SKLifeItem* item in self.points) {
        //NSLog(@"check pair %i %i", item.x, item.y);
        if (item.x == _x && item.y == _y) {
            return YES;
        }
    }
    return NO;
}


-(void) addCandidateTo:(NSCountedSet*) cells WithX:(int) x Y:(int) y {
    //NSLog(@"try add %i %i %i %i", x, y, self.maxX, self.maxY);
    if( x < 0 || x > self.maxX - 1) {
        //NSLog(@"no add. x border");
        return;
    }
    if ( y < 0 || y > self.maxY -1 ) {
        //NSLog(@"no add. y border");
        return;
    }
    if ( [self containsInPointsByX:x Y:y]) {
        //NSLog(@"no add. points contain this");
        return;
    }
    //NSLog(@"add");
    [cells addObject: [NSString stringWithFormat: @"%i,%i", x, y] ];
}


-(void) addCandidatesTo:(NSCountedSet*) _candidateCells forPoint:(SKLifeItem*) point {

    int x = point.x;
    int y = point.y;

    int newX = x-1;
    int newY = y-1;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x-1;
    newY = y;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x-1;
    newY = y+1;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x+1;
    newY = y-1;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x+1;
    newY = y;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x+1;
    newY = y+1;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x;
    newY = y-1;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

    newX = x;
    newY = y+1;
    [self addCandidateTo: _candidateCells WithX: newX Y:newY];

}


-(BOOL) mustDie:(SKLifeItem*) _item {
    // проверяет должен ли данный элемент умереть
    int x = _item.x;
    int y = _item.y;
    int minX = x - 1;
    if (minX < 0) {
        minX = 0;
    }
    int minY = y - 1;
    if (minY < 0) {
        minY = 0;
    }
    int maxXX = x + 1;
    if (maxXX >= self.maxX - 1) {
        maxXX = x;
    }
    int maxYY = y + 1;
    if (maxYY >= self.maxY -1) {
        maxYY = y;
    }
    // кол-во соседей
    int cntNear = 0;
    for(int i = 0; i < [self.points count]; i++) {
        SKLifeItem* item = [self.points objectAtIndex:i];
        if (item.x == x && item.y == y) {
            continue;
        }
        if (item.x >= minX && item.x <= maxXX && item.y >= minY && item.y <= maxYY) {
            cntNear++;
            if (cntNear >= 4) {
                return YES;
            }
        }
    }
    if (cntNear >= 4 || cntNear <= 1) {
        return YES;
    } else {
        return NO;
    }


}

- (void) twingle {
    if([self.points count] == 0) {
        [myTicker invalidate];
    }
    //NSLog(@"start %@", self.points);

    NSCountedSet* newCells = [[NSCountedSet alloc] init];
    for (SKLifeItem* cell in self.points) {
        [self addCandidatesTo:newCells forPoint:cell];
    }

    NSMutableArray* newItems = [NSMutableArray arrayWithCapacity:1];
    for (NSString* str in [newCells allObjects] ){
        //NSLog(@" %@ %i", str , [newCells countForObject:str]);
        if ([newCells countForObject:str] == 3) {
            NSArray *split = [str componentsSeparatedByString:@","];

            int x = [[split objectAtIndex:0] intValue];
            int y = [[split objectAtIndex:1] intValue ];

            [newItems addObject: [[SKLifeItem alloc] initWithX: x Y: y]];
        }
    }
    [self setNeedsDisplay];

    //NSLog(@"before die %@", self.points);
    NSMutableArray* die = [NSMutableArray arrayWithCapacity:1];

    for (SKLifeItem* item in self.points) {
        if ( [self mustDie:item] ) {
            [die addObject:item ];
        }
    }
    for (SKLifeItem* item in die) {
        [self.points removeObject:item];
    }
    [self.points addObjectsFromArray:newItems];


    if ([newItems count] == 0 && [die count] == 0) {
        [myTicker invalidate];
    }
    //NSLog(@"itogo %@ ", self.points);

    [self setNeedsDisplay];

}





@end
