// main.js
var clip = new ZeroClipboard( document.getElementById("copy-button"), {
  moviePath: "/assets/ensnare/ZeroClipboard.swf"
} );

clip.on( "load", function(client) {
  // alert( "movie is loaded" );

  client.on( "complete", function(client, args) {
    // `this` is the element that was clicked
    this.value = "none";
    document.getElementById("copy-button").innerHTML = 'Copied!';
    setTimeout(function(){ document.getElementById("copy-button").innerHTML = 'Copy to Clipboard!';},3000);
    //alert("Copied text to clipboard: " + args.text );
  } );
} );


