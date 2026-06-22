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

import { SONG_KEY } from '../constants/Index';
import { PlayStateType } from '../models/PlayState';
import AVPlayerManager from '../utils/AVPlayerManager';

@Component
struct PlayerNav {
  @StorageLink(SONG_KEY) playState: PlayStateType = new PlayStateType();

  build() {
    Row() {
      Row({ space: 10 }) {
        Image(this.playState.img)
          .width(32)
          .borderRadius(5)
          .aspectRatio(1)
          .margin({
            left: 8
          });
        Column() {
          Text(this.playState.name)
            .fontColor('#000000');
          Text(this.playState.author)
            .fontSize(12)
            .fontColor('#000000');
        }.alignItems(HorizontalAlign.Start);
      }.height('100%')
      .alignItems(VerticalAlign.Center);

      Row() {
        Image(this.playState.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
          .height(24)
          .width(24)
          .fillColor('#FE1A47')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            if (!this.playState.isPlay) {
              AVPlayerManager.singlePlay(this.playState.playList[this.playState.playIndex]);
            } else {
              AVPlayerManager.pause();
            }
          });
        Image($r('app.media.play_list'))
          .width(20)
          .height(20)
          .aspectRatio(1)
          .fillColor('#000000')
          .margin(12);
      }.height('100%');
    }
    .width('97%')
    .height(48)
    .backgroundColor('#EFEFEF')
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(5);
  }
}

export default PlayerNav;