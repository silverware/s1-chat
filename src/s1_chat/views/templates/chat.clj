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
       "{{#if Chat.isAuthenticated}}"
	       [:h5 "{{Chat.ticket.username}}"]
	       [:ul
	        [:li.editProfile {:nav-id "profile-edit"} [:i.icon-edit] "edit profile"]
		      [:li.loginLink [:i.icon-edit] "log out"]
	      ]
       "{{else}}"
	       [:ul
	         [:li.loginLink [:i.icon-edit] "log in"]
	         [:li.registerLink [:i.icon-edit] "register"]
	       ]
       "{{/if}}"
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
     [:input#message.span10 {:type "text" :placeholder "Message" :autocomplete "off"}]
    ]
))

(defn hbs-chan-users-template []
  (html
    
      [:ul
	        "<li {{action \"partChan\" target=\"view\"}}> <i class=\"icon-reply\"></i>Leave Channel</li>"
      ]
      

      [:h5 "participants"]
      [:ul
       "{{#each user in view.chan.usernames}}"
         [:li "{{view view.UserItemView userBinding=\"user\"}}" ]
       "{{/each}}"
     ]
))


(defn hbs-home-template []
  (html
    [:section.anonym 
	   
	    [:button.btn.btn-large.btn-primary {:type "button"} [:i.icon-tasks] "create anonymous channel" ]
    ]
    [:section.public
    
     (for [chan-name (filter #(not (:anonymous? (:attr-map (@chat/chans %)))) (keys @chat/chans))]
                 [:div.join-chan chan-name])
    ]
))


(defn hbs-login-template []
  (html
    [:ul {:class "nav nav-tabs"} 
     [:li {:class "active"} [:a {:href "#guest-login-pane" :data-toggle "tab"} "Guest"]]
     [:li [:a {:href "#login-pane" :data-toggle "tab"} "Login"]]]

    [:div {:class "tab-content"}
    [:div {:class "tab-pane active" :id "guest-login-pane"}
    (common/horizontal-form-to [:post "/login" {:id "guest-login-form"}] 
                             (common/bootstrap-text-field :username "username" {:placeholder "Guest"})
                             (common/bootstrap-submit "Submit"))]

    [:div {:class "tab-pane" :id "login-pane"}
    (common/horizontal-form-to [:post "/login" {:id "login-form"}] 
                             (common/bootstrap-text-field :username "username" {:placeholder "name@example.com"})
                             (common/bootstrap-text-field :password "Password")
                             (common/bootstrap-submit "Submit"))]]))

(defn hbs-register-template []
  (html 
    (common/horizontal-form-to [:post ""]
                               (common/bootstrap-text-field :email "E-Mail" {:placeholder "name@example.com"})
                               (common/bootstrap-text-field :username "Username")
                               (common/bootstrap-password-field :password1 "password")
                               (common/bootstrap-password-field :password2 "password (repeat)")
                               (common/bootstrap-submit "Submit"))))
