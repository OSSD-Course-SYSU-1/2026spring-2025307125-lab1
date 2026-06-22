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

import { Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { PlayStateType } from '../models/PlayState';

export default class SongManager {
  static context: Context;

  static getStore() {
    return preferences.getPreferencesSync(SongManager.context || SongManager.context, {
      name: 'song_cache'
    });
  }

  // 更新音乐
  static async updateSong(song: string) {
    let store = SongManager.getStore();
    store.putSync('song_cache_key', song);
    await store.flush();
  }

  static async getSong() {
    let store = SongManager.getStore();
    return JSON.parse(store.getSync('song_cache_key', JSON.stringify(new PlayStateType)) as string) as PlayStateType;
  }
}