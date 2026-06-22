/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import SleepTimerManager from '../utils/SleepTimerManager';

@Component
export struct SleepTimerSheet {
  @Link isShow: boolean;
  @State selectedDuration: number = 30; // 选中的时长（分钟）
  @State remainingTime: number = 0; // 剩余时间
  @State isTimerActive: boolean = false;
  
  private durationOptions: number[] = [15, 30, 45, 60, 90, 120]; // 时长选项（分钟）
  
  aboutToAppear() {
    this.isTimerActive = SleepTimerManager.isTimerRunning();
    this.remainingTime = SleepTimerManager.getRemainingTime();
    
    // 设置回调
    SleepTimerManager.onTick((remaining: number) => {
      this.remainingTime = remaining;
    });
    
    SleepTimerManager.onEnd(() => {
      this.isTimerActive = false;
      this.remainingTime = 0;
    });
  }
  
  // 设置定时器
  setTimer() {
    SleepTimerManager.setTimer({
      duration: this.selectedDuration,
      type: 'time'
    });
    this.isTimerActive = true;
    this.isShow = false;
  }
  
  // 设置播完当前后停止
  setFinishTimer() {
    SleepTimerManager.setTimer({
      duration: 0,
      type: 'finish'
    });
    this.isTimerActive = true;
    this.isShow = false;
  }
  
  // 取消定时器
  cancelTimer() {
    SleepTimerManager.clearTimer();
    this.isTimerActive = false;
    this.remainingTime = 0;
    this.isShow = false;
  }
  
  @Builder
  DurationOption(duration: number) {
    Column() {
      Text(`${duration}分钟`)
        .fontSize(16)
        .fontColor(this.selectedDuration === duration ? '#FF6B6B' : '#333')
        .fontWeight(this.selectedDuration === duration ? FontWeight.Bold : FontWeight.Normal)
    }
    .width(80)
    .height(48)
    .borderRadius(8)
    .backgroundColor(this.selectedDuration === duration ? '#FFF0F0' : '#F5F5F5')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.selectedDuration = duration;
    })
  }
  
  build() {
    Column() {
      // 标题
      Row() {
        Text('睡眠定时')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Center)
      
      Divider()
        .color('#F0F0F0')
      
      if (this.isTimerActive) {
        // 显示倒计时
        Column() {
          Text('定时器已开启')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 24 })
          
          Text(SleepTimerManager.formatTime(this.remainingTime))
            .fontSize(48)
            .fontColor('#FF6B6B')
            .fontWeight(FontWeight.Bold)
            .margin({ top: 16 })
          
          Text('后停止播放')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 8 })
          
          // 取消按钮
          Button('取消定时')
            .width('80%')
            .height(48)
            .fontSize(16)
            .fontColor('#FFF')
            .backgroundColor('#FF6B6B')
            .borderRadius(24)
            .margin({ top: 32 })
            .onClick(() => {
              this.cancelTimer();
            })
        }
        .width('100%')
        .padding(16)
      } else {
        // 显示设置选项
        Column() {
          // 时长选项
          Text('选择定时时长')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 24, bottom: 16 })
          
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            ForEach(this.durationOptions, (duration: number) => {
              this.DurationOption(duration)
                .margin({ right: 12, bottom: 12 })
            })
          }
          .width('100%')
          .padding({ left: 24, right: 24 })
          
          Divider()
            .color('#F0F0F0')
            .margin({ top: 16, bottom: 16 })
          
          // 播完当前选项
          Row() {
            Column() {
              Text('播完当前歌曲后停止')
                .fontSize(16)
                .fontColor('#333')
              
              Text('适合睡前听完当前歌曲')
                .fontSize(12)
                .fontColor('#999')
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding({ left: 24, right: 24, top: 12, bottom: 12 })
          .onClick(() => {
            this.setFinishTimer();
          })
          
          Divider()
            .color('#F0F0F0')
            .margin({ top: 16, bottom: 16 })
          
          // 确认按钮
          Button('确认设置')
            .width('80%')
            .height(48)
            .fontSize(16)
            .fontColor('#FFF')
            .backgroundColor('#FF6B6B')
            .borderRadius(24)
            .margin({ top: 16 })
            .onClick(() => {
              this.setTimer();
            })
        }
        .width('100%')
      }
    }
    .width('100%')
    .backgroundColor('#FFF')
    .borderRadius({ topLeft: 24, topRight: 24 })
  }
}
