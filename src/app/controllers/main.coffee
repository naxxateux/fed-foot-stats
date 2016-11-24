app.controller 'MainController', ($scope, $location, Tabletop, Tools) ->
  $scope.season = $location.search()['season']

  # Parse season data
  parseSeasonData = (seasonSheet) ->
    matchDays = _.tail _.keys seasonSheet['column_names']
    matchDays = matchDays.map (d) -> parseInt d
    matchDates = seasonSheet['elements'][0]
    matchResults = seasonSheet['elements'][1]
    matches = []
    players = []

    for day in matchDays
      date = moment matchDates[day], 'DD/MM/YYYY'
      matchResult = matchResults[day].split ':'
      result =
        whites: parseInt matchResult[0]
        reds: parseInt matchResult[1]

      matches.push {day, date, result}

    for i in [2...seasonSheet['elements'].length]
      playerData = seasonSheet['elements'][i]
      fullName = playerData['Тур'].split ' '
      firstName = fullName[1]
      lastName = fullName[0]
      matchStats = []

      for day in matchDays
        playerMatchData = playerData[day].split ','
        result = playerMatchData[0]
        goals = Tools.preventNaN parseInt playerMatchData[1]
        assists = Tools.preventNaN parseInt playerMatchData[2]
        ownGoals = Tools.preventNaN parseInt playerMatchData[3]

        matchStats.push {day, result, goals, assists, ownGoals}

      players.push {firstName, lastName, matchStats}

    {matches, players}

  # Load spreadsheet and parse seasons data
  Tabletop.then (ttdata) ->
    spreadsheet = ttdata[0]
    $scope.seasons = _.keys spreadsheet
    $scope.season = Tools.last($scope.seasons) unless $scope.season
    $scope.data = {}

    for season in $scope.seasons
      $scope.data[season] = parseSeasonData spreadsheet[season]

    $scope.isInitialized = true
    return
  return
