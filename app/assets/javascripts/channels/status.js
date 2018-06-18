var url_string = window.location.href;
index = url_string.search(/\d+$/i);
tree_id = url_string.substring(index);

App.messages = App.cable.subscriptions.create ({ channel: 'StatusChannel', 
  tree_id: tree_id }, 
  {
    received: function(data) {
      parsed = JSON.parse(data);

      html = "<input type='radio' name='tree-version' id='" + parsed["method"] + "' value='" + parsed["method"] + "'>"
      if ( !this.success_scaled(parsed["response"]) ) {
        html = "<div class='alert alert-danger alert-dismissible' role='alert'><i class='fa fa-exclamation-triangle'></i>" + parsed["response"] + "</div>"
      }
      
      console.log(parsed);
      console.log(html);
      if (parsed["method"] == "scaled_sdm") {
        return $("#sdm-scaled-tree .scaled-tree-context-wrapper").html(html);
      } else if (parsed["method"] == "scaled_median") {
        return $("#median-scaled-tree .scaled-tree-context-wrapper").html(html);
      }
    },

    success_scaled: function(response) {
      try {
        parsed_res = JSON.parse(response);        
      }
      catch {
        console.log("true");
        return true
      }
      if (parsed_res["message"].indexOf("Datelife Error") == "-1") {
        console.log("true");
        return true
      }
      console.log("false");
      return false
    }
  }
  
);
