/*
*
* AppBehind.as
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

package {
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import infrastructure.QueryChunk;

public class AppBehind extends EventDispatcher {
    public function AppBehind() {
        m_font = "";
        var s:FileStream = new FileStream();
        s.open(File.applicationDirectory.resolvePath("config.xml"), FileMode.READ);
        try {
            var x:XML = new XML(s.readUTFBytes(s.bytesAvailable));
            m_font = x.font.child("*");
            m_fontSize = parseInt(x.fontSize.child("*"));
        } finally {
            s.close();
        }
        m_filePath = "";
        m_password = "";
        m_message = "";
        m_queryChunk = new QueryChunk();
        m_filePathDelegate = blankFunction;
        m_messageDelegate = blankFunction;
    }

    private var m_font:String;

    public function get font():String {
        return m_font;
    }

    private var m_fontSize:int;

    public function get fontSize():int {
        return m_fontSize;
    }

    private var m_filePath:String;

    public function get filePath():String {
        return m_filePath;
    }

    public function set filePath(value:String):void {
        m_filePath = value;
        m_queryChunk.filePath = m_filePath;
        m_filePathDelegate();
    }

    private var m_password:String;

    public function set password(value:String):void {
        m_password = value;
        m_queryChunk.password = m_password;
    }

    private var m_message:String;

    public function get message():String {
        return m_message;
    }

    public function set message(value:String):void {
        m_message = value;
        m_messageDelegate();
    }

    private var m_queryChunk:QueryChunk;

    public function get queryChunk():QueryChunk {
        return m_queryChunk;
    }

    private var m_filePathDelegate:Function;

    public function set filePathDelegate(value:Function):void {
        m_filePathDelegate = value;
    }

    private var m_messageDelegate:Function;

    public function set messageDelegate(value:Function):void {
        m_messageDelegate = value;
        m_queryChunk.messageDelegate = showQCError;
    }

    private function blankFunction():void {
    }

    private function showQCError(arg:String):void {
        m_message = arg;
        m_messageDelegate();
    }
}
}
