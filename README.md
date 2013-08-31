Reactive-coffee-demo
===============

[Demo Website](http://reactive-coffee-demo.meteor.com)

A quick todoMVC example built with [Meteor-Reactive-Coffee](https://github.com/zhouzhuojie/meteor-reactive-coffee).

![](http://i1336.photobucket.com/albums/o641/00zzj/Tmp/Screenshot_083113_035407_PM_zps55e7f57b.jpg)

#### Some implementation notes

* We don't even need html/templates

* Populate the Meteor.Collection data into `rx.array` or `rx.cell`

```coffeescript
window.tasks = rx.meteor.find TaskDB, {}, {sort:{created:-1}}
window.taskLatest = rx.meteor.findOne TaskDB, {}, {sort:{created:-1}}
```

* Data bind is as simple as plain reactive-coffee

```coffeescript
ul {id: 'todo-list'}, tasks.map (task) ->
  # ...
  span task.title
  # ...
```

see `client/reactive-coffee-demo.coffee` for details.
