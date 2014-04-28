angular.module('VidMarketApp').config ($routeProvider,$locationProvider,viewPath)->
  $locationProvider.hashPrefix('!')
  $routeProvider.when "/",
    templateUrl:"#{viewPath}/home.html"
    controller:"HomeCtrl"

  $routeProvider.when "/accounts",
    templateUrl:"#{viewPath}/accounts.html"
    controller:'AccountsCtrl'
  
  $routeProvider.otherwise
    redirectTo:'/'

  return
