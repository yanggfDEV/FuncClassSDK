//
//  FZPhotosViewerModel
//
//  Created by Liuyong on 15-1-19.
//

#import "FZPhotosViewerModel.h"

@implementation FZPhotosViewerModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"icon":@"url",
             @"desc":@"desc"
             };
}

@end
