app.directive 'header', ($document, $timeout) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/header.html'
  scope:
    seasons: '='
    season: '='
    adjustWidth: '='
  link: ($scope, $element, $attrs) ->
    $scope.isSelectorPrepared = not $scope.adjustWidth
    $scope.isDropdownShown = false

    clickHandler = (event) ->
      return if $element.find(event.target).length

      $scope.isDropdownShown = false
      $scope.$apply()
      $document.unbind 'click', clickHandler
      return

    $scope.toggleDropdown = ->
      $scope.isDropdownShown = not $scope.isDropdownShown

      if $scope.isDropdownShown
        $document.bind 'click', clickHandler
      else
        $document.unbind 'click', clickHandler
      return

    $scope.isItemSelected = (item) ->
      item is $scope.season

    $scope.selectItem = (item) ->
      $scope.season = item
      $scope.isDropdownShown = false
      return

    if $scope.adjustWidth
      $timeout ->
        $toggle = $element.find '.header__selector-toggle'
        $dropdown = $element.find '.header__selector-dropdown'
        toggleWidth = $toggle[0].getBoundingClientRect().width
        dropdownWidth = $dropdown[0].getBoundingClientRect().width
        dropdownHasScroll = $dropdown[0].scrollHeight > $dropdown[0].offsetHeight

        dropdownWidth += 16 if dropdownHasScroll

        $toggle.innerWidth Math.max toggleWidth, dropdownWidth
        $dropdown.width Math.max toggleWidth, dropdownWidth
        $scope.isSelectorPrepared = true
        return

    return
