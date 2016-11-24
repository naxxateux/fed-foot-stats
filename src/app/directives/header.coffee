app.directive 'header', ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/header.html'
  scope:
    seasons: '='
    season: '='
  link: ($scope, $element, $attrs) ->
    return
