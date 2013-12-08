define [
  'config'
  'angular'
  'lodash'
  'collection/menu-items-collection'
], (cfg, A, _, menuItemsCollection) ->
  menuFactory = ($location, $q, $rootScope) ->
    handleFactorySetSuccess = (dfd, collection) ->
      factory.collection = collection

      dfd.resolve()

    $rootScope.$on '$locationChangeSuccess', (event) ->
      factory.setSelectedItemByHref $location.path()

    factory =
      selectedItem: null

      set: (serviceDfd, data) ->
        dfd = $q.defer()
        success = A.bind @, handleFactorySetSuccess, serviceDfd

        menuItemsCollection dfd, data
        dfd.promise.then success

      get: () ->
        factory.collection

      setSelectedItemByHref: (href) ->
        if factory.selectedItem
          factory.selectedItem.selected = false

        A.forEach factory.collection, (vo) ->
          if href is '/'
            vo.selected = vo.href is href
          else
            vo.selected = !!~vo.href.indexOf href

  menuFactory.$inject = [
    '$location'
    '$q'
    '$rootScope'
  ]

  app = A.module cfg.ngApp
  app.factory 'menuFactory', menuFactory