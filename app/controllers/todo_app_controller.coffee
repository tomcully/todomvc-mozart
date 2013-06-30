class Todo.TodoAppController extends Mozart.Controller

  init: ->
    Todo.TodoItem.loadAllLocalStorage()

    @set 'items', Todo.TodoItem
    @set 'completedfilter', null

    @bind('change:mode',@itemsChanged)
    @setMode('all')

    Todo.TodoItem.bind('change',@fixCounts)
    @fixCounts()

  itemsChanged: =>
    switch @mode
      when 'completed'
        @set 'completedfilter', 'true'
      when 'active'
        @set 'completedfilter', 'false'
      else
        @set 'completedfilter', ''

  setMode: (mode) =>
    @set 'mode', mode

  fixCounts: =>
    @set 'displayItems', Todo.TodoItem.count() != 0
    @set 'itemCount', Todo.TodoItem.findByAttribute('completed', false).length
    @set 'completedItemCount', Todo.TodoItem.count() - @itemCount

  createItem: (name) =>
    Todo.TodoItem.createFromValues({name:name, completed: false})
    @fixCounts()

  clearCompleted: =>
    item.destroy() for item in Todo.TodoItem.all() when item.completed

  toggleAllVisible: =>
    switch @mode
      when 'completed'
        items = Todo.TodoItem.findByAttribute('completed', true)
      when 'active'
        items = Todo.TodoItem.findByAttribute('completed', false)
      else
        items = Todo.TodoItem.all()

    item.set('completed',!item.completed) for item in items
      
