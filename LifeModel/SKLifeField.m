//
//  SKLifeField.m
//  LifeModel
//
//  Created by Aleksandr Skorokhodov on 13.09.13.
//  Copyright (c) 2013 Aleksandr Skorokhodov. All rights reserved.
//

#import "SKLifeField.h"


@implementation SKLifeField
{
    NSMutableArray* field;
}


@synthesize sizeY, sizeX, points;


-(void) initInternalStruct {
// заполняет внутреннюю матрицу ноликами
    field = [NSMutableArray arrayWithCapacity:1];

    for (int x=0; x<self.sizeX; x++) {
        NSMutableArray* row = [NSMutableArray arrayWithCapacity:self.sizeY];
        for (int y = 0; y < self.sizeY; y++) {
            [row addObject: [NSNumber numberWithInteger:0]];
        }
        [field addObject:row];
    }

    self.points = [NSMutableArray arrayWithCapacity:1];
}

// конструктор по умолчанию размером 10x10
-(id) init {
	self = [super init];
	if (self != nil) {
        self.sizeX = 10;
        self.sizeY = 10;
        [self initInternalStruct];
    }
    return self;
}

// конструктор поля размером _x на _y
-(id) initWithSizeX: (int) _x SizeY: (int) _y {
	self = [super init];
	if (self != nil) {
        self.sizeX = _x;
        self.sizeY = _y;
        [self initInternalStruct];
    }
    return self;
}

// Возвращает YES - если есть точка или NO - если нет точки по координатам _x _y
-(BOOL) fieldX:(NSUInteger) _x Y:(NSUInteger) _y {
    @try {
        NSMutableArray* col = [field objectAtIndex:_x];
        NSNumber *val = [col objectAtIndex:_y];
        return [val intValue] == 1;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
    }
}

// добавляет точку на поле
// проверяет чтобы точка попадала в поле
// и указанные координаты не заняты
// Возвращает YES  если точка добавлена NO если точку не удалось добавить
-(BOOL) addPointWithX:(int) _x Y:(int) _y {
    if ( _x > self.sizeX  || _y > self.sizeY || _x < 0 || _y < 0) {
        return NO;
    }
    if ( [self fieldX:_x  Y:_y] ) {
        return NO;
    }
    NSMutableArray* col = [field objectAtIndex:_x];
    [col replaceObjectAtIndex:_y withObject: [NSNumber numberWithInteger:1]];
    SKLifeItem* item = [[SKLifeItem alloc] initWithX: _x Y: _y  ];
    [self.points addObject: item ];
    return YES;
}

// Удаляет точку с поля
// удаляет ее из списка точек и из матрицы
-(void) removePoint:(SKLifeItem*) item {
    if ( item.x > self.sizeX  || item.y > self.sizeY || item.x < 0 || item.y < 0) {
        return ;
    }
    NSMutableArray* col = [field objectAtIndex:item.x];
    [col replaceObjectAtIndex:item.y withObject: [NSNumber numberWithInteger:0]];
    [self.points removeObject: item ];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"field %i x %i", self.sizeX, self.sizeY];
}


// добавляет точку x,y в список cells
// добавляет точку в список если эта точка находится внутри поля
// и не входит в текущий список точек points
-(void) addCandidateTo:(NSCountedSet*) cells WithX:(int) x Y:(int) y {
    if( x < 0 || x > self.sizeX - 1) {
        return;
    }
    if ( y < 0 || y > self.sizeY -1 ) {
        return;
    }
    if ( [self fieldX:x Y:y] == YES) {
        return;
    }
    [cells addObject: [NSString stringWithFormat: @"%i,%i", x, y] ];
}

// добавляет соседей точки point в список _candidateCells
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


// Формирует список новых точек
// тех что родятся на этом шаге
-(NSMutableArray*) newGenerationItems {
    NSCountedSet* newCells = [[NSCountedSet alloc] init];
    for (SKLifeItem* cell in self.points) {
        [self addCandidatesTo:newCells forPoint:cell];
    }

    NSMutableArray* newItems = [NSMutableArray arrayWithCapacity:1];
    for (NSString* str in [newCells allObjects] ){
        if ([newCells countForObject:str] == 3) {
            NSArray *split = [str componentsSeparatedByString:@","];

            int x = [[split objectAtIndex:0] intValue];
            int y = [[split objectAtIndex:1] intValue];

            [newItems addObject: [[SKLifeItem alloc] initWithX: x Y: y]];
        }
    }
    return newItems;


}
// Определяет должен ли этот элеметн умереть на текущем шаге
-(BOOL) mustDie:(SKLifeItem*) _item {
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
    int maxX = x + 1;
    if (maxX >= self.sizeX - 1) {
        maxX = x;
    }
    int maxY = y + 1;
    if (maxY >= self.sizeY -1) {
        maxY = y;
    }
    // кол-во соседей
    int cntNear = 0;
    int xx = minX;
    int yy = minY;
    while (xx <= maxX) {
        while( yy <= maxY) {
            //NSLog(@" %i %i cnt %i" , xx, yy, cntNear);
            if ((x == xx ) && (y == yy) ) {
                yy++;
            } else {
                if ( [self fieldX:xx Y:yy] == YES ) {
                    cntNear++;
                    if (cntNear >= 4) {
                        return YES;
                    }
                }
                yy++;
            }
        }
        yy = minY;
        xx++;
    }

    /*
     хорошо бы точнее проверить какой метод быстрее (тот что с двумы while и матрицей
     или каждый раз бегать по массиву точек)
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
*/
    if (cntNear >= 4 || cntNear <= 1) {
        return YES;
    } else {
        return NO;
    }
}


// Формирует список точек для удаления на данном шаге
// точки для удаления это подмножество self.points
-(NSMutableArray*) itemsForDie {

    NSMutableArray* die = [NSMutableArray arrayWithCapacity:1];

    for (SKLifeItem* item in self.points) {
        if ( [self mustDie:item] ) {
            [die addObject:item ];
        }
    }
    return die;
}

// Пересчитываем все поле
-(void) recountField {

    NSMutableArray* newItems  = [self newGenerationItems];

    NSMutableArray* dieItems = [self itemsForDie];

    for (SKLifeItem* item in dieItems) {
        [self removePoint: item];
    }

    for (SKLifeItem* newItem in newItems) {
        [self addPointWithX:newItem.x Y:newItem.y];
    }

}


@end
