//
//  Maze3D.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/14.
//

#import <QuartzCore/CoreAnimation.h>
#import "MazeTypes.h"

@interface Maze3D : NSObject {
    int sizeX;
    int sizeY;
    int sizeZ;
    MazePosition start;
    MazePosition goal;
    char ***map;
}
@property(readonly) int sizeX, sizeY, sizeZ;
@property(readonly) MazePosition start, goal;

- (void)constructMaze:(int)x :(int)y :(int)z;

- (BOOL) isAtGoal: (MazePosition)pos;
- (BOOL) hasWallAt:(MazePosition)pos              for:(WallDirection)direction;
- (BOOL) position: (MazePosition)pos  isAroundGoalFor:(WallDirection)direction;
- (BOOL) position: (MazePosition)pos isAroundStartFor:(WallDirection)direction;
@end

#ifdef MAZE_3D_INCLUDE
#define MAZE_3D_EXTERN
#else
#define MAZE_3D_EXTERN extern
#endif


// Notification names
MAZE_3D_EXTERN NSString *Maze3DDidInitializeNotification;
