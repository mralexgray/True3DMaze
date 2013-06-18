//
//  MazeSetting.m
//  True3DMaze
//
//  Created by Terazzo on 11/12/17.
//
#define MAZE_SETTING_INCLUDE

#import "MazeSetting.h"

@implementation MazeSetting

- (id)init	{	return self = [super init] ?

	_cellSize  		= 25.0f,
	_mazeSizeX		= 5,
	_mazeSizeY 		= 6,
	_mazeSizeZ 		= 6,
	_opaque 			= 0.7f,
	_borderWidth 	= 0.5f,
	_cornerRadius 	= 2.0f,
	_wallColor 		= [NSColor whiteColor],
	_throughWalls 	= NSOnState,
	_freeRotation 	= NSOnState, self : nil;
}

- (void)didChangeValueForKey:(NSString *)key	{
	NSLog(@"%@  key: %@", NSStringFromSelector(_cmd), key);
   [super didChangeValueForKey:key];
	[@[@"cellSize", @"opaque", @"borderWidth", @"cornerRadius", @"wallColor"] containsObject:key] ?
	[NSNotificationCenter postNotificationName:MazeAppearanceChanged object:self userInfo:@{key:[self valueForKey:key]}] : nil;
}
@end
