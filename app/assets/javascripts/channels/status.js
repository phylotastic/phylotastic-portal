var url_string = window.location.href;
index = url_string.search(/\d+$/i);
tree_id = url_string.substring(index);

var nw_parser = function(s) {
  var ancestors = [];
  var tree = {};
  var tokens = s.split(/\s*(;|\(|\)|,|:)\s*/);
  for (var i=0; i<tokens.length; i++) {
    var token = tokens[i];
    switch (token) {
      case '(': // new branchset
        var subtree = {};
        tree.branchset = [subtree];
        ancestors.push(tree);
        tree = subtree;
        break;
      case ',': // another branch
        var subtree = {};
        ancestors[ancestors.length-1].branchset.push(subtree);
        tree = subtree;
        break;
      case ')': // optional name next
        tree = ancestors.pop();
        break;
      case ':': // optional length next
        break;
      default:
        var x = tokens[i-1];
        if (x == ')' || x == '(' || x == ',') {
          tree.name = token;
        } else if (x == ':') {
          tree.length = parseFloat(token);
        }
    }
  }
  return tree;
};

function getLeafNodes(leafNodes, obj){
  if(typeof obj.branchset === "undefined"){
    leafNodes.push(obj);
  } else{
    obj.branchset.forEach(function(child){getLeafNodes(leafNodes,child)});
  }
}

App.messages = App.cable.subscriptions.create (
  { 
    channel: 'StatusChannel', 
    tree_id: tree_id 
  }, 
  {
    received: function(data) {
      parsed = JSON.parse(data);
      leaves = [];
      html = "<input type='radio' name='tree-version' id='" + parsed["method"] + "' value='" + parsed["method"] + "'><a href='/trees/" + tree_id + "?method=" + parsed["method"] + "'></a>"
      if ( this.success_scaled(parsed["response"]) ) {
        nw_in_json = nw_parser( this.extract_newick(parsed["response"]) )
        getLeafNodes( leaves, nw_in_json );
        tips = leaves.length;
        // console.log(nw_in_json);
        // console.log(leaves);
        // console.log(tips);
      } else {
        html = "<div class='alert alert-danger alert-dismissible' role='alert'><i class='fa fa-exclamation-triangle'></i>" + parsed["response"] + "</div>";
      }
      
      // console.log(parsed);
      // console.log(html);
      
      if (parsed["method"] == "scaled_sdm") {
        $("#sdm-scaled-tree .scaled-tree-context-wrapper").html(html);
        $("#sdm-scaled-tree label").text("SDM scaled (" + tips + " tips)");
        
      } else if (parsed["method"] == "scaled_median") {
        $("#median-scaled-tree .scaled-tree-context-wrapper").html(html);
        $("#median-scaled-tree label").text("Median scaled (" + tips + " tips)");
      }
      $( "#" + parsed["method"] ).change(function() {
        window.location.href = $(this).siblings("a").attr("href");
      });
    },

    success_scaled: function(response) {
      try {
        parsed_res = JSON.parse(response);        
      }
      catch {
        // console.log("true");
        return true
      }
      if (parsed_res["message"].indexOf("Datelife Error") == "-1") {
        // console.log("true");
        return true
      }
      // console.log("false");
      return false
    },
    
    extract_newick: function(response) {
      return response["scaled_tree"]
    }
  }
  
);

