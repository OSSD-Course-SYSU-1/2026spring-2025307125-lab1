/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { SongItemType } from '../../models/Music';
import { PlayStateType } from '../../models/PlayState';
import LocalMusicManager from '../../utils/LocalMusicManager';
import AVPlayerManager from '../../utils/AVPlayerManager';
import router from '@ohos.router';

@Entry
@Component
struct LocalMusic {
  @State localSongs: SongItemType[] = [];
  @State isLoading: boolean = false;
  @State currentSongId: string = '';
  
  aboutToAppear() {
    this.loadLocalSongs();
    // 监听当前播放歌曲
    if (AVPlayerManager.currentSong.playList.length > 0) {
      const currentIndex = AVPlayerManager.currentSong.playIndex;
      const currentSong = AVPlayerManager.currentSong.playList[currentIndex];
      if (currentSong) {
        this.currentSongId = currentSong.id;
      }
    }
  }
  
  async loadLocalSongs() {
    this.isLoading = true;
    this.localSongs = await LocalMusicManager.loadLocalMusicList();
    this.isLoading = false;
  }
  
  // 导入本地音乐
  async importMusic() {
    this.isLoading = true;
    const newSongs = await LocalMusicManager.selectMusicFiles();
    if (newSongs.length > 0) {
      // 合并新旧列表
      const allSongs: SongItemType[] = [];
      for (let i = 0; i < this.localSongs.length; i++) {
        allSongs.push(this.localSongs[i]);
      }
      for (let i = 0; i < newSongs.length; i++) {
        allSongs.push(newSongs[i]);
      }
      await LocalMusicManager.saveLocalMusicList(allSongs);
      this.localSongs = allSongs;
    }
    this.isLoading = false;
  }
  
  // 播放歌曲
  playSong(song: SongItemType, index: number) {
    // 设置播放列表
    AVPlayerManager.currentSong.playList = this.localSongs;
    AVPlayerManager.currentSong.playIndex = index;
    // 播放歌曲
    AVPlayerManager.singlePlay(song);
    router.pushUrl({
      url: 'pages/play/Play'
    });
  }
  
  // 删除歌曲
  async deleteSong(songId: string) {
    this.localSongs = await LocalMusicManager.deleteLocalMusic(songId);
  }
  
  @Builder
  SongItem(song: SongItemType, index: number) {
    Row() {
      // 序号
      Text(`${index + 1}`)
        .fontSize(14)
        .fontColor('#999')
        .width(40)
        .textAlign(TextAlign.Center)
      
      // 歌曲信息
      Column() {
        Text(song.name)
          .fontSize(16)
          .fontColor(this.currentSongId === song.id ? '#FF6B6B' : '#333')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Text(song.author)
          .fontSize(12)
          .fontColor('#999')
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
      
      // 删除按钮
      Button({ type: ButtonType.Circle }) {
        Text('×')
          .fontSize(18)
          .fontColor('#999')
      }
      .width(32)
      .height(32)
      .backgroundColor('transparent')
      .onClick(() => {
        this.deleteSong(song.id);
      })
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.playSong(song, index);
    })
  }
  
  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('本地音乐')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
        
        Blank()
        
        // 导入按钮
        Button('导入音乐')
          .fontSize(14)
          .fontColor('#FFF')
          .backgroundColor('#FF6B6B')
          .borderRadius(20)
          .height(36)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            this.importMusic();
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFF')
      
      // 分割线
      Divider()
        .color('#F0F0F0')
        .height(1)
      
      if (this.isLoading) {
        // 加载状态
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#FF6B6B')
          
          Text('加载中...')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 16 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.localSongs.length === 0) {
        // 空状态
        Column() {
          Text('🎵')
            .fontSize(64)
          
          Text('暂无本地音乐')
            .fontSize(16)
            .fontColor('#999')
            .margin({ top: 16 })
          
          Text('点击右上角"导入音乐"按钮\n从本地选择音乐文件')
            .fontSize(14)
            .fontColor('#CCC')
            .textAlign(TextAlign.Center)
            .margin({ top: 8 })
            .lineHeight(22)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // 歌曲列表
        List() {
          ForEach(this.localSongs, (song: SongItemType, index: number) => {
            ListItem() {
              this.SongItem(song, index)
            }
          }, (song: SongItemType) => song.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: '#F5F5F5',
          startMargin: 68,
          endMargin: 48
        })
      }
      
      // 底部统计信息
      if (this.localSongs.length > 0) {
        Row() {
          Text(`共 ${this.localSongs.length} 首歌曲`)
            .fontSize(12)
            .fontColor('#999')
        }
        .width('100%')
        .height(48)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#FAFAFA')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF')
  }
}
