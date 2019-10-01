
function reset_app() {
  open_box("upload_box");
}

Shiny.addCustomMessageHandler("enable_next", function(x) {
  
  $("#" + x).prop('disabled', false);
  
});

function open_box(box_id, close_others = true) {
  
  $(".box").each(function(index) {
    if($(this).find('.box-body').attr('id') === box_id) {
      if($(this).hasClass("collapsed-box")) {
        $(this).find('[data-widget=collapse]').click();
      }
    } else if(close_others === true) {
      if($(this).hasClass("collapsed-box") === false) {
        $(this).find('[data-widget=collapse]').click();
      }
    }
  });
  
}

$(document).ready(function() {
  
  $("#introModal").modal("show");

});

function start_tutorial() {
  
  $("#introModal").modal("hide");
  introJs()
    .onbeforechange(runBeforeChangeFunctions)
    .onchange(runChangeFunctions)
    .onafterchange(runAfterChangeFunctions)
    .start();
    
 
}

function runBeforeChangeFunctions(el) {
  runIntroFunctions(el, "before");
}

function runChangeFunctions(el) {
  runIntroFunctions(el, "change");
}

function runAfterChangeFunctions(el) {
  runIntroFunctions(el, "after");
}

function runIntroFunctions(targetElement, when) {
  let step = "step_" + $(targetElement).data('step');
  if(Object.keys(step_functions).indexOf(step) > -1) {
    let sf = step_functions[step];
    if(Object.keys(sf).indexOf(when) > -1) {
      sf[when](targetElement);
    }
  }
  
}

var step_functions = {
  "step_3": {
    before: function(el) {
      alert("Hello");
    },
    change: function() {
      alert("World");
    },
    after: function(el) {
      let grp = $("#source_file").closest(".input-group");
      grp.find("input[type='text']").val("gtt.csv");
      $("#source_file_progress").css("visibility", "visible");
      $("#source_file_progress").find("div").css("width", "100%");
      $("#file_next").attr('disabled', false);
      Shiny.setInputValue('tutorial_load_data', true);
    }
  },
  "step_4": {
    before: function(el) {
      open_box("typing_box");
    }
  }
};