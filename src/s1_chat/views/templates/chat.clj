(ns s1-chat.views.templates.chat
  (:require [s1-chat.views.common :as common]
            [s1-chat.models.chat :as chat])
  (:use [hiccup.page :only [include-css include-js html5]]
        [hiccup.core]))

(defn hbs-chat-template []
  (html 
     [:nav.nav-0
      [:ul
	      [:li {:nav-id "home"} [:i.icon-home] "home"]
      ]
      [:h5 "channels"]
      [:ul
	      "{{#each chan in Chat.chans}}"
	        "<li {{action \"open\" target=\"chan\"}} nav-id=\"{{unbound chan.name}}\"><img src=\"img/dummy.png\" /> {{chan.name}} </li>"
	      "{{/each}}"
      ]
      
      [:div {:style "bottom: 20px; position: absolute; width: 214px"} 
       [:h5 "{{Chat.username}}"]
       [:ul
        [:li.editProfile {:nav-id "profile-edit"} [:i.icon-edit] "edit profile"]
	      [:li.loginLink [:i.icon-edit] "log out"]
       ]
       ]
      ]
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
        "{{#each msg in view.chan.messages}}{{msg.name}}: {{msg.text}} <br /> {{/each}}"
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
     
     (for [chan-name (keys @chat/chans)]
                 [:div.join-chan chan-name])
    ]
))


(defn hbs-login-template []
  (html
    [:h3 "login"]
    (common/horizontal-form-to [:post "/login"]
                               (common/bootstrap-text-field :username "username" {:placeholder "name@example.com"})
                               (common/bootstrap-text-field :password "Password")
                               (common/bootstrap-submit "Submit"))))
