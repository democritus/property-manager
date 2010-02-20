module RoundedBoxHelper
  def rounded_box(content, stem='rounded_box')
    %Q{
      <div class="#{stem}_t">
      <div class="#{stem}_l">
      <div class="#{stem}_r">
      <div class="#{stem}_b">
      <div class="#{stem}_tl">
      <div class="#{stem}_tr">
      <div class="#{stem}_bl">
      <div class="#{stem}_br">
      <div class="#{stem}">
      #{content}
      </div></div></div></div></div></div></div></div></div> 
    }
  end
end
