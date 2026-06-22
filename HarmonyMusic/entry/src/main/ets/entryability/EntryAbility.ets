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

import { UIAbility } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import AVPlayerManager from '../utils/AVPlayerManager';
import AVSessionManager from '../utils/AVSessionManager';
import rpc from '@ohos.rpc';
import { SONG_KEY } from '../constants/Index';
import SongManager from '../utils/SongManager';

class Params implements rpc.Parcelable {
  unmarshalling(dataIn: rpc.MessageSequence): boolean {
    hilog.info(0x0000, 'testTag', '%{public}s', `${dataIn}`);
    return true;
  }

  marshalling(dataOut: rpc.MessageSequence): boolean {
    hilog.info(0x0000, 'testTag', '%{public}s', `${dataOut}`);
    return true;
  }
}

export default class EntryAbility extends UIAbility {
  onCreate(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 上一首
    this.callee.on('prev', () => {
      AVPlayerManager.prevPlay();
      return new Params();
    });

    // 下一首
    this.callee.on('next', () => {
      AVPlayerManager.nextPlay();
      return new Params();
    });

    this.callee.on('getFormId', (data) => {
      hilog.info(0x0000, 'testTag', '%{public}s', `${data}`);
      return new Params();
    });
  }

  onDestroy(): void {
    this.callee.off('prev');
    this.callee.off('next');
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index')
      .then(async () => {
        let win = windowStage.getMainWindowSync();
        let uiContext = win.getUIContext();
        win.setWindowLayoutFullScreen(true);
        AppStorage.setOrCreate(
          'topHeight',
          uiContext.px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
        );
        AppStorage.setOrCreate(
          'bottomHeight',
          uiContext.px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)
        );
        AVPlayerManager.uiContext = uiContext;
        AVPlayerManager.init();
        AVSessionManager.init(this.context);
        SongManager.context = this.context;
        AVPlayerManager.currentSong = await SongManager.getSong(); // 获去缓存的音乐信息
        AppStorage.setOrCreate(SONG_KEY, AVPlayerManager.currentSong); // 更新到全局状态
      });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
};
