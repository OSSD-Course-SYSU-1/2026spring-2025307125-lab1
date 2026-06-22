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

const FAVORITE_KEY = 'favorite_songs';

export default class FavoriteManager {
  static context: Context;
  
  // 设置上下文
  static setContext(context: Context) {
    FavoriteManager.context = context;
  }
  
  // 添加收藏
  static async addFavorite(song: SongItemType): Promise<void> {
    try {
      let favorites = await FavoriteManager.loadFavorites();
      
      // 检查是否已存在
      const exists = favorites.some(item => item.id === song.id);
      if (!exists) {
        favorites.unshift(song);
        await FavoriteManager.saveFavorites(favorites);
        console.info('添加收藏成功');
      }
    } catch (error) {
      console.error('添加收藏失败:', error);
    }
  }
  
  // 取消收藏
  static async removeFavorite(songId: string): Promise<void> {
    try {
      let favorites = await FavoriteManager.loadFavorites();
      favorites = favorites.filter(item => item.id !== songId);
      await FavoriteManager.saveFavorites(favorites);
      console.info('取消收藏成功');
    } catch (error) {
      console.error('取消收藏失败:', error);
    }
  }
  
  // 切换收藏状态
  static async toggleFavorite(song: SongItemType): Promise<boolean> {
    try {
      const isFav = await FavoriteManager.isFavorite(song.id);
      if (isFav) {
        await FavoriteManager.removeFavorite(song.id);
        return false;
      } else {
        await FavoriteManager.addFavorite(song);
        return true;
      }
    } catch (error) {
      console.error('切换收藏状态失败:', error);
      return false;
    }
  }
  
  // 检查是否已收藏
  static async isFavorite(songId: string): Promise<boolean> {
    try {
      const favorites = await FavoriteManager.loadFavorites();
      return favorites.some(item => item.id === songId);
    } catch (error) {
      console.error('检查收藏状态失败:', error);
      return false;
    }
  }
  
  // 加载收藏列表
  static async loadFavorites(): Promise<SongItemType[]> {
    try {
      const dataPreferences = await preferences.getPreferences(FavoriteManager.context, FAVORITE_KEY);
      const favoritesStr = await dataPreferences.get('favorites', '[]') as string;
      return JSON.parse(favoritesStr) as SongItemType[];
    } catch (error) {
      console.error('加载收藏列表失败:', error);
      return [];
    }
  }
  
  // 保存收藏列表
  private static async saveFavorites(favorites: SongItemType[]): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(FavoriteManager.context, FAVORITE_KEY);
      await dataPreferences.put('favorites', JSON.stringify(favorites));
      await dataPreferences.flush();
    } catch (error) {
      console.error('保存收藏列表失败:', error);
    }
  }
  
  // 清空所有收藏
  static async clearAllFavorites(): Promise<void> {
    try {
      await FavoriteManager.saveFavorites([]);
      console.info('清空收藏列表成功');
    } catch (error) {
      console.error('清空收藏列表失败:', error);
    }
  }
  
  // 获取收藏数量
  static async getFavoriteCount(): Promise<number> {
    try {
      const favorites = await FavoriteManager.loadFavorites();
      return favorites.length;
    } catch (error) {
      console.error('获取收藏数量失败:', error);
      return 0;
    }
  }
}
