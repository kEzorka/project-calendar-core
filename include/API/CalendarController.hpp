#pragma once

#include <drogon/HttpController.h>

using namespace drogon;

class CalendarController : public drogon::HttpController<CalendarController> {
 public:
  METHOD_LIST_BEGIN

  ADD_METHOD_TO(CalendarController::getCalendarTasks, "/api/calendar/tasks",
                Get, "AuthFilter");
  METHOD_LIST_END

  void getCalendarTasks(const HttpRequestPtr& req,
                        std::function<void(const HttpResponsePtr&)>&& callback);
};