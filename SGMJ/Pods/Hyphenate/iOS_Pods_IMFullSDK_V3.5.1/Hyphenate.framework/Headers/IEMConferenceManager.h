/*!
 *  \~chinese
 *  @header IEMConferenceManager.h
 *  @abstract 此协议定义了多人实时音频/视频通话相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMConferenceManager.h
 *  @abstract This protocol defines a multiplayer real-time audio / video call related operation
 *  @author Hyphenate
 *  @version 3.00
 */

#ifndef IEMConferenceManager_h
#define IEMConferenceManager_h

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "EMCallConference.h"
#import "EMCallVideoView.h"
#import "EMConferenceManagerDelegate.h"

@class EMError;

/*!
 *  \~chinese
 *  多人会议场景
 *
 *  \~english
 *  Conference mode
 */
typedef enum {
    EMConferenceModeNormal = 0,    /*! \~chinese 人数较少 \~english A small number of people for video conferencing */
    EMConferenceModeLarge,        /*! \~chinese 人数较多 \~english A large number of people for video conferencing */
} EMConferenceMode EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE");

/*!
 *  \~chinese
 *  多人实时音频/视频通话相关操作
 *
 *  \~english
 *  Multi-user real-time audio / video call related operations
 */
@protocol IEMConferenceManager <NSObject>

@optional

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<EMConferenceManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<EMConferenceManagerDelegate>)aDelegate;

#pragma mark - Conference

/*!
 *  \~chinese
 *  设置应用Appkey, 环信ID, 环信ID对应的Token
 *
 *  @param aAppkey           应用在环信注册的Appkey
 *  @param aUserName         环信ID
 *  @param aToken            环信ID对应的Token
 *
 *  \~english
 *  Setup MemberName
 *
 *  @param aAppkey           AppKey in Hyphenate
 *  @param aUserName         The Hyphenate ID
 *  @param aToken            The token of Hyphenate ID
 */
- (void)setAppkey:(NSString *)aAppkey
         username:(NSString *)aUsername
            token:(NSString *)aToken;

/*!
 *  \~chinese
 *  构建MemberName
 *
 *  @param aAppkey           应用在环信注册的Appkey
 *  @param aUserName         环信ID
 *
 *  @result MemberName
 *
 *  \~english
 *  Setup MemberName
 *
 *  @param aAppkey           AppKey in Hyphenate
 *  @param aUserName         The Hyphenate ID
 *
 *  @result MemberName
 */
- (NSString *)getMemberNameWithAppkey:(NSString *)aAppkey
                             username:(NSString *)aUserName;

/*!
 *  \~chinese
 *  判断会议是否存在
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Determine if the conference exists
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)getConference:(NSString *)aConfId
             password:(NSString *)aPassword
           completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  创建并加入会议
 *
 *  @param aType             会议类型
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aType             The type of the conference
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithType:(EMConferenceType)aType
                               password:(NSString *)aPassword
                             completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加入已有会议
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Join a conference
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)joinConferenceWithConfId:(NSString *)aConfId
                        password:(NSString *)aPassword
                      completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  加入已有会议
 *
 *  @param aTicket           加入会议的凭证
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Join a conference
 *
 *  @param aTicket           Conference Tickets
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)joinConferenceWithTicket:(NSString *)aTicket
                      completion:(void (^)(EMCallConference *aCall, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  上传本地摄像头的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamParam      数据流的配置项
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Publish the data stream of the local camera
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamParam      The config of stream
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)publishConference:(EMCallConference *)aCall
              streamParam:(EMStreamParam *)aStreamParam
               completion:(void (^)(NSString *aPubStreamId, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  取消上传本地摄像头的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamId         数据流ID（在[IEMConferenceManager publishConference:pubConfig:completion:]返回）
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Cancel the publish of the local camera's data stream
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamId         Stream id (in [IEMConferenceManager publishConference:pubConfig:completion:] return)
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)unpublishConference:(EMCallConference *)aCall
                   streamId:(NSString *)aStreamId
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  订阅其他人的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamId         数据流ID (在[EMConferenceManagerDelegate streamDidUpdate:addStream]中返回)
 *  @param aRemoteView       视频显示页面
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Subscribe to other user`s data streams
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamId         Stream id (in [EMConferenceManagerDelegate streamDidUpdate:addStream] return )
 *  @param aRemoteView       Video display view
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)subscribeConference:(EMCallConference *)aCall
                   streamId:(NSString *)aStreamId
            remoteVideoView:(EMCallRemoteView *)aRemoteView
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  取消订阅的数据流
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aStreamId         数据流ID
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Unsubscribe data stream
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aStreamId         Stream id
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)unsubscribeConference:(EMCallConference *)aCall
                     streamId:(NSString *)aStreamId
                   completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  改变成员角色，需要管理员权限
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aMemberNameList   成员名列表
 *  @param aRole             成员角色
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Changing member roles, requires administrator privileges
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aMemberNameList   Member Name list
 *  @param aRole             The Role
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)changeMemberRoleWithConfId:(NSString *)aConfId
                       memberNames:(NSArray<NSString *> *)aMemberNameList
                              role:(EMConferenceRole)aRole
                        completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  踢人，需要管理员权限
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aMemberNameList   成员名列表
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Kick members, requires administrator privileges
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aMemberNameList   Member Name list
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)kickMemberWithConfId:(NSString *)aConfId
                 memberNames:(NSArray<NSString *> *)aMemberNameList
                  completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  销毁会议，需要管理员权限
 *
 *  @param aConfId           会议ID(EMCallConference.confId)
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Destroy conference, requires administrator privileges
 *
 *  @param aConfId           Conference ID (EMCallConference.confId)
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)destroyConferenceWithId:(NSString *)aConfId
                     completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  离开会议（创建者可以离开，最后一个人离开，会议销毁）
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Leave the conference (the creator can leave, the last person to leave, the conference is destroyed)
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)leaveConference:(EMCallConference *)aCall
             completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  开始监听说话者
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aTimeMillisecond  返回回调的间隔，单位毫秒，传0使用300毫秒[EMConferenceManagerDelegate conferenceTalkerDidChange:talkingStreamIds:]
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Start listening to the speaker
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aTimeMillisecond  The interval of callbacks [EMConferenceManagerDelegate conferenceTalkerDidChange:talkingStreamIds:], Unit milliseconds, pass 0 using 300 milliseconds
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)startMonitorSpeaker:(EMCallConference *)aCall
               timeInterval:(long long)aTimeMillisecond
                 completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  结束监听说话者
 *
 *  @param aCall             会议实例（自己创建的无效）
 *
 *  \~english
 *  Stop listening to the speaker
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 */
- (void)stopMonitorSpeaker:(EMCallConference *)aCall;

#pragma mark - Update

/*!
 *  \~chinese
 *  切换前后摄像头
 *
 *  @param aCall             会议实例（自己创建的无效）
 *
 *  \~english
 *  Switch the camera before and after
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 */
- (void)updateConferenceWithSwitchCamera:(EMCallConference *)aCall;

/*!
 *  \~chinese
 *  设置是否静音
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aIsMute           是否静音
 *
 *  \~english
 *  Set whether to mute
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aIsMute           Is mute
 */
- (void)updateConference:(EMCallConference *)aCall
                  isMute:(BOOL)aIsMute;

/*!
 *  \~chinese
 *  设置视频是否可用
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aEnableVideo      视频是否可用
 *
 *  \~english
 *  Set whether the video is available
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aEnableVideo      Whether the video is available
 */
- (void)updateConference:(EMCallConference *)aCall
             enableVideo:(BOOL)aEnableVideo;

/*!
 *  \~chinese
 *  更新视频显示页面
 *
 *  @param aCall             会议实例
 *  @param aStreamId         数据流ID
 *  @param aRemoteView       显示页面
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Update remote video view
 *
 *  @param aCall              EMConference instance
 *  @param aStreamId          Stream id
 *  @param aRemoteView        Video display view
 *  @param aCompletionBlock   The callback block of completion
 */
- (void)updateConference:(EMCallConference *)aCall
                streamId:(NSString *)aStreamId
         remoteVideoView:(EMCallRemoteView *)aRemoteView
              completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更新视频最大码率
 *
 *  @param aCall             会议实例
 *  @param aMaxVideoKbps     最大码率
 *
 *  \~english
 *  Update video maximum bit rate
 *
 *  @param aCall              EMConference instance
 *  @param aMaxVideoKbps      Maximum bit rate
 */
- (void)updateConference:(EMCallConference *)aCall
            maxVideoKbps:(int)aMaxVideoKbps;

#pragma mark - Input Video Data

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aSampleBuffer     视频采样缓冲区
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aSampleBuffer     Video sample buffer
 *  @param aCall             EMConference instance
 *  @param aPubStreamId      [EMConferenceManager publishConference:streamParam:completion], If successful, the value will be returned in the callback
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoSampleBuffer:(CMSampleBufferRef)aSampleBuffer
                    conference:(EMCallConference *)aCall
             publishedStreamId:(NSString *)aPubStreamId
                        format:(EMCallVideoFormat)aFormat
                      rotation:(int)aRotation
                    completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aPixelBuffer      视频像素缓冲区
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aPixelBuffer      Video pixel buffer
 *  @param aCall             EMConference instance
 *  @param aPubStreamId      [EMConferenceManager publishConference:streamParam:completion], If successful, the value will be returned in the callback
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoPixelBuffer:(CVPixelBufferRef)aPixelBuffer
                   conference:(EMCallConference *)aCall
            publishedStreamId:(NSString *)aPubStreamId
                       format:(EMCallVideoFormat)aFormat
                     rotation:(int)aRotation
                   completion:(void (^)(EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  自定义本地视频数据
 *
 *  @param aData             视频数据
 *  @param aCall             会议实例
 *  @param aPubStreamId      调用接口[EMConferenceManager publishConference:streamParam:completion]，如果成功则会在回调中返回该值
 *  @param aWidth            宽度
 *  @param aHeight           高度
 *  @param aFormat           视频格式
 *  @param aRotation         旋转角度0~360，默认0
 *  @param aCompletionBlock  完成后的回调
 *
 *  \~english
 *  Customize local video data
 *
 *  @param aData             Video data
 *  @param aCall             EMConference instance
 *  @param aPubStreamId      [EMConferenceManager publishConference:streamParam:completion], If successful, the value will be returned in the callback
 *  @param aWidth            Width
 *  @param aHeight           Height
 *  @param aFormat           Video format
 *  @param aRotation         Rotation angle 0~360, default 0
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inputVideoData:(NSData *)aData
            conference:(EMCallConference *)aCall
     publishedStreamId:(NSString *)aPubStreamId
         widthInPixels:(size_t)aWidth
        heightInPixels:(size_t)aHeight
                format:(EMCallVideoFormat)aFormat
              rotation:(int)aRotation
            completion:(void (^)(EMError *aError))aCompletionBlock;

#pragma mark - EM_DEPRECATED_IOS 3.4.3

/*!
 *  \~chinese
 *  多人会议场景
 *
 *  \~english
 *  Conference mode
 */
@property (nonatomic) EMConferenceMode mode EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE");

/*!
 *  \~chinese
 *  创建并加入会议
 *
 *  @param aPassword         会议密码
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Create and join a conference
 *
 *  @param aPassword         The password of the conference
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)createAndJoinConferenceWithPassword:(NSString *)aPassword
                                 completion:(void (^)(EMCallConference *aCall, NSString *aPassword, EMError *aError))aCompletionBlock EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -[EMConferenceManagerDelegate createAndJoinConferenceWithType:password:completion:]");

/*!
 *  \~chinese
 *  邀请人加入会议
 *
 *  @param aCall             会议实例（自己创建的无效）
 *  @param aUserName         被邀请人的环信ID
 *  @param aPassword         会议密码
 *  @param aExt              扩展信息
 *  @param aCompletionBlock  完成的回调
 *
 *  \~english
 *  Invite user join the conference
 *
 *  @param aCall             EMConference instance (invalid by yourself)
 *  @param aUserName         The Hyphenate ID of the invited user
 *  @param aPassword         The password of the conference
 *  @param aExt              Extended Information
 *  @param aCompletionBlock  The callback block of completion
 */
- (void)inviteUserToJoinConference:(EMCallConference *)aCall
                          userName:(NSString *)aUserName
                          password:(NSString *)aPassword
                               ext:(NSString *)aExt
                             error:(EMError **)pError EM_DEPRECATED_IOS(3_1_0, 3_4_3, "Use -DELETE, 在demo层自定义实现");


@end


#endif /* IEMConferenceManager_h */
