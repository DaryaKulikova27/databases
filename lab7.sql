USE [university]

-- 1.�������� ������� �����
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


-- 2. ������ ������ ��������� �� ����������� ���� ��� ��������� ������� ��������. �������� ������ ������ � �������������� view.
CREATE VIEW students_information AS
SELECT * FROM mark
JOIN [student] ON student.id_student = [mark].id_student
JOIN lesson ON lesson.id_lesson = [mark].id_lesson
JOIN [subject] ON lesson.id_subject = [subject].id_subject
WHERE ([subject].name = '�����������')
GO
SELECT students_information.mark, students_information.name
FROM students_information;


-- 3. ���� ���������� � ��������� � ��������� ������� �������� � �������� ��������. 
--���������� ��������� ��������, �� ������� ������ �� ��������, ������� ������� � ������. �������� � ���� ���������, �� ����� ������������� ������.
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


-- 4. ���� ������� ������ ��������� �� ������� �������� ��� ��� ���������, �� ������� ���������� �� ����� 35 ���������

-- 5. ���� ������ ��������� ������������� �� �� ���� ���������� ��������� � ��������� ������, �������, ��������, ����. ��� ���������� ������ ��������� ���������� NULL ���� ������

-- 6. ���� ��������� ������������� ��, ���������� ������ ������� 5 �� �������� �� �� 12.05, �������� ��� ������ �� 1 ����

-- 7. �������� ����������� �������