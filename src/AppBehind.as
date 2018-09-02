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
import infrastructure.QueryChunk;

public class AppBehind {
    private var m_filePath:String;
    private var m_password:String;
    private var m_message:String;
    private var m_queryChunk:QueryChunk;
    private var m_filePathDelegate:Function;
    private var m_messageDelegate:Function;

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

    public function get message():String {
        return m_message;
    }

    public function set message(value:String):void {
        m_message = value;
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

    public function AppBehind() {
        m_filePath = "";
        m_password = "";
        m_message = "";
        m_queryChunk = new QueryChunk();
        m_filePathDelegate = blankFunction;
        m_messageDelegate = blankFunction;
    }

    private function blankFunction():void {
    }

    private function showQCError(arg:String):void {
        m_message = arg;
        m_messageDelegate();
    }
}
}
