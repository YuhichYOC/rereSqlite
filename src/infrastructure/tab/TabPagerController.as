/*
*
* TabPagerController.as
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
import flash.events.MouseEvent;

import mx.core.UIComponent;

import spark.components.Button;
import spark.components.Group;
import spark.components.HGroup;

public class TabPagerController {
    public function TabPagerController() {
        m_idx = 0;
    }

    private var m_bar:HGroup;
    private var m_view:Group;
    private var m_idx:int;

    private var m_pages:Vector.<TabItem>;

    public function setInstance(b:HGroup, v:Group):void {
        m_bar = b;
        m_view = v;
    }

    public function addPage(n:String, c:UIComponent):void {
        if (!m_pages) {
            m_pages = new Vector.<TabItem>();
        }
        var t:String = "t" + m_idx.toString();
        ++m_idx;
        var add:TabItem = new TabItem(n, t, c);
        m_pages.push(add);
        var b:Button = new Button();
        b.label = n;
        b.id = t;
        b.addEventListener(MouseEvent.CLICK, bar_click);
        m_bar.addElement(b);
        m_view.addElement(c);
        changePage(t);
    }

    public function closePage(arg:String):void {
        if (0 == m_pages.length) {
            return;
        }
        var idx:int = 0;
        var new_pages:Vector.<TabItem> = new Vector.<TabItem>();
        for (var i:int = 0; i < m_pages.length; ++i) {
            if (m_pages[i].tag == arg) {
                break;
            }
            ++idx;
            new_pages.push(m_pages[i]);
        }
        for (var j:int = idx + 1; j < m_pages.length; ++j) {
            new_pages.push(m_pages[j]);
        }
        m_bar.removeElementAt(idx);
        m_view.removeElementAt(idx);
        m_pages = new_pages;
    }

    public function currentPageTag():String {
        for each (var item:TabItem in m_pages) {
            if (item.container.visible) {
                return item.tag;
            }
        }
        return "";
    }

    private function changePage(arg:String):void {
        for each (var item:TabItem in m_pages) {
            if (item.tag == arg) {
                item.container.visible = true;
            } else {
                item.container.visible = false;
            }
        }
    }

    private function bar_click(e:MouseEvent):void {
        var t:String = (e.target as Button).id;
        changePage(t);
    }
}
}
