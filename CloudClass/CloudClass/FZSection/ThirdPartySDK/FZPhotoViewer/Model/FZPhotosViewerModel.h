//
//  FZPhotosViewerModel
//
//  Created by Liuyong on 15-1-19.
//

#import "MTLModel.h"

@interface FZPhotosViewerModel : MTLModel

@property (copy, nonatomic) NSString *icon; //url
@property (copy, nonatomic) NSString *desc;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, strong) NSString *isavatar;

@end
