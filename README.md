#happimetrics

A tool to track user-definable metrics against happiness data.

## Technologies used

- Ruby on Rails
- Highcharts (+ LazyHighCharts gem for rails integration)
- Twitter bootstrap, albeit quite heavily styled
- jQuery & LESS
- Served on Heroku
- Developed using Sublime Text 2

## Areas of intended / potential improvement

- Tie in some relevant data from APIs, etc. e.g. Wolfram Alpha data - weather, traffic, etc was intended but unfortunately too long-winded for the time scale)
- Add local Eventbrite archived events for a given month / day - unfortunately not available through the Eventbrite API
- Add archive twitter feeds for a given day from NixonMcInnes - maybe this would be provide some context?
- It's pretty nippy, but cache more if there is going to be increased data / calculation
- Write some tests