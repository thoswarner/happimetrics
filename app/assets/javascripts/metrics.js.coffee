# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $("div.details ul.percentage-chart").each ->
    chart = $(this)
    items = $("li", this)
    items.each () ->
      item = $(this)
      percentage = item.attr "data-percentage"
      happiness_value = item.attr "data-happiness-value"
      chart.show()
      item.animate
        width: "#{percentage}%"
      item.addClass happiness_value

  window.bindMetricInputPopovers = ->
    $('a.metric-input').each ->
      link = $(this)
      unless link.hasClass("popover-bound")
        inputHolder = $("##{link.attr("data-input-id")}")
        content = inputHolder.html()
        inputHolder.remove()
        link.popover
          html: true
          placement: 'right'
          content: content
          title: false
          template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><div class="popover-content"><p></p></div></div></div>'
        link.addClass("popover-bound")

  window.bindMetricInputPopovers()
