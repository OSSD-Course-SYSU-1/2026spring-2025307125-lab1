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

// 歌词行数据结构
export interface LyricLine {
  time: number; // 时间戳（毫秒）
  text: string; // 歌词文本
}

export default class LyricParser {
  // 解析LRC格式歌词
  static parseLrc(lrcContent: string): LyricLine[] {
    const lines = lrcContent.split('\n');
    const lyrics: LyricLine[] = [];
    
    for (const line of lines) {
      // 匹配时间标签格式 [mm:ss.xx] 或 [mm:ss:xx]
      const timeMatch = line.match(/\[(\d{2}):(\d{2})[.:](\d{2,3})\]/);
      if (timeMatch) {
        const minutes = parseInt(timeMatch[1]);
        const seconds = parseInt(timeMatch[2]);
        const milliseconds = parseInt(timeMatch[3].padEnd(3, '0'));
        const time = minutes * 60 * 1000 + seconds * 1000 + milliseconds;
        
        // 提取歌词文本（去掉时间标签）
        const text = line.replace(/\[\d{2}:\d{2}[.:]\d{2,3}\]/g, '').trim();
        
        if (text) {
          lyrics.push({ time, text });
        }
      }
    }
    
    // 按时间排序
    lyrics.sort((a, b) => a.time - b.time);
    
    return lyrics;
  }
  
  // 根据当前播放时间找到当前歌词行索引
  static findCurrentLyricIndex(lyrics: LyricLine[], currentTime: number): number {
    if (lyrics.length === 0) return -1;
    
    for (let i = lyrics.length - 1; i >= 0; i--) {
      if (currentTime >= lyrics[i].time) {
        return i;
      }
    }
    
    return -1;
  }
  
  // 生成模拟歌词（当没有真实歌词时）
  static generateMockLyric(songName: string): LyricLine[] {
    return [
      { time: 0, text: '♪ ' + songName },
      { time: 5000, text: '♪ 暂无歌词' },
      { time: 10000, text: '♪ 请欣赏音乐' },
      { time: 15000, text: '♪ ~~~~~~' },
      { time: 20000, text: '♪ ~~~~~~' },
      { time: 25000, text: '♪ ~~~~~~' },
      { time: 30000, text: '♪ ~~~~~~' },
      { time: 35000, text: '♪ ~~~~~~' },
      { time: 40000, text: '♪ ~~~~~~' },
      { time: 45000, text: '♪ ~~~~~~' },
      { time: 50000, text: '♪ ~~~~~~' },
      { time: 55000, text: '♪ ~~~~~~' },
      { time: 60000, text: '♪ ~~~~~~' },
      { time: 65000, text: '♪ ~~~~~~' },
      { time: 70000, text: '♪ ~~~~~~' },
      { time: 75000, text: '♪ ~~~~~~' },
      { time: 80000, text: '♪ ~~~~~~' },
      { time: 85000, text: '♪ ~~~~~~' },
      { time: 90000, text: '♪ ~~~~~~' },
      { time: 95000, text: '♪ ~~~~~~' },
      { time: 100000, text: '♪ ~~~~~~' },
      { time: 105000, text: '♪ ~~~~~~' },
      { time: 110000, text: '♪ ~~~~~~' },
      { time: 115000, text: '♪ ~~~~~~' },
      { time: 120000, text: '♪ ~~~~~~' }
    ];
  }
  
  // 示例歌词数据（用于演示）
  static getDemoLyric(): string {
    return `[00:00.00]示例歌曲
[00:05.00]这是第一句歌词
[00:10.00]这是第二句歌词
[00:15.00]这是第三句歌词
[00:20.00]这是第四句歌词
[00:25.00]这是第五句歌词
[00:30.00]♪ ~~~~~~
[00:35.00]♪ ~~~~~~
[00:40.00]♪ ~~~~~~`;
  }
}
