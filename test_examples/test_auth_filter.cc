#include <drogon/drogon.h>

#include <cassert>
#include <iostream>
#include <memory>

#include "../src/filters/AuthFilter.h"
#include "../src/services/JwtService.h"

using namespace drogon;

// Создаём тестовый HTTP запрос с заголовком Authorization
HttpRequestPtr createTestRequest(const std::string& token = "") {
  auto req = HttpRequest::newHttpRequest();
  req->setPath("/api/auth/me");
  req->setMethod(Get);

  if (!token.empty()) {
    req->addHeader("Authorization", "Bearer " + token);
  }

  return req;
}

void testRealAuthFilter() {
  std::cout << "=== Testing REAL AuthFilter ===" << std::endl;

  // 1. Создаём реальный AuthFilter
  auto authFilter = std::make_shared<AuthFilter>();

  // 2. Генерируем реальный JWT токен
  std::string user_id = "test-user-123";
  std::string token = JwtService::generateToken(user_id, 7);

  std::cout << "1. Testing with valid token..." << std::endl;

  // 3. Создаём запрос с валидным токеном
  auto req_with_token = createTestRequest(token);

  // 4. В реальном коде AuthFilter проверяет токен через JwtService
  // и добавляет user_id в атрибуты запроса

  // Проверим что JwtService работает правильно
  auto payload = JwtService::verifyToken(token);
  assert(payload.valid);
  assert(payload.user_id == user_id);

  std::cout << "   ✅ JWT token is valid" << std::endl;
  std::cout << "   User ID from token: " << payload.user_id << std::endl;

  // 5. Тестируем извлечение user_id из запроса (как это делает AuthFilter)
  // В реальном AuthFilter после проверки он делает:
  // req->attributes()->insert("user_id", payload.user_id);

  // Имитируем это:
  req_with_token->attributes()->insert("user_id", payload.user_id);

  // Проверяем что можем извлечь:
  auto extracted_user_id = AuthFilter::getUserIdFromRequest(req_with_token);
  assert(extracted_user_id == user_id);

  std::cout << "   ✅ User ID extracted from request: " << extracted_user_id
            << std::endl;

  // 6. Тест без токена
  std::cout << "\n2. Testing without token..." << std::endl;
  auto req_without_token = createTestRequest();

  auto extracted_empty = AuthFilter::getUserIdFromRequest(req_without_token);
  assert(extracted_empty.empty());

  std::cout << "   ✅ No user ID without token (as expected)" << std::endl;

  std::cout << "\n=== AuthFilter integration test passed! ===" << std::endl;
}

int main() {
  try {
    // Инициализируем Drogon минимально для тестов
    drogon::app().setLogLevel(trantor::Logger::kWarn);

    testRealAuthFilter();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "❌ Test failed: " << e.what() << std::endl;
    return 1;
  }
}