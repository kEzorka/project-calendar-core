#pragma once

#include <jwt-cpp/jwt.h>

#include <chrono>
#include <string>

class JwtService {
 public:
  // Структура для результата проверки токена
  struct JwtPayload {
    std::string user_id;
    bool valid;
    std::string error;

    JwtPayload() : valid(false) {}
  };

  // Генерация JWT токена
  static std::string generateToken(const std::string& user_id, int days = 7);

  // Проверка JWT токена
  static JwtPayload verifyToken(const std::string& token);

 private:
  // Получение секретного ключа
  static std::string getSecretKey();

  // Получение издателя токена
  static std::string getIssuer() { return "project-calendar"; }
};