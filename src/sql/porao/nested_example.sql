DROP PROCEDURE IF EXISTS insere_a_direita_dos_filhos;

DELIMITER //

CREATE PROCEDURE insere_a_direita_dos_filhos(IN nome_no_pai varchar(20), IN no_para_inserir varchar(20))
BEGIN
	SELECT @no_filho_a_direita:=node.name, (COUNT(parent.name) - (MAX(sub_tree.depth) + 1)) AS depth
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent,
	        categorias_cnae AS sub_parent,
	        (
	                SELECT node.name, (COUNT(parent.name) - 1) AS depth
	                FROM categorias_cnae AS node,
	                        categorias_cnae AS parent
	                WHERE node.lft BETWEEN parent.lft AND parent.rgt
	                        AND node.name = nome_no_pai
	                GROUP BY node.name
	                ORDER BY MAX(node.lft)
	        )AS sub_tree
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
	        AND sub_parent.name = sub_tree.name
	GROUP BY node.name
	HAVING depth = 1
	ORDER BY MAX(node.lft) DESC LIMIT 1;

	SELECT concat("O filho a direita é: ", @no_filho_a_direita);
	
	SELECT @myRight := rgt FROM categorias_cnae
	WHERE name = @no_filho_a_direita;
	
	UPDATE categorias_cnae SET rgt = rgt + 2 WHERE rgt > @myRight;
	UPDATE categorias_cnae SET lft = lft + 2 WHERE lft > @myRight;
	
	INSERT INTO categorias_cnae(name, lft, rgt) VALUES(no_para_inserir, @myRight + 1, @myRight + 2);
	

END
//
DROP PROCEDURE IF EXISTS mostra_arvore
//
CREATE PROCEDURE mostra_arvore()
BEGIN
	SELECT CONCAT( REPEAT(' ', COUNT(parent.name) - 1), node.name) AS name
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	GROUP BY node.name
	ORDER BY MAX(node.lft);
END
//
DELIMITER ;

DROP TABLE IF EXISTS nested_category;
DROP TABLE IF EXISTS categorias_cnae;

CREATE TABLE nested_category (
        category_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(20) NOT NULL,
        lft INT NOT NULL,
        rgt INT NOT NULL
);

CREATE TABLE categorias_cnae (
        category_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(20) NOT NULL,
        lft INT NOT NULL,
        rgt INT NOT NULL
);

insert into categorias_cnae values (1,'CNAE',1,2);


INSERT INTO nested_category VALUES(1,'ELECTRONICS',1,20),(2,'TELEVISIONS',2,9),(3,'TUBE',3,4),
 (4,'LCD',5,6),(5,'PLASMA',7,8),(6,'PORTABLE ELECTRONICS',10,19),(7,'MP3 PLAYERS',11,14),(8,'FLASH',12,13),
 (9,'CD PLAYERS',15,16),(10,'2 WAY RADIOS',17,18);

SELECT "Visao interna da arvore:";
SELECT * FROM nested_category ORDER BY category_id;

SELECT "Arvore completa:";
SELECT node.name
FROM nested_category AS node,
        nested_category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND parent.name = 'ELECTRONICS'
ORDER BY node.lft;


SELECT "Todas as folhas:";

SELECT name
FROM nested_category
WHERE rgt = lft + 1;

SELECT "Percorre uma trilha: FLASH";
SELECT parent.name
FROM nested_category AS node,
        nested_category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.name = 'FLASH'
ORDER BY parent.lft; 

SELECT "Percorre uma trilha: MP3 PLAYERS";
SELECT parent.name
FROM nested_category AS node,
        nested_category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.name = 'MP3 PLAYERS'
ORDER BY parent.lft; 


SELECT "Profundidade de cada nó:";
SELECT node.name, (COUNT(parent.name) - 1) AS depth
FROM nested_category AS node,
        nested_category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
ORDER BY MAX(node.lft);

SELECT "Arvore identada";
SELECT CONCAT( REPEAT(' ', COUNT(parent.name) - 1), node.name) AS name
FROM nested_category AS node,
        nested_category AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
ORDER BY MAX(node.lft);


SELECT "Arvore identada CNAE";
SELECT CONCAT( REPEAT(' ', COUNT(parent.name) - 1), node.name) AS name
FROM categorias_cnae AS node,
        categorias_cnae AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
ORDER BY MAX(node.lft);



SELECT "Inserir Categoria CNAE 1:";

LOCK TABLE categorias_cnae WRITE;

SELECT @myLeft := lft FROM categorias_cnae

WHERE name = 'CNAE';

UPDATE categorias_cnae SET rgt = rgt + 2 WHERE rgt > @myLeft;
UPDATE categorias_cnae SET lft = lft + 2 WHERE lft > @myLeft;

INSERT INTO categorias_cnae(name, lft, rgt) VALUES('01', @myLeft + 1, @myLeft + 2);

UNLOCK TABLES;

SELECT "Arvore identada CNAE";
SELECT CONCAT( REPEAT(' ', COUNT(parent.name) - 1), node.name) AS name
FROM categorias_cnae AS node,
        categorias_cnae AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
ORDER BY MAX(node.lft);

SELECT "Inserir Categoria CNAE 2:";

LOCK TABLE categorias_cnae WRITE;

SELECT @myLeft := lft FROM categorias_cnae

WHERE name = 'CNAE';

UPDATE categorias_cnae SET rgt = rgt + 2 WHERE rgt > @myLeft;
UPDATE categorias_cnae SET lft = lft + 2 WHERE lft > @myLeft;

INSERT INTO categorias_cnae(name, lft, rgt) VALUES('02', @myLeft + 1, @myLeft + 2);

UNLOCK TABLES;

SELECT "Arvore identada CNAE";
SELECT CONCAT( REPEAT(' ', COUNT(parent.name) - 1), node.name) AS name
FROM categorias_cnae AS node,
        categorias_cnae AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
ORDER BY MAX(node.lft);

SELECT "Inserir Categoria CNAE 3:";

LOCK TABLE categorias_cnae WRITE;

SELECT @myLeft := lft FROM categorias_cnae

WHERE name = 'CNAE';

UPDATE categorias_cnae SET rgt = rgt + 2 WHERE rgt > @myLeft;
UPDATE categorias_cnae SET lft = lft + 2 WHERE lft > @myLeft;

INSERT INTO categorias_cnae(name, lft, rgt) VALUES('03', @myLeft + 1, @myLeft + 2);

UNLOCK TABLES;

SELECT "Arvore identada CNAE";
SELECT CONCAT( REPEAT(' ', COUNT(parent.name) - 1), node.name) AS name
FROM categorias_cnae AS node,
        categorias_cnae AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.name
ORDER BY MAX(node.lft);

SELECT "MOSTRA FILHOS de CNAE 1";

SELECT node.name, (COUNT(parent.name) - (MAX(sub_tree.depth) + 1)) AS depth
FROM categorias_cnae AS node,
        categorias_cnae AS parent,
        categorias_cnae AS sub_parent,
        (
                SELECT node.name, (COUNT(parent.name) - 1) AS depth
                FROM categorias_cnae AS node,
                        categorias_cnae AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.name = 'CNAE'
                GROUP BY node.name
                ORDER BY MAX(node.lft)
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.name = sub_tree.name
GROUP BY node.name
HAVING depth = 1
ORDER BY MAX(node.lft) DESC;

SELECT "MOSTA FILHOS de 01";

SELECT node.name, (COUNT(parent.name) - (MAX(sub_tree.depth) + 1)) AS depth
FROM categorias_cnae AS node,
        categorias_cnae AS parent,
        categorias_cnae AS sub_parent,
        (
                SELECT node.name, (COUNT(parent.name) - 1) AS depth
                FROM categorias_cnae AS node,
                        categorias_cnae AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.name = '01'
                GROUP BY node.name
                ORDER BY MAX(node.lft)
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.name = sub_tree.name
GROUP BY node.name
HAVING depth = 1
ORDER BY MAX(node.lft) LIMIT 1;

SELECT "MOSTA FILHOS DIR de CNAE";

SELECT node.name, (COUNT(parent.name) - (MAX(sub_tree.depth) + 1)) AS depth
FROM categorias_cnae AS node,
        categorias_cnae AS parent,
        categorias_cnae AS sub_parent,
        (
                SELECT node.name, (COUNT(parent.name) - 1) AS depth
                FROM categorias_cnae AS node,
                        categorias_cnae AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.name = 'CNAE'
                GROUP BY node.name
                ORDER BY MAX(node.lft)
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.name = sub_tree.name
GROUP BY node.name
HAVING depth = 1
ORDER BY MAX(node.lft) DESC LIMIT 1;


