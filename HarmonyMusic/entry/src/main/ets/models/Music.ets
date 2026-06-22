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

export interface SongItemType {
  img: string;
  name: string;
  author: string;
  src: string;
  id: string;
}

export interface RecommendListType {
  img: string;
  title: string;
  count: string;
}

export interface RecommendDailyType {
  img: string;
  title: string;
  type: string;
  song: string;
  bottom: string;
}

export interface FavoriteListType {
  name: string;
  nickName: string;
  avatar: ResourceStr;
  songs: SongItemType[];
}

export interface MomentListType {
  author: string;
  avatar: string;
  content: string;
  comment: string;
  song: SongItemType;
}

export interface PaihangListType {
  img: string;
  title1: string;
  title2: string;
  count: string;
  song1: string;
  author1: string;
  song2: string;
  author2: string;
  song3: string;
  author3: string;
}

export class SongItemTypeModel implements SongItemType {
  img: string = '';
  name: string = '';
  author: string = '';
  src: string = '';
  id: string = '';

  constructor(model: SongItemType) {
    this.img = model.img;
    this.name = model.name;
    this.author = model.author;
    this.src = model.src;
    this.id = model.id;
  }
}

export class RecommendListTypeModel implements RecommendListType {
  img: string = '';
  title: string = '';
  count: string = '';

  constructor(model: RecommendListType) {
    this.img = model.img;
    this.title = model.title;
    this.count = model.count;
  }
}

export class RecommendDailyTypeModel implements RecommendDailyType {
  img: string = '';
  title: string = '';
  type: string = '';
  song: string = '';
  bottom: string = '';

  constructor(model: RecommendDailyType) {
    this.img = model.img;
    this.title = model.title;
    this.type = model.type;
    this.bottom = model.bottom;
  }
}

export class FavoriteListTypeModel implements FavoriteListType {
  name: string = '';
  nickName: string = '';
  avatar: ResourceStr = '';
  songs: SongItemType[] = [];

  constructor(model: FavoriteListType) {
    this.name = model.name;
    this.nickName = model.nickName;
    this.avatar = model.avatar;
    this.songs = model.songs;
  }
}

export class MomentListTypeModel implements MomentListType {
  author: string = '';
  avatar: string = '';
  content: string = '';
  comment: string = '';
  song: SongItemType = new SongItemTypeModel({} as SongItemType);

  constructor(model: MomentListType) {
    this.author = model.author;
    this.avatar = model.avatar;
    this.content = model.content;
    this.comment = model.comment;
    this.song = model.song;
  }
}

export class PaihangListTypeModel implements PaihangListType {
  img: string = '';
  title1: string = '';
  title2: string = '';
  count: string = '';
  song1: string = '';
  author1: string = '';
  song2: string = '';
  author2: string = '';
  song3: string = '';
  author3: string = '';

  constructor(model: PaihangListType) {
    this.img = model.img;
    this.title1 = model.title1;
    this.title2 = model.title2;
    this.count = model.count;
    this.song1 = model.song1;
    this.author1 = model.author1;
    this.song2 = model.song2;
    this.author2 = model.author2;
    this.song3 = model.song3;
    this.author3 = model.author3;
  }
}