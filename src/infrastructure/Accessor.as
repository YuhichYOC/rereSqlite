/*
*
* Accessor.as
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
import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLSchemaResult;
import flash.data.SQLStatement;
import flash.events.Event;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class Accessor {
    public function Accessor() {
        m_alreadyBegun = false;
    }

    private var m_connection:SQLConnection;
    private var m_statements:Vector.<SQLStatement>;

    private var m_datasource:String;
    private var m_password:String;
    private var m_schemaResult:SQLSchemaResult;
    private var m_queryString:String;
    private var m_mutableDataDelegate:Function;
    private var m_showStatusDelegate:Function;
    private var m_messageDelegate:Function;
    private var m_alreadyBegun:Boolean;

    public function set datasource(value:String):void {
        m_datasource = value;
    }

    public function set password(value:String):void {
        m_password = value;
    }

    public function get schemaResult():SQLSchemaResult {
        return m_schemaResult;
    }

    public function get queryString():String {
        return m_queryString;
    }

    public function set queryString(value:String):void {
        m_queryString = value;
    }

    public function set mutableDataDelegate(value:Function):void {
        m_mutableDataDelegate = value;
    }

    public function set showStatusDelegate(value:Function):void {
        m_showStatusDelegate = value;
    }

    public function set messageDelegate(value:Function):void {
        m_messageDelegate = value;
    }

    public function get alreadyBegun():Boolean {
        return m_alreadyBegun;
    }

    public function open():void {
        m_statements = new Vector.<SQLStatement>();
        if ("" != m_password) {
            openWithPassword();
        } else {
            m_connection = new SQLConnection();
            m_connection.addEventListener(Event.OPEN, onOpened);
            m_connection.open((new File()).resolvePath(m_datasource))
        }
    }

    public function close():void {
        if (null != m_connection && m_connection.connected) {
            m_connection.close();
        }
    }

    public function begin():void {
        m_connection.begin();
        m_alreadyBegun = true;
    }

    public function commit():void {
        m_connection.commit();
        m_alreadyBegun = false;
    }

    public function rollback():void {
        m_connection.rollback();
        m_alreadyBegun = false;
    }

    public function createStatement():SQLStatement {
        var add:SQLStatement = new SQLStatement();
        add.sqlConnection = m_connection;
        add.text = m_queryString;
        add.addEventListener(SQLEvent.RESULT, onSuccess);
        add.addEventListener(SQLErrorEvent.ERROR, onFailure);
        m_statements.push(add);
        return add;
    }

    public function executeStatements():void {
        for each (var item:SQLStatement in m_statements) {
            item.execute();
        }
    }

    private function openWithPassword():void {
        m_connection = new SQLConnection();
        m_connection.addEventListener(Event.OPEN, onOpened);
        var ba:ByteArray = new ByteArray();
        ba.writeUTFBytes(m_password);
        m_connection.open((new File()).resolvePath(m_datasource), "create", false, 1024, ba);
    }

    private function onOpened(e:Event):void {
        m_connection.removeEventListener(Event.OPEN, onOpened);
        m_connection.loadSchema();
        m_schemaResult = m_connection.getSchemaResult();
    }

    private function onSuccess(e:SQLEvent):void {
        var target:SQLStatement = e.target as SQLStatement;
        if (null != target) {
            target.removeEventListener(SQLEvent.RESULT, onSuccess);
            target.removeEventListener(SQLErrorEvent.ERROR, onFailure);
            var result:SQLResult = target.getResult();
            if (null != result && null != result.data && 0 < result.data.length) {
                if (null != m_mutableDataDelegate) {
                    m_mutableDataDelegate(result);
                }
            }
        }
        if (null != m_showStatusDelegate) {
            m_showStatusDelegate("success");
        }
    }

    private function onFailure(e:SQLErrorEvent):void {
        var target:SQLStatement = e.target as SQLStatement;
        var m:Vector.<String> = new Vector.<String>();
        if (null != target) {
            target.removeEventListener(SQLEvent.RESULT, onSuccess);
            target.removeEventListener(SQLErrorEvent.ERROR, onFailure);
            m.push(target.text);
            m.push(e.error.toString());
            m.push(e.error.details);
        }
        if (null != m_showStatusDelegate) {
            m_showStatusDelegate("failure");
        }
        if (null != m_messageDelegate) {
            m_messageDelegate(m);
        }
    }
}
}
