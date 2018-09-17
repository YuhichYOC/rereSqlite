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
import flash.data.SQLSchemaResult;
import flash.data.SQLStatement;
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class Accessor {
    public function Accessor() {
        m_alreadyBegun = false;
    }

    private var m_connection:SQLConnection;

    private var m_datasource:String;

    public function set datasource(value:String):void {
        m_datasource = value;
    }

    private var m_password:String;

    public function set password(value:String):void {
        m_password = value;
    }

    private var m_schemaResult:SQLSchemaResult;

    public function get schemaResult():SQLSchemaResult {
        return m_schemaResult;
    }

    private var m_queryString:String;

    public function get queryString():String {
        return m_queryString;
    }

    public function set queryString(value:String):void {
        m_queryString = value;
    }

    private var m_statement:SQLStatement;

    public function get statement():SQLStatement {
        return m_statement;
    }

    private var m_alreadyBegun:Boolean;

    public function get alreadyBegun():Boolean {
        return m_alreadyBegun;
    }

    public function open():void {
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
        m_statement = new SQLStatement();
        m_statement.sqlConnection = m_connection;
        return m_statement;
    }

    public function executeStatement():void {
        m_statement.text = m_queryString;
        m_statement.execute();
    }

    public function queryIsSelect():Boolean {
        if ((new RegExp("^ *SELECT")).test(m_queryString)) {
            return true;
        }
        return false;
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
}
}
