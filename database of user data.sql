CREATE DATABASE timetable_db;

USE timetable_db;

CREATE TABLE user_timetable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    occupation VARCHAR(50),
    days TEXT,
    subjects TEXT,
    occupied_start TIME,
    occupied_end TIME,
    sleep_time TIME,
    study_hours INT
);
