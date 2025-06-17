# Tasca S3.01.


### Nivell 1

#Exercici 1
#   Creo la tabla credit_card
    CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(20) PRIMARY KEY,
        iban VARCHAR(50),
        pan VARCHAR(50),
        pin VARCHAR(6),
        cvv INT,
        expiring_date CHAR(8)informetecnico
    );
    
#####FALTA columna fecha_actual 

# check si la tabla credit_card es relacionada correctamente
SELECT *
FROM company
JOIN transaction
ON company.id = transaction.company_id
JOIN credit_card
ON credit_card.id = transaction.credit_card_id;

#cambio el tipo de variable de expiring_date de CHAR(8) a DATE
#creo nueva columna temporanea
ALTER TABLE credit_card
ADD COLUMN expiring_date_tmp DATE;

#pongo los datos de expiring_date en el formato correcto el la nueva columna
SET SQL_SAFE_UPDATES = 0;

UPDATE credit_card
SET expiring_date_tmp = STR_TO_DATE(expiring_date, "%m/%d/%y");

SET SQL_SAFE_UPDATES = 1;

#elimino la columna original y cambio el nombre de la columna original
ALTER TABLE credit_card
DROP COLUMN expiring_date;

ALTER TABLE credit_card
RENAME COLUMN expiring_date_tmp TO expiring_date;


#Exercici 2
# El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit 
# amb ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. 
# Recorda mostrar que el canvi es va realitzar.

#miro el dato original
SELECT *
FROM credit_card
WHERE credit_card.id = "CcU-2938";


#cambio el dato
UPDATE credit_card
SET iban = "TR323456312213576817699999"
WHERE id = "CcU-2938";

#avireguo que haya cambiado correctamente
SELECT *
FROM credit_card
WHERE credit_card.id = "CcU-2938";



#Exercici 3
#En la taula "transaction" ingressa un nou usuari amb la següent informació:
# Id 	108B1D1D-5B23-A76C-55EF-C568E49A99DD
# credit_card_id 	CcU-9999
# company_id 	b-9999
# user_id 	9999
# lat 	829.999
# longitude 	-117.999
# amount 	111.11
# declined 	0

#averiguo que el dato ya no exista en la tabla
SELECT *
FROM company
JOIN transaction
ON company.id = transaction.company_id
JOIN credit_card
ON credit_card.id = transaction.credit_card_id
WHERE credit_card.id = "CcU-9999";

#inserto el nuevo dato en las tablas relacionadas como p.k.
INSERT INTO credit_card (id) VALUES ("CcU-9999");
INSERT INTO company (id) VALUES ("b-9999");

#inserto el nuevo dato en la tabla transaction
INSERT INTO transaction (
  Id,
  credit_card_id,
  company_id,
  user_id,
  lat,
  longitude,
  amount,
  declined
) VALUES (
  "108B1D1D-5B23-A76C-55EF-C568E49A99DD",
  "CcU-9999",
  "b-9999",
  9999,
  829.999,
  -117.999,
  111.11,
  0
);

#averiguo que ahora exista el registro de "CcU-9999"
SELECT *
FROM company
JOIN transaction
ON company.id = transaction.company_id
JOIN credit_card
ON credit_card.id = transaction.credit_card_id
WHERE credit_card.id = "CcU-9999";


#Exercici 4
#Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.
ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM credit_card;


### Nivell 2

#Exercici 1
#Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

SELECT *
FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

DELETE FROM transaction
WHERE Id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

SELECT *
FROM transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";
 
 
#Exercici 2
# Crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
# Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
# Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
# Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

SELECT company_name as "nombre", phone, country, AVG(amount) AS "Media de compra"
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY company_name, phone, country
ORDER BY AVG(amount) DESC;



#Exercici 3
# Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
SELECT * FROM transactions.VistaMarketing
WHERE country = "Germany";


### Nivell 3

#Exercici 1
# La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
# Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar.
# Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

#creo la tabla user y importo los datos del los files "estructura_dades_user" y "dades_introduir_user"
CREATE TABLE IF NOT EXISTS user (
	id INT PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);
#cambio el nombre de la tabla para que coincida con el nombre indicado en el diagrama
RENAME TABLE user TO data_user;
#averiguo que sea relacionada correctamente
SELECT *
FROM transaction
JOIN data_user
  ON data_user.id = transaction.user_id;
  


#Exercici 2
# L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:

#    ID de la transacció
#    Nom de l'usuari/ària
#    Cognom de l'usuari/ària
#    IBAN de la targeta de crèdit usada.
#    Nom de la companyia de la transacció realitzada.
#    Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.

# Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.


SELECT transaction.id, data_user.name, data_user.surname, credit_card.iban, company.company_name, company.country, transaction.amount
FROM transaction
JOIN data_user
  ON data_user.id = transaction.user_id
JOIN company
  ON company.id = transaction.company_id
JOIN credit_card
  ON credit_card.id = transaction.credit_card_id
ORDER BY id DESC;


