$(document).ready(function()
{
    var request = $.ajax({'url': '/getNames'});
    request.done(function(response)
    {
      var lista = JSON.parse(response)
      var html = ""
        for(i = lista["Nomes"].length - 1; i >=0; i--){

          html = html + "<div class='col-md-4 caixa'> <div class='card'> <div class='card-body'> <h5 class='card-title'>"+lista["Nomes"][i]+"</h5> </div> </div> </div>";
        }
      document.getElementById("colunas").innerHTML = html
      if(html == ""){
        document.getElementById("text").innerHTML = "Não existem objetos na base de dados"
      }
      else{
        document.getElementById("text").innerHTML = "Chegou ao fim! Pareçe que não há mais nomes"
      }
    });
    request.fail(function(jqXHR, textStatus)
    {
      alert('Request failed: ' + textStatus);
    });
});

function sort() {
  // Declare variables
  var input, filter, ul, li, a, i, txtValue;
  input = document.getElementById('myInput');
  filter = input.value.toUpperCase();
  li = document.getElementsByClassName("caixa")

  // Loop through all list items, and hide those who don't match the search query
  for (i = 0; i < li.length; i++) {
    a = li[i].getElementsByTagName("h5")[0];
    txtValue = a.textContent || a.innerText;
    if (txtValue.toUpperCase().indexOf(filter) > -1) {
      li[i].style.display = "";
    } else {
      li[i].style.display = "none";
    }
  }
}

$(document).ready(function()
{
    var request = $.ajax({'url': '/getNames'});
    request.done(function(response)
    {
      var lista = JSON.parse(response)
    });
    request.fail(function(jqXHR, textStatus)
    {
      alert('Request failed: ' + textStatus);
    });
});
