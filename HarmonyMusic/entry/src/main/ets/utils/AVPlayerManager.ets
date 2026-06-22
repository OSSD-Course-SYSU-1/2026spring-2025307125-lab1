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

import { media } from '@kit.MediaKit';
import { SONG_KEY } from '../constants/Index';
import { SongItemType } from '../models/Music';
import { PlayStateType } from '../models/PlayState';
import AVSessionManager from './AVSessionManager';
import { wantAgent } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import SongManager from './SongManager';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

class AVPlayerManager {
  // 创建的播放器应该存在我们的工具类上，这样才能被导出使用
  static player: media.AVPlayer | null = null;
  static currentSong: PlayStateType = new PlayStateType(); // 当前歌曲的状态
  static playTime: number = 0;
  static uiContext: UIContext | undefined = undefined;

  // 创建播放器的方法
  static async init() {
    if (!AVPlayerManager.player) {
      AVPlayerManager.player = await media.createAVPlayer();
    }
    // 监听状态
    AVPlayerManager.player.on('stateChange', (state) => {
      switch (state) {
        case 'initialized':
          AVPlayerManager.player!.prepare();
          break;
        case 'prepared':
          AVPlayerManager.player!.play();
          AVPlayerManager.currentSong.isPlay = true; // 播放状态
          break;
        case 'completed':
          AVPlayerManager.nextPlay(AVPlayerManager.currentSong.playMode === 'repeat');
          break;
      }
    });
    // 监听歌曲时长
    AVPlayerManager.player.on('durationUpdate', (duration) => {
      // 每次切换歌曲都会触发这个函数, 更新即可
      AVPlayerManager.currentSong.duration = duration;
      AVSessionManager.setAVMetaData(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
    });
    // 监听播放时长
    AVPlayerManager.player.on('timeUpdate', async (time) => {
      // 每次切换歌曲都会触发这个函数, 更新即可
      AVPlayerManager.currentSong.time = time;
      AVSessionManager.setAVPlaybackState(); // 更新状态
      AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AVPlayerManager.currentSong); // 更新全局状态
    });
  }

  // 单歌播放
  static async singlePlay(song: SongItemType) {
    if (AVPlayerManager.player && AVPlayerManager.player?.state === 'idle') {
      AVPlayerManager.changePlay();
    }
    AVPlayerManager.startBackgroundTask();
    // 添加到播放列表中，再进行播放
    let isList = AVPlayerManager.currentSong.playList.some(
      (item: SongItemType) => item.id === song.id
    );
    if (isList) {
      // 是不是正在播放的
      if (AVPlayerManager.currentSong.name === song.name && AVPlayerManager.currentSong.author === song.author) {
        // 重新播放（切换当前播放索引的歌曲）
        AVPlayerManager.player?.play();
        AVPlayerManager.currentSong.isPlay = true;
      } else {
        // 切换歌曲（更新播放索引切换歌曲）
        AVPlayerManager.currentSong.playIndex =
          AVPlayerManager.currentSong.playList.findIndex(
            (item: SongItemType) => item.id === song.id
          );
        AVPlayerManager.changePlay();
      }
    } else {
      AVPlayerManager.currentSong.playList.unshift(song);
      AVPlayerManager.currentSong.playIndex = 0;
      AVPlayerManager.changePlay();
    }
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AVPlayerManager.currentSong); // 更新全局状态
    AVSessionManager.setAVPlaybackState(); // 更新状态
  }

  static async startBackgroundTask() {
    if (AVSessionManager.session.sessionId) {
      // 如果有会话，则不用开启后台任务
      return;
    }
    try {
      let wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: 'com.example.xiaohuamusic',
            abilityName: 'com.example.xiaohuamusic.EntryAbility'
          }
        ],
        actionType: wantAgent.OperationType.START_ABILITY,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let want = await wantAgent.getWantAgent(wantAgentInfo);
      await backgroundTaskManager.startBackgroundRunning(
        AVPlayerManager.uiContext?.getHostContext(),
        backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK,
        want
      );
    } catch (e) {
      AVPlayerManager.uiContext?.showAlertDialog({ message: e.message });
    }
  }

  // 暂停播放
  static pause() {
    AVPlayerManager.player!.pause();
    // 更新播放器状态
    AVPlayerManager.currentSong.isPlay = false;
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AVPlayerManager.currentSong);
    AVSessionManager.setAVPlaybackState(); // 更新状态
  }

  // 上一首
  static prevPlay() {
    // 如果是随机播放
    if (AVPlayerManager.currentSong.playMode === 'random' && AVPlayerManager.currentSong.playList.length) {
      let index = -1;
      do {
        index = Math.floor(AVPlayerManager.doRand() * AVPlayerManager.currentSong.playList.length);
      } while (index === AVPlayerManager.currentSong.playIndex);
      AVPlayerManager.currentSong.playIndex = index;
    } else {
      AVPlayerManager.currentSong.playIndex--;
      // 有可能减到负数
      AVPlayerManager.currentSong.playIndex =
        (AVPlayerManager.currentSong.playIndex + AVPlayerManager.currentSong.playList.length) %
        AVPlayerManager.currentSong.playList.length;
    }
    AVPlayerManager.singlePlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
  }

  // 下一首
  static nextPlay(repeat?: boolean) {
    if (!AVPlayerManager.currentSong.playList.length) {
      return;
    }
    if (!repeat) {
      if (AVPlayerManager.currentSong.playMode === 'random' && AVPlayerManager.currentSong.playList.length) {
        let index = 0;
        do {
          index = Math.floor(AVPlayerManager.doRand() * AVPlayerManager.currentSong.playList.length);
        } while (index === AVPlayerManager.currentSong.playIndex);
        AVPlayerManager.currentSong.playIndex = index;
      } else {
        AVPlayerManager.currentSong.playIndex++;
        // 有可能减到负数
        AVPlayerManager.currentSong.playIndex =
          (AVPlayerManager.currentSong.playIndex + AVPlayerManager.currentSong.playList.length) %
          AVPlayerManager.currentSong.playList.length;
      }
    }
    AVPlayerManager.singlePlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
  }

  // 切换歌曲
  static async changePlay() {
    // 重置播放器状态至初始化，异步方法
    await AVPlayerManager.player!.reset();
    // 重置播放状态
    AVPlayerManager.currentSong.duration = 0;
    AVPlayerManager.currentSong.time = 0;

    let ctx = AVPlayerManager.uiContext?.getHostContext();
    if (!ctx) {
      return;
    }
    //此处为特例代码来访问本地音乐文件，具体播放资源可自定义
    let fileDescriptor = ctx.resourceManager.getRawFdSync(`Delacey - Dream It Possible.flac`);
    let avFileDescriptor: media.AVFileDescriptor = {
      fd: fileDescriptor.fd,
      offset: fileDescriptor.offset,
      length: fileDescriptor.length
    };
    AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex].src =
      avFileDescriptor.toString() + AVPlayerManager.currentSong.name;
    AVPlayerManager.player!.fdSrc = avFileDescriptor;

    AVPlayerManager.currentSong.img = AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex].img;
    AVPlayerManager.currentSong.name = AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex].name;
    AVPlayerManager.currentSong.author =
      AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex].author;
    AVPlayerManager.currentSong.src =
      AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex].src +
      AVPlayerManager.currentSong.name;
    AVPlayerManager.pushImg(); // 推送封面
    SongManager.updateSong(JSON.stringify(AVPlayerManager.currentSong));
  }

  static async pushImg() {
  }

  // 删除播放
  static async remove(index: number) {
    if (AVPlayerManager.currentSong.playIndex === index) {
      // 是否删除正在播放的歌曲
      if (AVPlayerManager.currentSong.playList.length > 1) {
        //如果当前的歌曲列表超过两首
        AVPlayerManager.currentSong.playList.slice(index, 1);
        AVPlayerManager.currentSong.playIndex =
          (AVPlayerManager.currentSong.playIndex + AVPlayerManager.currentSong.playList.length) %
          AVPlayerManager.currentSong.playList.length;
        AVPlayerManager.singlePlay(AVPlayerManager.currentSong.playList[AVPlayerManager.currentSong.playIndex]);
      } else {
        await AVPlayerManager.player?.reset();
        AVPlayerManager.currentSong = new PlayStateType(); // 重置数据
        AVPlayerManager.uiContext?.getRouter().back();
      }
    } else {
      if (AVPlayerManager.currentSong.playIndex > index) {
        AVPlayerManager.currentSong.playIndex--;
      }
      AVPlayerManager.currentSong.playList.splice(index, 1);
    }
    AppStorage.setOrCreate<PlayStateType>(SONG_KEY, AVPlayerManager.currentSong); // 更新全局状态
  }

  static doRand() {
    try {
      let rand = cryptoFramework.createRandom();
      let seed = new Uint8Array([1, 2, 3]);
      rand.setSeed({ data: seed });
      let len = 1;
      let res = rand.generateRandomSync(len);
      let dataView = new DataView(res.data.buffer);
      let num = dataView.getUint8(0);
      return num / 255;
    } catch (e) {
      return 0;
    }
  }
}

export default AVPlayerManager;