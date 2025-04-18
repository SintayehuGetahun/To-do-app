class Config {
  static const String baseUrl = 'http:// 10.161.123.46:3000/';  // Your base URL for the API
  static const String registration = '${baseUrl}register';    // Endpoint for registration
  static const String login = '${baseUrl}login';              // Endpoint for login
  static const String addTodo = '${baseUrl}createToDo';       // Endpoint to add a to-do
  static const String getToDoList = '${baseUrl}getUserTodoList'; // Endpoint to get user's to-do list
  static const String deleteTodo = '${baseUrl}deleteTodo';    // Endpoint to delete a to-do
}
