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
      overallStats = []

      for day, i in matchDays
        matchData = matches[i]

        break unless matchData.date.isBefore()

        index = i * (if +seasonSheet.name >= 2018 then 4 else 3) + 1
        result = playerData[index]
        result = undefined if result is 'x'
        goals = Tools.preventNaN parseInt playerData[index + 1]
        ownGoals = Tools.countCharOccurancies playerData[index + 1], 'а'
        assists = Tools.preventNaN parseInt playerData[index + 2]
        votes = if +seasonSheet.name >= 2018 then Tools.preventNaN(parseFloat(playerData[index + 3])) else undefined

        matchStats.push {day, result, goals, ownGoals, assists, votes, matchData}

      for i in [0, 1]
        overallStats[i] = {}
        currentMatchStats = _.dropRight matchStats, i
        overallStats[i].games = currentMatchStats
          .filter (match) -> match.result
          .length
        overallStats[i].won = currentMatchStats
          .filter (match) -> match.result is 'в'
          .length
        overallStats[i].drawn = currentMatchStats
          .filter (match) -> match.result is 'н'
          .length
        overallStats[i].lost = currentMatchStats
          .filter (match) -> match.result is 'п'
          .length
        overallStats[i].points = overallStats[i].won * 3 + overallStats[i].drawn * 1
        overallStats[i].goals = _.sum currentMatchStats.map (match) -> match.goals
        overallStats[i].ownGoals = _.sum currentMatchStats.map (match) -> match.ownGoals
        overallStats[i].assists = _.sum currentMatchStats.map (match) -> match.assists
        overallStats[i].votes = _.sum currentMatchStats.map (match) -> match.votes
        overallStats[i].ga = overallStats[i].goals + overallStats[i].assists
        overallStats[i].pm = _.sum currentMatchStats.map (match) ->
          d = Math.abs match.matchData.result.whites - match.matchData.result.reds
          if match.result is 'в' then d else if match.result is 'п' then -d else 0
        overallStats[i].ppg = overallStats[i].points / overallStats[i].games
        overallStats[i].wp = overallStats[i].won * 100 / overallStats[i].games

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
