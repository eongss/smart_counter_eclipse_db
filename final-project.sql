select * From t_member;
select * From t_character;
select * From t_athletic;
select * from t_quest;

select to_char(reg_date,'yyyymmdd')from t_athletic;

-- 날짜 쿼리 중요!! --
select * from t_athletic where to_char(reg_date,'yyyymmdd') = '20211215' AND m_id = 'bang9';

-- 통산 기록 쿼리 --
select m_id, sum(pushup_cnt) as PUSH, sum(pullup_cnt) as PULL, sum(squat_cnt) as SQUART 
from t_athletic
where m_id = 'bang9'
group by m_id;

-- 통산 타임어택 최고기록 쿼리(풀업) --
select max(timeattack_rec) as TIMEATTACK
    from t_athletic
    where m_id = 'bang9' AND time_mode = 'pull';

select * from t_athletic;

select a_seq, timeattack_rec 
from t_athletic where a_seq = (select max(a_seq) from t_athletic) 
AND m_id = 'bang9';

select max(a_seq) from t_athletic where m_id = 'bang9';
select a_seq from t_athletic where m_id = 'bang9';

select max(timeattack_rec)
from t_athletic
where to_char(reg_date,'yyyymmdd') = '20211215';


-- 해당 아이디당 날짜별 최고 타임어택기록
select adate, max(timeattack_rec) as TIME_REC
from (
    select to_char(sysdate,'yyyymmdd') as adate, timeattack_rec
    from t_athletic
    where m_id = 'bang9' AND to_char(reg_date,'yyyymmdd') = '20211224' AND time_mode = 'pull'
    )
group by adate;




select * from t_athletic;

-- 메인화면 타임어택 최고기록 
select max(timeattack_rec)
from t_athletic
where m_id = 'bang9';

commit;

-- 기록 테이블에 컬럼 추가
alter table t_athletic add(time_mode varchar2(50));

-- 캐릭터 레벨, 경험치 불러오기
select m_id, c_level, c_exp from t_character where m_id='bang9';

-- 캐릭터 닉네임 불러오기
select m_id, m_nickname from t_member where m_id='bang9';

-- 캐릭터 관련 데이터 조인
select a.m_id, a.c_level, a.c_exp, b.m_nickname
from t_character a, t_member b
where a.m_id = b.m_id 
AND b.m_id = 'bang9';

-- 퀘스트 테이블 컬럼명 변경
alter table t_quest rename column q_calory to q_exp;

-- 퀘스트 테이블 커멘트 수정
comment on table t_quest is '퀘스트 테이블';

-- 퀘스트 테이블 q_exp 커멘트 수정
comment on column t_quest.q_exp is '퀘스트 경험치';

commit;

-- 시퀀스 관련
select last_number from user_sequences where sequence_name='T_QUEST_SEQ';
alter sequence T_QUEST_SEQ increment by -21;
select T_QUEST_SEQ.nextval from dual;

-- 시퀀스 드랍
drop sequence T_QUEST_SEQ;

-- 시퀀스 생성
create sequence T_QUEST_SEQ
minvalue 1
maxvalue 99999
start with 1
increment by 1
cache 20;

-- 퀘스트 테이블 조회
select to_char(sysdate, 'yyyymmdd') as current_date, q_name, q_cnt, q_check, q_exp, q_label from t_quest where m_id = 'bang9' order by q_seq asc;

select * from t_quest where m_id = 'bang9';

-- 퀘스트 테이블 Q_CNT칼럼 디폴트값 수정
alter table t_quest modify (Q_CNT default 0);

alter table t_quest add q_label number(12,0); 

select * from (select * from T_RAID order by RAID_SEQ desc) where rownum < 4;
--select * from T_RAID;

select a.m_id, a.c_level 
from t_character a;

select b.m_id, b.q_exp, b.q_check 
from t_quest b
where b.q_check = 'Y';




select a.m_id, a.c_level, b.q_exp, b.q_check
from t_character a, t_quest b
where a.m_id = b.m_id(+);


select *
from (select a.m_id, a.c_level, b.q_exp, b.q_check
from t_character a, t_quest b
where a.m_id = b.m_id(+)
and not a.m_id = 'admin');
--where q_check = 'Y';


-- 퀘스트 테이블 + 레이드 어플라이어 조인
select b.m_id, b.q_exp, c.applier_exp
from t_quest b, t_raid_applier c
where b.m_id = c.m_id
and b.q_check = 'Y'
and c.raid_seq = 12;


-- 서브쿼리(퀘스트 테이블 + 레이드 어플라이어 조인) 이용한 m_id로 그룹바이
select m_id, sum(q_exp+applier_exp) as total_exp
from (select b.m_id, b.q_exp, c.applier_exp
        from t_quest b, t_raid_applier c
        where b.m_id = c.m_id
        and b.q_check = 'Y'
        and c.raid_seq = 12)
GROUP BY m_id
order by total_exp desc;

-- 위에 문장을 서브쿼리를 이용해서 rownum < 4 줌(위에서는 적용 안됨)
select * from (select m_id, sum(q_exp+applier_exp) as total_exp
from (select b.m_id, b.q_exp, c.applier_exp
        from t_quest b, t_raid_applier c
        where b.m_id = c.m_id
        and b.q_check = 'Y'
        and c.raid_seq = 12)
GROUP BY m_id)
where ROWNUM < 4
order by total_exp desc;



-- 퀘스트 테이블 + 레이드 어플라이어 조인
select b.m_id, b.q_exp, c.applier_exp
from t_quest b, t_raid_applier c
where b.m_id = c.m_id
and b.q_check = 'Y'
and c.raid_seq = 12;

select a.m_id, a.c_level, b.q_exp, b.q_check
from t_character a, (select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b
where a.m_id = b.m_id(+)
and not a.m_id = 'admin';

select c.m_id, c.applier_exp
from T_RAID_APPLIER c
where c.raid_seq = 12;

-- 중복 되는 데이터 없이 테이블 3개 조인 --
select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp
from t_character a, (select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp
from T_RAID_APPLIER c
where c.raid_seq = 12) c
where a.m_id = b.m_id(+)
and b.m_id = c.m_id(+)
and not a.m_id = 'admin'
order by m_id;

-- 아래 문장을 서브쿼리를 이용해서 rownum < 4 줌(위에서는 적용 안됨)
select * from (
select m_id, c_level, sum(q_exp+applier_exp) as total_exp
from (
select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp
from t_character a, 
(select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b, 
(select c.m_id, c.applier_exp
from T_RAID_APPLIER c where c.raid_seq = 12) c
where a.m_id = b.m_id(+)
and b.m_id = c.m_id(+)
and not a.m_id = 'admin'
order by m_id)
GROUP BY m_id, c_level)
where ROWNUM < 4
and total_exp is not null
order by total_exp desc;

select * from (select m_id, c_level, sum(q_exp+applier_exp) as total_exp from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp from t_character a, (select b.m_id, b.q_exp, b.q_check from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp from T_RAID_APPLIER c where c.raid_seq = 12) c where a.m_id = b.m_id(+) and b.m_id = c.m_id(+) and not a.m_id = 'admin' order by m_id) GROUP BY m_id, c_level) where ROWNUM < 4 and total_exp is not null order by total_exp desc;

select m_id, c_level, sum(q_exp+applier_exp) as total_exp
from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp
from t_character a, (select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp
from T_RAID_APPLIER c
where c.raid_seq = 12) c
where a.m_id = b.m_id(+)
and b.m_id = c.m_id(+)
and not a.m_id = 'admin'
order by m_id)
GROUP BY m_id, c_level;


select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp
from t_character a, (select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp
from T_RAID_APPLIER c
where c.raid_seq = 12) c
where a.m_id = b.m_id(+)
and b.m_id = c.m_id(+)
and not a.m_id = 'admin'
order by m_id;


select a.m_nickname, b.c_level, b.total_exp
from t_member a, (select * from (
select m_id, c_level, sum(q_exp+applier_exp) as total_exp
from (
select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp
from t_character a, 
(select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b, 
(select c.m_id, c.applier_exp
from T_RAID_APPLIER c where c.raid_seq = 12) c
where a.m_id = b.m_id(+)
and b.m_id = c.m_id(+)
and not a.m_id = 'admin'
order by m_id)
GROUP BY m_id, c_level)
where ROWNUM < 4
and total_exp is not null
order by total_exp desc) b
where a.m_id = b.m_id;

select * from (
select m_id, c_level, sum(q_exp+applier_exp) as total_exp
from (
select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp
from t_character a, 
(select b.m_id, b.q_exp, b.q_check 
from t_quest b where b.q_check = 'Y') b, 
(select c.m_id, c.applier_exp
from T_RAID_APPLIER c where c.raid_seq = 12) c
where a.m_id = b.m_id(+)
and b.m_id = c.m_id(+)
and not a.m_id = 'admin'
order by m_id)
GROUP BY m_id, c_level)
where ROWNUM < 4
and total_exp is not null
order by total_exp desc;

select a.m_nickname, b.c_level, b.total_exp from t_member a, (select * from (select m_id, c_level, sum(q_exp+applier_exp) as total_exp from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp from t_character a, (select b.m_id, b.q_exp, b.q_check from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp from T_RAID_APPLIER c where c.raid_seq = 12) c where a.m_id = b.m_id(+) and b.m_id = c.m_id(+) and not a.m_id = 'admin' order by m_id) GROUP BY m_id, c_level) where total_exp is not null order by total_exp desc) b where a.m_id = b.m_id;


-- 랭킹 리스트 데이터(최종) --
select rowNum, a.m_nickname, b.c_level, b.total_exp from t_member a, (select * from (select m_id, c_level, sum(q_exp+applier_exp) as total_exp from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp from t_character a, (select b.m_id, b.q_exp, b.q_check from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp from T_RAID_APPLIER c where c.raid_seq = 12) c where a.m_id = b.m_id(+) and b.m_id = c.m_id(+) and not a.m_id = 'admin' order by m_id) GROUP BY m_id, c_level) order by total_exp desc) b where a.m_id = b.m_id;
select a.m_nickname, b.c_level, b.total_exp from t_member a, (select * from (select m_id, c_level, sum(q_exp+applier_exp) as total_exp from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp from t_character a, (select b.m_id, b.q_exp, b.q_check from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp from T_RAID_APPLIER c where c.raid_seq = 12) c where a.m_id = b.m_id(+) and b.m_id = c.m_id(+) and not a.m_id = 'admin' order by m_id) GROUP BY m_id, c_level) where total_exp is not null order by total_exp desc) b where a.m_id = b.m_id;

select rowNum, a.m_nickname, b.c_level, b.total_exp from t_member a, (select * from (select m_id, c_level, sum(q_exp+applier_exp) as total_exp from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp from t_character a, (select b.m_id, b.q_exp, b.q_check from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp from T_RAID_APPLIER c where c.raid_seq = 12) c where a.m_id = b.m_id(+) and b.m_id = c.m_id(+) and not a.m_id = 'admin' order by m_id) GROUP BY m_id, c_level) where total_exp is not null order by total_exp desc) b where a.m_id = b.m_id;
commit;

SELECT a.m_nickname, b.c_level, b.total_exp 
FROM t_member a, (SELECT * FROM 
(SELECT m_id, c_level, SUM(q_exp + applier_exp) AS total_exp FROM (SELECT a.m_id,
 a.c_level, b.q_exp, b.q_check, c.applier_exp FROM t_character a, 
 (SELECT b.m_id, b.q_exp, b.q_check FROM t_quest b WHERE b.q_check = 'Y') b, 
 (SELECT c.m_id, c.applier_exp FROM t_raid_applier c WHERE c.raid_seq = 12) c 
 WHERE a.m_id = b.m_id(+) AND b.m_id = c.m_id(+) AND NOT a.m_id = 'admin' ORDER BY m_id) 
GROUP BY m_id, c_level) 
ORDER BY total_exp DESC) b 
WHERE a.m_id = b.m_id;

-- 가데이터(지금 넣어놓은것)
select rowNum, a.m_nickname, b.c_level, b.total_exp from t_member a, (select * from (select m_id, c_level, sum(q_exp+applier_exp) as total_exp from (select a.m_id, a.c_level, b.q_exp, b.q_check, c.applier_exp from t_character a, (select b.m_id, b.q_exp, b.q_check from t_quest b where b.q_check = 'Y') b, (select c.m_id, c.applier_exp from T_RAID_APPLIER c where c.raid_seq = 12) c where a.m_id = b.m_id(+) and b.m_id = c.m_id(+) and not a.m_id = 'admin' order by m_id) GROUP BY m_id, c_level) order by total_exp desc) b where a.m_id = b.m_id;

select q.m_id, sum(r.applier_exp+q.q_exp) as exp 
from t_quest q, t_raid_applier r
where q.m_id = r.m_id and q.q_check = 'Y'
group by q.m_id;

select m_id, q_exp from t_quest where q_check = 'Y';
select m_id, applier_exp from t_raid_applier;

select * from t_member;

select * from t_character;

-- 닉네임 + 캐릭터 총경험치 조인한 테이블(랭크 부분에 사용)-- 
select ROWNUM, temp.*
from (select a.m_nickname, b.m_id, b.c_exp
from t_member a, t_character b
where a.m_id = b.m_id
order by b.c_exp desc) temp;

select a.m_nickname, b.m_id, b.c_exp
from t_member a, t_character b
where a.m_id = b.m_id
order by b.c_exp desc;



select m_id, c_exp, trunc(c_exp/100) lv, mod(c_exp,100) exp
from t_character 
order by c_exp desc;

-- 닉네임 + 캐릭터 총경험치 + 레벨 + 필경 조인한 테이블 -- 
select ROWNUM, temp.*
from (select a.m_nickname, b.m_id, b.c_exp, b.lv, b.n_exp
from t_member a, (select m_id, c_exp, trunc(c_exp/100) lv, mod(c_exp,100) n_exp
from t_character) b
where a.m_id = b.m_id
order by b.c_exp desc) temp;

-- 랭크에 사용하는 쿼리 (주간경험치가 아니라 총경험치임)--
select ROWNUM, temp.*
from (select a.m_nickname, b.m_id, b.c_exp, b.lv
from t_member a, (select m_id, c_exp, trunc(c_exp/100+1) lv
from t_character) b
where a.m_id = b.m_id
order by b.c_exp desc) temp;

commit;

select ROWNUM, temp.* from (select a.m_nickname, b.m_id, b.c_exp, b.lv from t_member a, (select m_id, c_exp, trunc(c_exp/100) lv from t_character) b where a.m_id = b.m_id order by b.c_exp desc) temp;

-- 자바 서블릿 CharExp()에 쓰는 쿼리 -- 
select m_id, c_exp from t_character where m_id = 'bang9';

select m_id, m_nickname from t_member where m_id = 'bang9';

-- 누적횟수 쿼리 --
select m_id, sum(pushup_cnt) push_cnt, sum(pullup_cnt) pull_cnt, sum(squat_cnt) squat_cnt
from t_athletic
where m_id = 'bang9'
group by m_id;

select m_id, timeattack_rec
from t_athletic
where m_id = 'bang9' and time_mode = 'pull'
order by timeattack_rec desc;




-- 타임어택 최고기록 쿼리 --
select a.m_id, a.pull_tcnt, b.push_tcnt, c.squart_tcnt 
from (select m_id, timeattack_rec pull_tcnt
from t_athletic
where m_id = 'bang9' and time_mode = 'pull'
order by timeattack_rec desc) a, (select m_id, timeattack_rec push_tcnt
from t_athletic
where m_id = 'bang9' and time_mode = 'push'
order by timeattack_rec desc) b, (select m_id, timeattack_rec squart_tcnt
from t_athletic
where m_id = 'bang9' and time_mode = 'squart'
order by timeattack_rec desc) c
where a.m_id = b.m_id
and b.m_id = c.m_id
and rownum < 2;










-- 스텟 쿼리 --
select a.*, z.push_tcnt, z.pull_tcnt, z.squart_tcnt 
from (select m_id, sum(pushup_cnt) push_cnt, sum(pullup_cnt) pull_cnt, sum(squat_cnt) squat_cnt
from t_athletic
where m_id = 'bang9'
group by m_id) a, (select a.m_id, a.pull_tcnt, b.push_tcnt, c.squart_tcnt 
from (select m_id, timeattack_rec pull_tcnt
from t_athletic
where m_id = 'bang9' and time_mode = 'pull'
order by timeattack_rec desc) a, (select m_id, timeattack_rec push_tcnt
from t_athletic
where m_id = 'bang9' and time_mode = 'push'
order by timeattack_rec desc) b, (select m_id, timeattack_rec squart_tcnt
from t_athletic
where m_id = 'bang9' and time_mode = 'squart'
order by timeattack_rec desc) c
where a.m_id = b.m_id
and b.m_id = c.m_id
and rownum < 2) z
where a.m_id = z.m_id;

select a.*, z.push_tcnt, z.pull_tcnt, z.squart_tcnt from (select m_id, sum(pushup_cnt) push_cnt, sum(pullup_cnt) pull_cnt, sum(squat_cnt) squart_cnt from t_athletic where m_id = 'bang9' group by m_id) a, (select a.m_id, a.pull_tcnt, b.push_tcnt, c.squart_tcnt from (select m_id, timeattack_rec pull_tcnt from t_athletic where m_id = 'bang9' and time_mode = 'pull' order by timeattack_rec desc) a, (select m_id, timeattack_rec push_tcnt from t_athletic where m_id = 'bang9' and time_mode = 'push' order by timeattack_rec desc) b, (select m_id, timeattack_rec squart_tcnt from t_athletic where m_id = 'bang9' and time_mode = 'squart' order by timeattack_rec desc) c where a.m_id = b.m_id and b.m_id = c.m_id and rownum < 2) z where a.m_id = z.m_id;

select * from t_athletic
where m_id = 'bang9';

-- 오늘 날짜(yyyyMMdd) 그룹바이 해서 총 카운트 갯수 합산한것
select m_id, to_char(reg_date,'yyyymmdd')as TODAY, sum(pushup_cnt) as PUSH, sum(pullup_cnt) as PULL, sum(squat_cnt) as SQUART 
from t_athletic
where to_char(reg_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd') AND m_id = 'bang9'
group by m_id, to_char(reg_date,'yyyymmdd');
--where to_char(reg_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd') AND m_id = 'bang9';

-- q_label 0 -> 푸쉬업 계열
select m_id, q_cnt, q_check, q_label, q_exp from t_quest
where m_id = 'bang9' and q_label = 1;


-- q_cnt >= push 이상이면 q_check = 'N'을 -> 'Y'로 업데이트
update t_quest set q_check = 'N' where m_id = 'bang9' and q_label = 1;


commit;

select * from t_quest;



-- 업데이트된 경험치 적용 예제 --
update t_character 
set c_exp = (select sum(c_exp+300) updated_exp 
from t_character
where m_id = 'bang9')
where m_id = 'bang9';

-- updated_exp --
select sum(c_exp+300) updated_exp 
from t_character
where m_id = 'bang9';

-- 레이드 어플라이어 레코드 업데이트 --
update t_raid_applier
set applier_record = (select sum(applier_record+1)
from t_raid_applier
where m_id = 'bang9' and raid_seq = 12)
where m_id = 'bang9' and raid_seq = 12;
commit;

select * from t_raid_applier;

select * from t_character;


select * from t_quest where m_id='bang9' order by q_seq asc;

rollback;


select a.*, z.push_tcnt, z.pull_tcnt, z.squart_tcnt
from (select m_id, sum(pushup_cnt) push_cnt, sum(pullup_cnt) pull_cnt, sum(squat_cnt) squart_cnt 
        from t_athletic 
        where m_id = 'bang9' 
        group by m_id) a,
        (select a.m_id, a.pull_tcnt, b.push_tcnt, c.squart_tcnt 
        from (select m_id, timeattack_rec pull_tcnt 
                from t_athletic 
                where m_id = 'bang9' 
                and time_mode = 'pull' 
                order by timeattack_rec desc) a,
                (select m_id, timeattack_rec push_tcnt 
                    from t_athletic 
                    where m_id = 'bang9' 
                    and time_mode = 'push' 
                    order by timeattack_rec desc) b, 
                    (select m_id, timeattack_rec squart_tcnt 
                    from t_athletic 
                    where m_id = 'bang9' 
                    and time_mode = 'squart' 
                    order by timeattack_rec desc) c 
            where a.m_id = b.m_id 
            and b.m_id = c.m_id 
            and rownum < 2) z 
            where a.m_id = z.m_id;

<-- b,c

<--B
select m_id, timeattack_rec push_tcnt 
from t_athletic 
where m_id = 'bang9' 
and time_mode = 'push' 
order by timeattack_rec desc

<-- C                    
select m_id, timeattack_rec squart_tcnt 
from t_athletic 
where m_id = 'bang9' 
and time_mode = 'squart' 
order by timeattack_rec desc


insert into t_athletic values(T_ATHLETIC_SEQ.nextval,0,0,0,30,'2021-12-24 12:53:11','bang9', 'pull');
insert into t_athletic values(T_ATHLETIC_SEQ.nextval,0,0,0,62,'2021-12-24 12:53:11','bang9', 'squart');
insert into t_athletic values(T_ATHLETIC_SEQ.nextval,0,0,0,42,'2021-12-13 12:53:11','bang9', 'squart');
commit
