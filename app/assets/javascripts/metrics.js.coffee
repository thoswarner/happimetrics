# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $("ul.percentage-chart").each ->
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

  $("a.shrinker").on "click", (e) ->
    e.preventDefault()
    $("div.day").animate
      width: 100
      height: 100
    , 500

