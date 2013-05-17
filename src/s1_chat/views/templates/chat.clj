(ns s1-chat.views.templates.chat
  (:require [s1-chat.views.common :as common])
  (:use [hiccup.page :only [include-css include-js html5]]
        [hiccup.core]))

(defn hbs-chat-template []
  (html 
     [:nav.nav-0
      
      [:div "Channels"]
      [:ul
	      "{{#each chan in chat.chans}}"
	        "<li {{action \"open\" target=\"chan\"}}> {{chan.name}} </li>"
	      "{{/each}}"
      ]
      
      [:div {:style "bottom: 20px; position: absolute"} "{{chat.username}}"]
      ]
      

    [:div#content]
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
       [:div.messages
        "{{#each msg in chan.messages}}{{msg.name}}: {{msg.text}} <br /> {{/each}}"
        ]
    
    [:form#messageForm
     [:input#message.span10 {:type "text" :placeholder "Message"}]
    ]
))

(defn hbs-chan-users-template []
  (html
    [:h5 "{{chan.name}}"]
      "Leave Channel"

      [:h5 "Participants:"]
      [:ul
       "{{#each user in chan.usernames}}<li>{{view UserItemView userBinding=\"user\"}}</li>{{/each}}"
     ]
))



