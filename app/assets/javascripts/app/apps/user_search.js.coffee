class AID.App.UserSearchView extends Backbone.View
  events:
    'click .search-button': 'onSearchButtonClicked'
    'click .clear': 'onClearButtonClicked'

  onSearchButtonClicked: (e)->
    e.preventDefault()
    console.log 'search'


  onClearButtonClicked: (e)->
    e.preventDefault()
    console.log 'clear'