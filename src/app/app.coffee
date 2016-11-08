appDependencies = [
  'ngRoute'
  'once'
]

app = angular
  .module 'app', appDependencies
  .config [
    '$routeProvider', '$locationProvider'
    ($routeProvider, $locationProvider) ->
      $routeProvider
      .when '/table',
        controller: 'TableController as table'
        templateUrl: 'pages/table.html'
      .otherwise redirectTo: '/table'

      $locationProvider.html5Mode true
      return
  ]
