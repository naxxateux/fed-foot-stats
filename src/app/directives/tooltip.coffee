monthNames = [
  'января'
  'февраля'
  'марта'
  'апреля'
  'мая'
  'июня'
  'июля'
  'августа'
  'сентября'
  'октября'
  'ноября'
  'декабря'
]

app.directive 'tooltip', ($rootScope) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/tooltip.html'
  link: ($scope) ->
    $scope.tooltipData = {}

    $rootScope.$on 'matchMouseEnter', (event, data) ->
      $scope.isShown = true
      $scope.tooltipData.date = data.matchData.date.date() + ' ' + monthNames[data.matchData.date.month()]
      $scope.tooltipData.whites = data.matchData.result.whites
      $scope.tooltipData.reds = data.matchData.result.reds
      if isNaN($scope.tooltipData.whites) and isNaN($scope.tooltipData.reds)
        if data.matchData.date.isAfter()
          $scope.tooltipData.noMatch = 'Матч еще не проводился'
        else if moment().isSame(data.matchData.date, 'day')
          $scope.tooltipData.noMatch = 'Матч сегодня'
        else
          $scope.tooltipData.noMatch = 'Результат матча аннулирован'
      else
        $scope.tooltipData.noMatch = ''
      $scope.tooltipData.playerResult = if data.result is 'в' then 'выиграл'
      else if data.result is 'н' then 'сыграл вничью'
      else if data.result is 'п' then 'проиграл'
      else 'не играл'
      $scope.tooltipData.playerVotes = (if data.votes then data.votes + ' ' else '') +
      (if not data.votes then '' else if data.votes > 4 then 'очков' else if data.votes is 1 then 'очко' else 'очка')
      $scope.tooltipData.playerActions = (if data.goals then data.goals + ' ' else '') +
      (if not data.goals then '' else if data.goals is 1 then 'гол' else if data.goals < 5 then 'гола' else 'голов') +
      (if data.assists then (if data.goals then ', ' else '') + data.assists + ' ' else '') +
      (if not data.assists then '' else if data.assists is 1 then 'передача' else if data.assists < 5 then 'передачи' else 'пердач') +
      (if data.ownGoals then (if data.assists or data.goals then ', ' else '') + data.ownGoals + ' ' else '') +
      (if not data.ownGoals then '' else if data.ownGoals is 1 then 'автогол' else if data.ownGoals < 5 then 'автогола' else 'автоголов')
      return

    $rootScope.$on 'matchMouseMove', (event, coordinates) ->
      $scope.coordinates = coordinates
      return

    $rootScope.$on 'matchMouseLeave', ->
      $scope.isShown = false
      return

    return
