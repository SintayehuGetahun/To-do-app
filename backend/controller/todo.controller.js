const ToDoService = require('../services/todo.service'); 
 
exports.createToDo =  async (req,res,next)=>{ 
    try { 
        const { userId,title, desc } = req.body; 
        let todoData = await 
ToDoService.createToDo(userId,title, desc); 
        res.json({status: true,success:todoData}); 
    } catch (error) { 
        console.log(error, 'err---->'); 
        next(error); 
    } 
} 
 
exports.getToDoList =  async (req,res,next)=>{ 
    try { 
        const { userId } = req.body; 
        let todoData = await 
ToDoService.getUserToDoList(userId); 
        res.json({status: true,success:todoData}); 
    } catch (error) { 
        console.log(error, 'err---->'); 
        next(error); 
    } 
} 
exports.deleteToDo = async (req, res, next) => {
    try {
      const { id } = req.body;
      const deletedData = await ToDoService.deleteToDo(id);
  
      if (deletedData) {
        res.json({ status: true, success: deletedData });
      } else {
        res.json({ status: false, message: 'Todo not found' });
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  };