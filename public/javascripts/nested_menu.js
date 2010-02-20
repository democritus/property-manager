function toggleNestedMenu(id) {
  layer = $(id);
  if (layer.style.display == 'none') {
    Effect.Appear(id, { duration: 0.25, delay: 0 });
  } else {
    Effect.Fade(id, { duration: 0.25, delay: 0 });
  }
}
function displayNestedMenu(id) {
  Effect.Appear(id, { duration: 0.25, delay: 0 });
}
function undisplayNestedMenu(id) {
  Effect.Fade(id, { duration: 0.25, delay: 0 });
}
function undisplayOtherMenus(exceptionId) {
  var menus = $$('div.nested_menu .submenu');
  for (i=0; i<menus.length; i++) {
    if (menus[i].id != exceptionId) {
      menus[i].style.display = 'none';
    }
  }
}
function toggleAndUndisplayOthers(id) {
  undisplayOtherMenus(id);
  toggleNestedMenu(id);
}
