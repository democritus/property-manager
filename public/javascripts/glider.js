var Glider = Class.create({
  initialize: function(layer, imageCount, imageWidth, imagesPerPanel) {
    this.layer = layer;
    this.imageCount = imageCount;
    this.imageWidth = imageWidth;
    this.panelWidth = imageWidth * imagesPerPanel;
    this.panelCount = Math.ceil(imageCount / imagesPerPanel);
    this.panelOffset = 0;
  },
  shiftLeft: function() {
    if (this.panelCount > 1) {
      if (this.panelOffset < (this.panelCount - 1)) {
        new Effect.Move(this.layer, {x: -this.panelWidth, y: 0, mode: 'relative' })
        this.panelOffset = this.panelOffset + 1
      } else {
        new Effect.Move(this.layer, {x: 0, y: 0, mode: 'absolute' })
        this.panelOffset = 0
      }
    }
    //this.debug
  },
  shiftRight: function() {
    if (this.panelCount > 1) {
      if (this.panelOffset > 0) {
        new Effect.Move(this.layer, {
          x: this.panelWidth, y: 0, mode: 'relative' })
        this.panelOffset = this.panelOffset - 1
      } else {
        new Effect.Move(this.layer, {
          x: -this.panelWidth*(this.panelCount-1), y: 0,
          mode: 'absolute' })
        this.panelOffset = this.panelCount-1
      }
    }
    //this.debug()
  },
  debug: function() {
    $(id + '_debug').innerHTML = 'panelOffset = ' + this.panelOffset +
      ', panelCount = ' + this.panelCount +
      ', imageCount = ' + this.imageCount +
      ', imageWidth = ' + this.imageWidth +
      ', panelWidth = ' + this.panelWidth
  }
});

