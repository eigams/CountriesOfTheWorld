//
//  GameOfLifeCell.h
//  RKGeonames
//
//  Created by Stefan Buretea on 2/10/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

#ifndef RKGeonames_GameOfLifeCell_h
#define RKGeonames_GameOfLifeCell_h


@interface GameOfLifeCell : NSObject

@property (nonatomic, assign) BOOL state;
@property (nonatomic, strong) NSArray *neighbours;
@property (nonatomic, strong) CGPoint *position;

- (void)determineCellState;



@end

static const int MAX_NEIGHBOURS = 8;

- (NSArray *) findNeighbours:(NSArray *)gridData {
    
    NSMutableArray *sink = [NSMutableArray arrayWithCapacity:MAX_NEIGHBOURS];
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x - 1] objectAtindex:self.position.y];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x + 1] objectAtindex:self.position.y];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x - 1] objectAtindex:self.position.y - 1];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x - 1] objectAtindex:self.position.y + 1];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x + 1] objectAtindex:self.position.y + 1];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x + 1] objectAtindex:self.position.y];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x - 1] objectAtindex:self.position.y];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    GameOfLifeCell *neighbour = [[gridData objectAtindex: self.position.x - 1] objectAtindex:self.position.y];
    if(neighbour) {
        [sink addObject:neighbour];
    }
    
    return sink;
    
}

@implementation GameOfLifeCell

- (id)initWithGrid:(NSArray *)grid andPosition:(CGPoint) position{
    
    self = [super init];
    if(self) {
        self.state = NO;
        self.neighbours = [NSArray arrayWithCapacity:MAX_NEIGHBOURS];
        
        self.position.x = position.x;
        self.position.y = position.y;
        
        self.neighbours = [[self findNeighbours:grid] copy];
    }
}

- (void)determineCellState {
    
    int aliveNeighbours = 0;
    for(GameOfLifeCell *neighbour in neighbours) {
        
        if(neighbour.state) {
            ++aliveNeighbours;
        }
    }
    
    if(self.state) {
        if(aliveNeighbours < 2 || aliveNeighbours > 3) {
            self.state = NO;
        }
        
    } else {
        if(aliveNeighbours == 3) {
            self.state = YES;
        }
    }
    
}

@end

static const int GRID_XSIZE = 10;
static const int GRID_YSIZE = 10;

@interface GameOfLifeGrid : NSObject

@property (nonatomic, strong) NSArray *cells[GRID_XSIZE];



@end

for(int i = 0; i < cells.count; ++i) {
    
    NSArray *rowCells = [cells objectAtindex:i];
    
    for (j = 0; j < rowCells.count; ++j) {
        GameOfLifeCell *cell = [rowCells objectAtindex:j];
        
        [cell determineCellState];
    }
}



#endif
