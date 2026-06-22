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
import { SONGS, FAVORITE_LIST } from '../../constants/MusicConstants';
import AVPlayerManager from '../../utils/AVPlayerManager';
import LocalMusicManager from '../../utils/LocalMusicManager';
import router from '@ohos.router';

@Entry
@Component
struct SearchPage {
  @State searchText: string = '';
  @State searchResults: SongItemType[] = [];
  @State hotSearchList: string[] = ['流行', '摇滚', '民谣', '电子', '古典', '爵士', '轻音乐', '说唱'];
  @State searchHistory: string[] = [];
  @State isSearching: boolean = false;
  @State allSongs: SongItemType[] = [];
  
  aboutToAppear() {
    this.loadSearchHistory();
    this.loadAllSongs();
  }
  
  async loadAllSongs() {
    // 加载所有歌曲（包括本地音乐）
    const localSongs = await LocalMusicManager.loadLocalMusicList();
    // 合并所有歌曲数组
    const allSongs: SongItemType[] = [];
    // 添加SONGS
    for (let i = 0; i < SONGS.length; i++) {
      allSongs.push(SONGS[i]);
    }
    // 添加FAVORITE_LIST.songs
    for (let i = 0; i < FAVORITE_LIST.songs.length; i++) {
      allSongs.push(FAVORITE_LIST.songs[i]);
    }
    // 添加localSongs
    for (let i = 0; i < localSongs.length; i++) {
      allSongs.push(localSongs[i]);
    }
    this.allSongs = allSongs;
  }
  
  loadSearchHistory() {
    // TODO: 从首选项加载搜索历史
    this.searchHistory = ['周杰伦', '林俊杰', '薛之谦'];
  }
  
  // 执行搜索
  performSearch(keyword: string) {
    if (!keyword.trim()) {
      this.searchResults = [];
      return;
    }
    
    this.isSearching = true;
    
    // 搜索歌曲名和歌手名
    const results = this.allSongs.filter(song => {
      const nameMatch = song.name.toLowerCase().includes(keyword.toLowerCase());
      const authorMatch = song.author.toLowerCase().includes(keyword.toLowerCase());
      return nameMatch || authorMatch;
    });
    
    this.searchResults = results;
    this.isSearching = false;
    
    // 保存搜索历史
    if (!this.searchHistory.includes(keyword)) {
      this.searchHistory = [keyword, ...this.searchHistory].slice(0, 10); // 最多保存10条
    }
  }
  
  // 播放歌曲
  playSong(song: SongItemType, index: number) {
    // 设置播放列表
    AVPlayerManager.currentSong.playList = this.searchResults;
    AVPlayerManager.currentSong.playIndex = index;
    // 播放歌曲
    AVPlayerManager.singlePlay(song);
    router.pushUrl({
      url: 'pages/play/Play'
    });
  }
  
  @Builder
  SearchBar() {
    Row() {
      // 返回按钮
      Button({ type: ButtonType.Circle }) {
        Text('←')
          .fontSize(20)
          .fontColor('#666')
      }
      .width(36)
      .height(36)
      .backgroundColor('transparent')
      .onClick(() => {
        router.back();
      })
      
      // 搜索输入框
      TextInput({ placeholder: '搜索歌曲、歌手', text: this.searchText })
        .layoutWeight(1)
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .padding({ left: 16, right: 16 })
        .margin({ left: 12 })
        .onChange((value: string) => {
          this.searchText = value;
        })
        .onSubmit(() => {
          this.performSearch(this.searchText);
        })
      
      // 搜索按钮
      Button('搜索')
        .fontSize(14)
        .fontColor('#FF6B6B')
        .backgroundColor('transparent')
        .margin({ left: 12 })
        .onClick(() => {
          this.performSearch(this.searchText);
        })
    }
    .width('100%')
    .height(56)
    .padding({ left: 8, right: 16 })
    .backgroundColor('#FFF')
  }
  
  @Builder
  HotSearch() {
    Column() {
      Text('热门搜索')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333')
        .margin({ bottom: 16 })
      
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.hotSearchList, (tag: string) => {
          Text(tag)
            .fontSize(14)
            .fontColor('#666')
            .backgroundColor('#F5F5F5')
            .borderRadius(16)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .margin({ right: 12, bottom: 12 })
            .onClick(() => {
              this.searchText = tag;
              this.performSearch(tag);
            })
        })
      }
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
  }
  
  @Builder
  SearchHistory() {
    Column() {
      Row() {
        Text('搜索历史')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
        
        Blank()
        
        Text('清空')
          .fontSize(14)
          .fontColor('#999')
          .onClick(() => {
            this.searchHistory = [];
          })
      }
      .width('100%')
      .margin({ bottom: 16 })
      
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.searchHistory, (keyword: string) => {
          Text(keyword)
            .fontSize(14)
            .fontColor('#666')
            .backgroundColor('#F5F5F5')
            .borderRadius(16)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .margin({ right: 12, bottom: 12 })
            .onClick(() => {
              this.searchText = keyword;
              this.performSearch(keyword);
            })
        })
      }
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
  }
  
  @Builder
  SearchResult() {
    Column() {
      Row() {
        Text(`搜索结果 (${this.searchResults.length})`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      
      if (this.isSearching) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#FF6B6B')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.searchResults.length === 0) {
        Column() {
          Text('🔍')
            .fontSize(48)
          
          Text('未找到相关结果')
            .fontSize(16)
            .fontColor('#999')
            .margin({ top: 16 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.searchResults, (song: SongItemType, index: number) => {
            ListItem() {
              Row() {
                // 封面
                Image(song.img)
                  .width(56)
                  .height(56)
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover)
                
                // 歌曲信息
                Column() {
                  Text(song.name)
                    .fontSize(16)
                    .fontColor('#333')
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
              }
              .width('100%')
              .height(72)
              .padding({ left: 16, right: 16 })
              .onClick(() => {
                this.playSong(song, index);
              })
            }
          }, (song: SongItemType) => song.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: '#F5F5F5',
          startMargin: 84,
          endMargin: 16
        })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
  
  build() {
    Column() {
      // 搜索栏
      this.SearchBar()
      
      Divider()
        .color('#F0F0F0')
        .height(1)
      
      if (this.searchText === '' && this.searchResults.length === 0) {
        // 显示热门搜索和搜索历史
        Scroll() {
          Column() {
            this.HotSearch()
            
            Divider()
              .color('#F0F0F0')
              .height(8)
              .margin({ left: -16, right: -16 })
            
            if (this.searchHistory.length > 0) {
              this.SearchHistory()
            }
          }
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      } else {
        // 显示搜索结果
        this.SearchResult()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF')
  }
}
