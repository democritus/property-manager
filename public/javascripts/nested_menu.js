function effectArgs(args) {
  if (!args['effect']) {
    args['effect'] = 'fold';
  }
  if (!args['options']) {
    args['options'] = null;
  }
  if (!args['speed']) {
    args['speed'] = null;
  }
  if (!args['callback']) {
    args['callback'] = null;
  }
  return args
}

function showChildren(el, child, args) {
  if (args == null) {
    args = []
  }
  args = effectArgs(args);
  $j(el).children(child).show(
      args['effect'], args['options'], args['speed'], args['callback']);;
}

function hideChildren(el, child, args) {
  if (args == null) {
    args = []
  }
  args = effectArgs(args);
  $j(el).children(child).hide(
      args['effect'], args['options'], args['speed'], args['callback']);;
}

function toggleChildren(el, child, args) {
  if (args == null) {
    args = []
  }
  args = effectArgs(args);
  $j(el).children(child).toggle(
      args['effect'], args['options'], args['speed'], args['callback']);;
}

function toggleChildrenNoBubble(el, child, args) {
  $j(el).children(child).click(function(event){
    event.stopPropagation();
    // do something
  });
  toggleChildren(el, child, args);
}

function hideNephews(el, general_class, hide_class, args) {
  if (args == null) {
    args = []
  }
  args = effectArgs(args);
  $j(general_class).not(el).children(hide_class).hide()
}
