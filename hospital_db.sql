create table departments (
dep_id serial primary key,
dept_name varchar(100) not null,
location varchar(100)
);

create table doctors (
doctor_id serial primary key,
name varchar(50) not null,
specialization varchar(100),
dep_id int references departments(dep_id)
);

create table patients (
patient_id serial primary key,
name varchar(50) not null,
email varchar(100) unique,
birth_date date,
gender varchar(10)
);

create table appointments(
appt_id serial primary key,
patient_id int references patients(patient_id),
doctor_id  INT REFERENCES doctors(doctor_id),
appt_date  DATE NOT NULL,
status     VARCHAR(20) DEFAULT 'scheduled'
);


create table MEDICAL_RECORDS (

record_id serial primary key,
patient_id int references patients(patient_id),
doctor_id  INT REFERENCES doctors(doctor_id),
visit_date date DEFAULT CURRENT_DATE,
diagnosis text
);

CREATE TABLE prescriptions (
    presc_id      SERIAL PRIMARY KEY,
    record_id     INT REFERENCES medical_records(record_id),
    medicine      VARCHAR(100) NOT NULL,
    dosage        VARCHAR(50),
    duration_days INT
);


INSERT INTO departments (dept_name, location) VALUES
('Cardiology',    'Building A - Floor 2'),
('Orthopedics',   'Building B - Floor 1'),
('Neurology',     'Building A - Floor 3'),
('Pediatrics',    'Building C - Floor 1');


INSERT INTO doctors (name, specialization, dep_id) VALUES
('Dr. James Wilson',   'Cardiologist',    1),
('Dr. Sarah Connor',   'Cardiologist',    1),
('Dr. Robert Chase',   'Orthopedist',     2),
('Dr. Lisa Cuddy',     'Neurologist',     3),
('Dr. Eric Foreman',   'Neurologist',     3),
('Dr. Allison Cameron','Pediatrician',    4);


INSERT INTO patients (name, email, birth_date, gender) VALUES
('John Smith',    'john@email.com',    '1990-03-15', 'Male'),
('Emily Davis',   'emily@email.com',   '1985-07-22', 'Female'),
('Michael Brown', 'michael@email.com', '2000-11-05', 'Male'),
('Sophia Johnson','sophia@email.com',  '1978-01-30', 'Female'),
('Chris Martin',  'chris@email.com',   '1995-09-18', 'Male');

INSERT INTO appointments (patient_id, doctor_id, appt_date, status) VALUES
(1, 1, '2025-05-01', 'completed'),
(2, 3, '2025-05-05', 'completed'),
(3, 4, '2025-05-10', 'scheduled'),
(4, 2, '2025-05-12', 'completed'),
(5, 6, '2025-05-15', 'cancelled'),
(1, 4, '2025-05-20', 'scheduled');

INSERT INTO medical_records (patient_id, doctor_id, visit_date, diagnosis) VALUES
(1, 1, '2025-05-01', 'High blood pressure'),
(2, 3, '2025-05-05', 'Knee ligament strain'),
(4, 2, '2025-05-12', 'Irregular heartbeat'),
(3, 4, '2025-05-10', 'Migraine');



INSERT INTO prescriptions (record_id, medicine, dosage, duration_days) VALUES
(1, 'Lisinopril',  '10mg once daily',  30),
(1, 'Aspirin',     '81mg once daily',  90),
(2, 'Ibuprofen',   '400mg three daily', 7),
(3, 'Metoprolol',  '25mg twice daily', 60),
(4, 'Sumatriptan', '50mg as needed',   14);

SELECT name, specialization FROM doctors;
SELECT * FROM appointments WHERE status = 'completed';
SELECT name, birth_date FROM patients WHERE gender = 'Male';



SELECT d.name, d.specialization, dept.dept_name
FROM doctors d
JOIN departments dept ON d.dep_id = dept.dep_id;

select p.name as patient, d.name as doctor , a.appt_date,a.status
from appointments a
join patients p on a.patient_id = p.patient_id 
join doctors d on a.doctor_id = d.doctor_id ;


SELECT doc.name, COUNT(*) AS total_appointments
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
GROUP BY doc.name
ORDER BY total_appointments DESC;


SELECT p.name, COUNT(pr.presc_id) AS total_prescriptions
FROM patients p
JOIN medical_records mr ON p.patient_id = mr.patient_id
JOIN prescriptions pr   ON mr.record_id  = pr.record_id
GROUP BY p.name
ORDER BY total_prescriptions DESC;

SELECT dept.dept_name, COUNT(d.doctor_id) AS num_doctors
FROM departments dept
JOIN doctors d ON dept.dep_id = d.dep_id
GROUP BY dept.dept_name
HAVING COUNT(d.doctor_id) > 1;


SELECT DISTINCT p.name
FROM patients p
JOIN appointments a     ON p.patient_id = a.patient_id
JOIN medical_records mr ON p.patient_id = mr.patient_id
WHERE a.status = 'scheduled';


SELECT 
    p.name        AS patient,
    mr.diagnosis,
    pr.medicine,
    pr.dosage,
    pr.duration_days
FROM patients p
JOIN medical_records mr ON p.patient_id = mr.patient_id
JOIN prescriptions pr   ON mr.record_id  = pr.record_id
ORDER BY p.name;


SELECT doc.name, COUNT(*) AS total_diagnoses
FROM doctors doc
JOIN medical_records mr ON doc.doctor_id = mr.doctor_id
GROUP BY doc.name
ORDER BY total_diagnoses DESC
LIMIT 1;


