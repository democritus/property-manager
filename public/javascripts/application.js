// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/**
* Returns the value of the selected radio button in the radio group, null if
* none are selected, and false if the button group doesn't exist
*
* @param {radio Object} or {radio id} el
* OR
* @param {form Object} or {form id} el
* @param {radio group name} radioGroup
*/
function $RF(el, radioGroup) {
    if($(el).type && $(el).type.toLowerCase() == 'radio') {
        var radioGroup = $(el).name;
        var el = $(el).form;
    } else if ($(el).tagName.toLowerCase() != 'form') {
        return false;
    }

    var checked = $(el).getInputs('radio', radioGroup).find(
        function(re) {return re.checked;}
    );
    return (checked) ? $F(checked) : null;
}

// set the radio button with the given value as being checked
// do nothing if there are no radio buttons
// if the given value does not exist, all the radio buttons
// are reset to unchecked
function setCheckedValue(radioObj, newValue) {
	if(!radioObj)
		return;
	var radioLength = radioObj.length;
	if(radioLength == undefined) {
		radioObj.checked = (radioObj.value == newValue.toString());
		return;
	}
	for(var i = 0; i < radioLength; i++) {
		radioObj[i].checked = false;
		if(radioObj[i].value == newValue.toString()) {
			radioObj[i].checked = true;
		}
	}
}

function inputs_to_ids(el) {
  inputs = $(el).select('input:checked');
  ids = new Array();
  for(i=0;i<inputs.length;i++) {
    ids[i] = inputs[i].value;
  }
  ids.flatten;
  return ids;
}
