//
//  MazeLayer.h
//  MazeSample
//
//  Created by Terazzo on 11/12/14.
//

#import <QuartzCore/CoreAnimation.h>
#import "MazeTypes.h"

@class MazeController;
@interface      MazeLayer : CALayer

@property (weak) MazeController *controller;
@property           NSIMG * icon;
@property             NSC * color;
@property    MazePosition   mazePosition;
@property (nonatomic) 		 Direction   direction;
@property 				BOOL   special;
@property (nonatomic) 	CATransform3D   mazeTransform;
@property 	CATransform3D   originalTransform;
@property  (readonly) CGF   PIECE_SIZE;

+   (id)  layerWithPosition:(MazePosition)position for:(Direction)direction controller:(MazeController*)ctr;
- (void) updateTransform:(CATransform3D)viewPointTransform;
@end


//{	BOOL special;
//	CATransform3D originalTransform;	}