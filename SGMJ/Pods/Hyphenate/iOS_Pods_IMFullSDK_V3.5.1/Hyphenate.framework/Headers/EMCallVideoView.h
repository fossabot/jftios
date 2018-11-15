//
//  EMCallVideoView.h
//  RtcSDK
//
//  Created by XieYajie on 2018/7/3.
//  Copyright © 2018 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
typedef enum {
    EMCallViewScaleModeAspectFit = 0,   /*! \~chinese 按比例缩放 \~english Aspect fit */
    EMCallViewScaleModeAspectFill = 1,  /*! \~chinese 全屏 \~english Aspect fill */
} EMCallViewScaleMode;


#pragma mark - EMCallLocalView

/*!
 *  \~chinese
 *  @header EMCallLocalView.h
 *  @abstract 视频通话本地图像显示页面
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallLocalView.h
 *  @abstract Video call local view
 *  @author Hyphenate
 *  @version 3.00
 */
@interface EMCallLocalView : UIView

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
@property (nonatomic, assign) EMCallViewScaleMode scaleMode;

@property (nonatomic, assign) BOOL previewDirectly;

@property (nonatomic, assign) BOOL autoGesture;

- (CGPoint)layerPointFromRatioPoint:(CGPoint)aPointOfRatio
                         fromRemote:(BOOL)aFromRemote;

- (CGPoint)viewPointFromLayerPoint:(CGPoint)aPointOfLayer;

- (CGPoint)devicePointFromLayerPoint:(CGPoint)aPointOfLayer;

@end


#pragma mark - EMCallRemoteView

/*!
 *  \~chinese
 *  @header EMCallRemoteView.h
 *  @abstract 视频通话对方图像显示页面
 *  @author Hyphenate
 *  @version 3.00
 *
 */
@interface EMCallRemoteView : UIView

/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
@property (nonatomic, assign) EMCallViewScaleMode scaleMode;

@property (nonatomic, assign) BOOL previewDirectly;

- (CGPoint)getInterestForUIPoint:(CGPoint)aPoint;

@end
