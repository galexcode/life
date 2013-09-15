//
//  SKCanvas.m
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 08.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import "SKCanvas.h"

const CGFloat CELL_SIZE = 20.0;
@implementation SKCanvas
{
    NSTimer *myTicker;
    CGRect lifeField;
}

@synthesize points, field, maxX, maxY;

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


    [self drawCellsWithContext:ctx];

    CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 1.0f, 0.5f);
    for (SKLifeItem* cell in self.field.points) {
        float x = [self convertToScreenCellX:cell.x];
        float y = [self convertToScreenCellY:cell.y];

        CGRect rectangle = CGRectMake(x,y, CELL_SIZE - 4, CELL_SIZE - 4 );
        CGContextFillRect(ctx, rectangle);
    }
    countLabel.text = [NSString stringWithFormat:@"Точек: %i", [self.field.points count] ];


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


/**Преобразует номер ячейки в экранную координату
 */
- (CGFloat) convertToScreenCellX:(int) _x {
    return _x*CELL_SIZE + lifeField.origin.x + 2;
}

/**Преобразует номер ячейки в экранную координату
 */
- (CGFloat) convertToScreenCellY:(int) _y {
    return _y*CELL_SIZE + lifeField.origin.y + 2;
}


// рисует сетку
//
-(void) drawCellsWithContext: (CGContextRef)ctx {

    CGFloat screenWidth = self.bounds.size.width;
    CGFloat screenHeight = self.bounds.size.height - 40;

    div_t ret = div(screenWidth, CELL_SIZE);
    self.maxX = ret.quot;
    CGFloat len = (ret.quot - 1) * CELL_SIZE;
    CGFloat startX = (screenWidth - len) / 2;
    ret = div(screenHeight, CELL_SIZE);
    self.maxY = ret.quot;
    CGFloat hight = (ret.quot - 1) * CELL_SIZE;
    CGFloat startY = (screenHeight - hight) / 2;

    CGContextSetRGBStrokeColor(ctx, 0.5f, 0.5f, 0.5f, 1.0f);
    CGContextSetLineWidth(ctx, 1.0f);
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

    ////NSLog(@" x = %i, y = %i", self.maxX, self.maxY);
}


// обработчик touch
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint tp = [touch  locationInView: self];
    float x = tp.x;
    float y = tp.y;

    if (self.points == nil) {
        self.points = [NSMutableArray arrayWithCapacity:1];
        self.field = [[SKLifeField alloc] initWithSizeX: self.maxX-1 SizeY: self.maxY-1 ];
    }
    if ( !CGRectContainsPoint(lifeField, tp) ) {
            return;
    }
    int cellX = [self convertToCellScreenX:x];
    int cellY = [self convertToCellScreenY:y];
//        ////NSLog(@"тык %f %f  %f %i  %f %i", x, y, startX , cellX,  startY, cellY);

    [self.field addPointWithX:cellX Y:cellY];
    [self setNeedsDisplay];
}

- (void) twingle {
    if([self.field.points count] == 0) {
        [myTicker invalidate];
    }
    [self.field recountField];
    [self setNeedsDisplay];

}


-(IBAction)stepLife{
    [myTicker invalidate];
    [self twingle];
}

-(IBAction)stopLife{
    [myTicker invalidate];
}


-(IBAction)startLife{
   [self twingle];
    myTicker = [NSTimer scheduledTimerWithTimeInterval:0.3 target: self
                                              selector:@selector(twingle)
                                              userInfo: nil
                                               repeats: YES];
}

@end
