#include <iostream>

#include "../src/services/JwtService.h"

int main() {
  try {
    std::string user_id = "test-user-123";

    std::cout << "Testing JWT Service..." << std::endl;

    // Генерация токена
    std::string token = JwtService::generateToken(user_id, 7);
    std::cout << "Generated token: " << token << std::endl;

    // Проверка токена
    auto payload = JwtService::verifyToken(token);

    if (payload.valid) {
      std::cout << "Token valid! User ID: " << payload.user_id << std::endl;
      std::cout << "SUCCESS: JWT service works correctly" << std::endl;
    } else {
      std::cout << "Token invalid: " << payload.error << std::endl;
      return 1;
    }

    // Проверка невалидного токена
    auto invalid_payload = JwtService::verifyToken("invalid.token.here");
    if (!invalid_payload.valid) {
      std::cout << "CORRECT: Invalid token rejected: " << invalid_payload.error
                << std::endl;
    }

  } catch (const std::exception& e) {
    std::cerr << "ERROR: " << e.what() << std::endl;
    return 1;
  }

  return 0;
}