DELIMITER //
DROP PROCEDURE IF EXISTS mostra_trilha_da_arvore_descricao_concatenada
//
CREATE PROCEDURE mostra_trilha_da_arvore_descricao_concatenada(IN no_de_busca varchar(20))
BEGIN
	SELECT group_concat(T.nomcat SEPARATOR "-") from (
	SELECT parent.descricao as nomcat 
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	        AND node.nome_categoria = no_de_busca
	ORDER BY parent.lft) as T;
END
//
DROP PROCEDURE IF EXISTS mostra_trilha_da_arvore_codigo_concatenado
//
CREATE PROCEDURE mostra_trilha_da_arvore_codigo_concatenado(IN no_de_busca varchar(20))
BEGIN
	SELECT group_concat(T.nomcat SEPARATOR "-") from (
	SELECT parent.nome_categoria as nomcat
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	        AND node.nome_categoria = no_de_busca
	ORDER BY parent.lft) as T;
END
//
DROP PROCEDURE IF EXISTS mostra_trilha_da_arvore
//
CREATE PROCEDURE mostra_trilha_da_arvore(IN no_de_busca varchar(20))
BEGIN
	SELECT parent.nome_categoria
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	        AND node.nome_categoria = no_de_busca
	ORDER BY parent.lft;
END
//
DROP PROCEDURE IF EXISTS retorna_filho_a_direita
//
CREATE PROCEDURE retorna_filho_a_direita(IN nome_no_pai varchar(20), OUT saida_no varchar(20))
busca:BEGIN

	SELECT @numero:=count(*) from categorias_cnae where nome_categoria = nome_no_pai;

	IF @numero = 0 THEN
		SET saida_no = '';
		LEAVE busca;		
	END iF;

	SELECT @no_filho_encontrado:=node.nome_categoria, (COUNT(parent.nome_categoria) - (MAX(sub_tree.depth) + 1)) AS depth
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent,
	        categorias_cnae AS sub_parent,
	        (
	                SELECT node.nome_categoria, (COUNT(parent.nome_categoria) - 1) AS depth
	                FROM categorias_cnae AS node,
	                        categorias_cnae AS parent
	                WHERE node.lft BETWEEN parent.lft AND parent.rgt
	                        AND node.nome_categoria = nome_no_pai
	                GROUP BY node.nome_categoria
	                ORDER BY MAX(node.lft)
	        )AS sub_tree
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
	        AND sub_parent.nome_categoria = sub_tree.nome_categoria
	GROUP BY node.nome_categoria
	HAVING depth = 1
	ORDER BY MAX(node.lft) DESC LIMIT 1;
	#SELECT concat("INterno ", @no_filho_encontrado);
	SET saida_no = @no_filho_encontrado;
	SELECT saida_no;
END
//
DROP PROCEDURE IF EXISTS insere_a_direita_dos_filhos
//
CREATE PROCEDURE insere_a_direita_dos_filhos(IN nome_no_pai varchar(20), IN no_para_inserir varchar(20), IN no_descricao varchar(1000))
funcao:BEGIN

	CALL retorna_filho_a_direita(nome_no_pai, @no_filho_a_direita);
	#SELECT concat("Retornou da chamada: ", @no_filho_a_direita);
	IF @no_filho_a_direita = '' THEN
		SELECT "Não foi possível encontrar o no!";
		LEAVE funcao;
	END IF;

	IF @no_filho_a_direita = nome_no_pai THEN
		#SELECT "Insere abaixo";
		SELECT @myLeft := lft FROM categorias_cnae
		
		WHERE nome_categoria = nome_no_pai;
		
		UPDATE categorias_cnae SET rgt = rgt + 2 WHERE rgt > @myLeft;
		UPDATE categorias_cnae SET lft = lft + 2 WHERE lft > @myLeft;
		
		INSERT INTO categorias_cnae(nome_categoria, descricao, lft, rgt) VALUES(no_para_inserir, no_descricao, @myLeft + 1, @myLeft + 2);
	ELSE
		#SELECT concat("Insere do lado - pai: ",nome_no_pai," a inserir ",no_para_inserir, "retorno da funcao ", @no_filho_a_direita); 
		#SELECT concat("O filho a direita é: ", @no_filho_a_direita);
		
		SELECT @myRight := rgt FROM categorias_cnae
		WHERE nome_categoria = @no_filho_a_direita;
		
		UPDATE categorias_cnae SET rgt = rgt + 2 WHERE rgt > @myRight;
		UPDATE categorias_cnae SET lft = lft + 2 WHERE lft > @myRight;
		
		INSERT INTO categorias_cnae(nome_categoria, descricao, lft, rgt) VALUES(no_para_inserir, no_descricao, @myRight + 1, @myRight + 2);
	END IF;

END
//
DROP PROCEDURE IF EXISTS mostra_arvore
//
CREATE PROCEDURE mostra_arvore()
BEGIN
	SELECT CONCAT( REPEAT(' ', COUNT(parent.nome_categoria) - 1), node.nome_categoria) AS nome_categoria
	FROM categorias_cnae AS node,
	        categorias_cnae AS parent
	WHERE node.lft BETWEEN parent.lft AND parent.rgt
	GROUP BY node.nome_categoria
	ORDER BY MAX(node.lft);
END
//
DELIMITER ;

DROP TABLE IF EXISTS categorias_cnae;


CREATE TABLE categorias_cnae (
        id_chave_categoria INT AUTO_INCREMENT PRIMARY KEY,
        nome_categoria VARCHAR(20) NOT NULL,
	descricao varchar(1000),
        lft INT NOT NULL,
        rgt INT NOT NULL
);

insert into categorias_cnae values (1,'CNAE','raiz',1,2);



