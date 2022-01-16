select * From t_member;
select * From t_character;
select * From t_athletic;
select * from t_quest where m_id = 'bang9' order by q_seq asc;
select * from t_raid_applier;
select * from t_quest;
select * from t_raid;

-- t_member 테스트 데이터 --
INSERT INTO t_member (m_id, m_pwd, m_gender, m_name, m_nickname, m_email, m_phone, m_push_yn, m_joindate, admin_yn) VALUES ('a', '1', 'M', '임문혁', 'Archer', 'a@naver.com', '010-1234-5678', 'Y', sysdate, 'N');
INSERT INTO t_member (m_id, m_pwd, m_gender, m_name, m_nickname, m_email, m_phone, m_push_yn, m_joindate, admin_yn) VALUES ('admin', 'admin', 'F', '변모씨', 'Warrior', 'bwk@naver.com', '010-1111-2222', 'N', sysdate, 'Y');
INSERT INTO t_member (m_id, m_pwd, m_gender, m_name, m_nickname, m_email, m_phone, m_push_yn, m_joindate, admin_yn) VALUES ('bang9', '123', 'M', '방상혁', '방상혁짱짱맨', 'bang9@naver.com', '010-1234-5678', 'Y', sysdate, 'N');

-- t_character 테스트 데이터 --
INSERT INTO t_character (c_memo, m_id, c_level, c_exp) VALUES ('꾼', 'shj', 1, 0);
INSERT INTO t_character (c_memo, m_id, c_level, c_exp) VALUES ('관리자 캐릭터', 'a', 99, 9999);
INSERT INTO t_character VALUES (T_CHARACTER_SEQ.nextval, '방구', 'bang9', 12, 300);

-- t_athletic 테스트 데이터 --
insert into t_athletic values(T_ATHLETIC_SEQ.nextval,1,2,3,17,sysdate,'bang9', 'pull');

-- t_quest 테스트 데이터 --
insert into t_quest (q_name, q_cnt, q_check, q_exp, reg_date, m_id, q_label) VALUES('푸쉬업을 20개 하세요!', 10, 'N', 100, sysdate, 'bang9', 0);
insert into t_quest (q_name, q_cnt, q_check, q_exp, reg_date, m_id, q_label) VALUES('풀업을 5개 하세요!', 5, 'N', 300, sysdate, 'bang9', 1);
insert into t_quest (q_name, q_cnt, q_check, q_exp, reg_date, m_id, q_label) VALUES('스쿼트를 15개 하세요!', 15, 'N', 150, sysdate, 'bang9', 2);
insert into t_quest (q_name, q_check, q_exp, reg_date, m_id, q_label) VALUES('보너스', 'N', 50, sysdate, 'bang9', 3);
insert into t_quest (q_name, q_check, q_exp, reg_date, m_id, q_label) VALUES('잠자기', 'N', 70, sysdate, 'bang9', 4);

delete from t_quest where m_id = 'bang9' and q_seq BETWEEN 4 and 20;
delete from t_quest where m_id = 'bang9';

-- 레이드 어플라이어 테스트 데이터 --
insert into t_raid_applier (m_id, reg_date, applier_record, applier_exp, raid_seq) 
values('a', sysdate, 750, 0, 12);

insert into t_athletic (timeattack_rec, M_ID, TIME_MODE) values('2', 'a', 'squart');



insert into t_raid values(12, '풀업레이드', 1500, sysdate, 'a');




select sum(applier_record) from t_raid_applier where raid_seq = 12;

select * from (select * from T_RAID order by RAID_SEQ desc) where rownum < 4;

-- 레이드 테이블에 컬럼 추가
alter table T_RAID add(raid_kind varchar2(50));

select m_id, to_char(reg_date,'yyyymmdd') as TODAY, sum(pushup_cnt) as PUSH, sum(pullup_cnt) as PULL, sum(squat_cnt) as SQUART 
from t_athletic 
where to_char(reg_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd') AND m_id = 'bang9' group by m_id, to_char(reg_date,'yyyymmdd');

select m_id, q_cnt, q_check, q_label from t_quest where m_id ='bang9' and q_label = 0;


commit;
rollback;