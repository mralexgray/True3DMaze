//
//  MazeSetting.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/17.
//

#import <Cocoa/Cocoa.h>
#import "MazeTypes.h"


@interface 				 MazeSetting : NSObject
@property 						  NSUI 	mazeSizeX,
											  	mazeSizeY,
											  	mazeSizeZ;
@property 						  BOOL 	throughWalls,
												freeRotation,
												evenKeel;
@property 						   CGF 	opaque,
												borderWidth,
												cornerRadius,
												cellSize;
@property(strong) 				NSC * wallColor,
											 * borderColor;

//- (void)notifyAppearanceChanged;
@end




//{
//    int mazeSizeX;
//    int mazeSizeY;
//    int mazeSizeZ;
//    CGFloat opaque;
//    CGFloat borderWidth;
//    CGFloat cornerRadius;
//    NSColor *wallColor;
//    int throughWalls;
//    int freeRotation;
//
//}

