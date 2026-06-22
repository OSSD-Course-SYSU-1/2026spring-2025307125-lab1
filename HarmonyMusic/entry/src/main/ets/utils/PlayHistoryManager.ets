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

import { SongItemType } from '../models/Music';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

const HISTORY_KEY = 'play_history';
const MAX_HISTORY_COUNT = 50; // 最多保存50条历史记录

export interface PlayHistoryItem extends SongItemType {
  playTime: number; // 播放时间戳
}

export default class PlayHistoryManager {
  static context: Context;
  
  // 设置上下文
  static setContext(context: Context) {
    PlayHistoryManager.context = context;
  }
  
  // 添加播放记录
  static async addPlayHistory(song: SongItemType): Promise<void> {
    try {
      let history = await PlayHistoryManager.loadPlayHistory();
      
      // 检查是否已存在，如果存在则移除旧的
      history = history.filter(item => item.id !== song.id);
      
      // 添加新记录到开头
      const historyItem: PlayHistoryItem = {
        id: song.id,
        name: song.name,
        author: song.author,
        img: song.img,
        src: song.src,
        playTime: Date.now()
      };
      history.unshift(historyItem);
      
      // 限制历史记录数量
      if (history.length > MAX_HISTORY_COUNT) {
        history = history.slice(0, MAX_HISTORY_COUNT);
      }
      
      // 保存
      await PlayHistoryManager.savePlayHistory(history);
    } catch (error) {
      console.error('添加播放历史失败:', error);
    }
  }
  
  // 加载播放历史
  static async loadPlayHistory(): Promise<PlayHistoryItem[]> {
    try {
      const dataPreferences = await preferences.getPreferences(PlayHistoryManager.context, HISTORY_KEY);
      const historyStr = await dataPreferences.get('history', '[]') as string;
      return JSON.parse(historyStr) as PlayHistoryItem[];
    } catch (error) {
      console.error('加载播放历史失败:', error);
      return [];
    }
  }
  
  // 保存播放历史
  private static async savePlayHistory(history: PlayHistoryItem[]): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(PlayHistoryManager.context, HISTORY_KEY);
      await dataPreferences.put('history', JSON.stringify(history));
      await dataPreferences.flush();
    } catch (error) {
      console.error('保存播放历史失败:', error);
    }
  }
  
  // 清空播放历史
  static async clearPlayHistory(): Promise<void> {
    try {
      await PlayHistoryManager.savePlayHistory([]);
      console.info('清空播放历史成功');
    } catch (error) {
      console.error('清空播放历史失败:', error);
    }
  }
  
  // 删除单条历史记录
  static async deleteHistoryItem(songId: string): Promise<PlayHistoryItem[]> {
    try {
      let history = await PlayHistoryManager.loadPlayHistory();
      history = history.filter(item => item.id !== songId);
      await PlayHistoryManager.savePlayHistory(history);
      return history;
    } catch (error) {
      console.error('删除历史记录失败:', error);
      return [];
    }
  }
  
  // 获取最近播放的歌曲（去重）
  static async getRecentSongs(count: number = 10): Promise<SongItemType[]> {
    try {
      const history = await PlayHistoryManager.loadPlayHistory();
      return history.slice(0, count).map(item => {
        // 手动提取歌曲属性，排除playTime
        const song: SongItemType = {
          id: item.id,
          name: item.name,
          author: item.author,
          img: item.img,
          src: item.src
        };
        return song;
      });
    } catch (error) {
      console.error('获取最近播放失败:', error);
      return [];
    }
  }
  
  // 格式化播放时间
  static formatPlayTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    
    const minutes = Math.floor(diff / (1000 * 60));
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    
    if (minutes < 1) {
      return '刚刚';
    } else if (minutes < 60) {
      return `${minutes}分钟前`;
    } else if (hours < 24) {
      return `${hours}小时前`;
    } else if (days < 7) {
      return `${days}天前`;
    } else {
      const date = new Date(timestamp);
      return `${date.getMonth() + 1}月${date.getDate()}日`;
    }
  }
}
