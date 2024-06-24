SET SESSION FOREIGN_KEY_CHECKS=0;

/* Drop Tables */

DROP TABLE IF EXISTS adksimilar;
DROP TABLE IF EXISTS adkeyword;
DROP TABLE IF EXISTS ad;
DROP TABLE IF EXISTS adminboard;
DROP TABLE IF EXISTS attach;
DROP TABLE IF EXISTS bsimilar;
DROP TABLE IF EXISTS bkeyword;
DROP TABLE IF EXISTS bookmark;
DROP TABLE IF EXISTS positive;
DROP TABLE IF EXISTS recomand;
DROP TABLE IF EXISTS reply;
DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS chat;
DROP TABLE IF EXISTS user;




/* Create Tables */

CREATE TABLE ad
(
	advertno int NOT NULL AUTO_INCREMENT,
	category varchar(50),
	subclass varchar(50),
	productName varchar(255) NOT NULL,
	price varchar(30) NOT NULL,
	imageURL varchar(255) NOT NULL,
	detailURL varchar(255) NOT NULL,
	PRIMARY KEY (advertno)
);


CREATE TABLE adkeyword
(
	adkeyno int NOT NULL AUTO_INCREMENT,
	keyword varchar(50) NOT NULL,
	advertno int NOT NULL,
	PRIMARY KEY (adkeyno)
);


CREATE TABLE adksimilar
(
	adksno int NOT NULL AUTO_INCREMENT,
	adkskey varchar(50),
	adksfr float,
	adkeyno int NOT NULL,
	PRIMARY KEY (adksno)
);


CREATE TABLE adminboard
(
	adno int NOT NULL AUTO_INCREMENT,
	uno int NOT NULL,
	adtitle varchar(50) NOT NULL,
	startday datetime NOT NULL,
	endday datetime NOT NULL,
	pname text,
	fname text,
	PRIMARY KEY (adno)
);


CREATE TABLE attach
(
	ano int NOT NULL AUTO_INCREMENT,
	pname text NOT NULL,
	fname text NOT NULL,
	bno int NOT NULL,
	PRIMARY KEY (ano)
);


CREATE TABLE bkeyword
(
	bkno int NOT NULL AUTO_INCREMENT,
	bkey varchar(25) NOT NULL,
	bkfr int NOT NULL,
	bno int NOT NULL,
	PRIMARY KEY (bkno)
);


CREATE TABLE board
(
	bno int NOT NULL AUTO_INCREMENT,
	uno int NOT NULL,
	btitle varchar(50) NOT NULL,
	bnote text,
	bwdate datetime DEFAULT now(),
	bhit int DEFAULT 0,
	blike int DEFAULT 0,
	bhate int DEFAULT 0,
	season varchar(20) NOT NULL,
	local varchar(20) NOT NULL,
	human varchar(20),
	move varchar(20),
	schedule varchar(20),
	uinout varchar(20),
	unick varchar(25),
	rno int,
	PRIMARY KEY (bno)
);


CREATE TABLE bookmark
(
	mno int NOT NULL AUTO_INCREMENT,
	uno int NOT NULL,
	bno int NOT NULL,
	PRIMARY KEY (mno)
);


CREATE TABLE bsimilar
(
	bsno int NOT NULL AUTO_INCREMENT,
	bskey varchar(25) NOT NULL,
	bsfr float NOT NULL,
	bkno int NOT NULL,
	PRIMARY KEY (bsno)
);


CREATE TABLE chat
(
	cno int NOT NULL AUTO_INCREMENT,
	cnote text NOT NULL,
	cwdate datetime DEFAULT now() NOT NULL,
	uno int NOT NULL,
	PRIMARY KEY (cno)
);


CREATE TABLE positive
(
	bpno int NOT NULL AUTO_INCREMENT,
	bpsent text NOT NULL,
	bposi float NOT NULL,
	bno int NOT NULL,
	PRIMARY KEY (bpno)
);


CREATE TABLE recomand
(
	rcno int NOT NULL AUTO_INCREMENT,
	rcstate int DEFAULT 0 NOT NULL,
	bno int NOT NULL,
	uno int NOT NULL,
	PRIMARY KEY (rcno)
);


CREATE TABLE reply
(
	rno int NOT NULL AUTO_INCREMENT,
	bno int NOT NULL,
	uno int NOT NULL,
	rnote text NOT NULL,
	rwdate datetime DEFAULT now() NOT NULL,
	uicon text,
	PRIMARY KEY (rno)
);


CREATE TABLE user
(
	uno int NOT NULL AUTO_INCREMENT,
	uid varchar(25) NOT NULL,
	upw varchar(100) NOT NULL,
	uname varchar(20) NOT NULL,
	unick varchar(25) NOT NULL,
	email text NOT NULL,
	ujoindate datetime DEFAULT now() NOT NULL,
	uretire char(1) DEFAULT 'N' NOT NULL,
	uicon text,
	season varchar(20) NOT NULL,
	local varchar(20) NOT NULL,
	human varchar(20),
	move varchar(20),
	schedule varchar(20),
	uinout varchar(20),
	admin char(1) DEFAULT 'N',
	ureason char(1),
	ustop char(1) DEFAULT 'N',
	ustopdate int,
	ustopend datetime,
	PRIMARY KEY (uno)
);



/* Create Foreign Keys */

ALTER TABLE adkeyword
	ADD FOREIGN KEY (advertno)
	REFERENCES ad (advertno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE adksimilar
	ADD FOREIGN KEY (adkeyno)
	REFERENCES adkeyword (adkeyno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE bsimilar
	ADD FOREIGN KEY (bkno)
	REFERENCES bkeyword (bkno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE attach
	ADD FOREIGN KEY (bno)
	REFERENCES board (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE bkeyword
	ADD FOREIGN KEY (bno)
	REFERENCES board (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE bookmark
	ADD FOREIGN KEY (bno)
	REFERENCES board (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE positive
	ADD FOREIGN KEY (bno)
	REFERENCES board (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE recomand
	ADD FOREIGN KEY (bno)
	REFERENCES board (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE reply
	ADD FOREIGN KEY (bno)
	REFERENCES board (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE adminboard
	ADD FOREIGN KEY (uno)
	REFERENCES user (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE board
	ADD FOREIGN KEY (uno)
	REFERENCES user (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE bookmark
	ADD FOREIGN KEY (uno)
	REFERENCES user (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE chat
	ADD FOREIGN KEY (uno)
	REFERENCES user (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE recomand
	ADD FOREIGN KEY (uno)
	REFERENCES user (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE reply
	ADD FOREIGN KEY (uno)
	REFERENCES user (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



