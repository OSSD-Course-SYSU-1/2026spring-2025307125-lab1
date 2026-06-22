/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the 'License');
 *  * you may not use this file except in compliance with the License.
 *  * You may obtain a copy of the License at
 *  *
 *  *     http://www.apache.org/licenses/LICENSE-2.0
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an 'AS IS' BASIS,
 *  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  * See the License for the specific language governing permissions and
 *  * limitations under the License.
 *
 */

import { AnimatorResult } from '@ohos.animator';
import { SongItemType } from '../../models/Music';
import { PlayStateType } from '../../models/PlayState';
import { SONG_KEY } from '../../constants/Index';
import AVPlayerManager from '../../utils/AVPlayerManager';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

@Entry
@Component
struct Play {
  @State opacityNum: number = 1;
  @State panelHeight: string = '0%';
  // 动画需要的数据
  randomColor: string = 'rgb(0,0,0)';
  randomShakenX: number = 0;
  randomShakenY: number = 0;
  rotateAngle: number = 0;
  rand = cryptoFramework.createRandom();
  animatorResult: AnimatorResult = this.getUIContext().createAnimator({
    duration: 1000 * 15,
    easing: 'linear',
    delay: 0,
    fill: 'none',
    direction: 'normal',
    iterations: -1,
    begin: 0,
    end: 360
  });
  
  // 睡眠定时器弹窗状态
  @State showSleepTimer: boolean = false;

  // 控制页面按钮是否能点击
  // @State btnEnable: boolean = true
  // 时长数字(ms)转字符串
  number2time(number: number) {
    let ms: number = number % 1000;
    let second = (number - ms) / 1000;
    let s: number = second % 60;
    if (second > 60) {
      let m: number = (second - s) / 60 % 60;
      return m.toString()
        .padStart(2, '0') + ':' + s.toString()
        .padStart(2, '0');
    }
    return '00:' + s.toString().padStart(2, '0');
  }

  @Builder
  deleteButton(index: number) {
    Button('删除')
      .backgroundColor($r('app.color.primary_light'))
      .fontColor('#fff')
      .width(80)
      .height('100%')
      .type(ButtonType.Normal)
      .onClick(() => {
        AVPlayerManager.remove(index);
      });
  }

  @StorageLink(SONG_KEY) playState: PlayStateType = new PlayStateType();

  changeAnimate() {
    if (this.playState.isPlay) {
      // 播放状态
      this.randomColor = `rgb(${Math.floor(this.rand.generateRandomSync(1).data[0] * 100 / 255 * 256)},
      ${Math.floor(this.rand.generateRandomSync(1).data[0] * 100 / 255 * 256)},
      ${Math.floor(this.rand.generateRandomSync(1).data[0] * 100 / 255 * 256)})`;
      this.randomShakenX = 2 - this.rand.generateRandomSync(1).data[0] * 100 / 255 * 4;
      this.randomShakenY = 2 - this.rand.generateRandomSync(1).data[0] * 100 / 255 * 4;
      this.animatorResult.play();
    } else {
      this.randomColor = 'rbg(0,0,0)';
      this.randomShakenX = 0;
      this.randomShakenY = 0;
      this.animatorResult.pause();
    }
  }

  async aboutToAppear() {
    // 从首选项加载数据
    if (this.playState.isPlay) {
      this.animatorResult.play();
    }
    this.animatorResult.onFrame = (val) => {
      this.rotateAngle = val;
    };
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 播放
      Stack() {
        // 变色背景
        Image(this.playState.img)
          .width('100%')
          .height('100%')
          .blur(1000);
        // 内容
        Column() {
          // 播放界面
          Column() {
            //头部控制
            Row() {
              Image($r('app.media.chevron_down'))
                .width(24)
                .height(24)
                .onClick(() => {
                  this.getUIContext().getRouter().back();
                });
              Row() {
                Text()
                  .backgroundColor('#465065')
                  .height(6)
                  .width(6)
                  .borderRadius('50%');
                Text()
                  .width(4);
                Text()
                  .backgroundColor('#DFE0E4')
                  .height(6)
                  .width(12)
                  .borderRadius('50%');
              };

              // 睡眠定时器按钮
              Row({ space: 4 }) {
                Image($r('app.media.people_wifi'))
                  .width(20)
                  .height(20)
                  .fillColor('#FFFFFF')
              }
              .width(36)
              .height(36)
              .borderRadius(18)
              .backgroundColor('rgba(255, 255, 255, 0.2)')
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.showSleepTimer = true;
              });
            }
            .height(48)
            .margin({
              top: AppStorage.get<number>('topHeight'),
            })
            .width('1100px')
            .justifyContent(FlexAlign.SpaceBetween);

            // 图片
            Image(this.playState.img)
              .height('1100px')
              .width('1100px')
              .objectFit(ImageFit.Cover)
              .borderRadius(10)
              .margin({
                top: 24,
                bottom: 24
              });
            // 歌曲信息
            Row() {
              Column() {
                Text(this.playState.name)
                  .fontSize(25)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E1E2E7');
                Text(this.playState.author)
                  .fontSize(18)
                  .fontColor('#989EAD');
              }
              .alignItems(HorizontalAlign.Start);

              Stack() {
                Image($r('app.media.ic_like'))
                  .width(24);
                Text('1w+')
                  .fontColor(Color.White)
                  .fontSize(10)
                  .padding({
                    bottom: 20,
                    left: 20
                  })
                  .fontWeight(600)
                  .width(40)
                  .height(40);
              }
              .width(40)
              .height(40);
            }.justifyContent(FlexAlign.SpaceBetween)
            .width('1100px')
            .height(47)
            .margin({
              bottom: 84
            });

            // 操作
            Row() {
              //歌单
              Image($r('app.media.ic_song_list'))
                .fillColor(Color.White)
                .width(28)
                .onClick(() => {
                  this.panelHeight = '100%';
                });
              //下载
              Image($r('app.media.ic_download_o'))
                .fillColor(Color.White)
                .width(30);
              //铃声
              Image($r('app.media.ic_sing'))
                .fillColor(Color.White)
                .width(30);

              //其他
              Image($r('app.media.ic_other'))
                .fillColor(Color.White)
                .width(30);
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({
              bottom: 10
            });

            // 播放
            Column() {
              // 进度条
              Slider({
                value: this.playState.time,
                min: 0,
                max: this.playState.duration,
                style: SliderStyle.InSet,
              })
                .blockBorderWidth(0)
                .blockSize({
                  width: 0.2,
                  height: 0.2
                })
                .trackThickness(5)
                .blockColor(Color.White)
                .blockBorderColor(Color.White)
                .selectedColor(Color.White)
                .trackColor('#ccc5c5c5')
                .onChange((val) => {
                  AVPlayerManager.player!.seek(val);
                })
                .margin({
                  bottom: -10,
                  left: -7,
                  right: -7
                });
              //时间
              Row() {
                Text(this.number2time(this.playState.time))
                  .fontSize(12)
                  .fontColor('#A5B4B1');
                Text(this.number2time(this.playState.duration))
                  .fontSize(12)
                  .fontColor('#A5B4B1');
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')
              .margin({
                bottom: 10
              });

              // 切换
              Row() {
                Image($r('app.media.ic_prev'))
                  .fillColor(Color.White)
                  .width(40)
                  .fillColor(Color.White)
                  .onClick(() => {
                    AVPlayerManager.prevPlay();
                  });
                // 播放按钮
                Image(this.playState.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
                  .fillColor(Color.White)
                  .width(80)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    if (!this.playState.isPlay) {
                      AVPlayerManager.singlePlay(this.playState.playList[this.playState.playIndex]);
                      this.animatorResult.play();
                    } else {
                      AVPlayerManager.pause();
                      this.animatorResult.pause();
                    }
                  });
                // 下一首
                Image($r('app.media.ic_next'))
                  .fillColor(Color.White)
                  .width(40)
                  .fillColor(Color.White)
                  .onClick(() => {
                    AVPlayerManager.nextPlay();
                  });
              }
              .width('100%')
              .padding({
                bottom: 24
              })
              .justifyContent(FlexAlign.SpaceAround);
            }
            .width('100%');
          }
          .layoutWeight(1)
          .width('1100px');
        };
      }
      .backgroundColor(Color.Transparent);

      // 列表
      Column() {
        Column() {

        }
        .width('100%')
        .layoutWeight(1)
        .onClick(() => {
          this.panelHeight = '0%';
        });

        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_play'))
                .width(20)
                .fillColor('#ff5186');
            }
            .width(50)
            .aspectRatio(1)
            .justifyContent(FlexAlign.Center);

            Row({ space: 8 }) {
              Text(`播放列表 (${this.playState.playList?.length})`)
                .fontColor(Color.White)
                .fontSize(14);
            }
            .layoutWeight(1);

            Image($r('app.media.ic_close'))
              .fillColor('#ffa49a9a')
              .width(24)
              .height(24)
              .margin({ right: 16 })
              .onClick(() => {
                this.panelHeight = '0%';
              });
          }
          .width('100%')
          .backgroundColor('#ff353333')
          .padding(8)
          .border({
            width: { bottom: 1 },
            color: '#12ec5c87'
          })
          .borderRadius({
            topLeft: 4,
            topRight: 4
          });

          // 播放列表
          List() {
            ForEach(this.playState.playList, (item: SongItemType, index: number) => {
              ListItem() {
                Row() {
                  Row() {
                    Text((index + 1).toString())
                      .fontColor('#ffa49a9a');
                  }
                  .width(50)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center);

                  // 列表
                  Row({ space: 10 }) {
                    Column() {
                      Text(item.name)
                        .fontSize(14)
                        .fontColor(this.playState.playIndex === index ? $r('app.color.primary_light') : '#ffa49a9a');
                      Text(item.author)
                        .fontSize(12)
                        .fontColor(this.playState.playIndex === index ? $r('app.color.primary_light') : Color.Gray);
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)
                    .justifyContent(FlexAlign.Center);
                  }
                  .layoutWeight(1);

                  Image($r('app.media.ic_more'))
                    .width(24)
                    .height(24)
                    .margin({ right: 16 })
                    .fillColor(Color.Gray);
                }
                .alignItems(VerticalAlign.Center);
              }
              .onClick(() => {
                AVPlayerManager.singlePlay(item);
              })
              .swipeAction({
                end: this.deleteButton(index)
              })
              .border({
                width: { bottom: 1 },
                color: '#12ec5c87'
              });
            });
          }
          .layoutWeight(1)
          .backgroundColor('#ff353333');

        }
        .height(400);
      }
      .height(this.panelHeight)
      .animation({
        duration: 300
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
    .opacity(this.opacityNum)
    .bindSheet($$this.showSleepTimer, this.SleepTimerSheet(), {
      height: 320,
      backgroundColor: Color.White,
      dragBar: false
    });
  }
  
  // 睡眠定时器弹窗内容
  @Builder
  SleepTimerSheet() {
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
      
      // 功能说明
      Column() {
        // 图标
        Column() {
          Image($r('app.media.people_wifi'))
            .width(48)
            .height(48)
            .fillColor('#F39C12')
        }
        .width(80)
        .height(80)
        .borderRadius(40)
        .backgroundColor('#FFF8E7')
        .justifyContent(FlexAlign.Center)
        
        Text('睡眠定时功能')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333')
          .margin({ top: 20 })
        
        Text('设置定时停止播放，适合睡前使用')
          .fontSize(14)
          .fontColor('#999')
          .margin({ top: 8 })
        
        Button('设置定时')
          .width('80%')
          .height(48)
          .fontSize(16)
          .fontColor('#FFF')
          .backgroundColor('#F39C12')
          .borderRadius(24)
          .margin({ top: 32 })
          .onClick(() => {
            // TODO: 打开睡眠定时器设置
            this.showSleepTimer = false;
          })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .padding({ bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF')
    .borderRadius({ topLeft: 24, topRight: 24 })
  }

  // 页面也换效果,避免滑动切换效果
  pageTransition() {
    PageTransitionEnter({ duration: 200 })
      .onEnter(() => {
        this.opacityNum = 1;
      });
    PageTransitionExit({ duration: 200 })
      .onExit(() => {
        this.opacityNum = 0;
      });
  }
}

