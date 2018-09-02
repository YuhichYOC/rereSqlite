/*
*
* MutableDataGridController.as
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

package infrastructure.grid {
import flash.desktop.Clipboard;
import flash.desktop.ClipboardFormats;

import mx.collections.ArrayList;
import mx.collections.IList;

import spark.components.DataGrid;
import spark.components.gridClasses.GridColumn;

public class MutableDataGridController {
    private var m_g:DataGrid;
    private var m_d:MutableData;

    public function setInstance(arg:DataGrid):void {
        m_g = arg;
    }

    public function MutableDataGridController() {
    }

    public function fill(arg:MutableData):void {
        if (arg.isEmpty) {
            m_g.dataProvider = arg.emptyXML;
        } else {
            createColumns(arg);
            m_g.dataProvider = arg.rowsToXML;
            m_d = arg;
        }
    }

    public function performClip():void {
        if (!m_d.isEmpty) {
            Clipboard.generalClipboard.clear();
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, m_d.toString());
        }
    }

    private function createColumns(arg:MutableData):void {
        var columns:IList = new ArrayList();
        for each (var f:String in arg.fields()) {
            var add:GridColumn = new GridColumn(f);
            add.dataField = f;
            add.width = 120;
            columns.addItem(add);
        }
        m_g.columns = columns;
    }
}
}
