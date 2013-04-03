(ns s1-chat.views.templates.chat
  (:require [s1-chat.views.common :as common])
  (:use [hiccup.page :only [include-css include-js html5]]
        [hiccup.core]))

(defn hbs-chat-template []
  (html 
    [:div.tabbable
     [:ul.nav.nav-tabs
      "{{#each chan in chat.chans}}"
      [:li [:a {:data-toggle "tab" :href "#tab{{unbound chan.id}}"} "{{chan.name}}" [:i.icon-remove]]]
      " {{/each}} "
      ]
     ]
    [:div.tab-content
     "{{#each chan in chat.chans}}"
        [:div.tab-pane {:id "tab{{unbound chan.id}}"} "{{view ChanView chanBinding=\"chan\"}}"]
      "{{/each}} "
    ]
    [:div#queryStreams
      "{{#each stream in chat.queryStreams}}{{view QueryStreamView streamBinding=\"stream\"}}{{/each}}"]
))

(defn hbs-query-stream-template []
  (html
    [:div.header "{{stream.username}}" [:i.icon-remove.close]]
    [:div.messages
    "{{#each msg in stream.messages}}{{msg.name}}: {{msg.text}}<br />{{/each}}"]
    [:form.queryForm
     [:input.query {:type "text" :placeholder "Message"}]
    ]
))

(defn hbs-chan-template []
  (html
    [:div.container-fluid
     [:div.row-fluid
      [:div.span10
       [:div.messages
        "{{#each msg in chan.messages}}{{msg.name}}: {{msg.text}} <br /> {{/each}}"
        ]
       ]
      [:div.span2
       "{{#each user in chan.usernames}}{{view UserItemView userBinding=\"user\"}}{{/each}}"]
      ]
     ]
    
    [:div.container-fluid.messageFormContainer
     [:div.row-fluid
    [:form#messageForm
     [:input#message.span10 {:type "text" :placeholder "Message"}]
    ]
    ]
     ]
))


