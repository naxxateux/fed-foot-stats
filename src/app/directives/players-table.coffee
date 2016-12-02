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

    # Sorting
    $scope.predicate = 'points'
    $scope.reverse = true

    $scope.sortableOnClick = (predicate) ->
      $scope.reverse = if $scope.predicate is predicate then not $scope.reverse else true
      $scope.predicate = predicate
      return

    return
