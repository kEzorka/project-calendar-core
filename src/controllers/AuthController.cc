#include "AuthController.h"

#include <bcrypt/bcrypt.h>
#include <drogon/HttpResponse.h>
#include <drogon/drogon.h>

#include <regex>

#include "../services/JwtService.h"
#include "models/AppUser.h"
#include "models/UserWorkSchedule.h"

using namespace drogon;
using namespace drogon_model::project_calendar;

static const std::regex EMAIL_REGEX(
    R"([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})");

void AuthController::asyncHandleHttpRequest(
    const HttpRequestPtr& req,
    std::function<void(const HttpResponsePtr&)>&& callback) {
  Json::Value json_response;
  auto resp = HttpResponse::newHttpJsonResponse(json_response);

  try {
    if (req->path() == "/api/auth/login") {
      // ЛОГИН
      auto json = req->getJsonObject();
      if (!json) throw std::runtime_error("Invalid JSON");

      std::string email = (*json)["email"].asString();
      std::string password = (*json)["password"].asString();

      if (email.empty() || password.empty())
        throw std::runtime_error("Email and password are required");

      if (!std::regex_match(email, EMAIL_REGEX))
        throw std::runtime_error("Invalid email format");

      auto dbClient = drogon::app().getDbClient();
      orm::Mapper<AppUser> userMapper(dbClient);

      try {
        auto user = userMapper.findOne(orm::Criteria(
            AppUser::Cols::_email, orm::CompareOperator::EQ, email));

        // Проверяем пароль
        if (!user.getValueOfPasswordHash() ||
            bcrypt_checkpw(password.c_str(),
                           user.getValueOfPasswordHash()->c_str()) != 0) {
          throw std::runtime_error("Invalid email or password");
        }

        // Генерируем JWT токен
        std::string user_id = user.getValueOfId();
        std::string token = JwtService::generateToken(user_id, 7);

        json_response["success"] = true;
        json_response["token"] = token;
        json_response["token_type"] = "Bearer";
        json_response["expires_in"] = 7 * 24 * 3600;

        Json::Value user_json;
        user_json["id"] = user_id;
        user_json["email"] = email;
        user_json["display_name"] = user.getValueOfDisplayName();
        user_json["locale"] = user.getValueOfLocale();
        if (user.getName()) user_json["name"] = *user.getName();
        if (user.getSurname()) user_json["surname"] = *user.getSurname();

        json_response["user"] = user_json;
        resp->setStatusCode(k200OK);

      } catch (const orm::UnexpectedRows& e) {
        throw std::runtime_error("Invalid email or password");
      }

    } else if (req->path() == "/api/auth/register") {
      // РЕГИСТРАЦИЯ
      auto json = req->getJsonObject();
      if (!json) throw std::runtime_error("Invalid JSON");

      std::string email = (*json)["email"].asString();
      std::string password = (*json)["password"].asString();
      std::string display_name = (*json)["display_name"].asString();
      std::string locale = (*json).get("locale", "ru-RU").asString();

      if (email.empty() || password.empty() || display_name.empty())
        throw std::runtime_error(
            "Email, password and display name are required");

      if (!std::regex_match(email, EMAIL_REGEX))
        throw std::runtime_error("Invalid email format");

      if (password.length() < 8)
        throw std::runtime_error("Password must be at least 8 characters");

      auto dbClient = drogon::app().getDbClient();
      orm::Mapper<AppUser> userMapper(dbClient);

      // Проверка уникальности email
      try {
        userMapper.findOne(orm::Criteria(AppUser::Cols::_email,
                                         orm::CompareOperator::EQ, email));
        throw std::runtime_error("Email already registered");
      } catch (const orm::UnexpectedRows& e) {
        // OK - email свободен
      }

      // Хешируем пароль
      char salt[BCRYPT_HASHSIZE];
      char hash[BCRYPT_HASHSIZE];
      if (bcrypt_gensalt(12, salt) != 0 ||
          bcrypt_hashpw(password.c_str(), salt, hash) != 0)
        throw std::runtime_error("Password encryption failed");

      // Создаём пользователя
      AppUser user;
      user.setId(Uuid());
      user.setEmail(email);
      user.setDisplayName(display_name);
      user.setPasswordHash(hash);
      user.setLocale(locale);
      user.setCreatedAt(Date::now());
      user.setUpdatedAt(Date::now());

      // Опциональные поля
      if ((*json).isMember("name")) user.setName((*json)["name"].asString());
      if ((*json).isMember("surname"))
        user.setSurname((*json)["surname"].asString());
      if ((*json).isMember("phone")) user.setPhone((*json)["phone"].asString());
      if ((*json).isMember("telegram"))
        user.setTelegram((*json)["telegram"].asString());

      userMapper.insert(user);

      // Рабочее расписание (если есть)
      if (json->isMember("work_schedule") &&
          (*json)["work_schedule"].isArray()) {
        orm::Mapper<UserWorkSchedule> scheduleMapper(dbClient);
        for (const auto& day_schedule : (*json)["work_schedule"]) {
          if (day_schedule.isMember("weekday") &&
              day_schedule.isMember("start_time") &&
              day_schedule.isMember("end_time")) {
            UserWorkSchedule schedule;
            schedule.setId(Uuid());
            schedule.setUserId(user.getValueOfId());
            schedule.setWeekday(day_schedule["weekday"].asInt());
            schedule.setStartTime(day_schedule["start_time"].asString());
            schedule.setEndTime(day_schedule["end_time"].asString());
            scheduleMapper.insert(schedule);
          }
        }
      }

      // Генерируем токен
      std::string user_id = user.getValueOfId().toStdString();
      std::string token = JwtService::generateToken(user_id, 7);

      json_response["success"] = true;
      json_response["message"] = "Registration successful";
      json_response["token"] = token;
      json_response["token_type"] = "Bearer";

      Json::Value user_json;
      user_json["id"] = user_id;
      user_json["email"] = email;
      user_json["display_name"] = display_name;
      user_json["locale"] = locale;
      json_response["user"] = user_json;
      resp->setStatusCode(k201Created);

    } else if (req->path() == "/api/auth/me") {
      // ПОЛУЧЕНИЕ ПРОФИЛЯ
      auto user_id_attr = req->getAttribute("user_id");
      if (!user_id_attr) throw std::runtime_error("User not authenticated");

      std::string user_id = std::any_cast<std::string>(user_id_attr);
      if (user_id.empty()) throw std::runtime_error("User not authenticated");

      auto dbClient = drogon::app().getDbClient();
      orm::Mapper<AppUser> userMapper(dbClient);

      try {
        auto user = userMapper.findOne(orm::Criteria(
            AppUser::Cols::_id, orm::CompareOperator::EQ, Uuid(user_id)));

        json_response["success"] = true;
        json_response["message"] = "Profile retrieved successfully";

        Json::Value user_json;
        user_json["id"] = user_id;
        user_json["email"] = user.getValueOfEmail();
        user_json["display_name"] = user.getValueOfDisplayName();
        user_json["locale"] = user.getValueOfLocale();
        if (user.getName()) user_json["name"] = *user.getName();
        if (user.getSurname()) user_json["surname"] = *user.getSurname();
        if (user.getPhone()) user_json["phone"] = *user.getPhone();
        if (user.getTelegram()) user_json["telegram"] = *user.getTelegram();

        json_response["user"] = user_json;
        resp->setStatusCode(k200OK);

      } catch (const orm::UnexpectedRows& e) {
        throw std::runtime_error("User not found");
      }
    }

  } catch (const std::exception& e) {
    std::string error_msg = e.what();
    json_response["success"] = false;
    json_response["error"] = "authentication_error";
    json_response["message"] = error_msg;

    if (error_msg.find("required") != std::string::npos ||
        error_msg.find("Invalid email") != std::string::npos ||
        error_msg.find("Password must be") != std::string::npos) {
      resp->setStatusCode(k400BadRequest);
    } else if (error_msg.find("Invalid email or password") !=
                   std::string::npos ||
               error_msg.find("User not found") != std::string::npos) {
      resp->setStatusCode(k401Unauthorized);
    } else if (error_msg.find("already registered") != std::string::npos) {
      resp->setStatusCode(k409Conflict);
    } else {
      resp->setStatusCode(k500InternalServerError);
    }
  }

  resp->setBody(json_response.toStyledString());
  callback(resp);
}