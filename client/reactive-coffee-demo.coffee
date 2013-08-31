Meteor.startup ->
  bind = rx.bind
  rxt.importTags()

  # Put some data into tasks
  window.tasks = rx.meteor.find TaskDB, {}, {sort:{created:-1}}
  window.taskLatest = rx.meteor.findOne TaskDB, {}, {sort:{created:-1}}

  incomplete = ->
    (task for task in tasks.all() when not task.isCompleted).length

  $ ->
    document.title = 'Meteor-Reactive-Coffee'
    $('body').prepend(
      a {
        href: "https://github.com/zhouzhuojie/reactive-coffee-demo"
        target: '_blank'
      }, [
        img {
          style: 'position: absolute; top: 0; right: 0; border: 0;'
          src: 'https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png'
          alt: 'Fork me on GitHub'
        }
      ]
      section {id: 'todoapp'}, [
        header {id: 'header'}, [
          h1 'todos'
          input {
            id: 'new-todo'
            type: 'text'
            placeholder: 'What needs to be done?'
            autofocus: true
            keydown: (e) ->
              if e.which == 13
                TaskDB.insert
                  title: @val().trim()
                  isEditing: false
                  isCompleted: false
                  created: new Date
                @val('')
                false # In IE, don't set focus on the utton(crazy!)
                # <http://stackoverflow.com/questions/12325066/button-click-event-fires-when-pressing-enter-key-in-different-input-no-forms>
          }
        ]
        div bind ->
          if tasks.length() == 0
            []
          else
            [
              section {id: 'main'}, [
                input {
                  id: 'toggle-all'
                  type: 'checkbox'
                  change: ->
                    for task in tasks.all()
                      TaskDB.update task._id, {$set: {isCompleted: @is(':checked')}}
                }
                label {for: 'toggle-all'}, 'Mark all as complete'
                ul {id: 'todo-list'}, tasks.all().map (task) ->
                  editBox = null
                  li {
                    class: [
                      'completed' if task.isCompleted
                      'editing' if task.isEditing
                    ].filter((x) -> x?).join(' ')
                  }, bind ->
                    if task.isEditing then [
                      editBox = input {
                        type: 'text'
                        class: 'edit'
                        autofocus: true
                        value: task.title
                        keyup: (e) ->
                          if e.which == 13
                            @blur()
                        blur: ->
                          TaskDB.update task._id, {$set: {isEditing: false, title: @val()}}
                      }
                    ] else [
                      input {
                        class: 'toggle'
                        type: 'checkbox'
                        checked: task.isCompleted
                        change: ->
                          TaskDB.update task._id, {$set: {isCompleted: @is(':checked')}}
                      }
                      label {
                        dblclick: ->
                          TaskDB.update task._id, {$set: {isEditing: true}}
                          editBox.focus()
                      }, "#{task.title}"
                      button {
                        class: 'destroy'
                        click: -> TaskDB.remove task._id
                      }
                    ]
              ]
              footer {id: 'footer'}, [
                div [
                  span {id: 'todo-count'}, bind -> [
                    strong "#{incomplete()}"
                    if incomplete() == 1 then ' item left' else ' items left'
                  ]
                  button {
                    id: 'clear-completed'
                    click: ->
                      for task in tasks.all()
                        if task.isCompleted
                          TaskDB.remove task._id
                  }, 'Clear completed'
                ]
                div bind ->
                  "Last edit: #{moment(taskLatest.get().created).fromNow()}"
              ]
            ]
      ]
      div {
        id: 'page-footer'
        style: 'margin-top: 100px; text-align:center; text-shadow: white 0.1em 0.1em 0.1em;'
      }, [
        span 'Proudly built with '
        span {
          style: 'cursor: pointer; cursor: hand;'
          click: ->
            window.open 'https://github.com/zhouzhuojie/meteor-reactive-coffee'
        }, 'Meteor-Reactive-Coffee'
      ]
    )
