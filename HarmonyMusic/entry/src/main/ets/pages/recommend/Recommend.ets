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

import { DAILY_RECOMMEND, RECOMMEND_LIST } from '../../constants/MusicConstants';
import { RecommendDailyType, RecommendListType } from '../../models/Music';
import router from '@ohos.router';

@Entry
@Component
struct Recommend {
  @Builder
  TitleBar(title: string) {
    // 标题
    Row() {
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black);
      Image($r('app.media.ic_right'))
        .width(15);
    }
    .width('100%')
    .padding(8)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: '12vp',
      right: '12vp'
    })
    .margin({
      top: '20vp',
      bottom: '12vp'
    });
  }

  build() {
    Scroll() {
      Column({}) {
        Row() {
          Text('推荐')
            .fontSize(28)
            .fontColor('#000000')
            .fontWeight(FontWeight.Bold);
          Image($r('app.media.ic_recommend'))
            .width('140px')
            .height('140px')
            .alignSelf(ItemAlign.Center);
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ top: 12 });

        //   搜索框
        Row() {
          Row({ space: 5 }) {
            Image($r('app.media.ic_search'))
              .width(18)
              .aspectRatio(1);
            Text('搜索歌曲、歌手')
              .fontSize(17)
              .fontColor('rgba(0, 0, 0, 0.6)')
              .layoutWeight(1);
          }
          .width('100%')
          .padding(12)
          .borderRadius('60')
          .backgroundColor('rgba(0, 0, 0, 0.05)');
        }
        .width('100%')
        .height('14%')
        .padding({ left: 20, right: 12 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/search/Search' });
        });

        //轮播
        Scroll() {
          Row({ space: 10 }) {
            ForEach(DAILY_RECOMMEND, (item: RecommendDailyType) => {
              Column() {
                Column() {
                  Row() {
                    Image($r('app.media.ic_song'))
                      .width('60px')
                      .height('60px')
                      .fillColor('#000000')
                      .margin({ left: '10px' });
                    Text(item.title)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Bold)
                      .fontSize(13)
                      .padding(8);
                  }
                  .padding({ left: 8, top: 6 });

                  Stack({ alignContent: Alignment.Center }) {
                    Row() {
                      Image($r('app.media.ic_back_left'))
                        .width('50%')
                        .aspectRatio(1);
                      Image($r('app.media.ic_back_right'))
                        .width('50%')
                        .aspectRatio(1);
                    }
                    .width('100%')
                    .margin({ top: '50px' })
                    .alignItems(VerticalAlign.Center);

                    Image(item.img)
                      .width('63%')
                      .borderRadius('10px')
                      .aspectRatio(1);
                  }
                  .width('100%')
                  .margin({ top: '50px' })
                  .alignContent(Alignment.Center);
                }
                .height('33%')
                .backgroundImage(item.img)
                .backgroundImageSize(ImageSize.Cover)
                .backdropBlur(50)
                .flexGrow(3);

                Row() {
                  Column() {
                    Text(item.type)
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#ffffff')
                      .margin({ left: '20px' })
                      .textOverflow({
                        overflow: TextOverflow.Ellipsis
                      });
                    Text(item.song)
                      .fontSize(13)
                      .fontColor('#f8f8ff')
                      .margin({ left: '20px' })
                      .maxLines(1)
                      .textOverflow({
                        overflow: TextOverflow.Ellipsis
                      })
                      .padding({ top: 5 });
                  }
                  .width('80%')
                  .justifyContent(FlexAlign.Start)
                  .alignItems(HorizontalAlign.Start)
                  .margin({ top: '30px', bottom: '30px' });

                  Image($r('app.media.ic_play_wg'))
                    .width('117px')
                    .height('120px')
                    .fillColor('#000000');
                }
                .flexGrow(1)
                .width('100%')
                .height('11%')
                .padding({ left: 10, right: 12 })
                .justifyContent(FlexAlign.SpaceBetween)
                .backgroundColor(item.bottom);
              }
              .backgroundImage(item.img)
              .backgroundImageSize(ImageSize.Cover)
              .backdropBlur(70.68)
              .width('63%')
              .borderRadius(16)
              .clip(true);
            });
          };
        }
        .width('100%')
        .scrollable(ScrollDirection.Horizontal)
        .scrollBarWidth(0)
        .padding({ left: 16 });

        //   推荐歌单
        Column() {
          this.TitleBar('Hi Raven，为你推荐');
          // 歌单项
          Row() {
            Scroll() {
              Row({ space: 10 }) {
                ForEach(RECOMMEND_LIST, (item: RecommendListType) => {
                  Column() {
                    Column() {
                      Stack({ alignContent: Alignment.Center }) {
                        Row() {
                          Image($r('app.media.ic_back_left'))
                            .width('50%')
                            .aspectRatio(1);
                          Image($r('app.media.ic_back_right'))
                            .width('50%')
                            .aspectRatio(1);
                        }
                        .width('100%')
                        .margin({ top: '50px' })
                        .alignItems(VerticalAlign.Center);

                        Image(item.img)
                          .width('63%')
                          .borderRadius(10)
                          .aspectRatio(1);
                      }
                      .padding({ top: 18, bottom: 4 })
                      .alignContent(Alignment.Center);

                      Row() {
                        Image($r('app.media.ic_play_wb'))
                          .width('70px')
                          .height('70px')
                          .fillColor('#000000')
                          .margin({ left: '30px', bottom: '20px' });
                        Text(item.count)
                          .width('100%')
                          .fontSize(11)
                          .textAlign(TextAlign.Start)
                          .fontColor(Color.White)
                          .fontWeight(FontWeight.Bold)
                          .padding(8);
                      }
                      .margin({ bottom: '20px' })
                      .alignItems(VerticalAlign.Center);
                    }
                    .aspectRatio(1)
                    .borderRadius(10)
                    .backgroundImage(item.img)
                    .backgroundImageSize(ImageSize.Cover)
                    .backdropBlur(65.24);

                    Text(item.title)
                      .textAlign(TextAlign.Start)
                      .fontSize(15)
                      .fontWeight(FontWeight.Regular)
                      .fontColor('#000000')
                      .maxLines(2)
                      .textOverflow({
                        overflow: TextOverflow.Ellipsis
                      })
                      .margin({
                        top: 8
                      });
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .borderRadius(16)
                  .width('38%');
                });
              };
            }
            .width('100%')
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off);
          }
          .padding({ left: 16 });
        };
      }
      .width('100%')
      .backgroundColor('#F1F3F5')
      .justifyContent(FlexAlign.Start)
      .padding({
        top: AppStorage.get<number>('topHeight'),
        bottom: AppStorage.get<number>('bottomHeight')
      });
    }
    .height('100%');
  }
}

export default Recommend;