#pragma once
#include <drogon/drogon.h>

#include <optional>
#include <string>

namespace drogon_model {
namespace project_calendar {

class AppUser {
 public:
  struct Cols {
    static const std::string _id;
    static const std::string _email;
    static const std::string _display_name;
    static const std::string _name;
    static const std::string _surname;
    static const std::string _phone;
    static const std::string _telegram;
    static const std::string _locale;
    static const std::string _password_hash;
    static const std::string _created_at;
    static const std::string _updated_at;
  };

  // Конструкторы
  AppUser() = default;

  // Геттеры (используются в AuthController)
  const std::string &getValueOfId() const { return id_; }
  const std::string &getValueOfEmail() const { return email_; }
  const std::string &getValueOfDisplayName() const { return display_name_; }
  const std::optional<std::string> &getName() const { return name_; }
  const std::optional<std::string> &getSurname() const { return surname_; }
  const std::optional<std::string> &getPhone() const { return phone_; }
  const std::optional<std::string> &getTelegram() const { return telegram_; }
  const std::string &getValueOfLocale() const { return locale_; }
  const std::optional<std::string> &getValueOfPasswordHash() const {
    return password_hash_;
  }
  const trantor::Date &getValueOfCreatedAt() const { return created_at_; }
  const trantor::Date &getValueOfUpdatedAt() const { return updated_at_; }

  // Сеттеры (используются при регистрации)
  void setId(const std::string &id) { id_ = id; }
  void setEmail(const std::string &email) { email_ = email; }
  void setDisplayName(const std::string &display_name) {
    display_name_ = display_name;
  }
  void setName(const std::optional<std::string> &name) { name_ = name; }
  void setSurname(const std::optional<std::string> &surname) {
    surname_ = surname;
  }
  void setPhone(const std::optional<std::string> &phone) { phone_ = phone; }
  void setTelegram(const std::optional<std::string> &telegram) {
    telegram_ = telegram;
  }
  void setLocale(const std::string &locale) { locale_ = locale; }
  void setPasswordHash(const std::optional<std::string> &password_hash) {
    password_hash_ = password_hash;
  }
  void setCreatedAt(const trantor::Date &created_at) {
    created_at_ = created_at;
  }
  void setUpdatedAt(const trantor::Date &updated_at) {
    updated_at_ = updated_at;
  }

 private:
  std::string id_;
  std::string email_;
  std::string display_name_;
  std::optional<std::string> name_;
  std::optional<std::string> surname_;
  std::optional<std::string> phone_;
  std::optional<std::string> telegram_;
  std::string locale_ = "ru-RU";
  std::optional<std::string> password_hash_;
  trantor::Date created_at_;
  trantor::Date updated_at_;
};

}  // namespace project_calendar
}  // namespace drogon_model