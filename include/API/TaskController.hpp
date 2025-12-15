#pragma once

#include <drogon/HttpController.h>

using namespace drogon;

class TaskController : public drogon::HttpController<TaskController> {
 public:
  METHOD_LIST_BEGIN
  ADD_METHOD_TO(TaskController::createTask, "/api/tasks", Post, "AuthFilter");

  ADD_METHOD_TO(TaskController::getTasks, "/api/tasks", Get, "AuthFilter");

  // Specific routes with longer paths first
  ADD_METHOD_TO(TaskController::createAssignment, "/api/tasks/{task_id}/assignments",
                Post, "AuthFilter");

  ADD_METHOD_TO(TaskController::listAssignments, "/api/tasks/{task_id}/assignments",
                Get, "AuthFilter");

  ADD_METHOD_TO(TaskController::getSubtasks, "/api/tasks/{task_id}/subtasks", Get,
                "AuthFilter");

  // Generic task routes (shorter paths)
  ADD_METHOD_TO(TaskController::updateTask, "/api/tasks/{task_id}", Put,
                "AuthFilter");

  ADD_METHOD_TO(TaskController::deleteTask, "/api/tasks/{task_id}", Delete,
                "AuthFilter");

  ADD_METHOD_TO(TaskController::deleteAssignment, "/api/assignments/{assignment_id}",
                Delete, "AuthFilter");
  METHOD_LIST_END

  void createTask(const HttpRequestPtr& req,
                  std::function<void(const HttpResponsePtr&)>&& callback);

  void getTasks(const HttpRequestPtr& req,
                std::function<void(const HttpResponsePtr&)>&& callback);

  void updateTask(const HttpRequestPtr& req,
                  std::function<void(const HttpResponsePtr&)>&& callback);

  void deleteTask(const HttpRequestPtr& req,
                  std::function<void(const HttpResponsePtr&)>&& callback);

  void getSubtasks(const HttpRequestPtr& req,
                   std::function<void(const HttpResponsePtr&)>&& callback);

  void createAssignment(const HttpRequestPtr& req,
                        std::function<void(const HttpResponsePtr&)>&& callback);

  void listAssignments(const HttpRequestPtr& req,
                       std::function<void(const HttpResponsePtr&)>&& callback);

  void deleteAssignment(const HttpRequestPtr& req,
                        std::function<void(const HttpResponsePtr&)>&& callback);
};