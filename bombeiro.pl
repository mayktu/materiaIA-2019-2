/* métodos de manipulação de listas */

pertence(Elem,[Elem|_]).
pertence(Elem,[_|Cauda]) :- pertence(Elem,Cauda).

inverte([],[]).
inverte([X|Y],Invertida) :- inverte(Y,Yinvertido), concatena(Yinvertido,[X], Invertida).

concatena([],Lista,Lista).
concatena([Cabeca|Cauda],Lista2,[Cabeca|Resultado]) :-
    concatena(Cauda,Lista2,Resultado).

conta([],0).
conta([_|Cauda], N) :- conta(Cauda, N1), N is N1 + 1.

inserir_primeiro(Elem,Lista,[Elem|Lista]).

/* Bombeirinho */
/* estado_bombeirinho(Andar, Bloco, quantidade_uso_extintor, focos_apagados, exintores_usados) */

inicio([1,1,0,[],[]]).

%Caso1
/*extintores([[3,2]]).
focos_incendio([[1,9], [5,10]]).
paredes([[3,3], [5,7]]).
entulhos([[2,4], [2,7], [4,4], [4,7], [5,6]]).
escadas_subindo([[1,5], [2,9], [3,1], [3,10], [4,3], [4,5], [4,9]]).
escadas_descendo([[2,5], [3,9], [4,1], [4,10], [5,3], [5,5], [5,9]]).
altura_predio(5). 
comprimento_predio(10). */
%Caso4
extintores([[3,6],[1,7]]).
focos_incendio([[3,2],[1,5],[5,8]]).
paredes([[3,5],[1,6]]).
entulhos([[1,2],[2,3],[2,10],[4,6],[5,6],[5,2]]).
escadas_subindo([[2,1],[1,4],[1,9],[2,7],[3,4],[3,10],[4,3],[4,9]]).
escadas_descendo([[3,1],[2,4],[2,9],[3,7],[4,4],[4,10],[5,3],[5,9]]).
altura_predio(5).
comprimento_predio(10).
%Exemplo_Extintores
/*extintores([[2,2],[2,3]]).
focos_incendio([[1,3],[1,4],[1,5]]).
paredes([]).
entulhos([]).
escadas_subindo([[1,1]]).
escadas_descendo([[2,1]]).
altura_predio(2).
comprimento_predio(5).*/


%Meta
meta([_,_,_,Apagados,_]) :- focos_incendio(Focos), conta(Focos,X), conta(Apagados,Y), X == Y.

%Pegar_extintor
/* se a posição que o bombeirinho estiver possuir um extintor, a contagem de uso do extintor for 0 e o extintor não for usado a contagem vai para 2 */
estado([Andar,Bloco,0,Apagados,ExtintoresU],[Andar,Bloco,2,Apagados,ExtintoresU2]) :- extintores(Extintores), pertence([Andar,Bloco],Extintores), not(pertence([Andar,Bloco],ExtintoresU)), inserir_primeiro([Andar,Bloco],ExtintoresU,ExtintoresU2).

%Apagar_fogo
/* verifica as posições ao lado do bombeirinho, se a contagem de uso do extintor for > 0 e houver fogo ele o apaga */
estado([Andar,Bloco,N_extintor,Apagados,ExtintoresU],[Andar,Bloco,N_extintor2,Apagados2,ExtintoresU]) :- focos_incendio(Focos), N_extintor > 0,
                                                                                      ((Blocoaux is Bloco + 1, pertence([Andar,Blocoaux],Focos), not(pertence([Andar,Blocoaux],Apagados)), N_extintor2 is N_extintor - 1, inserir_primeiro([Andar,Blocoaux],Apagados,Apagados2)) ;
                                                                                       (Blocoaux2 is Bloco - 1, pertence([Andar,Blocoaux2],Focos), not(pertence([Andar,Blocoaux2],Apagados)), N_extintor2 is N_extintor - 1, inserir_primeiro([Andar,Blocoaux2],Apagados,Apagados2))).
%Movimentacao_permitida
posicao_permitida([Andar,Bloco], Apagados) :- altura_predio(Altura), comprimento_predio(Comp), focos_incendio(Focos), paredes(Paredes), entulhos(Entulhos), Andar=<Altura, Andar>0, Bloco=<Comp, Bloco>0, not(pertence([Andar,Bloco],Paredes)), not(pertence([Andar,Bloco],Entulhos)), (not(pertence([Andar,Bloco],Focos)) ; pertence([Andar,Bloco],Apagados)).

%Movimentacao_para_cima
estado([Andar,Bloco,N_extintor,Apagados,ExtintoresU],[Andar2,Bloco,N_extintor,Apagados,ExtintoresU]) :- escadas_subindo(Escadas_subindo), pertence([Andar,Bloco],Escadas_subindo), Andar2 is Andar + 1. 

%Movimentacao_para_direita
estado([Andar,Bloco,N_extintor,Apagados,ExtintoresU],[Andar,Bloco2,N_extintor,Apagados,ExtintoresU]) :- Blocoaux is Bloco + 1, ((posicao_permitida([Andar,Blocoaux],Apagados), Bloco2 is Blocoaux) ; (entulhos(Entulhos),escadas_subindo(EscadasS), escadas_descendo(EscadasD), pertence([Andar,Blocoaux],Entulhos), Bloco2 is Bloco + 2, not(pertence([Andar,Bloco2],EscadasS)), not(pertence([Andar,Bloco2],EscadasD)), posicao_permitida([Andar,Bloco2],Apagados))).

%Movimentacao_para_esquerda
estado([Andar,Bloco,N_extintor,Apagados,ExtintoresU],[Andar,Bloco2,N_extintor,Apagados,ExtintoresU]) :- Blocoaux is Bloco - 1, ((posicao_permitida([Andar,Blocoaux],Apagados), Bloco2 is Blocoaux) ; (entulhos(Entulhos),escadas_subindo(EscadasS), escadas_descendo(EscadasD), pertence([Andar,Blocoaux],Entulhos), Bloco2 is Bloco - 2, not(pertence([Andar,Bloco2],EscadasS)), not(pertence([Andar,Bloco2],EscadasD)), posicao_permitida([Andar,Bloco2],Apagados))).

%Movimentacao_para_baixo
estado([Andar,Bloco,N_extintor,Apagados,ExtintoresU],[Andar2,Bloco,N_extintor,Apagados,ExtintoresU]) :- escadas_descendo(Escadas_descendo), pertence([Andar,Bloco],Escadas_descendo), Andar2 is Andar - 1.


/* Busca em largura */
solucao_bl(ISolucao) :- inicio(X), bl([[X]],Solucao), inverte(Solucao,ISolucao).
bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores),concatena(Outros,Sucessores,NovaFroteira),bl(NovaFroteira,Solucao).
estende([Estado|Caminho],ListaSucessores) :- bagof([Sucessor,Estado|Caminho],(estado(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))),ListaSucessores),!.
estende(_,[]).
