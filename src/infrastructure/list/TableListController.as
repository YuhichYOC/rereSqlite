/*
*
* TableListController.as
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

package infrastructure.list {
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;

import spark.components.List;

public class TableListController {
    public function TableListController() {
        m_doubleClickedDelegate = blankFunction;
    }

    private var m_l:List;
    private var m_d:TableListData;

    private var m_doubleClickedDelegate:Function;

    public function set doubleClickedDelegate(arg:Function):void {
        m_doubleClickedDelegate = arg;
    }

    public function setInstance(arg:List):void {
        m_l = arg;
    }

    public function fill(arg:TableListData):void {
        m_l.dataProvider = arg.rowsToXML;
        m_d = arg;
    }

    public function performDoubleClick():void {
        var r:Object = m_l.selectedItem;
        if (r) {
            if (r.label) {
                var i:int = m_d.nameToIndex(r.label);
                if (0 <= i) {
                    m_doubleClickedDelegate(i);
                }
            }
        }
    }

    public function performClip():void {
        if (!m_d.isEmpty) {
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, m_d.toString());
        }
    }

    private function blankFunction():void {
    }
}
}
