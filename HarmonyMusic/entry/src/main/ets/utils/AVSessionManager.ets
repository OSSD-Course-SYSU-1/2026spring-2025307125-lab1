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

import AvSession from '@ohos.multimedia.avsession';
import { SongItemType } from '../models/Music';
import AVPlayerManager from './AVPlayerManager';

export default class AVSessionManager {
  static session: AvSession.AVSession;
  static controller: AvSession.AVSessionController;

  // 初始化媒体会话
  static async init(context: Context) {
    AVSessionManager.session = await AvSession.createAVSession(context, 'bgPlay', 'audio'); // 获取会话对象
    AVSessionManager.controller = await AVSessionManager.session.getController(); // 获取会话控制器
    AVSessionManager.registerEvent();
  }

  static async setAVMetaData(song: SongItemType) {
    await AVSessionManager.session.setAVMetadata({
      assetId: song.id,
      title: song.name,
      artist: song.author,
      mediaImage: song.img,
      duration: AVPlayerManager.currentSong.duration
    });
  }

  static async setAVPlaybackState() {
    AVSessionManager.session.setAVPlaybackState({
      state: AVPlayerManager.currentSong.isPlay ?
        AvSession.PlaybackState.PLAYBACK_STATE_PLAY :
        AvSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      position: {
        elapsedTime: AVPlayerManager.currentSong.time,
        updateTime: (new Date()).getTime(),
      },
      speed: 1.0,
      duration: AVPlayerManager.currentSong.duration
    });
  }

  static async registerEvent() {
    AVSessionManager.session.on('play', () => {
      AVPlayerManager.singlePlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
    });
    AVSessionManager.session.on('pause', () => {
      AVPlayerManager.pause();
    });
    AVSessionManager.session.on('stop', () => {

    });
    AVSessionManager.session.on('playNext', () => {
      AVPlayerManager.nextPlay();
    });
    AVSessionManager.session.on('playPrevious', () => {
      AVPlayerManager.prevPlay();
    });
    AVSessionManager.session.on('seek', (time) => {
      AVPlayerManager.player!.seek(time);
    });
    AVSessionManager.session.activate();
  }
}