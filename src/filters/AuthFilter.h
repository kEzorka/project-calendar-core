#pragma once

#include <drogon/HttpFilter.h>

using namespace drogon;

class AuthFilter : public drogon::HttpFilter<AuthFilter> {
 public:
  void doFilter(const HttpRequestPtr& req, FilterCallback&& fcb,
                FilterChainCallback&& fccb) override;

  static std::string getUserIdFromRequest(const HttpRequestPtr& req);
};