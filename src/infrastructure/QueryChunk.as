/*
*
* QueryChunk.as
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
import flash.data.SQLResult;
import flash.data.SQLTableSchema;

import infrastructure.grid.MutableData;
import infrastructure.list.Row;
import infrastructure.list.TableListData;

import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

public class QueryChunk {
    public function QueryChunk() {
        m_password = "";
        m_a = new Accessor();
        m_tables = new TableListData();
        m_qList = new Vector.<String>();
        m_count = 0;
    }

    private var m_a:Accessor;
    private var m_tables:TableListData;
    private var m_qList:Vector.<String>;
    private var m_count:int;
    private var m_filePath:String;

    public function set filePath(value:String):void {
        m_filePath = value;
        if (m_filePath) {
            if ("" != m_filePath) {
                m_a.datasource = m_filePath;
                m_a.password = m_password;
                loadTables();
            }
        }
    }

    private var m_password:String;

    public function set password(value:String):void {
        m_password = value;
    }

    private var m_queryString:String;

    public function get queryString():String {
        return m_queryString;
    }

    public function set queryString(value:String):void {
        m_queryString = value;
        var t:String = "";
        var r:RegExp = new RegExp("^.+$", "gm");
        var m:Object = r.exec(value);
        while (null != m) {
            t += " " + StringUtil.trim(m[0]);
            m = r.exec(value);
        }
        m_qList = new Vector.<String>();
        t.split(";").forEach(function (arg:String, idx:int, org:Array):void {
            if ("" != StringUtil.trim(arg)) {
                m_qList.push(arg);
            }
        });
        m_queryStringDelegate();
    }

    private var m_mutableData:MutableData;

    public function get mutableData():MutableData {
        return m_mutableData;
    }

    private var m_queryStringDelegate:Function;

    public function set queryStringDelegate(arg:Function):void {
        m_queryStringDelegate = arg;
    }

    private var m_schemaResultDelegate:Function;

    public function set schemaResultDelegate(arg:Function):void {
        m_schemaResultDelegate = arg;
    }

    private var m_mutableDataDelegate:Function;

    public function set mutableDataDelegate(arg:Function):void {
        m_mutableDataDelegate = arg;
    }

    private var m_showStatusDelegate:Function;

    public function set showStatusDelegate(arg:Function):void {
        m_showStatusDelegate = arg;
    }

    private var m_messageDelegate:Function;

    public function set messageDelegate(arg:Function):void {
        m_messageDelegate = arg;
    }

    public function get alreadyBegun():Boolean {
        return m_a.alreadyBegun;
    }

    public function loadTables():void {
        try {
            m_tables = new TableListData();
            m_a.open();
            m_a.close();
            for (var i:int = 0; i < m_a.schemaResult.tables.length; ++i) {
                m_tables.addRow(m_a.schemaResult.tables[i].name, i);
            }
            m_schemaResultDelegate();
            m_showStatusDelegate("success");
        } catch (err:Error) {
            var m:Vector.<String> = new Vector.<String>();
            m.push(err.message);
            m.push(err.getStackTrace());
            m_showStatusDelegate("failure");
            m_messageDelegate(m);
        }
    }

    public function tables(arg:String):TableListData {
        if ("" == arg) {
            return m_tables;
        }
        var ret:TableListData = new TableListData();
        for each (var r:Row in m_tables.rows) {
            if (r.name.indexOf(arg) >= 0) {
                ret.addRow(r.name, r.value);
            }
        }
        return ret;
    }

    public function begin():void {
        m_a.datasource = m_filePath;
        m_a.password = m_password;
        m_a.open();
        m_a.begin();
    }

    public function commit():void {
        m_a.commit();
        m_a.close();
    }

    public function rollback():void {
        m_a.rollback();
        m_a.close();
    }

    public function execute(name:String):void {
        var openNew:Boolean = !m_a.alreadyBegun;
        if (openNew) {
            open();
        }
        try {
            m_a.mutableDataDelegate = function (arg:SQLResult):void {
                fill(arg);
                if ("" != name) {
                    m_mutableDataDelegate(name);
                } else {
                    m_mutableDataDelegate("Query " + (m_count++).toString());
                }
            };
            m_a.showStatusDelegate = m_showStatusDelegate;
            m_a.messageDelegate = m_messageDelegate;
            for each (var qs:String in m_qList) {
                m_a.queryString = qs;
                m_a.createStatement();
            }
            m_a.executeStatements();
            m_showStatusDelegate("success");
        } catch (err:Error) {
            var m:Vector.<String> = new Vector.<String>();
            m.push(err.message);
            m.push(err.getStackTrace());
            m_showStatusDelegate("failure");
            m_messageDelegate(m);
        }
        if (openNew) {
            close();
        }
    }

    public function queryWholeTable(i:int):void {
        var tInfo:SQLTableSchema = m_a.schemaResult.tables[i];
        var q:String = "SELECT ";
        for (var j:int = 0; j < tInfo.columns.length; ++j) {
            q += tInfo.columns[j].name;
            if (tInfo.columns.length > j + 1) {
                q += ", ";
            } else {
                q += " ";
            }
        }
        q += "FROM " + tInfo.name;
        queryString = q;
        execute(tInfo.name);
    }

    private function open():void {
        m_a.datasource = m_filePath;
        m_a.password = m_password;
        m_a.open();
    }

    private function close():void {
        m_a.close();
    }

    private function fill(arg:SQLResult):void {
        m_mutableData = new MutableData();
        if (arg && arg.data && 0 < arg.data.length && arg.data[0]) {
            describe(arg.data[0]);
            for (var r:int = 0; r < arg.data.length; ++r) {
                for each (var f:String in mutableData.fields()) {
                    var v:String = arg.data[r][f];
                    mutableData.addValue(v);
                }
                mutableData.addRow();
            }
        }
    }

    private function describe(arg:Object):void {
        var info:Object = ObjectUtil.getClassInfo(arg);
        for (var i:int = 0; i < info.properties.length; ++i) {
            m_mutableData.addField(info.properties[i].localName);
        }
    }
}
}
