create database school;
use school;


create table  user(
user_id int auto_increment primary key,
username varchar (60) not null,
 user_password varchar (30) not null,
 role enum("Teacher","Student") not null
 );

 create table notice (
 notice_id int auto_increment primary key,
 title varchar (30) not null,
 content varchar (40) not null, 
 created_by varchar(30) NOT NULL,
 created_at DATETIME  DEFAULT(current_timestamp)
 );


insert into user(user_id,username,user_password,role) values
 (1, 'prof_sharma',   'teach@123', 'teacher'),
 (2, 'prof_mehta',    'teach@456', 'teacher'),
 (3, 'prof_verma',    'teach@789', 'teacher'),
(4, 'rahul_student', 'stud@123',  'student'),
(5, 'priya_student', 'stud@456',  'student'),
 (6, 'amit_student',  'stud@789',  'student');

 insert into notice(notice_id,title,content,created_by,created_at)  values
(1, 'Annual Sports Day',      'Held on 5th June at 8AM.',   1, '2025-05-01 09:00:00'),
 (2, 'Exam Schedule Released', 'Exams start from 15th May.', 1, '2025-05-02 10:30:00'),
 (3, 'Library Closure Notice', 'Closed Saturday for work.',  2, '2025-05-03 11:00:00'),
(4, 'Workshop on AI & ML',    'Workshop on 20th-21st May.', 2, '2025-05-04 12:00:00'),
 (5, 'Fee Payment Reminder',   'Last date is 20th May.',     3, '2025-05-05 09:30:00'),
 (6, 'College Holiday Notice', 'Holiday on 12th May.',       3, '2025-05-06 08:00:00');
 
 
 
-- 1 registeruser--  
 DELIMITER $$
 create procedure registeruser(in p_username VARCHAR(100),in  p_user_password VARCHAR(255),
in p_role enum("Teacher", "Student"))
 BEGIN
if exists  (select  1  from user where username = p_username) then 
select 'Error: Username already exists.' as message;
else
 insert into user (username, user_password, role)
 values (p_username, p_user_password, p_role);
 select 'User registered successfully.' as message;
 end if;
 END$$

 DELIMITER ;
call registeruser('priya','student456','student');


-- 2 userlogin-- 


  DELIMITER $$
create procedure userlogin(in p_username varchar(50),in p_user_password VARCHAR(40))
 BEGIN
 declare v_count int;
 select COUNT(*) into v_count
 from user
where username = p_username and user_password = p_user_password;
  if v_count = 0 then
 	select 'Error: Invalid username or password.' as message;
 else
 select user_id,username,role,'Login successful.' AS message
 from user
where username = p_username and user_password = p_user_password;
 end if;
 END$$
 DELIMITER ;
call userlogin('priya',"student456");


-- -- 3createnotice

 DELIMITER $$

create procedure createnotice(in p_user_id int,in p_title varchar(50),in p_content varchar(70))
 BEGIN
 insert into notice (title, content, created_by)values(p_title, p_content, p_user_id);
 select 'Notice created successfully.' as message;
 END$$

DELIMITER ;

call createnotice(1, 'Exam Schedule Released');



-- 5 viewnotice--     

 DELIMITER $$
 
   create procedure viewnotice()
 BEGIN
 select n.notice_id,n.title,n.content,u.username as created_by,n.created_at
 from notice n
join user u on n.created_by = u.user_id
  order by n.created_at DESC;
 END$$
 DELIMITER ;
 
 
 
 

-- 6)updatenotice-------------------------------
 delimiter $$
create procedure updatenotice(in p_user_id   int,in p_notice_id int,in p_title varchar(50),
 in p_content varchar(100))
begin
  if not exists (select 1 from notice where notice_id = p_notice_id) then
 select 'Error: Notice not found.' as message;
else
 update notice
 set title = p_title,content = p_content where notice_id = p_notice_id;
 select 'Notice updated successfully.' as message;
 end if;
end$$
 delimiter ;


 drop procedure updatenotice;
 call updatenotice( 1,1, 'Annual Sports Day - UPDATED',
   'Annual Sports Day .');
    
    
--     deletenotices-- 
    delimiter $$
create procedure deletenotice(in p_user_id int,in p_notice_id int)
begin
    if not exists (select 1 from notice where notice_id = p_notice_id) then
        select 'Error: Notice not found.' as message;
    else
        delete from notice
        where notice_id = p_notice_id;
        select 'Notice deleted successfully.' as message;
    end if;
end$$
delimiter ;
call deletenotice(1, 3);