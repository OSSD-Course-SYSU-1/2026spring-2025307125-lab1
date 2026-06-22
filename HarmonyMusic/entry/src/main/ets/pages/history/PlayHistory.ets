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
import { PlayHistoryItem } from '../../utils/PlayHistoryManager';
import PlayHistoryManager from '../../utils/PlayHistoryManager';
import AVPlayerManager from '../../utils/AVPlayerManager';
import router from '@ohos.router';

@Entry
@Component
struct PlayHistory {
  @State historyList: PlayHistoryItem[] = [];
  @State isLoading: boolean = false;
  @State currentSongId: string = '';
  
  aboutToAppear() {
    this.loadHistory();
    // 获取当前播放歌曲ID
    if (AVPlayerManager.currentSong.playList.length > 0) {
      const currentIndex = AVPlayerManager.currentSong.playIndex;
      const currentSong = AVPlayerManager.currentSong.playList[currentIndex];
      if (currentSong) {
        this.currentSongId = currentSong.id;
      }
    }
  }
  
  async loadHistory() {
    this.isLoading = true;
    this.historyList = await PlayHistoryManager.loadPlayHistory();
    this.isLoading = false;
  }
  
  // 播放歌曲
  playSong(song: PlayHistoryItem, index: number) {
    // 转换为SongItemType数组
    const songs: SongItemType[] = this.historyList.map((item: PlayHistoryItem): SongItemType => {
      // 手动提取歌曲属性，排除playTime
      const songItem: SongItemType = {
        id: item.id,
        name: item.name,
        author: item.author,
        img: item.img,
        src: item.src
      };
      return songItem;
    });
    
    // 设置播放列表
    AVPlayerManager.currentSong.playList = songs;
    AVPlayerManager.currentSong.playIndex = index;
    // 播放歌曲
    const currentSongItem: SongItemType = {
      id: song.id,
      name: song.name,
      author: song.author,
      img: song.img,
      src: song.src
    };
    AVPlayerManager.singlePlay(currentSongItem);
    router.pushUrl({
      url: 'pages/play/Play'
    });
  }
  
  // 删除单条记录
  async deleteItem(songId: string) {
    this.historyList = await PlayHistoryManager.deleteHistoryItem(songId);
  }
  
  // 清空所有记录
  async clearAll() {
    await PlayHistoryManager.clearPlayHistory();
    this.historyList = [];
  }
  
  @Builder
  HistoryItem(item: PlayHistoryItem, index: number) {
    Row() {
      // 序号
      Text(`${index + 1}`)
        .fontSize(14)
        .fontColor('#999')
        .width(40)
        .textAlign(TextAlign.Center)
      
      // 封面
      Image(item.img)
        .width(48)
        .height(48)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)
      
      // 歌曲信息
      Column() {
        Text(item.name)
          .fontSize(16)
          .fontColor(this.currentSongId === item.id ? '#FF6B6B' : '#333')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Row() {
          Text(item.author)
            .fontSize(12)
            .fontColor('#999')
          
          Text(' • ')
            .fontSize(12)
            .fontColor('#CCC')
          
          Text(PlayHistoryManager.formatPlayTime(item.playTime))
            .fontSize(12)
            .fontColor('#CCC')
        }
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
        this.deleteItem(item.id);
      })
    }
    .width('100%')
    .height(64)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.playSong(item, index);
    })
  }
  
  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('播放历史')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
        
        Blank()
        
        if (this.historyList.length > 0) {
          Button('清空')
            .fontSize(14)
            .fontColor('#FF6B6B')
            .backgroundColor('transparent')
            .onClick(() => {
              this.clearAll();
            })
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFF')
      
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
      } else if (this.historyList.length === 0) {
        // 空状态
        Column() {
          Text('🕐')
            .fontSize(64)
          
          Text('暂无播放历史')
            .fontSize(16)
            .fontColor('#999')
            .margin({ top: 16 })
          
          Text('快去听歌吧')
            .fontSize(14)
            .fontColor('#CCC')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // 历史列表
        List() {
          ForEach(this.historyList, (item: PlayHistoryItem, index: number) => {
            ListItem() {
              this.HistoryItem(item, index)
            }
          }, (item: PlayHistoryItem) => item.id)
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
      if (this.historyList.length > 0) {
        Row() {
          Text(`共 ${this.historyList.length} 首歌曲`)
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
