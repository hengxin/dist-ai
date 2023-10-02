----------------------------- MODULE LockServer -----------------------------
\*the set of all servers and the set of all clients
CONSTANT SERVER,CLIENT 
 \* semaphore is a semaphore sequence of s.
 \* link is a link sequence of server s with client c. 
VARIABLES semaphore,link

TypeOK == 
    /\ semaphore \subseteq [server:SERVER]
    /\ link \subseteq [server:SERVER,client:CLIENT]
  
Init == 
    /\ semaphore = [server:SERVER]
    /\ link = {}
    
canConnect(s,c) == 
    /\ [server|->s] \in semaphore
    /\ [server|->s,client|->c] \notin link
    
canDisConnect(s,c) == 
    /\ [server|->s,client|->c] \in link
    /\ [server|->s] \notin semaphore
    
Connect(s,c) ==   
    /\ canConnect(s,c)
    /\ link' = link \cup {[server|->s,client|->c]}
    /\ semaphore' = semaphore \ {[server|->s]}
       
DisConnect(s,c) == 
    /\ canDisConnect(s,c)
    /\ link' = link \ {[server|->s,client|->c]}
    /\ semaphore' = semaphore \cup {[server|->s]}
    
Next == \E s \in SERVER, c \in CLIENT: Connect(s,c) \/ DisConnect(s,c)

Consistent ==  
  \A s \in SERVER,c1,c2 \in CLIENT : \/ /\ [server|->s,client|->c1] \in link
                                        /\ [server|->s,client|->c2] \in link
                                        /\ c1 = c2
                                     \/ /\ [server|->s,client|->c1] \in link
                                        /\ [server|->s,client|->c2] \notin link
                                     \/ /\ [server|->s,client|->c1] \notin link
                                        /\ [server|->s,client|->c2] \in link
                                     \/ /\ [server|->s,client|->c1] \notin link
                                        /\ [server|->s,client|->c2] \notin link      
=============================================================================
\* Modification History
\* Last modified Fri Apr 29 13:23:10 CST 2022 by fruitfighter
\* Created Thu Apr 21 15:49:29 CST 2022 by fruitfighter
