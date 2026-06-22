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
import FavoriteManager from '../utils/FavoriteManager';

@Component
export struct FavoriteButton {
  @Prop song: SongItemType;
  @State isFavorite: boolean = false;
  @Prop size: number = 24; // 图标大小
  @Prop showText: boolean = false; // 是否显示文字
  
  async aboutToAppear() {
    this.isFavorite = await FavoriteManager.isFavorite(this.song.id);
  }
  
  async toggleFavorite() {
    this.isFavorite = await FavoriteManager.toggleFavorite(this.song);
  }
  
  build() {
    if (this.showText) {
      // 带文字的按钮
      Button() {
        Row() {
          Text(this.isFavorite ? '❤️' : '🤍')
            .fontSize(this.size)
          
          Text(this.isFavorite ? '已收藏' : '收藏')
            .fontSize(14)
            .fontColor(this.isFavorite ? '#FF6B6B' : '#666')
            .margin({ left: 8 })
        }
      }
      .backgroundColor('transparent')
      .onClick(() => {
        this.toggleFavorite();
      })
    } else {
      // 仅图标按钮
      Button({ type: ButtonType.Circle }) {
        Text(this.isFavorite ? '❤️' : '🤍')
          .fontSize(this.size)
      }
      .width(this.size + 16)
      .height(this.size + 16)
      .backgroundColor('transparent')
      .onClick(() => {
        this.toggleFavorite();
      })
    }
  }
}
