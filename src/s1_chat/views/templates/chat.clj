(ns s1-chat.views.templates.chat
  (:require [s1-chat.views.common :as common])
  (:use [hiccup.page :only [include-css include-js html5]]
        [hiccup.core]))

(defn hbs-chat-template []
  (html 
     [:nav.nav-0
      [:ul
	      [:li.homeLink [:i.icon-home] "home"]
      ]
      [:h5 "channels"]
      [:ul
	      "{{#each chan in Chat.chans}}"
	        "<li {{action \"open\" target=\"chan\"}}> {{chan.name}} </li>"
	      "{{/each}}"
      ]
      
      [:div {:style "bottom: 20px; position: absolute"} "{{Chat.username}}"]
      ]
      

    [:div#content]
    [:div#queryStreams
      "{{#each stream in Chat.queryStreams}}{{view view.QueryStreamView streamBinding=\"stream\"}}{{/each}}"]
))

(defn hbs-query-stream-template []
  (html
    [:div.header "{{view.stream.username}}" [:i.icon-remove.close]]
    [:div.messages
    "{{#each msg in view.stream.messages}}{{msg.name}}: {{msg.text}}<br />{{/each}}"]
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
    [:h5 "{{view.chan.name}}"]
    
      [:ul
	        "<li {{action \"partChan\" target=\"view\"}}> <i class=\"icon-reply\"></i>Leave Channel</li>"
      ]
      

      [:h5 "Participants:"]
      [:ul
       "{{#each user in view.chan.usernames}}<li>{{view view.UserItemView userBinding=\"user\"}}</li>{{/each}}"
     ]
))


(defn hbs-home-template []
  (html
    [:section.anonym 
    "home sweet home"
    ]
    [:section.public
    "Public huhu"
    ]
))

