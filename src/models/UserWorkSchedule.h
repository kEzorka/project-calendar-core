#pragma once
#include <string>

namespace drogon_model {
namespace project_calendar {

class UserWorkSchedule {
 public:
  struct Cols {
    static const std::string _id;
    static const std::string _user_id;
    static const std::string _weekday;
    static const std::string _start_time;
    static const std::string _end_time;
  };

  // Геттеры
  const std::string &getValueOfId() const { return id_; }
  const std::string &getValueOfUserId() const { return user_id_; }
  int getValueOfWeekday() const { return weekday_; }
  const std::string &getValueOfStartTime() const { return start_time_; }
  const std::string &getValueOfEndTime() const { return end_time_; }

  // Сеттеры
  void setId(const std::string &id) { id_ = id; }
  void setUserId(const std::string &user_id) { user_id_ = user_id; }
  void setWeekday(int weekday) { weekday_ = weekday; }
  void setStartTime(const std::string &start_time) { start_time_ = start_time; }
  void setEndTime(const std::string &end_time) { end_time_ = end_time; }

 private:
  std::string id_;
  std::string user_id_;
  int weekday_ = 0;
  std::string start_time_;
  std::string end_time_;
};

}  // namespace project_calendar
}  // namespace drogon_model