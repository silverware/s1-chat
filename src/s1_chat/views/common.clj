(ns s1-chat.views.common
  (:require [noir.validation :as vali])
  (:use [hiccup.page :only [include-js include-css html5]]
        [hiccup.core :only [html]]
        hiccup.form
        hiccup.def))

(defn controls [& content] (html [:div.controls 
                                        content]))

(defelem control-group [field-name label-text & content]
              [:div {:class (if (vali/errors? field-name) "control-group error" "control-group")} 
               [:label.control-label {:for field-name} label-text]
               (controls (list content (when (vali/errors? field-name) [:span.help-inline (first (vali/get-errors field-name))])))])

(defn- get-attr-map [args] 
  (if (map? (first args))
    (first args)
    {}))

(defn- get-value [args]
  (if (not (map? (first args)))
    (first args)
    (second args)))

(defelem horizontal-form-to 
         ([[method action attr-map] & body]
          (form-to (into {:class "form-horizontal"} attr-map) [method action] body)))

(defelem bootstrap-password-field 
         ([field-name label-text & args] 
          (control-group field-name label-text (password-field (get-attr-map args) field-name (get-value args)))))

(defelem bootstrap-text-field 
         ([field-name label-text & args] 
          (control-group field-name label-text (text-field (get-attr-map args) field-name (get-value args)))))

(defelem bootstrap-check-box
         ([field-name label-text & args] 
          (control-group field-name label-text (check-box (get-attr-map args) field-name (get-value args)))))


(defelem bootstrap-submit [label] (html [:button {:class "btn btn-primary"} label]))

(defn layout [& content]
            (html5
              [:head
               (include-js "/lib/require.js")
               (include-js "/lib/jquery-1.8.3.min.js")
               (include-js "/lib/handlebars-1.0.rc.3.js")
               (include-js "/lib/ember-1.0.0-rc.3.js")
               (include-js "/lib/jquery.gracefulWebSocket.js")
               (include-js "/lib/jquery.connect.js")
               (include-js "/js/require-config.js")
               (include-js "/lib/jquery.validate.min.js")
               (include-js "/bootstrap/js/bootstrap-tab.js")
               (include-js "/bootstrap/js/bootstrap-tooltip.js")
               (include-js "/bootstrap/js/bootstrap-popover.js")
               [:title "s1-chat"]
               (include-css "/css/normalize.css")
               (include-css "/bootstrap/css/bootstrap.css")
               (include-css "/css/font-awesome.css")
               (include-css "/css/common.css")
;               (include-css "/bootstrap/css/bootstrap-responsive.css")
              ]
              [:body content]
              ))
