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
            m_windowWidth = x.width.child("*");
            m_windowHeight = x.height.child("*");
            m_preEnterPassword = x.password.child("*");
            m_font = x.font.child("*");
            m_fontSize = parseInt(x.fontSize.child("*"));
            m_newLine = x.newLine.child("*");
        } finally {
            s.close();
        }
        m_filePath = "";
        m_password = "";
        m_message = new Vector.<String>();
        m_queryChunk = new QueryChunk();
        m_filePathDelegate = blankFunction;
        m_messageDelegate = blankFunction;
    }

    private var m_windowWidth:int;
    private var m_windowHeight:int;
    private var m_preEnterPassword:String;
    private var m_font:String;
    private var m_fontSize:int;
    private var m_newLine:String;
    private var m_filePath:String;
    private var m_password:String;
    private var m_message:Vector.<String>;
    private var m_ex:Error;
    private var m_queryChunk:QueryChunk;
    private var m_filePathDelegate:Function;
    private var m_messageDelegate:Function;

    public function get windowWidth():int {
        return m_windowWidth;
    }

    public function get windowHeight():int {
        return m_windowHeight;
    }

    public function get preEnterPassword():String {
        return m_preEnterPassword;
    }

    public function get font():String {
        return m_font;
    }

    public function get fontSize():int {
        return m_fontSize;
    }

    public function get newLine():String {
        return m_newLine;
    }

    public function get filePath():String {
        return m_filePath;
    }

    public function set filePath(value:String):void {
        m_filePath = value;
        m_queryChunk.filePath = m_filePath;
        m_filePathDelegate();
    }

    public function set password(value:String):void {
        m_password = value;
        m_queryChunk.password = m_password;
    }

    public function get message():Vector.<String> {
        return m_message;
    }

    public function set message(value:Vector.<String>):void {
        m_message = value;
        m_messageDelegate();
    }

    public function get ex():Error {
        return m_ex;
    }

    public function set ex(value:Error):void {
        var m:Vector.<String> = new Vector.<String>();
        m.push(value.message);
        m.push(value.getStackTrace());
        m_message = m;
        m_messageDelegate();
    }

    public function get queryChunk():QueryChunk {
        return m_queryChunk;
    }

    public function set filePathDelegate(value:Function):void {
        m_filePathDelegate = value;
    }

    public function set messageDelegate(value:Function):void {
        m_messageDelegate = value;
        m_queryChunk.messageDelegate = showQCError;
    }

    private function blankFunction():void {
    }

    private function showQCError(arg:Vector.<String>):void {
        m_message = arg;
        m_messageDelegate();
    }
}
}
