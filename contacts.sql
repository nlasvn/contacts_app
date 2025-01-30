CREATE TABLE contacts(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first TEXT NOT NULL,
    last TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT NOT NULL) STRICT;

INSERT INTO contacts(first, last, phone, email)
VALUES('Marisa', 'Kirisame', '123-456-789', 'kirisame_marisa@example.com');

INSERT INTO contacts(first, last, phone, email)
VALUES('Reimu', 'Hakurei', '234-567-890', 'reimu_hakurei@example.com');

INSERT INTO contacts(first, last, phone, email)
VALUES('Sakuya', 'Izayoi', '231-445-123', 'izayoi_sakuya@example.com');

INSERT INTO contacts(first, last, phone, email)
VALUES('Yuyuko', 'Saigyouji', '543-123,876', 'yuyuko_saigyouji@example.com');

INSERT INTO contacts(first, last, phone, email)
VALUES('Youmu', 'Konpaku', '654-324-785', 'youmu_konpaku@example.com');

INSERT INTO contacts(first, last, phone, email)
VALUES('Sanae', 'Kochiya', '765-382-548', 'sanae_kochiya@example.com');