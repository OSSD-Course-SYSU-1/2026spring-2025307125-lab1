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

import { LyricLine } from '../utils/LyricParser';
import LyricParser from '../utils/LyricParser';

@Component
export struct LyricView {
  @Prop lyrics: LyricLine[] = [];
  @Prop currentTime: number = 0; // 当前播放时间（毫秒）
  @Prop songName: string = '';
  @State currentIndex: number = -1;
  private scroller: Scroller = new Scroller();
  
  aboutToAppear() {
    // 如果没有歌词，生成模拟歌词
    if (this.lyrics.length === 0) {
      this.lyrics = LyricParser.generateMockLyric(this.songName);
    }
  }
  
  // 监听时间变化，更新当前歌词索引
  aboutToUpdate() {
    const newIndex = LyricParser.findCurrentLyricIndex(this.lyrics, this.currentTime);
    if (newIndex !== this.currentIndex) {
      this.currentIndex = newIndex;
      // 滚动到当前歌词
      if (newIndex >= 0) {
        this.scroller.scrollToIndex(newIndex, true, ScrollAlign.CENTER);
      }
    }
  }
  
  build() {
    Column() {
      if (this.lyrics.length === 0) {
        // 无歌词状态
        Column() {
          Text('♪')
            .fontSize(48)
            .fontColor('#CCC')
          
          Text('暂无歌词')
            .fontSize(16)
            .fontColor('#999')
            .margin({ top: 16 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 歌词列表
        List({ scroller: this.scroller }) {
          ForEach(this.lyrics, (lyric: LyricLine, index: number) => {
            ListItem() {
              Text(lyric.text)
                .fontSize(this.currentIndex === index ? 18 : 14)
                .fontColor(this.currentIndex === index ? '#FF6B6B' : '#999')
                .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
                .textAlign(TextAlign.Center)
                .width('100%')
                .padding({ top: 12, bottom: 12 })
                .opacity(this.currentIndex === index ? 1 : 0.6)
                .animation({
                  duration: 300,
                  curve: Curve.EaseInOut
                })
            }
          }, (lyric: LyricLine) => `${lyric.time}_${lyric.text}`)
        }
        .width('100%')
        .layoutWeight(1)
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
    }
    .width('100%')
    .height('100%')
  }
}
