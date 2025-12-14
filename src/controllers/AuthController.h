#pragma once

#include <drogon/HttpSimpleController.h>

using namespace drogon;

class AuthController : public drogon::HttpSimpleController<AuthController> {
 public:
  void asyncHandleHttpRequest(
      const HttpRequestPtr& req,
      std::function<void(const HttpResponsePtr&)>&& callback) override;

  PATH_LIST_BEGIN
  PATH_ADD("/api/auth/login", Post);
  PATH_ADD("/api/auth/register", Post);
  PATH_ADD("/api/auth/me", Get, "AuthFilter");
  PATH_LIST_END
};