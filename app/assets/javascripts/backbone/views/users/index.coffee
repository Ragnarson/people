class Hrguru.Views.UsersIndex extends Backbone.View
  el: '#main-container'

  initialize: ->
    @createCollections()
    @createViews()
    @$('.icons a').tooltip()
    @$('.info').tooltip()

  createCollections: ->
    @users = new Hrguru.Collections.Users(gon.users)
    @projects = new Hrguru.Collections.Projects(gon.projects)
    @roles = new Hrguru.Collections.Roles(gon.roles)

  createViews: ->
    @filters_view = new Hrguru.Views.UsersFilters(@projects, @roles, @users, gon.locations)
    @filters_view.render()
    @tbodyView = new Hrguru.Views.UsersCollectionView(@users)
    @tbodyView.render()
