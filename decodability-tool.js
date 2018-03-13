
function myFunction() {

  var text;
  var maxLevel;

  text = document.getElementById("textarea").value;
  if (text === "")
  {
    return;
  }

  maxLevel = document.querySelector('input[name="maxLevel"]:checked').value;
  

  var colorForEachLevel = [
  "#DDDDDD",
  "#666666",
  "#555555",
  "#444444",
  "#333333",
  "#222222",
  "#111111",
  "#000000",
  "#000000",
  "#000000",
  "#000000"
  ];

  var sizeForEachLevel = [
  1,
  1.1,
  1.2,
  1.3,
  1.4,
  1.5,
  1.6,
  1.7,
  1.8,
  1.9,
  2.0
  ];



  var tokens = splitText( text );
  var styledText = "";

  //styledText += "<pre>";

  for (var i = 0; i < tokens.length; i++){
    var token = tokens[ i ];

    var nonLetter = /[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]/;

    if( nonLetter.test( token ) ){

     styledText += token;

    } else {

      var styledToken = "";
      var level = com_goojaji_levels[ token.toUpperCase() ];

      if ( level ){

        var levelDiff = level - maxLevel;
        if ( levelDiff < 0 ){
          levelDiff = 0;
        }

        //styledToken = '<span style="level-' + levelDiff + '">' + token + '</span>';

        var color = colorForEachLevel[ levelDiff ];
        if (! color ){
          color = '#FFFFFF';
        }

        var size = sizeForEachLevel[ levelDiff ];
        if (! size ){
          size = 1;
        }
        

        styledToken = '<span style="color: ' + color + '; font-size: ' + size + 'em; ">' + token + '</span>';
        

      } else {
            
        styledToken = '<span style="color: #000000; font-style: italic; ">' + token + '</span>';

      }


      styledText += styledToken;

    }






  }

  //styledText += "</pre>";



  var demoDiv = document.getElementById("demo")
  if (demoDiv ){
    demoDiv.innerHTML = styledText;
  } else {
    console.log("can't find demo div");
  }




}


function splitText( text ){

  var nonLetter = /[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]/;
  var tokens = [];
  var currentToken = "";

  for (var i =0; i < text.length ; i++){
    
     var thisLetter = text[i];
     //console.log(thisLetter);
     //console.log( nonLetter.test( thisLetter ) );

    if ( nonLetter.test( thisLetter )){

      if ( currentToken === "" ){
        currentToken = thisLetter;
      } else {
        if ( nonLetter.test( currentToken )){
          currentToken += thisLetter;
        } else {

          tokens.push( currentToken );
          currentToken = thisLetter;

        }
      }
    } else {
      if ( currentToken === "" ){
        currentToken = thisLetter;
      } else {
        if ( nonLetter.test( currentToken )){
          tokens.push( currentToken );
          currentToken = thisLetter;
        } else {
          currentToken += thisLetter;
        }
      }
    }
  }
  if ( currentToken != "" ){
      tokens.push( currentToken );
    }
  return tokens;
}