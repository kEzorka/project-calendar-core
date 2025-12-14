#include "AuthFilter.h"

#include <drogon/HttpResponse.h>
#include <drogon/drogon.h>

#include "../services/JwtService.h"

using namespace drogon;

void AuthFilter::doFilter(const HttpRequestPtr& req, FilterCallback&& fcb,
                          FilterChainCallback&& fccb) {
  Json::Value json_response;

  try {
    auto auth_header = req->getHeader("Authorization");

    if (auth_header.empty()) {
      json_response["success"] = false;
      json_response["error"] = "authentication_required";
      json_response["message"] = "Authorization header is missing";

      auto resp = HttpResponse::newHttpJsonResponse(json_response);
      resp->setStatusCode(k401Unauthorized);
      fcb(resp);
      return;
    }

    const std::string bearer_prefix = "Bearer ";
    if (auth_header.find(bearer_prefix) != 0) {
      json_response["success"] = false;
      json_response["error"] = "invalid_token_format";
      json_response["message"] = "Token must be in format: Bearer <token>";

      auto resp = HttpResponse::newHttpJsonResponse(json_response);
      resp->setStatusCode(k401Unauthorized);
      fcb(resp);
      return;
    }

    std::string token = auth_header.substr(bearer_prefix.length());

    if (token.empty()) {
      json_response["success"] = false;
      json_response["error"] = "empty_token";
      json_response["message"] = "Token cannot be empty";

      auto resp = HttpResponse::newHttpJsonResponse(json_response);
      resp->setStatusCode(k401Unauthorized);
      fcb(resp);
      return;
    }

    auto payload = JwtService::verifyToken(token);

    if (!payload.valid) {
      json_response["success"] = false;
      json_response["error"] = "invalid_token";
      json_response["message"] = payload.error;

      auto resp = HttpResponse::newHttpJsonResponse(json_response);
      resp->setStatusCode(k401Unauthorized);
      fcb(resp);
      return;
    }

    req->attributes()->insert("user_id", payload.user_id);
    fccb();

  } catch (const std::exception& e) {
    LOG_ERROR << "AuthFilter error: " << e.what();

    json_response["success"] = false;
    json_response["error"] = "server_error";
    json_response["message"] = "Authentication service error";

    auto resp = HttpResponse::newHttpJsonResponse(json_response);
    resp->setStatusCode(k500InternalServerError);
    fcb(resp);
    return;
  }
}

std::string AuthFilter::getUserIdFromRequest(const HttpRequestPtr& req) {
  return req->attributes()->get<std::string>("user_id");
}