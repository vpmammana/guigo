
CREATE TABLE bairros (
  id_chave_bairro int not null auto_increment,
  bairro_id varchar(11) DEFAULT NULL,
  bairro_nome varchar(200) DEFAULT NULL,
  cidade_id varchar(7) DEFAULT NULL,
  primary key(id_chave_bairro),
  unique
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ceps (
  cidade varchar(120) DEFAULT NULL,
  cidade_id varchar(7) DEFAULT NULL,
  cidade_cep tinytext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE logradouros (
  logradouro_cep varchar(11) DEFAULT NULL,
  logradouro_tipo varchar(50) DEFAULT NULL,
  logradouro_completo varchar(100) DEFAULT NULL,
  logradouro_complemento varchar(100) DEFAULT NULL,
  logradouro_nome varchar(100) DEFAULT NULL,
  cidade_id double DEFAULT NULL,
  bairro_nome varchar(100) DEFAULT NULL,
  data_atualizacao int NOT NULL,
  cidade_nome text,
  uf_id int DEFAULT NULL,
  uf_sigla tinytext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

create table paises (id_chave_pais int not null auto_increment, nome_pais varchar(200), codigo int, primary key (id_chave_pais), unique(nome_pais));

create table estados (id_chave_estado int not null auto_increment, nome_estado varchar(200), sigla varchar(2), codigo int, id_pais int, primary key(id_chave_estado), unique(nome_estado), unique(sigla), unique(codigo), FOREIGN KEY (id_pais) REFERENCES paises(id_chave_pais));

create table municipios (id_chave_municipio int not null auto_increment, nome_municipio varchar(200), codigo int, id_estado int, primary key(id_chave_municipio), unique (nome_municipio), unique(codigo), FOREIGN KEY (id_estado) REFERENCES estados(id_chave_estado));

create table tipos_contribuintes (id_chave_tipo_contribuinte int not null auto_increment, nome_tipo_contribuinte varchar(30), primary key (id_chave_tipo_contribuinte), unique(nome_tipo_contribuinte));

create table registrados (id_chave registrado int not null auto_increment, nome_registrado varchar(200), cpf varchar(11), email varchar(100), id_tipo_contribuinte int, primary key (id_chave_registrado), unique(cpf), unique(email), FOREIGN KEY (id_tipo_contribuinte) REFERENCES tipos_contribuintes(id_chave_tipo_contribuinte));

create table instituicoes (id_chave_instituicao int not null auto_increment, nome_instituicao varchar(200), cnpj varchar(14), inscricao_estadual varchar(20), inscricao_municipal varchar(20), telefone varchar(2), primary key (id_chave_instituicao), unique(cnpj), unique(telefone));


