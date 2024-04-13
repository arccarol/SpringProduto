package br.edu.fateczl.SpringProduto.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class Produto {
	
	
	int codigo;
	String nome;
	Float valorUnitario;
	int qtdEstoque;
	
	public String toString() {
		return nome;
	} 
	
	

}