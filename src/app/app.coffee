appDependencies = [
  'ngRoute'
  'times.tabletop'
]

app = angular
  .module 'app', appDependencies
  .config [
    '$routeProvider', '$locationProvider', 'TabletopProvider'
    ($routeProvider, $locationProvider, TabletopProvider) ->
      TabletopProvider.setTabletopOptions
        key: '1UO4yK0TcEfXTVMM2XqlTQ2tdrpHExDoNJO-k0IuQUWk'

      $routeProvider
        .when '/main',
          controller: 'MainController as main'
          templateUrl: 'pages/main.html'
          reloadOnSearch: false
        .otherwise redirectTo: '/main'

      $locationProvider.html5Mode true
      return
  ]
