jQuery ->
  _.templateSettings = {
      interpolate : /\{\{([\s\S]+?)\}\}/g
  }

  class AppView extends Backbone.View
    el: '#wrap'
    initialize: (options) ->
      @collection.bind 'reset', @render, @
      @subviews = [
        new MenuView      collection: @collection
        new VinylsView    collection: @collection
        new NewVinylView  collection: @collection
        ]
    render: ->
      $(@el).empty()
      $(@el).append subview.render().el for subview in @subviews
      @

  class MenuView extends Backbone.View
    tagName: 'header'
    template: _.template($('#menu-template').html())
    render: ->
      $(@el).html @template()
      @

  class VinylsView extends Backbone.View
    tagName: 'table'
    initialize: (options) ->
      @collection.bind 'add', @render, @
    render: ->
      $(@el).empty()
      $(@el).append @collection.models.length
      for vinyl in @collection.models
        console.log "vinyl",vinyl
        vinylView = new VinylView model: vinyl
        $(@el).append vinylView.render().el
      @

  class VinylView extends Backbone.View
    tagName: 'tr'
    template: _.template($('#vinyl-template').html())
    render: ->
      $(@el).html @template(@model.toJSON())
      @

  class NewVinylView extends Backbone.View
    id: 'new-vinyl'
    tagName: 'form'
    template: _.template($('#new-vinyl-template').html())
    events:
      'keypress .vinyl-form': 'saveOnEnter'
    render: ->
      $(@el).html @template()
      @
    saveOnEnter: (event) ->
      if (event.keyCode is 13) # ENTER
        event.preventDefault()
        newAttributes = {
          title: $('#new-vinyl').find('[name="title"]').val()
          year: $('#new-vinyl').find('[name="year"]').val()
          size: $('#new-vinyl').find('[name="size"]').val()
          records: $('#new-vinyl').find('[name="records"]').val()
        }
        if @collection.create(newAttributes)
          @emptyFields()
          @focus()
    emptyFields: ->
      $('#new-vinyl .vinyl-form').val('')
      $('#new-vinyl').find('[name="size"]').val("12")
      $('#new-vinyl').find('[name="records"]').val("1")
      true
    focus: ->
      $('#new-vinyl').find('[name="title"]').focus()
      

  @app = window.app ? {}
  @app.AppView = AppView
  