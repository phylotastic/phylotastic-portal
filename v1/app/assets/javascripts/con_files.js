function drag_and_drop() {
  var dropZoneId = "drop-zone";
  var buttonId = "clickHere";
  var mouseOverClass = "mouse-over";

  var dropZone = $("#" + dropZoneId);
  var ooleft = dropZone.offset().left;
  var ooright = dropZone.outerWidth() + ooleft;
  var ootop = dropZone.offset().top;
  var oobottom = dropZone.outerHeight() + ootop;
  var inputFile = dropZone.find("input");
  document.getElementById(dropZoneId).addEventListener("dragover", function (e) {
    e.preventDefault();
    e.stopPropagation();
    dropZone.addClass(mouseOverClass);
    var x = e.pageX;
    var y = e.pageY;
    
    if (!(x < ooleft || x > ooright || y < ootop || y > oobottom)) {
      inputFile.offset({ top: y - 15, left: x - 100 });
    } else {
      inputFile.offset({ top: y, left: x });
    }

  }, true);

  if (buttonId != "") {
    var clickZone = $("#" + buttonId);

    var oleft = clickZone.offset().left;
    var oright = clickZone.outerWidth() + oleft;
    var otop = clickZone.offset().top;
    var obottom = clickZone.outerHeight() + otop;

    $("#" + buttonId).mousemove(function (e) {
        var x = e.pageX;
        var y = e.pageY;
        if (!(x < oleft || x > oright || y < otop || y > obottom)) {
          inputFile.offset({ top: y - 15, left: x - 160 });
        } else {
          inputFile.offset({ top: y, left: x });
        }
    });
  }

  document.getElementById(dropZoneId).addEventListener("drop", function (e) {
    $("#" + dropZoneId).removeClass(mouseOverClass);
    $("#chosen_file").text(e.dataTransfer.files[0].name + " is selected");
  }, true);
  
  inputFile.change(function(e){
    fileName = $(this).val().split('/').pop().split('\\').pop();
    $("#chosen_file").text(fileName + " is selected");
  });
}