CREATE DATABASE alumni_management;
use alumni_management;

CREATE TABLE alumni (
    al_no INT NOT NULL AUTO_INCREMENT,
    al_name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    qualification VARCHAR(100),
    pass_year INT,
    addr VARCHAR(255),
    contact VARCHAR(15) NOT NULL UNIQUE,
    city VARCHAR(100),
    reg_date DATE,
    company_name VARCHAR(150),
    designation VARCHAR(100), 
    salary DECIMAL(10,2),
    PRIMARY KEY (al_no)
);
  
CREATE TABLE event (
    ev_id INT NOT NULL AUTO_INCREMENT,
    ev_title VARCHAR(100),
    description TEXT,
    date DATE,
    time TIME,
    PRIMARY KEY (ev_id)
);

CREATE TABLE al_ev (
    al_no INT NOT NULL,
    ev_id INT NOT NULL,
    reg_date DATE,
    PRIMARY KEY (al_no, ev_id),
    FOREIGN KEY (al_no) REFERENCES alumni(al_no) ON DELETE CASCADE,
    FOREIGN KEY (ev_id) REFERENCES event(ev_id) ON DELETE CASCADE
);


CREATE TABLE lecture_schedule (
    lec_id INT AUTO_INCREMENT PRIMARY KEY,
    alumni_id INT NOT NULL, 
    email VARCHAR(150) NOT NULL,
    topic VARCHAR(255) NOT NULL,
    selected_date DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alumni_id) REFERENCES alumni(al_no) ON DELETE CASCADE
);

CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    admin_reply TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE admin (
    email VARCHAR(255),
    password VARCHAR(255) NOT NULL UNIQUE
);
-- Insert into alumni table
INSERT INTO alumni (al_name, email, qualification, pass_year, addr, contact, city, reg_date, company_name, designation, salary)
VALUES
();

-- Insert into event table
INSERT INTO event (ev_title, description, date, time) VALUES
();

-- Insert values into al_ev table
INSERT INTO al_ev (al_no, ev_id, reg_date) VALUES
();

-- Insert values into event_registrations table
INSERT INTO event_registrations (al_no, ev_id, reg_date) VALUES
();


-- Insert into lecture_schedule table
INSERT INTO lecture_schedule (alumni_id, topic, selected_date, status)
VALUES
();

-- Insert into admin table
INSERT INTO admin (email, password) VALUES
();
