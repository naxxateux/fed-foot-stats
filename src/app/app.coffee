appDependencies = [
  'ngRoute'
  'once'
  'times.tabletop'
]

app = angular
  .module 'app', appDependencies
  .config [
    '$routeProvider', '$locationProvider', 'TabletopProvider'
    ($routeProvider, $locationProvider, TabletopProvider) ->
      TabletopProvider.setTabletopOptions
        key: 'https://docs.google.com/spreadsheets/d/1UO4yK0TcEfXTVMM2XqlTQ2tdrpHExDoNJO-k0IuQUWk/pubhtml'

      $routeProvider
        .when '/table',
          controller: 'TableController as table'
          templateUrl: 'pages/table.html'
        .otherwise redirectTo: '/table'

      $locationProvider.html5Mode true
      return
  ]
