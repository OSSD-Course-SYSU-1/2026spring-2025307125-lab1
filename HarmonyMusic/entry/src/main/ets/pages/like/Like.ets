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

import { FAVORITE_LIST } from '../../constants/MusicConstants';
import { SongItemType } from '../../models/Index';
import AVPlayerManager from '../../utils/AVPlayerManager';

@Entry
@Component
struct Like {
  build() {
    Column() {
      // 播放页
      Column() {
        // 歌单明细
        Column() {
          // 简介
          Row({ space: 12 }) {
            Image($r('app.media.ic_ilike'))
              .width('32%')
              .aspectRatio(1)
              .objectFit(ImageFit.Cover)
              .borderRadius(10);
            Column({ space: 8 }) {
              Text('我的喜欢')
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .fontSize(19);
              Text('xxxx')
                .fontSize(14)
                .fontColor('#ffffff');
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start);
          }
          .width('100%')
          .height('80%');

          // 按钮
          Row() {
            Button() {
              Row({ space: 8 }) {
                Image($r('app.media.ic_like_icon'))
                  .width(17);
                Text('分享')
                  .fontColor('#ffffff')
                  .fontSize(15);
              }
              .width('30%')
              .height('21%')
              .borderRadius('21px')
              .justifyContent(FlexAlign.Center)
              .backgroundColor('#bebebe');
            }
            .clip(true);

            Button() {
              Row({ space: 8 }) {
                Image($r('app.media.ic_like_icon'))
                  .width(17);
                Text('评论')
                  .fontColor('#ffffff')
                  .fontSize(15);
              }
              .width('30%')
              .height('21%')
              .borderRadius('21px')
              .justifyContent(FlexAlign.Center)
              .backgroundColor('#bebebe');
            }
            .clip(true);

            Button() {
              Row({ space: 8 }) {
                Image($r('app.media.ic_like_icon'))
                  .width(17);
                Text('收藏')
                  .fontColor('#ffffff')
                  .fontSize(15);
              }
              .width('30%')
              .height('21%')
              .borderRadius('21px')
              .justifyContent(FlexAlign.Center)
              .backgroundColor('#bebebe');
            }
            .clip(true);
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 8, right: 8 });
        }
        .width('100%')
        .height('32%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding(16);

        // 播放列表
        Column() {
          Row({ space: 8 }) {
            Row({ space: 8 }) {
              Image($r('app.media.ic_play_wp'))
                .width('120px')
                .height('120px')
                .fillColor('#000000');
              Text(`播放全部 ${FAVORITE_LIST.songs.length}`)
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
                .fontSize(20);
            };
          }
          .width('100%')
          .padding(16)
          .border({
            width: { bottom: 1 },
            color: '#12ec5c87'
          });

          Column() {
            List() {
              ForEach(FAVORITE_LIST.songs, (item: SongItemType) => {
                ListItem() {
                  Row() {
                    // 列表
                    Row({ space: 10 }) {
                      Column() {
                        Text(item.name)
                          .fontSize(17)
                          .fontWeight(FontWeight.Medium)
                          .fontColor('#000000');
                        Row() {
                          Image($r('app.media.ic_sq'))
                            .width('50px');
                          Text(item.author)
                            .fontSize(14)
                            .fontColor(Color.Gray)
                            .margin({ left: '10px' });
                        }
                        .margin({ top: '10px' });
                      }
                      .margin({ left: '40px' })
                      .layoutWeight(1)
                      .alignItems(HorizontalAlign.Start)
                      .justifyContent(FlexAlign.Center);

                      Image($r('app.media.ic_path'))
                        .width(7)
                        .height(14)
                        .margin({ right: 16 });
                    }
                    .layoutWeight(1)
                    .justifyContent(FlexAlign.SpaceBetween)
                    .padding({ left: 8 });
                  }
                  .height('15.7%')
                  .alignItems(VerticalAlign.Center);
                }
                .border({
                  width: { bottom: 1 },
                  color: '#cccccc'
                })
                .onClick(() => {
                  // 播放
                  AVPlayerManager.singlePlay(item);
                });
              });
            }
            .layoutWeight(1);
          }
          .layoutWeight(1);
        }
        .backgroundColor('rgb(241, 243, 245)')
        .layoutWeight(1)
        .width('100%')
        .borderRadius({ topLeft: 25, topRight: 25 });
      }
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%')
    .backdropBlur(70.68) // 对背景进行模糊
    .backgroundImage($r('app.media.ic_ilike'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .padding({
      top: AppStorage.get<number>('topHeight')
    });
  }
}

export default Like;