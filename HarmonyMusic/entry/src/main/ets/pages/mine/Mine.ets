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

import { SONGS } from '../../constants/MusicConstants';
import { SongItemType, SongItemTypeModel } from '../../models/Index';
import { PlayStateType } from '../../models/PlayState';
import AVPlayerManager from '../../utils/AVPlayerManager';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import router from '@ohos.router';


@Extend(Text)
function functionText(num: number) {
  .fontColor('#A3A4B5')
  .margin({ right: 12 })
  .fontSize(14)
  .height(30)
  .width(50)
  .textAlign(num)
  .margin({
    bottom: 4,
    left: 10,
    right: 10
  });
}

@Entry
@Component
struct Mine {
  @Link playState: PlayStateType;
  @State selectedIndex: number = 0;
  columnList: number[] = [0, 1, 2, 3, 4, 5, 6, 7];
  private controller: TabsController = new TabsController();
  rand = cryptoFramework.createRandom();
  num: number = this.rand.generateRandomSync(1).data[0] * 100 / 255;

  //tabBar组件
  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .backgroundColor(this.selectedIndex === index ? '#0A59F7' : '#F3F3F3')
        .fontColor(this.selectedIndex === index ? Color.White : Color.Black)
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .width(96)
        .height(36)
        .borderRadius('50%')
        .textAlign(1);
    }
    .margin({
      top: 10,
      left: 15
    });
  }

  //歌单组件
  @Builder
  playlist(photo: Resource, name: string, detail: string, isList: boolean) {
    Row() {
      Stack() {
        Image(photo)
          .borderRadius(10)
          .height(48)
          .width(48)
          .margin({
            right: 10
          });
        if (isList) {
          Image($r('app.media.core'))
            .height(16)
            .width(18)
            .margin({
              right: 10
            });
        }
      };

      Column() {
        Text(name)
          .fontSize(17)
          .textAlign(0)
          .width('100%')
          .margin({
            bottom: 5
          });
        Text(detail)
          .fontSize(15)
          .fontColor('#7D7D7D')
          .textAlign(0)
          .width('100%');
      }.width('70%');

      Image($r('app.media.play_fill'))
        .width(20)
        .height(isList ? 20 : 0);

    }
    .height(64)
    .width('100%')
    .margin({
      left: 4
    });
  }

  build() {
    Column() {
      // 个人信息
      Column() {
        Image($r('app.media.head'))
          .height(80)
          .width(80)
          .borderRadius(40)
          .margin({
            top: 60
          });
        Row() {
          Text('我的音乐')
            .fontSize(20)
            .fontColor(Color.White);
          Image($r('app.media.vip'))
            .width(20)
            .height(20)
            .margin({
              left: 3
            });
        }
        .height(50)
        .width('100%')
        .justifyContent(FlexAlign.Center);

        Row() {
          Text('00后')
            .functionText(2);
          Text('狮子座')
            .functionText(1);
          Text('上海')
            .functionText(0);
        };

        Row() {
          Text('1 关注')
            .functionText(2);
          Text('12粉丝')
            .functionText(1);
          Text('13w 赞')
            .functionText(0);
        }
        .margin({
          bottom: 13
        });
      };

      // 功能菜单区域
      Column() {
        // 标题
        Row() {
          Text('快捷功能')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 16, bottom: 12 })
        
        // 功能网格
        Grid() {
          // 本地音乐
          GridItem() {
            Column() {
              Column() {
                Image($r('app.media.ic_song'))
                  .width(24)
                  .height(24)
                  .fillColor('#FF6B6B')
              }
              .width(48)
              .height(48)
              .borderRadius(12)
              .backgroundColor('#FFF5F5')
              .justifyContent(FlexAlign.Center)
              
              Text('本地音乐')
                .fontSize(13)
                .fontColor('#333')
                .margin({ top: 8 })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              router.pushUrl({ url: 'pages/localmusic/LocalMusic' });
            })
          }
          
          // 搜索
          GridItem() {
            Column() {
              Column() {
                Image($r('app.media.ic_search'))
                  .width(24)
                  .height(24)
                  .fillColor('#4A90E2')
              }
              .width(48)
              .height(48)
              .borderRadius(12)
              .backgroundColor('#F0F7FF')
              .justifyContent(FlexAlign.Center)
              
              Text('搜索')
                .fontSize(13)
                .fontColor('#333')
                .margin({ top: 8 })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              router.pushUrl({ url: 'pages/search/Search' });
            })
          }
          
          // 播放历史
          GridItem() {
            Column() {
              Column() {
                Image($r('app.media.play_list'))
                  .width(24)
                  .height(24)
                  .fillColor('#9B59B6')
              }
              .width(48)
              .height(48)
              .borderRadius(12)
              .backgroundColor('#F8F0FF')
              .justifyContent(FlexAlign.Center)
              
              Text('播放历史')
                .fontSize(13)
                .fontColor('#333')
                .margin({ top: 8 })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              router.pushUrl({ url: 'pages/history/PlayHistory' });
            })
          }
          
          // 睡眠定时
          GridItem() {
            Column() {
              Column() {
                Image($r('app.media.people_wifi'))
                  .width(24)
                  .height(24)
                  .fillColor('#F39C12')
              }
              .width(48)
              .height(48)
              .borderRadius(12)
              .backgroundColor('#FFF8E7')
              .justifyContent(FlexAlign.Center)
              
              Text('睡眠定时')
                .fontSize(13)
                .fontColor('#333')
                .margin({ top: 8 })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              // 跳转到播放页面并打开定时器
              router.pushUrl({ url: 'pages/play/Play' });
            })
          }
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr')
        .columnsGap(8)
        .rowsGap(8)
        .width('100%')
        .height(110)
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .backgroundColor('#FFF')
      .margin({ top: 12 })
      .borderRadius({ topLeft: 16, topRight: 16 })
      .padding({ bottom: 16 })

      //详情
      Column() {
        Tabs({ barPosition: BarPosition.Start, index: this.selectedIndex, controller: this.controller }) {
          TabContent() {
            List() {
              ListItem() {
                this.playlist($r('app.media.cover'), '我喜欢的音乐', '17 首·235 次播放', true);
              }.margin(8);

              ForEach(this.columnList, (item: string) => {
                ListItem() {
                  this.playlist($r('app.media.cover'), '歌单' + item, '17 首·235 次播放', false);
                }.margin(8);
              });
              ListItem() {
              }.height(260);
            };
          }.tabBar(this.tabBuilder(0, '音乐'));

          TabContent() {
            List() {
              ForEach(this.columnList, (item: string) => {
                ListItem() {
                  this.playlist($r('app.media.cover'), '收藏' + item, '17 首·235 次播放', false);
                }.margin(8);
              });
              ListItem() {
              }.height(260);
            }.height('100%');
          }.tabBar(this.tabBuilder(1, '收藏'));

          TabContent() {
            List() {
              ForEach(this.columnList, (item: string) => {
                ListItem() {
                  this.playlist($r('app.media.cover'), '专辑' + item, '17 首·235 次播放', false);
                }.margin(8);
              });
              ListItem() {

              }.height(260);
            };
          }.tabBar(this.tabBuilder(2, '专辑'));

          TabContent() {
            Column().width('100%').height('100%').backgroundColor(Color.White);
          }.tabBar(this.tabBuilder(3, '动态'));
        }
        .onChange((index: number) => {
          this.selectedIndex = index;
        })
        .barMode(BarMode.Scrollable)
        .fadingEdge(false)
        .vertical(false)
        .barPosition(BarPosition.Start)
        .barMode(BarMode.Scrollable);
      }
      .backgroundColor(Color.White)
      .borderRadius({
        topLeft: 20,
        topRight: 20
      });
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      repeating: false, // 渐变颜色是否重复
      colors: [[0x22294F, 0.0], [0x616681, 1]]
    })
    .expandSafeArea([SafeAreaType.CUTOUT], [SafeAreaEdge.TOP]);
  }
}

@Component
struct SongCard {
  @Link playState: PlayStateType;
  @State showList: SongItemType[] = [];
  columnIndex: number = 0;
  rand = cryptoFramework.createRandom();

  aboutToAppear() {
    this.showList = SONGS.map(item => new SongItemTypeModel(item))
      .sort(() => this.rand.generateRandomSync(1).data[0] * 100 / 255 - 0.5);
  }

  build() {
    List({ space: 12 }) {
      ForEach(this.showList, (item: SongItemType) => {
        ListItem() {
          Stack() {
            Image(item.img)
              .width('100%');
          }
          .width('100%')
          .aspectRatio(1)
          .borderRadius(8)
          .clip(true)
          .onClick(() => {
            //点击的卡片的歌曲和当前播放的歌曲是不是同一首歌曲
            if (this.playState.src === item.src) {
              this.playState.isPlay ? AVPlayerManager.pause() : AVPlayerManager.singlePlay(item);
            } else {
              AVPlayerManager.singlePlay(item);
            }
          });
        };
      });
    }
    .width('100%');
  }
}

export default Mine;