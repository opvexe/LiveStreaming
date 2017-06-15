//
//  LiveStreamView.m
//  LiveStreaming
//
//  Created by jieku on 2017/6/15.
//  Copyright © 2017年 jieku. All rights reserved.
//

#import "LiveStreamView.h"
#import <Masonry.h>
#import <LFLiveKit.h>

@interface LiveStreamView ()<LFLiveSessionDelegate>
@property (nonatomic, strong) UILabel       *stateLabel;
@property (nonatomic, strong) UIButton      *beautyButton;
@property (nonatomic, strong) UIButton      *cameraButton;
@property (nonatomic, strong) UIButton      *closeButton;
@property (nonatomic, strong) UIButton      *startLiveButton;
@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) LFLiveSession *liveSession;

@end
@implementation LiveStreamView

- (UIView*)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.frame = self.bounds;
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _backView;
}

- (UILabel*)stateLabel{
    if(!_stateLabel){
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 40)];
        _stateLabel.text = @"未连接";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14.f];
        
    }
    return _stateLabel;
}

- (UIButton*)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton new];
        _closeButton.tag =100;
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dothings:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton*)cameraButton{
    if(!_cameraButton){
        _cameraButton = [UIButton new];
        _cameraButton.tag =101;
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(dothings:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (UIButton*)beautyButton{
    if(!_beautyButton){
        _beautyButton = [UIButton new];
        _beautyButton.tag = 102;
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateSelected];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateNormal];
        [_beautyButton addTarget:self action:@selector(dothings:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _beautyButton;
}

- (UIButton*)startLiveButton{
    if(!_startLiveButton){
        _startLiveButton = [UIButton new];
        _startLiveButton.tag =103;
        _startLiveButton.layer.cornerRadius = 44/2;
        [_startLiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
        _startLiveButton.backgroundColor = [UIColor redColor];
        [_startLiveButton addTarget:self action:@selector(dothings:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startLiveButton;
}

- (LFLiveSession*)liveSession{
    if(!_liveSession){
        _liveSession = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]];
        _liveSession.delegate = self;
        _liveSession.preView  = self;
    }
    return _liveSession;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
     
        [self addSubview:self.backView];
        [_backView addSubview:self.stateLabel];
        [_backView addSubview:self.closeButton];
        [_backView addSubview:self.cameraButton];
        [_backView addSubview:self.beautyButton];
        [_backView addSubview:self.startLiveButton];
        [self snap];
        
        [self.liveSession setRunning:YES];
    }
    return self;
}
-(void)snap{
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_equalTo(-10);
        make.top.mas_equalTo(self).mas_equalTo(10);
        make.width.height.mas_equalTo(44);
    }];
    
    [_cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.closeButton.mas_left).mas_equalTo(-20);
        make.top.mas_equalTo(self).mas_equalTo(10);
        make.width.height.mas_equalTo(44);
    }];
    
    [_beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cameraButton.mas_left).mas_equalTo(-20);
        make.top.mas_equalTo(self).mas_equalTo(10);
        make.width.height.mas_equalTo(44);
    }];
    
    [_startLiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_equalTo(-50);
        make.left.mas_equalTo(self).mas_equalTo(30);
        make.right.mas_equalTo(self).mas_equalTo(-30);
        make.height.mas_equalTo(44);
    }];
}


-(void)dothings:(UIButton *)sender{
    
    switch (sender.tag-100) { //关闭
        case 0:
        {
            [_liveSession stopLive];
            
        }
            break;
            
        case 1:{  //摄像头
            AVCaptureDevicePosition devicePositon = _liveSession.captureDevicePosition;
            _liveSession.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        }
            break;
        case 2:  //美颜
        {
            _liveSession.beautyFace = !_liveSession.beautyFace;
            _beautyButton.selected = !_liveSession.beautyFace;
        }
            break;
            
        case 3:{ //直播
            sender.selected = !sender.selected;
            if (sender.selected) {
                [_startLiveButton setTitle:@"结束直播" forState:UIControlStateNormal];
                LFLiveStreamInfo *stream = [[LFLiveStreamInfo alloc]init];
                stream.url = @"rtmp://192.168.1.128:0993/rtmplive/room";
                [_liveSession startLive:stream];
            }else{
                [_startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    switch (state) {
        case 0:
        {
            [_stateLabel setText:@"准备"];
        }
            break;
        case 1:
        {
            [_stateLabel setText:@"连接"];
        }
            break;
        case 2:
        {
            
            [_stateLabel setText:@"已连接"];
        }
            break;
        case 3:
        {
            
            [_stateLabel setText:@"已断开"];
        }
            break;
        case 4:
        {
            
            [_stateLabel setText:@"连接出错"];
        }
            break;
        case 5:
        {
            
            [_stateLabel setText:@"正在刷新"];
        }
            break;
        default:
            break;
    }
}

- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    NSLog(@"debugInfo: %lf", debugInfo.dataFlow);
}

- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"errorCode: %ld", errorCode);
}

@end
