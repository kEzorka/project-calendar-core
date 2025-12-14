#include "JwtService.h"

#include <chrono>
#include <iostream>

using namespace std::chrono;

std::string JwtService::getSecretKey() {
  return "project-calendar-mvp-secret-key-2025-change-in-production";
}

std::string JwtService::generateToken(const std::string& user_id, int days) {
  try {
    auto now = std::chrono::system_clock::now();
    auto expires = now + std::chrono::hours(24 * days);

    auto token = jwt::create()
                     .set_issuer(getIssuer())
                     .set_type("JWT")
                     .set_issued_at(now)
                     .set_expires_at(expires)
                     .set_payload_claim("user_id", jwt::claim(user_id))
                     .sign(jwt::algorithm::hs256{getSecretKey()});

    return token;

  } catch (const std::exception& e) {
    std::cerr << "Error generating JWT token: " << e.what() << std::endl;
    throw;
  }
}

JwtService::JwtPayload JwtService::verifyToken(const std::string& token) {
  JwtPayload payload;

  if (token.empty()) {
    payload.error = "Empty token";
    return payload;
  }

  try {
    auto decoded = jwt::decode(token);

    auto verifier = jwt::verify();
    verifier.allow_algorithm(jwt::algorithm::hs256{getSecretKey()});
    verifier.with_issuer(getIssuer());

    verifier.verify(decoded);

    payload.user_id = decoded.get_payload_claim("user_id").as_string();
    payload.valid = true;

  } catch (const jwt::error::token_verification_exception& e) {
    payload.valid = false;
    payload.error = e.what();
  } catch (const std::exception& e) {
    payload.valid = false;
    payload.error = std::string("Unexpected error: ") + e.what();
  }

  return payload;
}