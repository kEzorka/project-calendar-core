#pragma once

#include <drogon/HttpController.h>

using namespace drogon;

class TaskController : public drogon::HttpController<TaskController> {
 public:
  METHOD_LIST_BEGIN
  ADD_METHOD_TO(TaskController::createTask, "/api/tasks", Post, "AuthFilter");

  ADD_METHOD_TO(TaskController::getTasks, "/api/tasks", Get, "AuthFilter");

  ADD_METHOD_TO(TaskController::updateTask, "/api/tasks/{id}", Put,
                "AuthFilter");

  ADD_METHOD_TO(TaskController::deleteTask, "/api/tasks/{id}", Delete,
                "AuthFilter");

  ADD_METHOD_TO(TaskController::getSubtasks, "/api/tasks/{id}/subtasks", Get,
                "AuthFilter");

  ADD_METHOD_TO(TaskController::createAssignment, "/api/tasks/{id}/assignments",
                Post, "AuthFilter");

  ADD_METHOD_TO(TaskController::listAssignments, "/api/tasks/{id}/assignments",
                Get, "AuthFilter");

  ADD_METHOD_TO(TaskController::deleteAssignment, "/api/assignments/{id}",
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