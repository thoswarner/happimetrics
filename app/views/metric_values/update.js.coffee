$("#metric_value_<%= resource.id %>").replaceWith "<%= escape_javascript(render('form', :metric_value => resource)) %>"
window.bindMetricInputPopovers()