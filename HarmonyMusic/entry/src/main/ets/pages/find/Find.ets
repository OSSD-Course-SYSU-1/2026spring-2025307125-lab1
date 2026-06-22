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

import { PAIHANG_LIST } from '../../constants/Index';
import { PaihangListType } from '../../models/Index';

@Entry
@Component
struct Find {
  @Builder
  Song(id: string, song: string, author: string, firstRow: boolean) {
    Row() {
      Text(id + ' ')
        .fontSize(15)
        .fontColor(Color.Gray);
      Text(song + ' ')
        .fontSize(15)
        .fontColor(Color.Black);
      Text(author)
        .fontSize(13)
        .fontColor(Color.Gray);
    }
    .width('90%')
    .margin({ left: '16px' })
    .padding({ top: (firstRow ? 0 : 10) });
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Text('排行榜')
            .fontSize(28)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold);
          Stack() {
            Image($r('app.media.ic_backpaihang'))
              .width('140px')
              .height('140px')
              .borderRadius('70px')
              .alignSelf(ItemAlign.Center);
            Image($r('app.media.ic_paihang'))
              .width('80px')
              .height('80px')
              .borderRadius('40px')
              .alignSelf(ItemAlign.Center);
          }
          .width('140px')
          .height('140px')
          .alignSelf(ItemAlign.Center);
        }
        .height('10%')
        .width('100%')
        .padding({ left: 16, right: 16 })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center);

        Text('官方榜')
          .fontSize(20)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding({ left: 16, right: 16 })
          .margin({ top: '60px', bottom: '20px' });
        Row() {
          List({ space: 7 }) {
            ForEach(PAIHANG_LIST, (item: PaihangListType) => {
              ListItem() {
                Row() {
                  Stack() {
                    Image(item.img)
                      .height('100%')
                      .aspectRatio(1)
                      .zIndex(1)
                      .borderRadius({ topLeft: 12, bottomLeft: 12 })
                      .alignSelf(ItemAlign.Start);
                    Column() {
                      Text('每天更新')
                        .fontSize(11)
                        .fontColor('#ffffff')
                        .textAlign(TextAlign.Start)
                        .margin({ top: '10px', left: '20px' });
                      Text(item.title1)
                        .fontSize(22)
                        .fontColor('#ffffff')
                        .fontWeight(FontWeight.Bold)
                        .textAlign(TextAlign.Center)
                        .alignSelf(ItemAlign.Center)
                        .margin({ top: '40px' });
                      Text(item.title2)
                        .fontSize(17)
                        .fontColor('#ffffff')
                        .alignSelf(ItemAlign.Center)
                        .fontWeight(FontWeight.Bold)
                        .textAlign(TextAlign.Center);
                      Row() {
                        Image($r('app.media.ic_play_wb'))
                          .width('60px')
                          .height('60px')
                          .fillColor('#000000')
                          .alignSelf(ItemAlign.Start);
                        Text(item.count)
                          .fontSize(11)
                          .fontColor('#ffffff')
                          .textAlign(TextAlign.Start);
                      }
                      .margin({ top: '30px', left: '20px' })
                      .padding({ bottom: 5 });
                    }
                    .alignItems(HorizontalAlign.Start)
                    .justifyContent(FlexAlign.Start)
                    .zIndex(10)
                    .width('100%')
                    .height('100%');
                  }
                  .height('100%')
                  .width('30%')
                  .borderRadius(10);

                  Column() {
                    this.Song('1', item.song1, item.song1, true);
                    this.Song('2', item.song2, item.song2, false);
                    this.Song('3', item.song3, item.song3, false);
                  }
                  .height('100%')
                  .width('70%')
                  .borderRadius({ topRight: 12, bottomRight: 12 })
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor(Color.White);
                }
                .width('100%')
                .height('15.7%')
                .alignItems(VerticalAlign.Top)
                .justifyContent(FlexAlign.SpaceBetween);
              };
            });
          };
        }
        .width('100%')
        .padding({ left: 16, right: 16 });
      }
      .backgroundColor('rgb(241, 243, 245)')
      .padding({
        top: AppStorage.get<number>('topHeight'),
        bottom: AppStorage.get<number>('bottomHeight')
      })
      .width('100%');
    }
    .height('100%');
  }
}

export default Find;