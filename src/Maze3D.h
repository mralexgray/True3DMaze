//
//  Maze3D.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/14.
//

#import <QuartzCore/CoreAnimation.h>
#import "MazeTypes.h"

@class  MazeController;
@interface Maze3D : NSObject
{
    int sizeX;
    int sizeY;
    int sizeZ;
    MazePosition start;
    MazePosition goal;
    char ***map;
}
@property (assign)  char ***map;
@property (weak)	MazeController *controller;
@property(readonly) int sizeX, sizeY, sizeZ;
@property(readonly) MazePosition start, goal;

- (void)constructMaze:(int)x :(int)y :(int)z controller:(MazeController*)c;

- (BOOL) isAtGoal: (MazePosition)pos;
- (BOOL) hasWallAt:(MazePosition)pos              for:(WallDirection)direction;
- (BOOL) position: (MazePosition)pos  isAroundGoalFor:(WallDirection)direction;
- (BOOL) position: (MazePosition)pos isAroundStartFor:(WallDirection)direction;
@end

@interface Maze3D ()
- (unsigned)checkAround:(int)x :(int)y :(int)z :(CellType)value;
- (void)allocateMap:(int)x :(int)y :(int)z;
- (void)freeMap;
@end
