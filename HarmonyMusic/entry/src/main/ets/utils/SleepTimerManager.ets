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

import AVPlayerManager from './AVPlayerManager';

export interface SleepTimerOptions {
  duration: number; // 定时时长（分钟）
  type: 'time' | 'finish'; // 定时类型：固定时间或播完当前
}

export default class SleepTimerManager {
  private static timerId: number = -1;
  private static remainingTime: number = 0; // 剩余时间（秒）
  private static isTimerActive: boolean = false;
  private static onTickCallback: ((remaining: number) => void) | null = null;
  private static onEndCallback: (() => void) | null = null;
  
  // 设置定时器
  static setTimer(options: SleepTimerOptions): void {
    // 先清除之前的定时器
    SleepTimerManager.clearTimer();
    
    if (options.type === 'finish') {
      // 播完当前歌曲后停止
      SleepTimerManager.isTimerActive = true;
      SleepTimerManager.remainingTime = 0;
      
      // 监听播放状态，当歌曲播放完毕时停止
      SleepTimerManager.timerId = setInterval(() => {
        if (!AVPlayerManager.playState.isPlaying) {
          SleepTimerManager.triggerTimerEnd();
        }
      }, 1000);
    } else {
      // 固定时间后停止
      SleepTimerManager.isTimerActive = true;
      SleepTimerManager.remainingTime = options.duration * 60; // 转换为秒
      
      SleepTimerManager.timerId = setInterval(() => {
        SleepTimerManager.remainingTime--;
        
        // 回调剩余时间
        if (SleepTimerManager.onTickCallback) {
          SleepTimerManager.onTickCallback(SleepTimerManager.remainingTime);
        }
        
        // 时间到，停止播放
        if (SleepTimerManager.remainingTime <= 0) {
          SleepTimerManager.triggerTimerEnd();
        }
      }, 1000);
    }
  }
  
  // 清除定时器
  static clearTimer(): void {
    if (SleepTimerManager.timerId !== -1) {
      clearInterval(SleepTimerManager.timerId);
      SleepTimerManager.timerId = -1;
    }
    SleepTimerManager.isTimerActive = false;
    SleepTimerManager.remainingTime = 0;
  }
  
  // 触发定时器结束
  private static triggerTimerEnd(): void {
    SleepTimerManager.clearTimer();
    
    // 停止播放
    AVPlayerManager.pause();
    
    // 回调结束事件
    if (SleepTimerManager.onEndCallback) {
      SleepTimerManager.onEndCallback();
    }
  }
  
  // 设置时间回调
  static onTick(callback: (remaining: number) => void): void {
    SleepTimerManager.onTickCallback = callback;
  }
  
  // 设置结束回调
  static onEnd(callback: () => void): void {
    SleepTimerManager.onEndCallback = callback;
  }
  
  // 获取剩余时间
  static getRemainingTime(): number {
    return SleepTimerManager.remainingTime;
  }
  
  // 获取定时器是否激活
  static isTimerRunning(): boolean {
    return SleepTimerManager.isTimerActive;
  }
  
  // 格式化剩余时间显示
  static formatTime(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    
    if (hours > 0) {
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    }
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
}
