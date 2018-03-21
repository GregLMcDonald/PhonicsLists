// v 1.1
// March 20, 2018

function myFunction() {

  var text;
  var maxLevel;
  var showLevelCheckbox;

  text = document.getElementById("textarea").value;
  if (text === "")
  {
    return;
  }

  maxLevel = document.querySelector('input[name="maxLevel"]:checked').value;
  showLevelCheckbox = document.querySelector('input[name="showLevelValue"]');
  

  var colorForEachLevel = [
  "#444444",
  "#999999",
  "#AAAAAA",
  "#BBBBBB",
  "#CCCCCC",
  "#DDDDDD",
  "#EEEEEE",
  "#FFFFFF",
  "#FFFFFF",
  "#FFFFFF",
  "#FFFFFF"
  ];

 //var colorForEachLevel = [
 // "#DDDDDD",
 // "#666666",
 // "#555555",
 // "#444444",
 // "#333333",
 // "#222222",
 // "#111111",
 // "#000000",
 // "#000000",
 // "#000000",
 // "#000000"
 // ];

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

     var color = colorForEachLevel[ 0 ];

     styledText += '<span style="color: ' + color +';">' + token + '</span>';

    } else {

      var styledToken = "";
      var level = com_goojaji_levels[ token.toUpperCase() ];

      if ( level ){

        var levelDiff = level - maxLevel;
        if ( levelDiff < 0 ){
          levelDiff = 0;
        }

        var color = colorForEachLevel[ levelDiff ];
        if (! color ){
          color = '#FFFFFF';
        }

        var size = sizeForEachLevel[ levelDiff ];
        if (! size ){
          size = 1;
        }

        var style = 'normal';
        if ( level === 11 ){
            // This is a special word like is, was, of, the
            color = '#444444';
            size = 1;
            style = 'italic';
            
        }

        if ( level == 9 ){
             style = 'italic';
        }

        var levelLabel = '';
        if ( showLevelCheckbox.checked ){
          levelLabel = '(' + level + ')';
        }

        styledToken = '<span style="color: ' + color + '; font-size: ' + size + 'em; font-style: ' + style + ';">' + token + levelLabel + '</span>';
        

      } else {

        // Not in word list    
        styledToken = '<span style="color: #FFFF55; font-style: italic; ">' + token + '</span>';

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