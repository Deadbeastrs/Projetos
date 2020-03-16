function transform() {
  document.getElementById("original").innerHTML = "<img src="+localStorage.getItem("path")+">"

}
transform();

$(function() {
      $("#sep").click( function()
           {
             var request = $.ajax({'url': '/sepFunc?path=' + localStorage.getItem("path")});
             request.done(function(response)
             {
               var path = response
               document.getElementById("trans").innerHTML = "<img src="+path+">"
             });
             request.fail(function(jqXHR, textStatus)
             {
               alert('Request failed: ' + textStatus);
             });
           }
      );
});
$(function() {
      $("#grey").click( function()
           {
             var request = $.ajax({'url': '/greyFunc?path=' + localStorage.getItem("path")});
             request.done(function(response)
             {
               var path = response
               document.getElementById("trans").innerHTML = "<img src="+path+">"
             });
             request.fail(function(jqXHR, textStatus)
             {
               alert('Request failed: ' + textStatus);
             });
           }
      );
});
