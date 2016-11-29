app.directive 'header', ($document, $timeout, Tools) ->
  restrict: 'E'
  replace: true
  templateUrl: 'directives/header.html'
  scope:
    seasons: '='
    season: '='
  link: ($scope, $element, $attrs) ->
    $scope.isSelectorPrepared = false
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

    $scope.selectItem = (item) ->
      $scope.season = item
      $scope.isDropdownShown = false
      Tools.setUrlParameter 'season', item
      return

    $timeout ->
      $toggle = $element.find '.header__selector-toggle'
      $dropdown = $element.find '.header__selector-dropdown'
      toggleWidth = $toggle[0].getBoundingClientRect().width
      dropdownWidth = $dropdown[0].getBoundingClientRect().width

      $toggle.innerWidth Math.max toggleWidth, dropdownWidth
      $dropdown.innerWidth Math.max toggleWidth, dropdownWidth
      $scope.isSelectorPrepared = true
      return

    return
