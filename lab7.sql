USE [university]

-- 1.Добавить внешние ключи
ALTER TABLE student
   ADD CONSTRAINT FK_group_student FOREIGN KEY (id_group)
      REFERENCES [group] (id_group)
;

ALTER TABLE lesson
   ADD CONSTRAINT FK_teacher_lesson FOREIGN KEY (id_teacher)
      REFERENCES [teacher] (id_teacher)
;

ALTER TABLE lesson
   ADD CONSTRAINT FK_subject_lesson FOREIGN KEY (id_subject)
      REFERENCES [subject] (id_subject)
;

ALTER TABLE lesson
   ADD CONSTRAINT FK_group_lesson FOREIGN KEY (id_group)
      REFERENCES [group] (id_group)
;

ALTER TABLE mark
   ADD CONSTRAINT FK_lesson_mark FOREIGN KEY (id_lesson)
      REFERENCES [lesson] (id_lesson)
;

ALTER TABLE mark
   ADD CONSTRAINT FK_student_mark FOREIGN KEY (id_student)
      REFERENCES [student] (id_student)
;


-- 2. Выдать оценки студентов по информатике если они обучаются данному предмету. Оформить выдачу данных с использованием view.
CREATE VIEW students_information AS
SELECT * FROM mark
JOIN [student] ON student.id_student = [mark].id_student
JOIN lesson ON lesson.id_lesson = [mark].id_lesson
JOIN [subject] ON lesson.id_subject = [subject].id_subject
WHERE ([subject].name = 'Информатика')
GO
SELECT students_information.mark, students_information.name
FROM students_information;


-- 3. Дать информацию о должниках с указанием фамилии студента и названия предмета. 
--Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе. Оформить в виде процедуры, на входе идентификатор группы.
CREATE PROCEDURE FindDebtor
(
    @id_group INT = NULL
)
AS
BEGIN 
    SELECT [student].name, [subject].name
	FROM [group]
	JOIN student ON [student].id_group = @id_group
	JOIN lesson ON lesson.id_group = @id_group
	JOIN [subject] ON [subject].id_subject = lesson.id_subject
	RIGHT JOIN mark ON lesson.id_lesson = lesson.id_lesson
	WHERE ([mark].mark = NULL)
END 
GO
FindDebtor 1;


-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по которым занимается не менее 35 студентов

-- 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить значениями NULL поля оценки

-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, повысить эти оценки на 1 балл

-- 7. Добавить необходимые индексы