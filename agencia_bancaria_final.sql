create schema agencia_bancaria;


/* -- Agencia -- */

drop table agencia;
create table agencia(
	id_agencia int primary key,
	nome_agencia varchar(100) not null,
	cidade varchar(40) not null,
	endereco varchar(100) not null
);


/* -- tipo cliente -- */

drop  table tipo_cliente;
create table tipo_cliente(
	id_tipo_cliente int primary key, 
	desc_tipo_cliente varchar (30) not null
);


/* -- Cliente:  -- */

drop  table cliente;
create table cliente (
	id_conta int primary key auto_increment,
	nome_cliente varchar(50) not null,
	dt_nasc date not null,
	cpf varchar(50) not null,
	rg varchar(50) not null,
	endereco varchar(100) not null,
	agencia int not null,
	dt_entrada date not null,
	tipo_cliente int not null,
	foreign key (agencia) references agencia(id_agencia),
	foreign key (tipo_cliente) references tipo_cliente(id_tipo_cliente)
);

/* -- transferencia_lancamentos:  -- */
drop table transferencia_lancamentos;
create table transferencia_lancamentos(	
	id_conta_de int,
    id_conta_para int,
    valor_transferencia decimal(10,2),
    dt_transferecia date,
    desc_transicao varchar(100),
	foreign key (id_conta_de) references cliente(id_conta),
    foreign key (id_conta_para) references cliente(id_conta)
);
	
drop table extrato;
create table extrato (
id_conta int primary key,
quantidade_extrato int,
dt_ultima_geracao_extrato date,
foreign key (id_conta) references cliente(id_conta)
);


/* -- transferencia_total: -- */
drop table transferencia_total;
create table transferencia_total (
	id_conta int not null unique,
	transferencia_total int not null,
	dt_transferecia date not null,
	foreign key (id_conta) references cliente(id_conta)
);



/* -- conta_corrente_lancamentos: -- */

drop table conta_corrente_lancamentos;
create table conta_corrente_lancamentos(
	id_lancamento_corrente int primary key auto_increment,
	id_conta int not null,
	dt_lancamento_corrente date not null,
	valor_lancamento_corrente decimal(10,2) not null,
	descricao varchar(100),
	foreign key (id_conta) references cliente(id_conta)
);


/* -- conta_corrente_total: -- */
drop table conta_corrente_total;
create table conta_corrente_total (
	id_conta int not null unique,
	valor_total_corrente decimal(10,2),
	dt_ultima_alteracao date not null,
	foreign key (id_conta) references cliente(id_conta)
);



/* -- poupanca_lancamentos: -- */

drop table poupanca_lancamentos;
create table poupanca_lancamentos(
	id_lancamento_poupanca int primary key auto_increment,
	id_conta int not null,
	dt_lancamento_poupanca date not null,
	valor_lancamento_poupanca decimal(10,2) not null,
	foreign key (id_conta) references cliente(id_conta)
); /*               LANÇAMENTO PODE SER NEGATIVO PORÉM NÃO "MAIOR" PARA NEGATIVAR A POUPANCA TOTAL      */


/* -- poupanca_total: -- */
drop table poupanca_total;
create table poupanca_total (
	id_conta int not null unique,
	valor_total_poupanca decimal(10,2),
	dt_ultima_alteracao date not null,
	foreign key (id_conta) references cliente(id_conta)
);





/* ----------------  CRIANDO CONTA -----------------------*/
drop procedure pr_abertura_conta;

delimiter \\
create procedure pr_abertura_conta (

	in p_nome_cliente varchar(50),
	in p_dt_nasc date,
	in p_cpf varchar(50),
	in p_rg varchar(50),
	in p_endereco varchar(100),
	in p_agencia int,
	in p_dt_entrada date,
	in p_tipo_cliente int
) 

begin
   	declare vid_conta int;

	insert into cliente values (
	id_conta,
	p_nome_cliente,
	p_dt_nasc,
	p_cpf,
	p_rg,
	p_endereco,
	p_agencia,
	p_dt_entrada,
	p_tipo_cliente
	);

end; \\
delimiter ;


drop trigger trg_insere_poupanca_corrente_transferencia;

delimiter \\
create trigger trg_insere_poupanca_corrente_transferencia
after insert on cliente for each row

begin

	insert into poupanca_total values (
    	new.id_conta,
		0,
		sysdate()
	);

	insert into conta_corrente_total values (
		new.id_conta,
		0,
		sysdate()
	);
    
    insert into transferencia_total values(
		new.id_conta,
		0,
		sysdate()
	);

	insert into extrato values(
	new.id_conta,
		0,
		sysdate()
		);

end; \\
delimiter ;

	
delete from cliente where id_conta between 2 and 4;
call pr_abertura_conta ('Guilherme','1994-04-06','333333333','6666666666','VILA LABODEGA',1,'2014-12-06',1);
call pr_abertura_conta ('Rodrigo Gaucho','1994-10-31','111111111','7777777777','VILA BOSQUE',3,'2013-02-01',1);
call pr_abertura_conta ('Matheus Pimpa','1992-11-16','22222222','88888888','VILA ITATINGA',2,'2012-04-01',1);
	


/* -------  TODOS OS SELECTS  -----------   */
select * from agencia;
select * from tipo_cliente;
select * from cliente;
select * from conta_corrente_lancamentos;
select * from conta_corrente_total;
select * from poupanca_lancamentos;
select * from poupanca_total;
select * from transferencia_lancamentos;
select * from transferencia_total;


/* -------  DML -----------   */
insert into agencia values (1,'SANTANDER CAMPINAS','CAMPINAS','CAMBUI');
insert into agencia values (2,'SANTANDER SUMARE','SUMARE','AVENIDA TEODORA');
insert into agencia values (3,'SANTANDER PAULINIA','PAULINIA','BETEL');
insert into agencia values (4,'SANTANDER HORTOLANDIA','HORTOLANDI','AMANDA');
  

insert into tipo_cliente values (1,'FISICA');
insert into tipo_cliente values (2,'JURIDICA');


		
		
		/* INSERIR VALORES NA CONTA CORRENTE */
       
		insert into conta_corrente_lancamentos values (1,2,sysdate(),30);
		insert into conta_corrente_lancamentos values (2,2,sysdate(),200);
		insert into conta_corrente_lancamentos values (3,3,sysdate(),1000);
		insert into conta_corrente_lancamentos values (4,3,sysdate(),23000);
		insert into conta_corrente_lancamentos values (5,3,sysdate(),-15000);
		insert into conta_corrente_lancamentos values (6,3,sysdate(),2000);
		insert into conta_corrente_lancamentos values (7,2,sysdate(),-300);
        insert into conta_corrente_lancamentos values (8,1,sysdate(),5000);
		insert into conta_corrente_lancamentos values (9,1,'2015-06-01',-300);
        insert into conta_corrente_lancamentos values (10,3,'2014-01-01',5000);
		insert into conta_corrente_lancamentos values (11,2,'2014-12-21',-300);
        
        
        /* INSERIR VALORES NA POUPANÇA */
		insert into poupanca_lancamentos values (1,2,sysdate(),20);
		insert into poupanca_lancamentos values (2,2,sysdate(),50);
		insert into poupanca_lancamentos values (3,2,sysdate(),80);
        insert into poupanca_lancamentos values (4,3,sysdate(),80);
        insert into poupanca_lancamentos values (5,3,sysdate(),80);
        insert into poupanca_lancamentos values (6,3,sysdate(),80);
        insert into poupanca_lancamentos values (7,1,sysdate(),80);
        insert into poupanca_lancamentos values (8,2,'2010-02-01',80);
		insert into poupanca_lancamentos values (9,2,'2013-07-01',-160);
        insert into poupanca_lancamentos values (10,2,'2015-07-01',400);
		insert into poupanca_lancamentos values (11,3,'2015-06-12',500);
		insert into poupanca_lancamentos values (14,2,'2015-06-12',-500);
        update poupanca_total set valor_total_poupanca = -10 where id_conta = 3;
        
        
		
        
        
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------------------------- */
/* ------------  SALDO POUPANCA < 0  --------------*/
drop procedure valida_vlr_poupanca;
delimiter \\
create procedure valida_vlr_poupanca (in pvalor_total_poupanca decimal(10,2)) 

begin

	
	if(pvalor_total_poupanca < 0) then

		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 'Valor da poupança total não pode ser menor que 0';

	end if;


end; \\
delimiter ;

/*     trigger update para valor < 0       */
drop trigger trg_vlr_poupanca_update;
delimiter \\
create trigger trg_vlr_poupanca_update
before update  on poupanca_total for each row

begin

	call valida_vlr_poupanca(new.valor_total_poupanca);

end; \\
delimiter ;



/*     trigger insert para valor < 0       */
drop trigger trg_vlr_poupanca_insert;
delimiter \\
create trigger trg_vlr_poupanca_insert
before insert  on poupanca_total for each row

begin

	call valida_vlr_poupanca(new.valor_total_poupanca);

end; \\
delimiter ;



/* -------------------------------------------------------------------------------------------- */


/*gera valor total - poupança e conta corrente */
drop trigger trg_gera_total_poupanca;
delimiter \\
create trigger trg_gera_total_poupanca
after insert on poupanca_lancamentos for each row

begin 

	update poupanca_total set valor_total_poupanca = valor_total_poupanca + new.valor_lancamento_poupanca
	where new.id_conta  = id_conta;

end; \\
delimiter ;


drop trigger trg_gera_total_corrente;
delimiter \\
create trigger trg_gera_total_corrente
after insert on conta_corrente_lancamentos for each row

begin 

	update conta_corrente_total 
		set valor_total_corrente = valor_total_corrente + new.valor_lancamento_corrente
	where new.id_conta  = id_conta;

end; \\
delimiter ;


/* -------------------------------TRANSFERENCIA-------------------------------------------------- */
        
drop trigger trg_insert_total_transferencia;

delimiter \\
create trigger trg_insert_total_transferencia
after insert on transferencia_lancamentos for each row

begin

	update transferencia_total
		set transferencia_total = transferencia_total + 1,
		dt_transferecia = sysdate()
	where new.id_conta_de = id_conta;
     
end; \\
delimiter ;





drop trigger trg_valida_numero_transferencia;
delimiter \\
create trigger trg_valida_numero_transferencia
before insert on transferencia_lancamentos for each row

begin 
	declare vnumero_trans int;
	
    select transferencia_total into vnumero_trans 
    from transferencia_total where new.id_conta_de = id_conta;
    
		if(vnumero_trans >= 3) then

        update conta_corrente_total set valor_total_corrente = valor_total_corrente + 5 where new.id_conta_de = id_conta;

        end if;
    
end; \\
delimiter ;




/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */




/*--PROXIMOS PASSOS: 
1: Taxa administrativa, o banco cobra um valor mensal por serviços administrativos. Este valor é
fixo em R$16,00 por mês. Este pacote de serviços te da direito a 3 transferências e 2 extratos
por mês. Cada transferência extra custa R$5,00 e cada extrato R$1,00.
*/




/* ----  Transferência: Procedure para transferir dinheiro de uma conta corrente para outra
conta corrente. E Procedure para transferir da CC para Poupança ou Poupança para CC;
*/
drop procedure pro_transfere_conta_corrente;
delimiter \\
create procedure pro_transfere_conta_corrente(in p_deidconta int,in p_paraidconta int, in p_valor int )

begin

			insert into transferencia_lancamentos values (
            p_deidconta,p_paraidconta,p_valor,sysdate(),'Transferencia - Conta Corrente');
			
            update conta_corrente_total set valor_total_corrente =  valor_total_corrente - p_valor
            where p_deidconta = id_conta;
            
            update conta_corrente_total set valor_total_corrente =  valor_total_corrente + p_valor
            where p_paraidconta = id_conta;
end; \\
delimiter ;


call pro_transfere_conta_corrente (3,2,500);


select * from conta_corrente_lancamentos;
select * from conta_corrente_total;
select * from poupanca_lancamentos;
select * from poupanca_total;
select * from transferencia_lancamentos;
select * from transferencia_total;



drop procedure pro_transferencia_poupanca_conta_corrente;
delimiter \\
create procedure pro_transferencia_poupanca_conta_corrente(in p_idconta int,in p_valor int )

begin
 
				update poupanca_total set valor_total_poupanca = valor_total_poupanca - p_valor
                where p_idconta = id_conta;
                
                update conta_corrente_total set valor_total_corrente = valor_total_corrente + p_valor
			    where p_idconta = id_conta;
end; \\
delimiter ;


drop procedure pro_transferencia_conta_corrente_poupanca;
delimiter \\
create procedure pro_transferencia_conta_corrente_poupanca(in p_idconta int,in p_valor int )

begin
                
                update conta_corrente_total set valor_total_corrente = valor_total_corrente - p_valor
			    where p_idconta = id_conta;
			
				update poupanca_total set valor_total_poupanca = valor_total_poupanca + p_valor
                where p_idconta = id_conta;
end; \\
delimiter ;


		call pro_transferencia_poupanca_conta_corrente(3,500);
		call pro_transferencia_conta_corrente_poupanca (3,100);
       
        
		select * from conta_corrente_lancamentos;
		select * from conta_corrente_total;
		select * from poupanca_lancamentos;
		select * from poupanca_total;
		select * from transferencia_lancamentos;
		select * from transferencia_total;



/* Relatório: Procedure que retorne uma projeção do saldo da Poupança e da CC, 
nos próximos 30, 60, 90 e 360 dias, assuma que não será feita nenhuma operação neste período */
drop procedure relatorio;
delimiter \\
create procedure relatorio (in pid_conta int,out projecao varchar(300))

begin
		
        
        /*     1. TAXA ADMINISTRATIVA 16 REAIS -- POR MÊS     
			   2. 0,6%  POR AUMENTO MENSAL NA POUPANÇA
        */
        
        declare vtotal_corrente decimal(10,2);
		declare vtotal_poupanca decimal(10,2);
        declare proj_30_conta_corrente int;    
        declare proj_60_conta_corrente int;
        declare proj_90_conta_corrente int;
        declare proj_360_conta_corrente int;
		declare proj_30_poupanca int;    
        declare proj_60_poupanca int;
        declare proj_90_poupanca int;
        declare proj_360_poupanca int;
        declare taxaadministrativa int;
        declare juros_poupanca decimal(4,3);
        
        set taxaadministrativa = 16;
        set juros_poupanca = 0.06;
        
        /* ---- TERMINAR PARA QUANDO O SALDO DA CONTA CORRENTE FOR NEGATIVO -----*/
        
        select valor_total_corrente into vtotal_corrente from conta_corrente_total
        where pid_conta = id_conta;
        select valor_total_poupanca into vtotal_poupanca from poupanca_total
		where pid_conta = id_conta;
         


         set proj_30_conta_corrente = vtotal_corrente  - taxaadministrativa;   
		 set proj_60_conta_corrente = vtotal_corrente - (taxaadministrativa * 2) ;
		 set proj_90_conta_corrente = vtotal_corrente - (taxaadministrativa * 3);
		 set proj_360_conta_corrente = vtotal_corrente - (taxaadministrativa * 12);
         
         set proj_30_poupanca = (juros_poupanca * vtotal_poupanca) + vtotal_poupanca;
         set proj_60_poupanca = ((juros_poupanca * 2) * vtotal_poupanca) + (vtotal_poupanca);
         set proj_90_poupanca = ((juros_poupanca * 3) * vtotal_poupanca) + (vtotal_poupanca);
         set proj_360_poupanca = ((juros_poupanca * 12) * vtotal_poupanca) + (vtotal_poupanca);
         
         
        
		 set projecao = concat(
                'Projeção CC-30 dias: ' , proj_30_conta_corrente ,'   ','\n',
				'Projeção CC-60 dias: ' , proj_60_conta_corrente , '   ','\n',
				'Projeção CC-90 dias: ' , proj_90_conta_corrente , '   ','\n',
				'Projeção CC-360 dias: ' , proj_360_conta_corrente ,'   ', '\n',
                'Projeção Poupança-30 dias: ' , proj_30_poupanca ,'   ','\n',
				'Projeção Poupança-60 dias: ' , proj_60_poupanca , '   ','\n',
				'Projeção Poupança-90 dias: ' , proj_90_poupanca , '   ','\n',
				'Projeção Poupança-360 dias: ' , proj_360_poupanca ,'   ', '\n' 
				);

	

end; \\
delimiter ;

	select * from poupanca_total;
	call relatorio (1,@projecao);
    select @projecao;

/* --  Extrato: View para facilitar a visualização das operações realizadas poupança e da CC, 
agrupandopor cliente e ordenando por data.
EXEMPLO: CREATE VIEW view_name ASSELECT column_name(s)FROM table_nameWHERE condition  */
drop view visualizacao_lancamentos;
create view visualizacao_lancamentos AS 
	select 'POUPANCA' as transacao,pl.id_conta,cli.nome_cliente,pl.dt_lancamento_poupanca as dt_lancamento,
			pl.valor_lancamento_poupanca as valor_lancamento
	from cliente cli join poupanca_lancamentos pl on (cli.id_conta = pl.id_conta)
            
	union 
    select 'CONTA CORRENTE',cl.id_conta,cli.nome_cliente,cl.dt_lancamento_corrente as dt_lancamento,
			cl.valor_lancamento_corrente as valor_lancamento
    from cliente cli join conta_corrente_lancamentos cl on (cli.id_conta = cl.id_conta)
            
	order by 2,4;
	

		select * from visualizacao_lancamentos;
		
/* --------------------------------------------------------------------------------------------  */


/*  Procedure para gerar um arquivo com o extrato do mês 
o saldo atual e sua projeção  */
drop procedure extracao;

delimiter \\
create procedure extracao (in pid_conta int ,in dt_ultima_alteracao date)
begin
	
	declare vquantidade_extrato int;
	select 'POUPANCA' as transacao,pl.id_conta,cli.nome_cliente,pl.dt_ultima_alteracao,
			pl.valor_total_poupanca as valor_lancamento
	from cliente cli join poupanca_total pl on (cli.id_conta = pl.id_conta)
	union 
    select 'CONTA CORRENTE',cl.id_conta,cli.nome_cliente,cl.dt_ultima_alteracao,
			cl.valor_total_corrente as valor_total
    from cliente cli join conta_corrente_total cl on (cli.id_conta = cl.id_conta)
    
    order by 2,1 INTO OUTFILE "C:/temp/extracao.txt";

	select quantidade_extrato into vquantidade_extrato from extrato where pid_conta = id_conta;

	if(vquantidade_extrato >= 2) then
	update conta_corrente_total set valor_total_corrente = valor_total_corrente - 1 where pid_conta = id_conta;
	end if;

	update extrato set quantidade_extrato = quantidade_extrato + 1 where pid_conta = id_conta;
	
	
		
end; \\
delimiter ;

select * from conta_corrente_total;
select * from poupanca_total;
update extrato set quantidade_extrato = 0 where id_conta = 2;
		select * from conta_corrente_total; 
		select * from extrato;
		call extracao (2,sysdate());


		

/* --------------------------------------------------------------------------------------------  */
/* Atualização de saldo: Procedure executada diariamente para atualizar os saldos da
poupança e conta corrente de acordo com os juros do dia; Importante, as operações em
todas as contas devem ser feitas de forma atômica, ou seja, se o processo falhar por
algum motivo nenhuma conta deve ser atualizada; (utilize session)   */

/*       TENTAR UTILIZAR CURSOR E LOOP           */

/*OQUE FALTA ->
--SOMENTE 2 EXTRATO PODERAM SER GERADOS POR MÊS SE FIZER MAIS AUMENTA 1 REAL NA CONTA CORRENTE.

--dividir o juros mensal da poupança por 30;
--se saldo negativo da conta corrente injeta juros
*/

drop procedure prg_juros_diario_corrente;

delimiter \\
create procedure prg_juros_diario_corrente()
begin

begin
    declare final int default(0);
	declare vid int;
	declare saldo decimal (10,5);

	/* JUROS CONTA CORRENTE */

	declare juros_diario_corrente cursor for

		select id_conta from conta_corrente_total;

		declare continue handler for not found set final = 1;

		open juros_diario_corrente;

			read_loop: loop
			fetch juros_diario_corrente into vid;

			select valor_total_corrente into saldo from conta_corrente_total where vid = id_conta;

			if(saldo < 0) then
			
			update conta_corrente_total 
				set valor_total_corrente = valor_total_corrente + (valor_total_corrente * 0.039)
			where vid = id_conta;

			end if;

			if (final = 1) then
			leave read_loop;
			end if;
		
	end loop read_loop;
	close juros_diario_corrente;
end;

begin
    declare final int default(0);
	declare vid int;
	declare saldo decimal (10,5);

	/* JUROS CONTA POUPANÇA */

	declare juros_diario_poupanca cursor for

		select id_conta from poupanca_total;

		declare continue handler for not found set final = 1;

		open juros_diario_poupanca;

			read_loop: loop
			fetch juros_diario_poupanca into vid;

			update poupanca_total set valor_total_poupanca = valor_total_poupanca * 1.002
			where vid = id_conta;


			if (final = 1) then
			leave read_loop;
			end if;
		
	end loop read_loop;
	close juros_diario_poupanca;
end;


end; \\
delimiter ;

call prg_juros_diario_corrente();
/*debitar  16 reais da conta corrente mensalmente; 
-- RODAR MENSALMENTE
 */

delimiter \\
create procedure prg_taxa_administrativa()
begin
    declare final int default(0);
	declare vid int;
	declare taxa_administrativa cursor for

		select id_conta from conta_corrente_total;

		declare continue handler for not found set final = 1;

		open taxa_administrativa;

			read_loop: loop
			fetch taxa_administrativa into vid;

			if (final = 1) then
			leave read_loop;
			end if;

			insert into conta_corrente_lancamentos values (id_lancamento_corrente,vid,sysdate(),-16,'taxa administrativa');

			
	end loop read_loop;
	close taxa_administrativa;

end; \\
delimiter ;



call prg_taxa_administrativa();
select * from conta_corrente_lancamentos;
select * from conta_corrente_total;


/*  procedure rodada acada 1 mês para zerar o número de transações na tabela de transferencia e extrato  */
drop procedure prc_zera_transferencia_extrato;

delimiter \\
create procedure prc_zera_transferencia_extrato()
begin

		update transferencia_total
		set transferencia_total = 0,
		dt_transferecia = sysdate();
		
		update extrato
		set quantidade_extrato = 0,
		dt_ultima_geracao_extrato = sysdate();


end; \\
delimiter ;


/*     ------------------------------                      */

select * from extrato;
