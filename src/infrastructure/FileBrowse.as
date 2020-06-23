/*
*
* FileBrowse.as
*
* Copyright 2018 Yuichi Yoshii
*     吉井雄一 @ 吉井産業  you.65535.kir@gmail.com
*
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
*
*/

package infrastructure {
import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;

public class FileBrowse {
    public function FileBrowse(arg:AppBehind) {
        m_f = new File();
        m_ab = arg;
    }

    private var m_f:File;
    private var m_ab:AppBehind;

    public function run():void {
        m_f.addEventListener(Event.SELECT, onSelect);
        m_f.addEventListener(Event.CANCEL, onCancel);
        m_f.browseForOpen("title", [new FileFilter("SQLite DB ファイル", "*.db"), new FileFilter("すべてのファイル", "*.*")]);
    }

    public function runForCreate():void {
        m_f.addEventListener(Event.SELECT, onSelect);
        m_f.addEventListener(Event.CANCEL, onCancel);
        m_f.browseForSave("title");
    }

    private function onCancel(e:Event):void {
        try {
            m_f.removeEventListener(Event.SELECT, onSelect);
            m_f.removeEventListener(Event.CANCEL, onCancel);
            m_ab.filePath = "";
        } catch (err:Error) {
            m_ab.ex = err;
        }
    }

    private function onSelect(e:Event):void {
        try {
            m_f.removeEventListener(Event.SELECT, onSelect);
            m_f.removeEventListener(Event.CANCEL, onCancel);
            var ret:File = (e.target as File);
            if (ret != null) {
                m_ab.filePath = ret.nativePath;
            }
        } catch (err:Error) {
            m_ab.ex = err;
        }
    }
}
}
