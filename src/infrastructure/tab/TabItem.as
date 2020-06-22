/*
*
* TabItem.as
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

package infrastructure.tab {
import mx.core.UIComponent;

public class TabItem {
    public function TabItem(n:String, t:String, c:UIComponent) {
        m_name = n;
        m_tag = t;
        m_container = c;
    }

    private var m_name:String;
    private var m_tag:String;
    private var m_container:UIComponent;

    public function get name():String {
        return m_name;
    }

    public function get tag():String {
        return m_tag;
    }

    public function get container():UIComponent {
        return m_container;
    }
}
}
