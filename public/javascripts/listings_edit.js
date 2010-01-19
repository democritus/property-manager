function startHidden()
{
  $$('.category_list_item').each(
    function(e)
    {
      e.style.display = 'none'
    }
  )
  $$('.feature_list_item').each(
    function(e)
    {
      e.style.display = 'none'
    }
  )
  $$('.style_list_item').each(
    function(e)
    {
      e.style.display = 'none'
    }
  )
}

function screenMultipleCheckbox(itemClass, values, checkedValues)
{
  $$('.' + itemClass).each(
    function(e)
    {
      var kid = e.childNodes[0]
      if (values.any(function(n){return n == kid.value;}))
      {
        kid.disabled = false
        kid.parentNode.style.display = 'block'
        if (checkedValues.any(function(n){return n == kid.value;}))
        {
          kid.checked = true
        }
        else
        {
          kid.checked = false
        }
      }
      else
      {
        kid.disabled = true
        kid.parentNode.style.display = 'none'
      }
    }
  )
}

function showSelect(className, listing_type_id, selected)
{
  if (listing_type_id == null)
  {
    layer = className
  }
  else
  {
    if (listing_type_id == 1)
    {
      prefix = 'sale_'
    }
    else
    {
      prefix = 'rent_'
    }
    layer = prefix + className
  }  
  $$('.' + className).each(
    function(e)
    {
      var papa = e.parentNode
      if (papa.id == layer)
      {
        e.disabled = false
        e.value = selected
      }
      else
      {
        e.disabled = true
        e.value = ''
      }
    }
  )
}

function checkedValues(itemClass)
{
  var checked = new Array()
  i = 0
  $$('.' + itemClass).each(
    function(e)
    {
      var kid = e.childNodes[0]
      if (kid.checked)
      {
        checked[i] = kid.value
        i++
      }
    }
  )
  return checked
}

