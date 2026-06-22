# HarmonyMusic - HarmonyOS 音乐播放应用

## 项目简介

HarmonyMusic 是一款基于 HarmonyOS 开发的音乐播放应用，提供丰富的音乐播放功能，支持本地音乐导入、歌词显示、搜索、睡眠定时等特色功能。

## 新增功能说明

本次更新新增了以下实用功能，参考了市面热门音乐应用的设计理念：

### 1. 📂 本地歌曲导入

**功能描述：**
- 支持从本地文件系统导入音乐文件
- 支持多种音频格式：MP3、WAV、FLAC、AAC、M4A
- 一次最多可选择 10 个文件批量导入
- 自动解析文件名作为歌曲名称
- 支持删除已导入的本地音乐

**使用方式：**
1. 进入"我的"页面
2. 点击"本地音乐"菜单项
3. 点击右上角"导入音乐"按钮
4. 在文件选择器中选择音乐文件

**技术实现：**
- 使用 `picker.DocumentViewPicker` 进行文件选择
- 使用 `preferences` 存储本地音乐列表
- 支持文件 URI 直接播放

**相关文件：**
- `entry/src/main/ets/utils/LocalMusicManager.ets` - 本地音乐管理工具类
- `entry/src/main/ets/pages/localmusic/LocalMusic.ets` - 本地音乐页面

---

### 2. 🎵 歌词显示

**功能描述：**
- 在播放页面显示歌词
- 支持歌词自动滚动
- 当前播放行高亮显示
- 支持 LRC 格式歌词解析
- 无歌词时显示模拟歌词动画

**使用方式：**
- 进入播放页面后自动显示歌词
- 歌词会随着播放进度自动滚动和高亮

**技术实现：**
- 支持 `[mm:ss.xx]` 格式的时间标签解析
- 根据播放时间计算当前歌词行
- 使用 `List` 组件实现平滑滚动效果
- 字体大小和颜色渐变动画

**相关文件：**
- `entry/src/main/ets/utils/LyricParser.ets` - 歌词解析工具类
- `entry/src/main/ets/components/LyricView.ets` - 歌词显示组件

---

### 3. 🔍 搜索功能

**功能描述：**
- 支持搜索歌曲名称和歌手名称
- 显示热门搜索标签
- 记录搜索历史（最多 10 条）
- 支持清空搜索历史
- 搜索结果可直接播放

**使用方式：**
1. 在首页点击搜索图标
2. 输入关键词搜索
3. 或点击热门标签快速搜索
4. 点击搜索结果即可播放

**技术实现：**
- 实时过滤匹配歌曲
- 支持模糊搜索（不区分大小写）
- 搜索范围包含所有歌曲和本地音乐
- 搜索历史本地缓存

**相关文件：**
- `entry/src/main/ets/pages/search/Search.ets` - 搜索页面

---

### 4. ⏰ 睡眠定时器

**功能描述：**
- 设置定时停止播放，适合睡前使用
- 支持多种定时时长：15、30、45、60、90、120 分钟
- 支持"播完当前歌曲后停止"选项
- 实时显示剩余时间倒计时
- 可随时取消定时

**使用方式：**
1. 在播放页面点击定时器图标
2. 选择定时时长或选择"播完当前后停止"
3. 点击确认设置
4. 时间到达后自动停止播放

**技术实现：**
- 使用 `setInterval` 实现倒计时
- 支持两种定时模式：固定时长和播完当前
- 时间格式化显示（HH:MM:SS）
- 定时结束自动暂停播放

**相关文件：**
- `entry/src/main/ets/utils/SleepTimerManager.ets` - 睡眠定时器管理类
- `entry/src/main/ets/components/SleepTimerSheet.ets` - 定时器设置组件

---

### 5. 📜 播放历史记录

**功能描述：**
- 自动记录播放过的歌曲
- 显示播放时间（刚刚、几分钟前、几小时前、几天前）
- 支持删除单条历史记录
- 支持清空所有历史记录
- 最多保存 50 条历史记录

**使用方式：**
1. 进入"我的"页面
2. 点击"播放历史"菜单项
3. 查看最近播放的歌曲
4. 点击歌曲可重新播放

**技术实现：**
- 每次播放自动添加到历史记录
- 使用 `preferences` 本地存储
- 智能时间格式化显示
- 自动去重，最新播放排在最前

**相关文件：**
- `entry/src/main/ets/utils/PlayHistoryManager.ets` - 播放历史管理类
- `entry/src/main/ets/pages/history/PlayHistory.ets` - 播放历史页面

---

### 6. ❤️ 歌曲收藏

**功能描述：**
- 收藏喜欢的歌曲
- 一键切换收藏状态
- 收藏列表独立管理
- 支持清空所有收藏
- 收藏按钮可视化反馈

**使用方式：**
- 在歌曲列表或播放页面点击收藏按钮
- 收藏的歌曲会显示红心图标
- 在"我的"页面查看收藏列表

**技术实现：**
- 使用 `preferences` 存储收藏列表
- 提供统一的收藏按钮组件
- 支持异步状态检查
- 收藏状态实时更新

**相关文件：**
- `entry/src/main/ets/utils/FavoriteManager.ets` - 收藏管理类
- `entry/src/main/ets/components/FavoriteButton.ets` - 收藏按钮组件

---

## 项目结构

```
entry/src/main/ets/
├── components/          # 公共组件
│   ├── FavoriteButton.ets    # 收藏按钮组件
│   ├── LyricView.ets         # 歌词显示组件
│   ├── PlayerNav.ets         # 播放导航组件
│   └── SleepTimerSheet.ets   # 睡眠定时器组件
├── constants/           # 常量定义
│   ├── EventConstants.ets
│   ├── Index.ets
│   └── MusicConstants.ets
├── models/              # 数据模型
│   ├── Index.ets
│   ├── Music.ets
│   └── PlayState.ets
├── pages/               # 页面
│   ├── find/            # 发现页
│   ├── history/         # 播放历史页 [新增]
│   ├── like/            # 喜欢页
│   ├── localmusic/      # 本地音乐页 [新增]
│   ├── mine/            # 我的页
│   ├── moment/          # 动态页
│   ├── play/            # 播放页
│   ├── recommend/       # 推荐页
│   └── search/          # 搜索页 [新增]
├── utils/               # 工具类
│   ├── AVPlayerManager.ets      # 音频播放管理
│   ├── AVSessionManager.ets     # 音频会话管理
│   ├── FavoriteManager.ets      # 收藏管理 [新增]
│   ├── LocalMusicManager.ets    # 本地音乐管理 [新增]
│   ├── LyricParser.ets          # 歌词解析 [新增]
│   ├── PlayHistoryManager.ets   # 播放历史管理 [新增]
│   ├── SleepTimerManager.ets    # 睡眠定时器 [新增]
│   └── SongManager.ets          # 歌曲管理
└── entryability/        # 应用入口
```

## 权限说明

应用需要以下权限：

| 权限名称 | 用途说明 |
|---------|---------|
| `ohos.permission.KEEP_BACKGROUND_RUNNING` | 允许后台播放音乐 |
| `ohos.permission.MICROPHONE` | 用于录音功能 |
| `ohos.permission.READ_MEDIA` | 读取本地音乐文件 [新增] |
| `ohos.permission.WRITE_MEDIA` | 保存音乐相关数据 [新增] |

## 技术特点

### 1. 状态管理
- 使用 `@State`、`@Prop`、`@Link` 等装饰器管理组件状态
- 采用单向数据流设计，状态变化可预测

### 2. 数据持久化
- 使用 `preferences` API 进行本地数据存储
- 支持收藏列表、播放历史、本地音乐列表等数据持久化

### 3. 文件操作
- 使用 `picker.DocumentViewPicker` 进行文件选择
- 支持多种音频格式的识别和播放

### 4. UI 设计
- 遵循 HarmonyOS 设计规范
- 使用圆角卡片、渐变色等现代 UI 元素
- 支持深色模式（可扩展）

### 5. 性能优化
- 使用 `LazyForEach` 进行列表懒加载
- 图片加载使用 `objectFit` 优化显示效果
- 歌词滚动使用 `ScrollAlign.CENTER` 平滑滚动

## 使用说明

### 环境要求
- DevEco Studio 3.1 或更高版本
- HarmonyOS SDK API 9 或更高版本
- Node.js 14.x 或更高版本

### 安装步骤
1. 克隆项目到本地
2. 使用 DevEco Studio 打开项目
3. 同步项目依赖
4. 连接 HarmonyOS 设备或启动模拟器
5. 点击运行按钮安装应用

### 开发建议
- 新增页面需要在 `main_pages.json` 中注册路由
- 新增权限需要在 `module.json5` 中声明
- 工具类建议放在 `utils` 目录下
- 组件建议放在 `components` 目录下

## 后续规划

以下功能计划在后续版本中实现：

- [ ] 在线音乐搜索和播放
- [ ] 歌单创建和管理
- [ ] 音乐均衡器设置
- [ ] 歌词在线获取
- [ ] 音乐分享功能
- [ ] 桌面小组件
- [ ] 播放统计和可视化
- [ ] 云端同步收藏和历史

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 许可证

本项目采用 Apache License 2.0 许可证。

---

**开发者：** HarmonyMusic Team  
**最后更新：** 2025年  
**版本：** v2.0.0
