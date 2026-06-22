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

import { picker } from '@kit.CoreFileKit';
import { fileIo } from '@kit.CoreFileKit';
import { SongItemType } from '../models/Music';
import { preferences } from '@kit.ArkData';
import { Context } from '@kit.AbilityKit';

const LOCAL_MUSIC_KEY = 'local_music_list';

export default class LocalMusicManager {
  static context: Context;
  
  // 设置上下文
  static setContext(context: Context) {
    LocalMusicManager.context = context;
  }
  
  // 打开文件选择器选择音乐文件
  static async selectMusicFiles(): Promise<SongItemType[]> {
    try {
      const documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = 10; // 最多选择10个文件
      documentSelectOptions.fileSuffixFilters = ['.mp3', '.wav', '.flac', '.aac', '.m4a']; // 支持的音频格式
      
      const documentViewPicker = new picker.DocumentViewPicker();
      const uris = await documentViewPicker.select(documentSelectOptions);
      
      if (uris && uris.length > 0) {
        const songs: SongItemType[] = [];
        for (let i = 0; i < uris.length; i++) {
          const song = await LocalMusicManager.parseMusicFile(uris[i], i);
          if (song) {
            songs.push(song);
          }
        }
        return songs;
      }
      return [];
    } catch (error) {
      console.error('选择音乐文件失败:', error);
      return [];
    }
  }
  
  // 解析音乐文件信息
  static async parseMusicFile(uri: string, index: number): Promise<SongItemType | null> {
    try {
      // 从URI中提取文件名
      const fileName = uri.split('/').pop() || '未知歌曲';
      const nameWithoutExt = fileName.replace(/\.(mp3|wav|flac|aac|m4a)$/i, '');
      
      // 生成唯一ID
      const id = `local_${Date.now()}_${index}`;
      
      return {
        id: id,
        name: nameWithoutExt,
        author: '本地音乐',
        img: 'file:///data/local/music_default.png', // 默认封面
        src: uri
      };
    } catch (error) {
      console.error('解析音乐文件失败:', error);
      return null;
    }
  }
  
  // 保存本地音乐列表到首选项
  static async saveLocalMusicList(songs: SongItemType[]): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(LocalMusicManager.context, LOCAL_MUSIC_KEY);
      await dataPreferences.put('localSongs', JSON.stringify(songs));
      await dataPreferences.flush();
      console.info('本地音乐列表保存成功');
    } catch (error) {
      console.error('保存本地音乐列表失败:', error);
    }
  }
  
  // 从首选项加载本地音乐列表
  static async loadLocalMusicList(): Promise<SongItemType[]> {
    try {
      const dataPreferences = await preferences.getPreferences(LocalMusicManager.context, LOCAL_MUSIC_KEY);
      const songsStr = await dataPreferences.get('localSongs', '[]') as string;
      return JSON.parse(songsStr) as SongItemType[];
    } catch (error) {
      console.error('加载本地音乐列表失败:', error);
      return [];
    }
  }
  
  // 删除指定的本地音乐
  static async deleteLocalMusic(songId: string): Promise<SongItemType[]> {
    try {
      let songs = await LocalMusicManager.loadLocalMusicList();
      songs = songs.filter(song => song.id !== songId);
      await LocalMusicManager.saveLocalMusicList(songs);
      return songs;
    } catch (error) {
      console.error('删除本地音乐失败:', error);
      return [];
    }
  }
  
  // 清空所有本地音乐
  static async clearAllLocalMusic(): Promise<void> {
    try {
      await LocalMusicManager.saveLocalMusicList([]);
      console.info('清空本地音乐列表成功');
    } catch (error) {
      console.error('清空本地音乐列表失败:', error);
    }
  }
}
