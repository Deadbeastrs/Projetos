$(document).ready(function()
{
    var request = $.ajax({'url': '/detecObjects'});
    request.done(function(response)
    {
      var lista = JSON.parse(response)
      var html = ""
      for (val in lista) {
        for(i = lista[val].length - 1; i >=0; i--){
          html = html + "<div class='col-md-4'> <div class='card'> <img class='card-img-top' src="+ lista[val][i]["path"] +" style= 'height:18rem; width:100%'> <div class='card-body'> <h5 class='card-title'>"+val+"</h5> Confiança : <p>"+lista[val][i]["confidence"]+"</p> </div> </div> </div>";
        }
      }
      document.getElementById("colunas").innerHTML = html
      if(html == ""){
        document.getElementById("text").innerHTML = "Não existem objetos na base de dados"
      }
      else{
        document.getElementById("text").innerHTML = "Chegou ao fim! Pareçe que não há mais imagens"
      }
    });
    request.fail(function(jqXHR, textStatus)
    {
      alert('Request failed: ' + textStatus);
    });
});

$( "form" ).on( "submit", function( event ) {
  event.preventDefault();
  var text = document.getElementById("textbox").value;
  if(text.length != 0){
    var request = $.ajax({'url': '/pesquisa?' + $( this ).serialize()});
  }else{
    var request = $.ajax({'url': '/detecObjects'});
  }
  request.done(function(response)
  {
    var lista = JSON.parse(response)
    var html = ""
    for (val in lista) {
      for(i = lista[val].length - 1; i >=0; i--){
        html = html + "<div class='col-md-4'> <div class='card'> <img class='card-img-top' src="+ lista[val][i]["path"] +" style= 'height:18rem; width:100%'> <div class='card-body'> <h5 class='card-title'>"+val+"</h5> Confidence : <p>"+lista[val][i]["confidence"]+"</p> </div> </div> </div>";
      }
    }
    document.getElementById("colunas").innerHTML = html
    if(html == ""){
      document.getElementById("text").innerHTML = "Não existem objetos na base de dados"
    }
    else{
      document.getElementById("text").innerHTML = "Chegou ao fim! Pareçe que não há mais imagens"
    }
  });
});
