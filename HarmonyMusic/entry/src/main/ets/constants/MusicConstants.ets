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

import {
  FavoriteListType,
  MomentListType,
  PaihangListType,
  RecommendDailyType,
  RecommendListType,
  SongItemType
} from '../models/Music';
import { TabClass } from '../models/Index';

// TabBar数据
export const TABS_DATA: TabClass[] = [
  {
    title: '推荐',
    name: 'recommend',
    icon: $r('app.media.ic_recommend_gt'),
    iconLight: $r('app.media.ic_recommend_pt')
  }, {
  title: '发现',
  name: 'find',
  icon: $r('app.media.ic_find_gt'),
  iconLight: $r('app.media.ic_find_pt')
}, {
  title: '喜欢',
  name: 'home',
  icon: $r('app.media.ic_like_gt'),
  iconLight: $r('app.media.ic_like_pt')
}, {
  title: '动态',
  name: 'moment',
  icon: $r('app.media.ic_moment_gt'),
  iconLight: $r('app.media.ic_moment_pt')
}, {
  title: '我的',
  name: 'mine',
  icon: $r('app.media.ic_mine_gt'),
  iconLight: $r('app.media.ic_mine_pt')
}];

// 每日推荐数据
export const DAILY_RECOMMEND: RecommendDailyType[] = [
  {
    img: 'resources/base/media/ic_img1.jpg',
    title: 'Music FM',
    type: '现在就听',
    song: 'Dream It Possible (Delacey)',
    bottom: 'rgba(0, 0, 0, 0.15)'
  },
  {
    img: 'resources/base/media/ic_img2.jpg',
    title: 'New',
    type: '新歌推荐',
    song: 'Dream It Possible (Delacey)',
    bottom: 'rgba(0, 0, 0, 0.15)'
  }
];

// 推荐歌单数据
export const RECOMMEND_LIST: RecommendListType[] = [
  {
    img: 'resources/base/media/ic_img3.jpg',
    title: '我在BGM中跳进了初夏的梦里',
    count: '257W'
  },
  {
    img: 'resources/base/media/ic_img4.jpg',
    title: '电波发送 | 叮！城市郊游指南',
    count: '257W'
  },
  {
    img: 'resources/base/media/ic_img5.jpg',
    title: '霓虹城市的合成器之音',
    count: '257W'
  }
];

// 歌曲列表
export const SONGS: SongItemType[] = [
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible0',
    author: 'Delacey0',
    src: '',
    id: '0000'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible1',
    author: 'Delacey1',
    src: '',
    id: '0001'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible2',
    author: 'Delacey2',
    src: '',
    id: '0002'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible3',
    author: 'Delacey3',
    src: '',
    id: '0003'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible4',
    author: 'Delacey4',
    src: '',
    id: '0004'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible5',
    author: 'Delacey5',
    src: '',
    id: '0005'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible6',
    author: 'Delacey6',
    src: '',
    id: '0006'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible7',
    author: 'Delacey7',
    src: '',
    id: '0007'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible8',
    author: 'Delacey8',
    src: '',
    id: '0008'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible9',
    author: 'Delacey9',
    src: '',
    id: '0009'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible10',
    author: 'Delacey10',
    src: '',
    id: '0010'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible11',
    author: 'Delacey11',
    src: '',
    id: '0011'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible12',
    author: 'Delacey12',
    src: '',
    id: '0012'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible13',
    author: 'Delacey13',
    src: '',
    id: '0013'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible14',
    author: 'Delacey14',
    src: '',
    id: '0014'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible15',
    author: 'Delacey15',
    src: '',
    id: '0015'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible16',
    author: 'Delacey16',
    src: '',
    id: '0016'
  }
];

export const SONGS_COMMENT: SongItemType[] = [
  {
    img: 'resources/base/media/ic_cover.png',
    name: 'Dream It Possiblea',
    author: 'Delaceya',
    src: '',
    id: '0000'
  },
  {
    img: 'resources/base/media/ic_cover.png',
    name: 'xxxxb',
    author: 'xxxb',
    src: '',
    id: '0001'
  },
  {
    img: 'resources/base/media/ic_cover.png',
    name: 'xxxxc',
    author: 'xxxc',
    src: '',
    id: '0002'
  }
];

// 喜欢列表
export const FAVORITE_LIST: FavoriteListType = {
  name: '我喜欢的音乐',
  nickName: '小花',
  avatar: $r('app.media.logo'),
  songs: SONGS
};

// 动态列表
export const MOMENT_LIST: MomentListType[] = [
  {
    author: '用户',
    avatar: 'resources/base/media/ic_user1.png',
    content: '花腔女高音 | 夜莺般的华彩炫技',
    comment: '个性签名',
    song: SONGS_COMMENT[0]
  },
  {
    author: '用户',
    avatar: 'resources/base/media/ic_user2.png',
    content: '花腔女高音 | 夜莺般的华彩炫技',
    comment: '个性签名',
    song: SONGS_COMMENT[1]
  },
  {
    author: '用户',
    avatar: 'resources/base/media/ic_user3.png',
    content: '花腔女高音 | 夜莺般的华彩炫技',
    comment: '个性签名',
    song: SONGS_COMMENT[2]
  }
];

//排行榜
export const PAIHANG_LIST: PaihangListType[] = [
  {
    img: 'resources/base/media/ic_img1.jpg',
    title1: 'DIGIX',
    title2: '热歌榜',
    count: '105746万',
    song1: '歌曲1',
    author1: '歌手1',
    song2: '歌曲2',
    author2: '歌手2',
    song3: '歌曲3',
    author3: '歌手3'
  },
  {
    img: 'resources/base/media/ic_img2.jpg',
    title1: 'DIGIX',
    title2: '热歌榜',
    count: '105746万',
    song1: '歌曲1',
    author1: '歌手1',
    song2: '歌曲2',
    author2: '歌手2',
    song3: '歌曲3',
    author3: '歌手3'
  },
  {
    img: 'resources/base/media/ic_img3.jpg',
    title1: 'DIGIX',
    title2: '热歌榜',
    count: '105746万',
    song1: '歌曲1',
    author1: '歌手1',
    song2: '歌曲2',
    author2: '歌手2',
    song3: '歌曲3',
    author3: '歌手3'
  },
  {
    img: 'resources/base/media/ic_img4.jpg',
    title1: 'DIGIX',
    title2: '热歌榜',
    count: '105746万',
    song1: '歌曲1',
    author1: '歌手1',
    song2: '歌曲2',
    author2: '歌手2',
    song3: '歌曲3',
    author3: '歌手3'
  },
  {
    img: 'resources/base/media/ic_img5.jpg',
    title1: 'DIGIX',
    title2: '热歌榜',
    count: '105746万',
    song1: '歌曲1',
    author1: '歌手1',
    song2: '歌曲2',
    author2: '歌手2',
    song3: '歌曲3',
    author3: '歌手3'
  }
];
