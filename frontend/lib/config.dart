class Config {
  static const String baseUrl = 'http://10.161.123.46:3000/';  // <-- No space here
  static const String registration = '${baseUrl}register';
  static const String login = '${baseUrl}login';
  static const String addTodo = '${baseUrl}createToDo';
  static const String getToDoList = '${baseUrl}getUserTodoList';
  static const String deleteTodo = '${baseUrl}deleteTodo';
}
