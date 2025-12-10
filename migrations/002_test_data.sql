-- ============================================================================
-- Project Calendar - Test Data
-- ============================================================================

-- ============================================================================
-- INSERT: app_user
-- 16 пользователей с разными ролями
-- ============================================================================

INSERT INTO app_user (email, display_name, name, surname, phone, telegram, locale) VALUES
('impelix@pumpelix.love', 'Антон Импеликс', 'Антон', 'Импеликс', '+7-900-111-11-11', '@impelix', 'ru-RU'),
('wildberries-manger@dubai.com', 'Глеб Генорто', 'Глеб', 'Генорто', '+7-901-222-22-22', '@genorto', 'ru-RU'),
('kezorka@polyana.opushka', 'Костя Кезорка', 'Костя', 'Кезорка', '+7-902-333-33-33', '@kezorka', 'ru-RU'),
('titlha@brdlha.mephi', 'Леша Титлха', 'Леша', 'Титлха', '+7-903-444-44-44', '@poil05', 'ru-RU'),
('baby@cute.love', 'Федор Ноувей', 'Федор', 'Ноувей', '+7-904-555-55-55', '@kis_kis', 'ru-RU'),

-- Дополнительные пользователи для полной команды
('maria.solovieva@example.com', 'Мария Соловьева', 'Мария', 'Соловьева', '+7-905-666-66-66', '@solovieva', 'ru-RU'),
('ivan.petrov@example.com', 'Иван Петров', 'Иван', 'Петров', '+7-906-777-77-77', '@petrov_ivan', 'ru-RU'),
('alexandra.smirnova@example.com', 'Александра Смирнова', 'Александра', 'Смирнова', '+7-907-888-88-88', '@smirnova', 'ru-RU'),
('dmitry.kuznetsov@example.com', 'Дмитрий Кузнецов', 'Дмитрий', 'Кузнецов', '+7-908-999-99-99', '@kuznetsov', 'ru-RU'),
('elena.volkova@example.com', 'Елена Волкова', 'Елена', 'Волкова', '+7-909-101-01-01', '@volkova_e', 'ru-RU'),

-- PM и Admin
('project.manager@example.com', 'Сергей Сидоров', 'Сергей', 'Сидоров', '+7-910-111-11-11', '@sidorov_pm', 'ru-RU'),
('admin@example.com', 'Администратор', 'Админ', 'Система', '+7-911-121-21-21', '@admin', 'ru-RU'),

-- Дополнительные разработчики
('alex.sokolov@example.com', 'Алексей Соколов', 'Алексей', 'Соколов', '+7-912-131-31-31', '@sokolov', 'ru-RU'),
('natalia.morozova@example.com', 'Наталья Морозова', 'Наталья', 'Морозова', '+7-913-141-41-41', '@morozova', 'ru-RU'),
('pavel.lebedev@example.com', 'Павел Лебедев', 'Павел', 'Лебедев', '+7-914-151-51-51', '@lebedev', 'ru-RU'),
('olga.novikova@example.com', 'Ольга Новикова', 'Ольга', 'Новикова', '+7-915-161-61-61', '@novikova', 'ru-RU');

-- ============================================================================
-- INSERT: permission (28 разрешений согласно permissions.html)
-- ============================================================================

INSERT INTO permission (key, description, is_global) VALUES
-- auth
('auth.login', 'Вход в систему (маркер)', true),

-- task.local permissions
('task.view.local', 'Просмотр карточки задачи (поля, назначения, сроки)', false),
('task.create.local', 'Создание задачи/подзадачи', false),
('task.update.local', 'Редактирование полей задачи', false),
('task.change_status.local', 'Переключение статусов задачи', false),
('task.delete.local', 'Локальное удаление задачи', false),
('task.comment.create.local', 'Создание комментариев к задаче', false),
('task.attachment.manage.local', 'Управление вложениями задачи', false),
('task.estimate.update.local', 'Обновление estimated_hours', false),

-- task.global permissions
('task.delete.global', 'Глобальное удаление задач/проектов', true),

-- assignment permissions
('assignment.assign.local', 'Назначение пользователя на задачу; запуск авто-планировщика', false),
('assignment.reassign.local', 'Корректировка назначённых часов между пользователями', false),

-- schedule permissions
('schedule.view.local', 'Просмотр расписаний (user/project/task)', false),
('schedule.adjust.local', 'Ручная корректировка блоков расписания', false),

-- delegation permissions
('delegation.request.local', 'Создание запроса на делегирование (pending)', false),
('delegation.grant.local', 'Подтверждение делегирования (супервизор)', false),
('delegation.revoke.local', 'Отзыв делегации (grantor/owner/иногда supervisor)', false),

-- project permissions
('project.update.global', 'Изменение метаданных проекта', true),
('project.manage_users.global', 'Управление участниками проекта/аккаунта', true),

-- user permissions
('user.profile.update.self', 'Обновление собственных контактных данных', false),
('user.manage.global', 'Управление аккаунтами пользователей', true),

-- system permissions
('permission.assign.global', 'Назначение глобальных прав/ролей', true),
('audit.view', 'Просмотр журнала аудита', true),
('conflict.resolve.local', 'Применение предложенного решения конфликта', false),
('report.generate.global', 'Генерация отчётов по проектам/ресурсам', true),
('webhook.manage.global', 'Управление внешними интеграциями/webhooks', true),
('settings.view.global', 'Просмотр глобальных настроек приложения', true),
('settings.update.global', 'Обновление глобальных настроек приложения', true);

-- ============================================================================
-- INSERT: role_permission (матрица ролей и разрешений согласно permissions.html)
-- ============================================================================

-- OWNER: полный доступ по сути
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('owner', 'auth.login', false),
('owner', 'task.view.local', false),
('owner', 'task.create.local', false),
('owner', 'task.update.local', false),
('owner', 'task.change_status.local', false),
('owner', 'task.delete.local', false),
('owner', 'task.delete.global', true),
('owner', 'task.comment.create.local', false),
('owner', 'task.attachment.manage.local', false),
('owner', 'task.estimate.update.local', false),
('owner', 'assignment.assign.local', false),
('owner', 'assignment.reassign.local', false),
('owner', 'schedule.view.local', false),
('owner', 'schedule.adjust.local', false),
('owner', 'delegation.request.local', false),
('owner', 'delegation.grant.local', false),
('owner', 'delegation.revoke.local', false),
('owner', 'project.update.global', true),
('owner', 'project.manage_users.global', true),
('owner', 'user.profile.update.self', false),
('owner', 'permission.assign.global', true),
('owner', 'audit.view', true),
('owner', 'conflict.resolve.local', false),
('owner', 'report.generate.global', true),
('owner', 'webhook.manage.global', true),
('owner', 'settings.view.global', true),
('owner', 'settings.update.global', true);

-- ADMIN: аналогично owner для критических систем
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('admin', 'auth.login', false),
('admin', 'task.view.local', false),
('admin', 'task.delete.global', true),
('admin', 'user.manage.global', true),
('admin', 'permission.assign.global', true),
('admin', 'audit.view', true),
('admin', 'project.update.global', true),
('admin', 'report.generate.global', true),
('admin', 'webhook.manage.global', true),
('admin', 'settings.view.global', true),
('admin', 'settings.update.global', true);

-- SUPERVISOR: управление проектом и людьми
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('supervisor', 'auth.login', false),
('supervisor', 'task.view.local', false),
('supervisor', 'task.create.local', false),
('supervisor', 'task.update.local', false),
('supervisor', 'task.change_status.local', false),
('supervisor', 'task.comment.create.local', false),
('supervisor', 'task.estimate.update.local', false),
('supervisor', 'assignment.assign.local', false),
('supervisor', 'assignment.reassign.local', false),
('supervisor', 'schedule.view.local', false),
('supervisor', 'schedule.adjust.local', false),
('supervisor', 'delegation.request.local', false),
('supervisor', 'delegation.grant.local', false),
('supervisor', 'delegation.revoke.local', false),
('supervisor', 'audit.view', true),
('supervisor', 'conflict.resolve.local', false);

-- HYBRID: смешанные возможности - исполнение + какое-то управление
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('hybrid', 'auth.login', false),
('hybrid', 'task.view.local', false),
('hybrid', 'task.update.local', false),
('hybrid', 'task.change_status.local', false),
('hybrid', 'task.comment.create.local', false),
('hybrid', 'assignment.reassign.local', false),
('hybrid', 'schedule.view.local', false),
('hybrid', 'schedule.adjust.local', false),
('hybrid', 'delegation.request.local', false),
('hybrid', 'user.profile.update.self', false);

-- EXECUTOR: исполнитель задач
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('executor', 'auth.login', false),
('executor', 'task.view.local', false),
('executor', 'task.change_status.local', false),
('executor', 'task.comment.create.local', false),
('executor', 'schedule.view.local', false),
('executor', 'delegation.request.local', false),
('executor', 'user.profile.update.self', false);

-- SPECTATOR: только просмотр
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('spectator', 'auth.login', false),
('spectator', 'task.view.local', false),
('spectator', 'task.comment.create.local', false),
('spectator', 'schedule.view.local', false),
('spectator', 'user.profile.update.self', false);

-- AUDIT_ROLE: чтение аудита
INSERT INTO role_permission (role, permission_key, is_global) VALUES
('audit_role', 'auth.login', false),
('audit_role', 'audit.view', true);

-- ============================================================================
-- INSERT: global_role_grant
-- Назначение ролей пользователям
-- ============================================================================

INSERT INTO global_role_grant (user_id, role, scope_type) 
SELECT id, 'admin', 'global' FROM app_user WHERE email = 'admin@example.com';

INSERT INTO global_role_grant (user_id, role, scope_type) 
SELECT id, 'owner', 'global' FROM app_user WHERE email = 'project.manager@example.com';

INSERT INTO global_role_grant (user_id, role, scope_type) 
SELECT id, 'executor', 'global' FROM app_user WHERE email IN (
  'impelix@pumpelix.love', 'wildberries-manger@dubai.com', 'kezorka@polyana.opushka',
  'titlha@brdlha.mephi', 'baby@cute.love', 'maria.solovieva@example.com', 
  'ivan.petrov@example.com', 'alex.sokolov@example.com', 
  'natalia.morozova@example.com', 'pavel.lebedev@example.com'
);

INSERT INTO global_role_grant (user_id, role, scope_type) 
SELECT id, 'spectator', 'global' FROM app_user WHERE email = 'alexandra.smirnova@example.com';

INSERT INTO global_role_grant (user_id, role, scope_type) 
SELECT id, 'audit_role', 'global' FROM app_user WHERE email = 'elena.volkova@example.com';

-- ============================================================================
-- INSERT: task (35 задач из mock и новые, с иерархией)
-- ============================================================================

-- ПРОЕКТ 1: Основное приложение Project Calendar
INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Project Calendar MVP', 'Разработка MVP приложения для управления проектами и задачами', 'high', 'in_progress', 160, '2025-11-20', '2026-01-15',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

-- ПРОЕКТ 2: Frontend
INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Frontend Development', 'Разработка фронтенда приложения', 'high', 'in_progress', 120, '2025-11-20', '2026-01-10',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

-- ПРОЕКТ 3: Backend
INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Backend Development', 'Разработка API и логики приложения', 'high', 'in_progress', 140, '2025-11-20', '2026-01-05',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

-- Frontend подзадачи (из mock)
INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1),
'Реализовать UserSearch компонент', 'Компонент для поиска пользователей с debounce 300ms', 'high', 'completed', 8, '2025-11-25', '2025-11-27',
(SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1),
'Создать TaskDetailModal', 'Модальное окно для отображения деталей задачи', 'high', 'in_progress', 6, '2025-11-26', '2025-11-28',
(SELECT id FROM app_user WHERE email = 'wildberries-manger@dubai.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1),
'Настроить тестовое окружение', 'Подготовить моковые данные и API для тестирования', 'normal', 'pending', 4, '2025-11-29', '2025-11-30',
(SELECT id FROM app_user WHERE email = 'kezorka@polyana.opushka');

-- Дополнительные Frontend задачи
INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1),
'Реализовать Calendar компонент', 'Интерактивный календарь для просмотра задач', 'high', 'in_progress', 16, '2025-11-28', '2025-12-05',
(SELECT id FROM app_user WHERE email = 'maria.solovieva@example.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1),
'Создать UI Kit компоненты', 'Базовые компоненты: Button, Input, Select, Modal', 'normal', 'in_progress', 12, '2025-11-25', '2025-12-02',
(SELECT id FROM app_user WHERE email = 'ivan.petrov@example.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1),
'Интеграция с API', 'Подключение к backend API всех компонентов', 'high', 'pending', 20, '2025-12-01', '2025-12-10',
(SELECT id FROM app_user WHERE email = 'titlha@brdlha.mephi');

-- Backend подзадачи
INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1),
'Реализовать User Service', 'Сервис для управления пользователями и поиска', 'high', 'in_progress', 20, '2025-11-25', '2025-12-05',
(SELECT id FROM app_user WHERE email = 'baby@cute.love');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1),
'Реализовать Task Service', 'Сервис для управления задачами и иерархией', 'high', 'in_progress', 24, '2025-11-25', '2025-12-08',
(SELECT id FROM app_user WHERE email = 'alex.sokolov@example.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1),
'Реализовать Permission Service', 'Система управления разрешениями и ролями', 'high', 'in_progress', 28, '2025-11-26', '2025-12-10',
(SELECT id FROM app_user WHERE email = 'natalia.morozova@example.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1),
'Реализовать Schedule Service', 'Сервис управления расписанием и конфликтами', 'normal', 'pending', 30, '2025-12-01', '2025-12-15',
(SELECT id FROM app_user WHERE email = 'pavel.lebedev@example.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1),
'Настроить Database', 'Создание схемы БД, миграции, индексы', 'high', 'completed', 16, '2025-11-20', '2025-11-24',
(SELECT id FROM app_user WHERE email = 'olga.novikova@example.com');

INSERT INTO task (parent_task_id, title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT (SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1),
'Настроить Authentication', 'JWT токены и система аутентификации', 'high', 'in_progress', 12, '2025-11-24', '2025-12-01',
(SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love');

-- Дополнительные общие задачи
INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'DevOps & Infrastructure', 'Настройка Docker, CI/CD, мониторинга', 'high', 'in_progress', 40, '2025-11-25', '2025-12-15',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Testing & QA', 'Автотесты, интеграционные тесты, E2E тесты', 'high', 'pending', 50, '2025-12-01', '2026-01-05',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Documentation', 'Документация API, руководство пользователя, README', 'normal', 'in_progress', 20, '2025-11-30', '2026-01-10',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Bug Fixes & Optimization', 'Исправление ошибок, оптимизация производительности', 'normal', 'open', 30, '2025-12-05', '2026-01-15',
(SELECT id FROM app_user WHERE email = 'project.manager@example.com');

INSERT INTO task (title, description, priority, status, estimated_hours, start_date, due_date, created_by) 
SELECT 'Security Review', 'Проверка безопасности, penetration testing', 'high', 'pending', 24, '2025-12-10', '2026-01-05',
(SELECT id FROM app_user WHERE email = 'admin@example.com');

-- ============================================================================
-- INSERT: task_role_assignment
-- Назначение ролей на задачи (из mock и новые)
-- ============================================================================

-- UserSearch компонент
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать UserSearch компонент' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love'), 'owner';

-- TaskDetailModal
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Создать TaskDetailModal' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'wildberries-manger@dubai.com'), 'owner';

INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Создать TaskDetailModal' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love'), 'executor';

-- Тестовое окружение
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Настроить тестовое окружение' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'kezorka@polyana.opushka'), 'owner';

-- Calendar компонент
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать Calendar компонент' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'maria.solovieva@example.com'), 'owner';

-- UI Kit компоненты
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Создать UI Kit компоненты' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'ivan.petrov@example.com'), 'owner';

-- API интеграция
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Интеграция с API' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'titlha@brdlha.mephi'), 'owner';

INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Интеграция с API' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'baby@cute.love'), 'executor';

-- User Service
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать User Service' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'baby@cute.love'), 'owner';

-- Task Service
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать Task Service' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'alex.sokolov@example.com'), 'owner';

-- Permission Service
INSERT INTO task_role_assignment (task_id, user_id, role) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать Permission Service' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'natalia.morozova@example.com'), 'owner';

-- ============================================================================
-- INSERT: task_assignment
-- Распределение часов на задачи (из mock и новые)
-- ============================================================================

-- UserSearch: Импеликс 8 часов
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать UserSearch компонент' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love'), 8;

-- TaskDetailModal: Генорто 6 часов
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Создать TaskDetailModal' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'wildberries-manger@dubai.com'), 6;

-- TaskDetailModal: Импеликс 4 часа помощи
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Создать TaskDetailModal' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love'), 4;

-- Тестовое окружение: Кезорка 4 часа
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Настроить тестовое окружение' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'kezorka@polyana.opushka'), 4;

-- Calendar: Соловьева 16 часов
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать Calendar компонент' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'maria.solovieva@example.com'), 16;

-- UI Kit: Петров 12 часов
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Создать UI Kit компоненты' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'ivan.petrov@example.com'), 12;

-- API интеграция: Титлха 20 часов
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Интеграция с API' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'titlha@brdlha.mephi'), 20;

-- User Service: Ноувей 20 часов
INSERT INTO task_assignment (task_id, user_id, assigned_hours) 
SELECT (SELECT id FROM task WHERE title = 'Реализовать User Service' LIMIT 1),
(SELECT id FROM app_user WHERE email = 'baby@cute.love'), 20;

-- ============================================================================
-- INSERT: user_work_schedule
-- Расписание работы пользователей
-- ============================================================================

-- Понедельник-Пятница 9:00-18:00 для всех разработчиков
INSERT INTO user_work_schedule (user_id, weekday, start_time, end_time) 
SELECT id, weekday, '09:00'::TIME, '18:00'::TIME
FROM app_user, (SELECT generate_series(0, 4) as weekday) days
WHERE email NOT IN ('admin@example.com');

-- ============================================================================
-- INSERT: super_project
-- Супер-проекты для группировки
-- ============================================================================

INSERT INTO super_project (name, description) VALUES
('Q4 2025 - Infrastructure', 'Квартальный план по инфраструктуре и DevOps'),
('Frontend Epic', 'Эпик разработки фронтенда приложения'),
('Backend Epic', 'Эпик разработки бэкенда приложения'),
('2026 Q1 Planning', 'Планирование на первый квартал 2026 года');

-- ============================================================================
-- INSERT: super_project_link
-- Связь супер-проектов
-- ============================================================================

INSERT INTO super_project_link (super_project_id, project_id) 
SELECT (SELECT id FROM super_project WHERE name = 'Frontend Epic' LIMIT 1),
(SELECT id FROM task WHERE title = 'Frontend Development' LIMIT 1);

INSERT INTO super_project_link (super_project_id, project_id) 
SELECT (SELECT id FROM super_project WHERE name = 'Backend Epic' LIMIT 1),
(SELECT id FROM task WHERE title = 'Backend Development' LIMIT 1);

INSERT INTO super_project_link (super_project_id, project_id) 
SELECT (SELECT id FROM super_project WHERE name = 'Q4 2025 - Infrastructure' LIMIT 1),
(SELECT id FROM task WHERE title = 'DevOps & Infrastructure' LIMIT 1);

-- ============================================================================
-- INSERT: audit_log
-- Логирование действий в системе
-- ============================================================================

INSERT INTO audit_log (actor_user_id, action_type, object_type, object_id, details, ip, user_agent) 
SELECT (SELECT id FROM app_user WHERE email = 'admin@example.com' LIMIT 1),
'CREATE_TASK', 'task', (SELECT id FROM task WHERE title = 'Project Calendar MVP' LIMIT 1),
'{"title": "Project Calendar MVP", "priority": "high"}'::JSONB, '127.0.0.1', 'Mozilla/5.0';

INSERT INTO audit_log (actor_user_id, action_type, object_type, object_id, details, ip, user_agent) 
SELECT (SELECT id FROM app_user WHERE email = 'impelix@pumpelix.love' LIMIT 1),
'COMPLETE_TASK', 'task', (SELECT id FROM task WHERE title = 'Реализовать UserSearch компонент' LIMIT 1),
'{"status": "completed"}'::JSONB, '192.168.1.100', 'Mozilla/5.0';

INSERT INTO audit_log (actor_user_id, action_type, object_type, object_id, details, ip, user_agent) 
SELECT (SELECT id FROM app_user WHERE email = 'project.manager@example.com' LIMIT 1),
'ASSIGN_USER', 'task_assignment', NULL,
'{"task_id": "task-1", "user_id": "user-1"}'::JSONB, '192.168.1.101', 'Mozilla/5.0';

-- ============================================================================
-- END OF TEST DATA
-- ============================================================================