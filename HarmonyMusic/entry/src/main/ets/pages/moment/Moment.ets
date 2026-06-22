/*
 *
 *  * Copyright (c) 2025 Huawei Device Co., Ltd.
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * you may not use this file except in compliance with the License.
 *  * You may obtain a copy of the License at
 *  *
 *  *     http://www.apache.org/licenses/LICENSE-2.0
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an "AS IS" BASIS,
 *  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  * See the License for the specific language governing permissions and
 *  * limitations under the License.
 *
 */

import { MOMENT_LIST } from '../../constants/MusicConstants';
import { MomentListType } from '../../models/Index';
import AVPlayerManager from '../../utils/AVPlayerManager';

@Entry
@Component
struct Moment {
  build() {
    Column() {
      Row() {
        Text('动态')
          .fontSize(28)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold);
      }
      .padding({ left: 14, top: 14, bottom: 16 })
      .width('100%');

      Row() {
        List({ space: 10 }) {
          ForEach(MOMENT_LIST, (item: MomentListType) => {
            ListItem() {
              Row() {
                Column() {
                  Row() {
                    Row() {
                      Column() {
                        Image(item.avatar)
                          .width(40)
                          .height(40)
                          .borderRadius(20);
                      };

                      Column() {
                        Text(item.author)
                          .fontColor('#000000')
                          .fontSize(14);
                        // 内容
                        Text(item.comment)
                          .fontColor('rgba(0, 0, 0, 0.6)')
                          .fontSize(12)
                          .textAlign(TextAlign.Start);
                      }
                      .padding({ left: 10 })
                      .alignItems(HorizontalAlign.Start);
                    };

                    Button('+关注')
                      .fontSize(13)
                      .fontColor('rgb(10, 89, 247)')
                      .backgroundColor('rgba(0, 0, 0, 0.05)')
                      .height('16%')
                      .width('20%');
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                  .margin({ top: '50px' })
                  .padding({ right: 10, left: 10 });

                  Row() {
                    Text(item.content)
                      .fontColor('#000000')
                      .fontSize(13);
                  }
                  .width('100%')
                  .margin({ top: '30px' })
                  .padding({ right: 10, left: 10 });

                  // 音乐卡片
                  Row() {
                    Image(item.song.img)
                      .width('10%')
                      .aspectRatio(1)
                      .borderRadius(5)
                      .margin({ left: 12 });
                    Column({ space: 10 }) {
                      Text(item.song.name)
                        .fontColor('#000000')
                        .fontWeight(FontWeight.Medium)
                        .fontSize(15);
                      Text(item.song.author)
                        .fontColor('rgba(0, 0, 0, 0.4)')
                        .fontSize(10);
                    }
                    .layoutWeight(1)
                    .height(60)
                    .alignItems(HorizontalAlign.Start)
                    .justifyContent(FlexAlign.SpaceBetween)
                    .padding(12);

                    Image($r('app.media.ic_play_wp'))
                      .width('80px')
                      .height('80px')
                      .fillColor('#000000')
                      .alignSelf(ItemAlign.Center)
                      .margin({ right: 12 });
                  }
                  .backgroundColor('rgb(241, 243, 245)')
                  .width('95%')
                  .height('27%')
                  .margin({ top: '30px' })
                  .borderRadius(8)
                  .clip(true)
                  .onClick(() => {
                    AVPlayerManager.singlePlay(item.song);
                  });

                  Row({ space: 20 }) {
                    Image($r('app.media.ic_love'))
                      .width('33%')
                      .fillColor('#ffffff');
                    Image($r('app.media.ic_comment'))
                      .width('33%')
                      .fillColor('#ffffff');
                    Image($r('app.media.ic_share'))
                      .width('33%')
                      .fillColor('#ffffff');
                  }
                  .width('100%')
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.SpaceBetween);
                };
              }
              .width('100%')
              .height('31%')
              .backgroundColor(Color.White)
              .borderRadius(10);
            };
          });
        }
        .padding({ right: 10, left: 10 });
      };
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
    .width('100%')
    .padding({
      top: AppStorage.get<number>('topHeight'),
      bottom: AppStorage.get<number>('bottomHeight')
    });
  }
}

export default Moment;