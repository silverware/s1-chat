/*! jquery-serializeForm - Make an object out of form elements - v1.1.1 - 2013-01-21
* https://github.com/danheberden/jquery-serializeForm
* Copyright (c) 2013 Dan Heberden; Licensed MIT */
(function(e){e.fn.serializeForm=function(){if(this.length<1)return!1;var t={},n=t,r=':input[type!="checkbox"][type!="radio"], input:checked',i=function(){var r=this.name.replace(/\[([^\]]+)?\]/g,",$1").split(","),i=r.length-1,s=e(this);if(r[0]){for(var o=0;o<i;o++)n=n[r[o]]=n[r[o]]||(r[o+1]===""?[]:{});n.length!==undefined?n.push(s.val()):n[r[i]]=s.val(),n=t}};return this.filter(r).each(i),this.find(r).each(i),t}})(jQuery);
