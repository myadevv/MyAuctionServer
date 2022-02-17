INSERT INTO memberList(ID, pwd, name, contact, address)
VALUE ("2116zzang", SHA2("1234321", 256), "정길호", "010-2565-2116", "경북 상주시 가장동 706번지 미소빌 203호");

SELECT * FROM memberList WHERE id = "2116zzang" AND pwd = SHA2("1234321", 256);

INSERT INTO productList(title, description, defaultImage, currentPoint, registerDate, endDate, sellerName, sellerID, payment)
VALUE ("testtesttesttesttesttesttest", "ㄻㅇㄻㄻㄻㄻㄹㅇㄹㅇㄹㄹㅇㄹ", "A1.jpg", 5500, "2020-11-15 12:00:00", "2020-11-16 14:00:00", "정길호", "2116zzang", 1 );

INSERT INTO productList(title, description, defaultImage, currentPoint, registerDate, endDate, sellerName, sellerID, payment)
VALUE ("BHC 캘린더 팝니다@@@@@@", "ㄻㅇㄻㄻㄻㄻㄹㅇㄹㅇㄹㄹㅇㄹ", "KakaoTalk_20201115_011001809.jpg", 20000, "2020-11-15 12:00:00", "2020-11-16 14:00:00", "정길호", "2116zzang", 1 );


SELECT * FROM productList;
SELECT * FROM payRelation;