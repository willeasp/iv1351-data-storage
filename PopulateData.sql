/*  
    Author: William Asp

    How to insert data into tables:

    INSERT INTO table_name(column1, column2, …)
    VALUES (value1, value2, …); 

*/
BEGIN;

/* Insert 6 people */
INSERT INTO person ( person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                "199903045555",
                "William",
                "Asp",
                "0761461400",
                "wille@mail.com",
                "Brommavägen",
                "95",
                "16835",
                "Bromma"
            );

INSERT INTO person( person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                "200107213475",
                "Moa",
                "Malmström",
                "0702346613",
                "moa@mail.com",
                "Nilegårdsvägen",
                "5b",
                "66890",
                "Blattnicksele"
            )

INSERT INTO person( person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                "200005167821",
                "Johannes",
                "Valck",
                "0709383159",
                "joppev@hotmail.nu",
                "Beämexvägen",
                "69",
                "42069"
                "Backflipköping"
            )

INSERT INTO person( person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                "198911088619",
                "Fredrik",
                "Blindström",
                "0705597812",
                "fredrikb@gmail.com",
                "Halvvägen",
                "18",
                "62870",
                "Trestegsköping"
            )

INSERT INTO person( person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                "175601274567",
                "Amadeus",
                "Mozart",
                "07099988869",
                "mozart@brevduva.au",
                "Getreidegasse",
                "9",
                "10044",
                "Salzburg"
            )

INSERT INTO person( person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                "177012171234",
                "Ludwig",
                "Beethoven",
                "0701823455",
                "beethoven@brevduva.au",
                "Ärtgatan",
                "4",
                "34567",
                "Wien"
            )

/* Insert 5 students */
/* INSERT INTO student()
    VALUES (value1, value2, …);  */


COMMIT;