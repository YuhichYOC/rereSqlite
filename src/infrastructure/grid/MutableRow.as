/*
*
* MutableRow.as
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
public class MutableRow {
    private var m_items:Vector.<String>;

    public function get items():Vector.<String> {
        return m_items;
    }

    public function addValue(arg:String):void {
        if (!m_items) {
            m_items = new Vector.<String>();
        }
        m_items.push(arg);
    }
}
}
