#include <drogon/drogon.h>

#include <fstream>

#include "controllers/AuthController.h"
#include "filters/AuthFilter.h"

int main() {
  // ============================================
  // 1. НАСТРОЙКА И ЗАПУСК СЕРВЕРА
  // ============================================

  // Пробуем загрузить конфигурацию из разных мест
  std::vector<std::string> config_paths = {"config.json", "../config.json",
                                           "config/config.json"};

  bool config_loaded = false;
  for (const auto& path : config_paths) {
    std::ifstream file(path);
    if (file.good()) {
      try {
        drogon::app().loadConfigFile(path);
        LOG_INFO << "Configuration loaded from: " << path;
        config_loaded = true;
        break;
      } catch (const std::exception& e) {
        LOG_WARN << "Failed to load config from " << path << ": " << e.what();
      }
    }
  }

  if (!config_loaded) {
    LOG_WARN << "No configuration file found, using defaults";

    // Устанавливаем минимальные настройки
    drogon::app()
        .setLogLevel(trantor::Logger::kInfo)
        .addListener("0.0.0.0", 8080)
        .setThreadNum(16)
        .setDocumentRoot("./www");
  }

  // ============================================
  // 2. РЕГИСТРАЦИЯ КОМПОНЕНТОВ
  // ============================================

  // Регистрируем фильтр аутентификации
  drogon::app().registerFilter(std::make_shared<AuthFilter>());

  // Регистрируем контроллеры
  drogon::app().registerController(std::make_shared<AuthController>());

  // ============================================
  // 3. ЗАПУСК СЕРВЕРА
  // ============================================
  LOG_INFO << "========================================";
  LOG_INFO << "Project Calendar Backend starting...";
  LOG_INFO << "========================================";
  LOG_INFO << "";

  // Логируем информацию о сервере
  auto& listeners = drogon::app().getListeners();
  if (!listeners.empty()) {
    LOG_INFO << "Server listening on:";
    for (auto& listener : listeners) {
      LOG_INFO << "  http://" << listener.toIp() << ":" << listener.toPort();
    }
  } else {
    LOG_INFO << "Server listening on: http://0.0.0.0:8080";
  }

  LOG_INFO << "";
  LOG_INFO << "Available endpoints:";
  LOG_INFO << "  POST /api/auth/login";
  LOG_INFO << "  POST /api/auth/register";
  LOG_INFO << "  GET  /api/auth/me (requires JWT)";
  LOG_INFO << "";
  LOG_INFO << "========================================";

  // Устанавливаем обработчик для graceful shutdown
  drogon::app().setSignalHandler({SIGINT, SIGTERM}, [](int signal) {
    LOG_INFO << "Received signal " << signal << ", shutting down gracefully...";
    drogon::app().quit();
  });

  // Запускаем приложение
  drogon::app().run();

  LOG_INFO << "Server shutdown complete";
  return 0;
}