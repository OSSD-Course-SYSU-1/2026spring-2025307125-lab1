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

import { TabClass } from '../models/Index';
import { SONG_KEY, TABS_DATA } from '../constants/Index';
import Find from './find/Find';
import Mine from './mine/Mine';
import Moment from './moment/Moment';
import Recommend from './recommend/Recommend';
import Like from './like/Like';
import PlayerNav from '../components/PlayerNav';
import { PlayStateType } from '../models/PlayState';
import AVPlayerManager from '../utils/AVPlayerManager';
import SongManager from '../utils/SongManager';

@Entry
@Component
struct HomeIndex {
  @State currentName: string = 'recommend';
  @StorageLink(SONG_KEY) playState: PlayStateType = new PlayStateType();
  opacityNum: number = 1;
  currentNameBool: boolean = this.currentName ? true : false;

  aboutToDisappear(): void {
    AVPlayerManager.pause();
    AVPlayerManager.player?.stop(() => {
      AVPlayerManager.player?.release();
    });
    SongManager.updateSong(JSON.stringify(AVPlayerManager.currentSong));
  }

  // tabBar组件
  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Row() {
        Image(item.name === this.currentName ? item.iconLight : item.icon)
          .width(item.name === this.currentName ? 25 : 30)
          .aspectRatio(1);
      }
      .width(22)
      .aspectRatio(1)
      .borderRadius(22)
      .justifyContent(FlexAlign.Center);

      Text(item.title)
        .fontSize(10)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name === this.currentName ? $r('app.color.primary_light') : $r('app.color.primary_dark'));
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween);
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Tabs({ barPosition: BarPosition.End }) {
          ForEach(TABS_DATA, (item: TabClass) => {
            TabContent() {
              if (item.name === 'recommend') {
                Recommend();
              } else if (item.name === 'find') {
                Find();
              } else if (item.name === 'moment') {
                Moment();
              } else if (item.name === 'mine') {
                Mine({ playState: $playState });
              } else {
                Like();
              }
            }
            .tabBar(this.getTabBar(item))
            .backgroundColor('#ffffff');
          });
        }
        .barHeight(60)
        .onChange(index => {
          this.currentName = TABS_DATA[index].name;
        });

        // 背景播放
        PlayerNav()
          .translate({ y: -60 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({
              url: 'pages/play/Play'
            });
          })
          .visibility(this.playState.playList.length > 0 && this.currentName !== 'mine' ? Visibility.Visible :
            Visibility.Hidden);
      };
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .opacity(this.opacityNum)
    .padding({
      bottom: AppStorage.get<number>('bottomHeight')
    });
  }
}


