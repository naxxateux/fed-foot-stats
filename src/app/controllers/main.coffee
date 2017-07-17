app.controller 'MainController', ($scope, $timeout, $window, Tabletop, Tools) ->
  $scope.model =
    season: Tools.getUrlParameter 'season'

  # Parse season data
  parseSeasonData = (seasonSheet) ->
    matchDays = _.values seasonSheet['elements'][0]
      .filter (d) -> d isnt 'Тур' and d isnt 'x'
      .map (d) -> parseInt d
    matchDates = _.values seasonSheet['elements'][1]
      .filter (d) -> d isnt 'Дата' and d isnt 'x'
      .map (d) -> moment d, 'DD.MM.YYYY'
    matchResults = _.values seasonSheet['elements'][2]
      .filter (d) -> d isnt 'Счёт (б:к)' and d.indexOf(':') isnt -1 or !d
      .map (d) ->
        result = d.split ':'
        whites: parseInt result[0]
        reds: parseInt result[1]
    matches = []

    for day, i in matchDays
      date = matchDates[i]
      result = matchResults[i]

      matches.push {day, date, result}

    players = []

    for i in [3...seasonSheet['elements'].length]
      playerData = _.values seasonSheet['elements'][i]
      fullName = playerData[0]

      break unless fullName

      splittedFullName = fullName.split(' ')
      firstName = splittedFullName[0]
      lastName = splittedFullName[1]
      matchStats = []

      for day, i in matchDays
        matchData = matches[i]
        index = i * 3 + 1
        result = playerData[index]
        result = undefined if result is 'x'
        goals = Tools.preventNaN parseInt playerData[index + 1]
        ownGoals = Tools.countCharOccurancies playerData[index + 1], 'а'
        assists = Tools.preventNaN parseInt playerData[index + 2]

        matchStats.push {day, result, goals, ownGoals, assists, matchData}

      overallStats = {}
      overallStats.games = matchStats
        .filter (match) -> match.result
        .length
      overallStats.won = matchStats
        .filter (match) -> match.result is 'в'
        .length
      overallStats.drawn = matchStats
        .filter (match) -> match.result is 'н'
        .length
      overallStats.lost = matchStats
        .filter (match) -> match.result is 'п'
        .length
      overallStats.points = overallStats.won * 3 + overallStats.drawn * 1
      overallStats.goals = _.sum matchStats.map (match) -> match.goals
      overallStats.ownGoals = _.sum matchStats.map (match) -> match.ownGoals
      overallStats.assists = _.sum matchStats.map (match) -> match.assists
      overallStats.ga = overallStats.goals + overallStats.assists
      overallStats.pm = _.sum matchStats.map (match) ->
        d = Math.abs match.matchData.result.whites - match.matchData.result.reds
        if match.result is 'в' then d else if match.result is 'п' then -d else 0
      overallStats.ppg = overallStats.points / overallStats.games
      overallStats.wp = overallStats.won * 100 / overallStats.games

      players.push {fullName, firstName, lastName, overallStats, matchStats}

    {matches, players}

  # Load spreadsheet and parse seasons data
  Tabletop.then (ttdata) ->
    spreadsheet = ttdata[0]
    $scope.seasons = _.keys spreadsheet
    $scope.model.season = Tools.last($scope.seasons) unless $scope.model.season
    $scope.data = {}

    for season in $scope.seasons
      $scope.data[season] = parseSeasonData spreadsheet[season]

    $scope.isInitialized = true

    $timeout ->
      $scope.$broadcast 'seasonIsChanged', $scope.data[$scope.model.season]
      $('.loading-cover').fadeOut()
    , 500
    return

  # Change season
  $scope.$watch 'model.season', ->
    return unless $scope.model.season

    Tools.setUrlParameter 'season', $scope.model.season
    $window.document.title = 'Статистика Федеративного чемпионата ' + $scope.model.season

    if $scope.data
      $scope.$broadcast 'seasonIsChanged', $scope.data[$scope.model.season]
    return

  return
