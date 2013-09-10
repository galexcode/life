//
//  SKCanvas.m
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 08.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import "SKCanvas.h"

@implementation SKCanvas
{
    NSTimer *myTicker;
}

@synthesize points, maxX, maxY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{


//    [self.points addObject: [[SKLifeItem alloc ]initWithX: 1 Y: 1] ];
//    [self.points addObject:[[SKLifeItem alloc ]initWithX: 5 Y: 2] ];
//    [self.points addObject:[[SKLifeItem alloc ]initWithX: 10 Y: 3]];


    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

    CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 1.0f, 0.5f);
    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 0.0f, 0.5f);

    //CGContextRotateCTM(ctx, M_PI);

    CGContextTranslateCTM(ctx, 10, 10);

    /*
     CGContextMoveToPoint(ctx, 0,0);
     CGContextAddLineToPoint(ctx, 100, 0);
     CGContextStrokePath(ctx);

     CGContextMoveToPoint(ctx, 0,0);
     CGContextAddLineToPoint(ctx, 0, 100);
     CGContextStrokePath(ctx);
     */
    [self drawCellsWithContext:ctx];
    CGContextSetRGBStrokeColor(ctx, 1.0f, 0.0f, 0.0f, 1);

    for (SKLifeItem* cell in self.points) {
        float x = cell.x * 20 + 2.0;
        float y = cell.y * 20 + 2.0;

//        //NSLog(@" x = %i y = %i xx = %f yy = %f" , cell.x, cell.y, x, y);
        CGRect rectangle = CGRectMake(x,y, 16.0, 16.0 );
        CGContextFillRect(ctx, rectangle);

    }


}

-(void) drawCellsWithContext: (CGContextRef)ctx {
    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1);
    CGRect rectangle = CGRectMake(0,0, self.bounds.size.width -20, self.bounds.size.height-20 );
    CGContextSetLineWidth(ctx, 3.0f);
    CGContextStrokeRect(ctx, rectangle);

    CGContextSetLineWidth(ctx, 1.0f);
    self.maxX = 0;
    self.maxY = 0;
    int x = 20;
    while (x < self.bounds.size.width){
        self.maxX++;
        CGContextMoveToPoint(ctx, x,0);
        CGContextAddLineToPoint(ctx, x, self.bounds.size.height - 20 );
        CGContextStrokePath(ctx);
        x += 20;
    }
    int y = 20;
    while (y < self.bounds.size.height){
        self->maxY++;
        CGContextMoveToPoint(ctx, 0, y);
        CGContextAddLineToPoint(ctx, self.bounds.size.width - 20, y);
        CGContextStrokePath(ctx);
        y += 20;
    }
    //NSLog(@" x = %i, y = %i", self.maxX, self.maxY);
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint tp = [touch locationInView: self];
    float x = tp.x;
    float y = tp.y;

    if (self.points == nil) {
        self.points = [NSMutableArray arrayWithCapacity:1];
    }
    if ([self.points count ] >= 10) {

        //NSLog(@"все");
//        [self twingle];
        myTicker = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
                                       selector:@selector(twingle)
                                       userInfo: nil
                                        repeats: YES];

    } else {
        //NSLog(@"тык %f %f" , x , y);
        SKLifeItem* item = [[SKLifeItem alloc] initWithScreenX: x ScreenY: y];
        [self.points addObject: item ];
        [self setNeedsDisplay];
        //NSLog(@" %@ " , self.points);
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
