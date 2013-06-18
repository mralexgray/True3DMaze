//
//  MazeSetting.m
//  True3DMaze
//
//  Created by Terazzo on 11/12/17.
//
#define MAZE_SETTING_INCLUDE

#import "MazeSetting.h"

@interface MazeSetting(Private)
- (void)notifyAppearanceChanged;
@end

@implementation MazeSetting

@synthesize mazeSizeX, mazeSizeY, mazeSizeZ, opaque, borderWidth, cornerRadius, wallColor, throughWalls, freeRotation;

static BOOL hasInitialized = NO;
static NSArray *appearanceKeys;
+ (void)initialize
{
    if (!hasInitialized) {
//        MazeAppearanceSettingDidChangeNotification = @"MazeAppearanceSettingDidChangeNotification";
//        appearanceKeys = ;
        hasInitialized = YES;
    }
}

- (id)init
{
    if (self = [super init]) {
        self.mazeSizeX = 7;
        self.mazeSizeY = 7;
        self.mazeSizeZ = 7;
        self.opaque = 0.7f;
        self.borderWidth = 0.5f;
        self.cornerRadius = 2.0f;
        self.wallColor = [NSColor whiteColor];
        self.throughWalls = NSOffState;
        self.freeRotation = NSOffState;
    }
    return self;
}
- (void)didChangeValueForKey:(NSString *)key
{
		NSLog(@"%@  key: %@", NSStringFromSelector(_cmd), key);
    [super didChangeValueForKey:key];
	if ([@[@"opaque", @"borderWidth", @"cornerRadius", @"wallColor"] containsObject:key])
		[NSNotificationCenter postNotificationName:MazeAppearanceSettingDidChangeNotification object:self];
}
//        [self notifyAppearanceChanged];
//    }
//}
//- (void)notifyAppearanceChanged
//{
//    [[NSNotificationCenter defaultCenter]
//        postNotificationName:MazeAppearanceSettingDidChangeNotification
//        object:self];
//}
@end
