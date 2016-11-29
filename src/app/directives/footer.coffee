app.directive 'footer', ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/footer.html'
  link: ($scope) ->
    startYear = 2016

    $scope.getCopyrightYears = ->
      endYear = moment().year()

      if endYear is startYear
        startYear
      else
        [startYear, endYear].join '…'

    likely.initiate()

    return
