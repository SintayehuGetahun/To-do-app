const ToDoModel = require("../models/todo.models");

class ToDoService {
    static async createToDo(userId, title, desc) {
        const createToDo = new ToDoModel({ userId, title, desc });
        return await createToDo.save();
    }

    static async getUserToDoList(userId) {
        const todoList = await ToDoModel.find({ userId });
        return todoList;
    }

    static async deleteToDo(id) {
        const deleted = await ToDoModel.findByIdAndDelete(id);
        return deleted;
    }
}

module.exports = ToDoService;
