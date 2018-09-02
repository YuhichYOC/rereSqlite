/*
*
* MutableData.as
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
import mx.collections.XMLListCollection;

public class MutableData {
    private var m_fieldNames:Vector.<String>;
    private var m_row:MutableRow;
    private var m_rows:Vector.<MutableRow>;

    public function get rowsToXML():XMLListCollection {
        var x:XML = new XML(rootNode());
        for (var i:int = 0; i < m_rows.length; ++i) {
            var addRow:XML = rowNode();
            for (var j:int = 0; j < m_fieldNames.length; ++j) {
                addRow.appendChild(columnNode(i, j));
            }
            x.appendChild(addRow);
        }
        var ret:XMLListCollection = new XMLListCollection(x.row);
        return ret;
    }

    public function get emptyXML():XMLListCollection {
        var x:XML = new XML(rootNode());
        var addRow:XML = rowNode();
        x.appendChild(addRow);
        var ret:XMLListCollection = new XMLListCollection(x.row);
        return ret;
    }

    public function get isEmpty():Boolean {
        if (!m_fieldNames) {
            return true;
        }
        if (0 == m_fieldNames.length) {
            return true;
        }
        if (!m_rows) {
            return true;
        }
        if (0 == m_rows.length) {
            return true;
        }
        return false;
    }

    public function MutableData() {
    }

    public function addField(arg:String):void {
        if (!m_fieldNames) {
            m_fieldNames = new Vector.<String>();
        }
        m_fieldNames.push(arg);
    }

    public function fields():Vector.<String> {
        return m_fieldNames;
    }

    public function addValue(arg:String):void {
        if (!m_fieldNames) {
            return;
        }
        if (!m_row) {
            m_row = new MutableRow();
        }
        m_row.addValue(arg);
    }

    public function addRow():void {
        if (!m_fieldNames) {
            return;
        }
        if (m_fieldNames.length > m_row.items.length) {
            return;
        }
        if (!m_row) {
            return;
        }
        if (!m_rows) {
            m_rows = new Vector.<MutableRow>();
        }
        m_rows.push(m_row);
        m_row = new MutableRow();
    }

    public function toString():String {
        var ret:String = "";
        for (var i:int = 0; i < m_fieldNames.length; ++i) {
            ret += m_fieldNames[i];
            if (m_fieldNames.length > i + 1) {
                ret += "\t";
            }
        }
        ret += "\r";
        for (var j:int = 0; j < m_rows.length; ++j) {
            for (var k:int = 0; k < m_rows[j].items.length; ++k) {
                ret += m_rows[j].items[k];
                if (m_rows[j].items.length > k + 1) {
                    ret += "\t";
                }
            }
            ret += "\r";
        }
        return ret;
    }

    private function rootNode():XML {
        var nodeName:String = "root";
        var ret:XML = <{nodeName}></{nodeName}>;
        return ret;
    }

    private function rowNode():XML {
        var nodeName:String = "row";
        var ret:XML = <{nodeName}></{nodeName}>;
        return ret;
    }

    private function columnNode(rowIdx:int, colIdx:int):XML {
        if (m_rows[rowIdx].items.length < colIdx) {
            return null;
        }
        if (m_fieldNames.length < colIdx) {
            return null;
        }
        var nodeName:String = m_fieldNames[colIdx];
        var nodeValue:String = m_rows[rowIdx].items[colIdx];
        var ret:XML = <{nodeName}>{nodeValue}</{nodeName}>;
        return ret;
    }
}
}
