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

import { fileIo } from '@kit.CoreFileKit';
import { request } from '@kit.BasicServicesKit';

export default class ImageSave {
  static async saveFile(uiContext: UIContext, context: Context, fileName: string, url: string,
    callBack: (path: string) => void): Promise<void> {
    try {
      if (!context) {
        throw new Error('Failed to get context');
      }

      let appContext = context.getApplicationContext();
      if (!appContext) {
        throw new Error('Failed to get application context');
      }

      let tempDir = context.getApplicationContext().tempDir;
      if (fileIo.listFileSync(tempDir).includes(fileName)) {
        callBack(tempDir + '/' + fileName);
        return;
      }
      let task = await request.downloadFile(context, {
        filePath: tempDir + '/' + fileName, url: url
      });
      task.on('complete', () => {
        let newPath = tempDir + '/' + fileName;
        callBack(newPath);
      });
      task.on('fail', () => {
        uiContext.showAlertDialog({
          message: '下载失败'
        });
      });
    } catch (e) {
      uiContext.showAlertDialog({
        message: e.message
      });
    }
  }
};