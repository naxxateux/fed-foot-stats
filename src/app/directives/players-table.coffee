app.directive 'playersTable', ($window, $document) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/players-table.html'
  scope:
    data: '='
    season: '='
  link: ($scope) ->
    # Sticky header
    $stickyHeaderContainer = $('.sticky-header-container')
    initialPos = $stickyHeaderContainer.offset().top

    angular
      .element $window
      .bind 'scroll', ->
        $scope.headerIsStuck = $document.scrollTop() > initialPos
        $scope.$apply()
        return

    return
