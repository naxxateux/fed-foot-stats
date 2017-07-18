app.directive 'playersTable', ($window, $document, Tools) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/players-table.html'
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

    $scope.prepareFullName = (fullName) -> Tools.transliterate fullName

    # Expand
    $scope.expandButtonClick = (player) ->
      isExpanded = $scope.expandedPlayers[player.fullName]

      if isExpanded
        _.unset $scope.expandedPlayers, player.fullName
      else
        $scope.expandedPlayers[player.fullName] = player.matchStats
      return

    # Season change
    sortByPoints = (players, stepsBack) ->
      players
        .slice()
        .sort (a, b) ->
          d = a.overallStats[stepsBack].points - b.overallStats[stepsBack].points
          return d if d
          d = a.overallStats[stepsBack].pm - b.overallStats[stepsBack].pm
          return d if d
          d = a.overallStats[stepsBack].games - b.overallStats[stepsBack].games
          return d if d
          return -1 if a.lastName > b.lastName
          return 1 if a.lastName < b.lastName
          return -1 if a.firstName > b.firstName
          return 1 if a.firstName < b.firstName

    $scope.$on 'seasonIsChanged', (event, seasonData) ->
      $scope.expandedPlayers = {}
      $scope.lastMatches = {}
      previousPlayers = sortByPoints seasonData.players, 1
      currentPlayers = sortByPoints seasonData.players, 0

      currentPlayers.forEach (p, i) ->
        previousIndex = _.findIndex previousPlayers, 'fullName': p.fullName
        p.movement = Tools.preventNaN i - previousIndex
        return

      $scope.players = currentPlayers
      $scope.champion = Tools.last($scope.players).fullName

      for player in $scope.players
        pastMatches = player.matchStats.filter (m) -> m.matchData.date.isBefore()
        $scope.lastMatches[player.fullName] = _.takeRight pastMatches, 5
      return

    return
