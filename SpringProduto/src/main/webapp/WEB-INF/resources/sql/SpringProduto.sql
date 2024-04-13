USE master
DROP DATABASE aulafunction


CREATE DATABASE aulafunction
GO
USE aulafunction 
GO
CREATE FUNCTION fn_produtos()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.codigo AS codigoProduto,
        p.nome AS nomeProduto,
        p.valorUnitario AS valorUnitarioProduto,
        p.qtdEstoque AS qtdEstoqueProduto
    FROM produto p
);

SELECT * FROM fn_produtos();
SELECT * FROM fn_funcionarios_dependentes();



CREATE TABLE produto(
codigo					INT			NOT NULL, 
nome					VARCHAR(30) NOT NULL,
valorUnitario			DECIMAL(7,2)NOT NULL,
qtdEstoque				INT			NOT NULL
PRIMARY KEY (codigo)
)
GO
INSERT INTO produto VALUES
(1, 'Smart TV', 1299.99, 50),
(2, 'Notebook', 2399.00, 30),
(3, 'Forno Micro-ondas', 299.90, 80),
(4, 'Liquidificador', 79.99, 100),
(5, 'Geladeira', 2599.00, 20),
(6, 'M�quina de Lavar Roupa', 1899.99, 40),
(7, 'Aspirador de P�', 159.50, 70),
(8, 'Secador de Cabelo', 49.90, 60),
(9, 'C�mera Fotogr�fica', 899.00, 15),
(10, 'Console de Videogame', 499.99, 25),
(11, 'Roteador Wi-Fi', 89.90, 55),
(12, 'Fone de Ouvido Bluetooth', 129.99, 85),
(13, 'Tablet', 349.00, 45),
(14, 'Monitor de Computador', 299.90, 35),
(15, 'Caixa de Som Bluetooth', 79.99, 75),
(16, 'Ventilador', 129.90, 90),
(17, 'C�mera de Seguran�a', 199.00, 10),
(18, 'Carregador Port�til', 39.90, 65),
(19, 'Impressora', 199.99, 30),
(20, 'Forno El�trico', 399.90, 20);
GO

CREATE PROCEDURE sp_iud_produto 
    @acao CHAR(1), 
    @codigo INT, 
    @nome VARCHAR(30), 
    @valorUnitario DECIMAL(7,2),
    @qtdEstoque INT,
    @saida VARCHAR(100) OUTPUT
AS
BEGIN
    IF (@acao = 'I')
    BEGIN
        IF EXISTS (SELECT 1 FROM produto WHERE codigo = @codigo)
        BEGIN
            SET @saida = 'Erro: Produto j� existe com o c�digo especificado'
            RETURN
        END
        ELSE
        BEGIN
            INSERT INTO produto (codigo, nome, valorUnitario, qtdEstoque) 
            VALUES (@codigo, @nome, @valorUnitario, @qtdEstoque)
            SET @saida = 'Produto inserido com sucesso'
        END
    END
    ELSE IF (@acao = 'U')
    BEGIN
        IF EXISTS (SELECT 1 FROM produto WHERE codigo = @codigo)
        BEGIN
            UPDATE produto 
            SET nome = @nome, valorUnitario = @valorUnitario, qtdEstoque = @qtdEstoque
            WHERE codigo = @codigo
            SET @saida = 'Produto alterado com sucesso'
        END
        ELSE
        BEGIN
            SET @saida = 'Erro: Produto n�o encontrado para altera��o'
            RETURN
        END
    END
    ELSE IF (@acao = 'D')
    BEGIN
        IF EXISTS (SELECT 1 FROM produto WHERE codigo = @codigo)
        BEGIN
            DELETE FROM produto WHERE codigo = @codigo
            SET @saida = 'Produto exclu�do com sucesso'
        END
        ELSE
        BEGIN
            SET @saida = 'Erro: Produto n�o encontrado para exclus�o'
            RETURN
        END
    END
    ELSE
    BEGIN
        SET @saida = 'Erro: Opera��o inv�lida'
        RETURN
    END
END

--a) a partir da tabela Produtos (codigo, nome, valor unit�rio e qtd estoque), quantos produtos est�o com estoque abaixo de um valor de entrada
CREATE FUNCTION fn_quantidadeEstoque (@qtdMinima INT)
RETURNS INT
AS
BEGIN
    DECLARE @qtdEstoqueAbaixo INT;

    SELECT @qtdEstoqueAbaixo = COUNT(*)
    FROM produto
    WHERE qtdEstoque < @qtdMinima;

    RETURN @qtdEstoqueAbaixo;
END;

SELECT dbo.fn_quantidadeEstoque(40) AS "Quantidade Estoque"

--b) Uma tabela com o c�digo, o nome e a quantidade dos produtos que est�o com o estoque abaixo de um valor de entrada

CREATE FUNCTION fn_produtosEstoque (@valor INT)
RETURNS TABLE
AS
RETURN (
    SELECT codigo, nome, qtdEstoque
    FROM produto
    WHERE qtdEstoque < @valor
);

SELECT * FROM dbo.fn_produtosEstoque(16)





