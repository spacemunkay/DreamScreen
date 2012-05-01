//MODEL
var Raw = Backbone.Model.extend({});

//COLLECTION
var Raws = Backbone.Collection.extend({
  model: Raw,
  url: 'http://localhost:4567/raw',
});

var rawImages = new Raws;

var RawView = Backbone.View.extend({
  tagName: 'div',

  render: function(){
    console.log("render");
    console.log(rawImages);
    this.collection.each( function(obj){
      console.log("create");
      console.log(obj);
      $(document.createElement("img"))
      .attr({ src: "images/raw/" + obj.get('path')})
      .addClass("raw")
      .appendTo("body")
      .click(function(){
          // Do something
          alert("hey!");
      })
    })
    return this;
  }

});

var rawsView = new RawView({
  collection: rawImages
});

console.log(rawsView.el);

rawImages.fetch({success: function(){rawsView.render();} });
