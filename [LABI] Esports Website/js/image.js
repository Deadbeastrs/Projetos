$(document).ready(function()
{
    var request = $.ajax({'url': '/detecObjects'});
    request.done(function(response)
    {
      var lista = JSON.parse(response)
      var html = ""
      for (val in lista) {
        for(i = lista[val].length - 1; i >=0; i--){
          html = html + "<div class='col-md-4 tes'> <div class='card'> <img class='card-img-top' src="+ lista[val][i]["path"] +" style= 'height:18rem; width:100%'> <div class='card-body'> <h5 class='card-title'>"+val+"</h5> Confiança : <p>"+lista[val][i]["confidence"] + "</p> <a onclick='tranform("+lista[val][i]["path"]+")'> <button type='button' class='btn btn-success'>Transformar</button></a> </div> </div> </div>";
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

var slider = document.getElementById("myRange");
var output = document.getElementById("value");
output.innerHTML = slider.value;

slider.oninput = function() {
  output.innerHTML = this.value;
  sort(output)
}

function sort(input) {
  // Declare variables
  var filter, ul, li, a, i, txtValue;
  ul = document.getElementById("UL");
  li = document.getElementsByClassName("tes")

  // Loop through all list items, and hide those who don't match the search query
  for (i = 0; i < li.length; i++) {
    a = li[i].getElementsByTagName("p")[0];
    txtValue = a.innerHTML;
    console.log(txtValue)
    if (parseInt(txtValue) > parseInt(input.innerHTML)) {
      li[i].style.display = "";
    } else {
      li[i].style.display = "none";
    }
  }
}

function tranform(path) {
  localStorage.setItem("path", path);
  setTimeout(function(){ window.location.href = 'transforme.html'; }, 1);
}
