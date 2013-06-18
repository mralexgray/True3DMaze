//
//  True3DMaze.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/14.
//



#ifdef MAZE_3D_INCLUDE
#define MAZE_3D_EXTERN
#else
#define MAZE_3D_EXTERN extern
#endif


// Notification names
MAZE_3D_EXTERN NSString *Maze3DDidInitializeNotification;


#ifdef VIEW_POINT_INCLUDE
#define VIEW_POINT_EXTERN
#else
#define VIEW_POINT_EXTERN extern
#endif


#ifdef MAZE_SETTING_INCLUDE
#define MAZE_SETTING_EXTERN
#else
#define MAZE_SETTING_EXTERN extern
#endif

// Notification names
//MAZE_SETTING_EXTERN NSString
#define MazeAppearanceChanged @"MazeAppearanceSettingDidChangeNotification"



// Notification names
VIEW_POINT_EXTERN NSString *ViewPointDidChangeNotification;
VIEW_POINT_EXTERN NSString *ViewPointTransformKey;

// 壁等の方向
typedef enum {
    DIR_NONE,
    DIR_X,
    DIR_Y,
    DIR_Z
} WallDirection;

// 地図の値
typedef enum {
    PATH = 0,
    WALL = 1
} CellType;

// 地図上の方向
typedef enum {
    NODIR = -1,
    XMINUS = 0,
    YMINUS,
    ZMINUS,
    XPLUS,
    YPLUS,
    ZPLUS
} Direction;
#define MAX_DIRECTION ZPLUS
#define DIRECTION_MASK (1<<XMINUS|1<<YMINUS|1<<ZMINUS|1<<XPLUS|1<<YPLUS|1<<ZPLUS)

#define DIR2X(dir) (dir == XMINUS ? -1 : dir == XPLUS ? 1 : 0)
#define DIR2Y(dir) (dir == YMINUS ? -1 : dir == YPLUS ? 1 : 0)
#define DIR2Z(dir) (dir == ZMINUS ? -1 : dir == ZPLUS ? 1 : 0)
#define DIR_EMPTY(around)   ((around & DIRECTION_MASK) == 0)
#define DIR_HIT(around, dir)   (around & 1<<dir)


typedef struct _MazePosition {
    int x;
    int y;
    int z;
} MazePosition;

//#define PIECE_SIZE 20.0f

#define EPS (PIECE_SIZE / 4.0f)


NS_INLINE MazePosition makePosition(int x, int y, int z) {
//MazePosition
//makePosition(int x, int y, int z)

	MazePosition position;
	position.x = x;
	position.y = y;
	position.z = z;
	return position;
}




