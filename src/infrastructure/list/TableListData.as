/*
*
* TableListData.as
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
import mx.collections.XMLListCollection;

public class TableListData {
    public function TableListData() {
    }

    private var m_rows:Vector.<Row>;

    public function get rows():Vector.<Row> {
        return m_rows;
    }

    public function get rowsToXML():XMLListCollection {
        var x:XML = new XML(rootNode());
        for (var i:int = 0; i < m_rows.length; ++i) {
            var addRow:XML = rowNode(i);
            x.appendChild(addRow);
        }
        var ret:XMLListCollection = new XMLListCollection(x.row);
        return ret;
    }

    public function addRow(name:String, idx:int):void {
        if (!m_rows) {
            m_rows = new Vector.<Row>();
        }
        var add:Row = new Row();
        add.name = name;
        add.value = idx;
        m_rows.push(add);
    }

    public function nameToIndex(arg:String):int {
        for each (var r:Row in m_rows) {
            if (arg == r.name) {
                return r.value;
            }
        }
        return -1;
    }

    private function rootNode():XML {
        var nodeName:String = "root";
        var ret:XML = <{nodeName}></{nodeName}>;
        return ret;
    }

    private function rowNode(r:int):XML {
        var nodeName:String = "row";
        var c1Name:String = "label";
        var c2Name:String = "value";
        var c1Value:String = m_rows[r].name;
        var c2Value:String = m_rows[r].value.toString();
        var ret:XML = <{nodeName}>
            <{c1Name}>{c1Value}</{c1Name}>
            <{c2Name}>{c2Value}</{c2Name}>
        </{nodeName}>;
        return ret;
    }
}
}
