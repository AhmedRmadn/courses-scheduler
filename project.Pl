%%%% Ahmed Ramadan Mohamed 
%%%% 46-18324

%%%%Facts
courses([(csen403,2),(csen905,2),(csen709,1),(csen601,2),(csen301,3),(csen701,2),(csen503,3),(csen501,2)]).
slots([slot(sunday,1),slot(sunday,2),slot(sunday,3),slot(monday,1),slot(monday,2),slot(monday,3),slot(tuesday,1),slot(tuesday,2),slot(tuesday,3),slot(wednesday,1),slot(wednesday,2),slot(wednesday,3)]).

%%%%%rules
putSlots(L):-
    slots(A),
    putSlotsHelper(L,A).
putSlotsHelper([],[]).
putSlotsHelper([H|T],[H1|T1]):-
        H=(H1,_),
		putSlotsHelper(T,T1).
		
courseNotDone([],_).
courseNotDone([H|T],Subject):-
    courseNotDone(T,Subject),
	H\=Subject.


pickAnotDoneCourse([H|_],L,C):-
    \+search(L,H),C=H.
pickAnotDoneCourse([_|T],L,C):-
     pickAnotDoneCourse(T,L,C).
	
search([H|_],H).
search([H|T],E):-
    search(T,E),
	H\=E.

scheduleCourse(_,_,0).
scheduleCourse([(slot(_, _), Name)|T],Name,N):-
    N>0,N1 is N-1,
    scheduleCourse(T,Name,N1).
scheduleCourse([(slot(_, _), X)|T],Name,N):-
    N>0,scheduleCourse(T,Name,N),X\=Name.
    
    
removeFromNotDone(_,[],[]).
removeFromNotDone(C,[C|T],L):-
    removeFromNotDone(C,T,L).
removeFromNotDone(C,[H|T],L):-
    removeFromNotDone(C,T,L2),
	L=[H|L2],H\=C.


schedule(_,DC,_,0,DCN):-length(DC,DCN).
schedule(L,DC,[(Name,NS)|T2],N,DCN):-
    N>0,
	scheduleCourse(L,Name,NS),
	N2 is N-NS,DC2=[(Name,NS)|DC],
	schedule(L,DC2,T2,N2,DCN).
schedule(L,DC,[(_,_)|T2],N,DCN):-
    N>0,
	schedule(L,DC,T2,N,DCN).
	
	
solve(L,DoneSubjN):-
    putSlots(L),
    length(L,N),
    courses(NotDone),
    sort(2,@=<,NotDone,SortedCourses), %A greedy approach to the maximization problem at hand
    schedule(L,[],SortedCourses,N,DoneSubjN).
  



 