var bodyParser = require('body-parser');

var urlencodedParser = bodyParser.urlencoded({ extended: false });

var mongoose = require('mongoose');

mongoose.connect('mongodb://admin:rZ53QHKeJz0LaspO@SG-TodoList-21241.servers.mongodirector.com:48561,SG-TodoList-21242.servers.mongodirector.com:48561,SG-TodoList-21243.servers.mongodirector.com:48561/admin?replicaSet=RS-TodoList-0&ssl=true')

var todoSchema = new mongoose.Schema({
  item: String
});

var Todo = mongoose.model('Todo', todoSchema);

// var itemOne = Todo({item: 'buy flowers'}).save(function(err) {
//   if (err) throw err;
//   console.log('item saved');
// });
//
// var data = [ {item: 'get milk'}, {item: "walk dog"}, {item: 'kick some coding ass'} ];;

module.exports = function (app) {
  app.get('/todo', function (req, res) {
    Todo.find({}, function (err, data) {
      if (err) throw err;
      res.render('todo', { todos: data });
    });
  });

  app.post('/todo', urlencodedParser, function (req, res) {
    var itemOne = Todo(req.body).save(function (err, data) {
      if (err) throw err;
      res.json(data);
    });
  });

  app.delete('/todo/:item', function (req, res) {
    // data = data.filter(function(todo) {
    //   return todo.item.replace(/ /g, "-") !== req.params.item;
    // });
    Todo.find({ item: req.params.item.replace(/-/g, " ") }).remove(function (err, data) {
      if (err) throw err;
      res.json(data);
    });
  });
}