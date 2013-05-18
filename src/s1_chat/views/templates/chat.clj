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
	        "<li {{action \"open\" target=\"chan\"}}><img src=\"img/dummy.png\" /> {{chan.name}} </li>"
	      "{{/each}}"
      ]
      
      [:div {:style "bottom: 20px; position: absolute; width: 194px"} 
       [:h5 "{{Chat.username}}"]
       [:ul
        [:li.editProfile [:i.icon-edit] "edit profile"]
	      [:li.editProfile [:i.icon-edit] "log out"]
       ]
       ]
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
    
      [:ul
	        "<li {{action \"partChan\" target=\"view\"}}> <i class=\"icon-reply\"></i>Leave Channel</li>"
      ]
      

      [:h5 "participants"]
      [:ul
       "{{#each user in view.chan.usernames}}<li>{{view view.UserItemView userBinding=\"user\"}}</li>{{/each}}"
     ]
))


(defn hbs-home-template []
  (html
    [:section.anonym 
	   
	    [:button.btn.btn-large.btn-primary {:type "button"} [:i.icon-tasks] "create anonymous channel" ]
    ]
    [:section.public
     "home sweet home"
    ]
))

