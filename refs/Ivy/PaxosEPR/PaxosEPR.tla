------------------------------ MODULE PaxosEPR ------------------------------

(*

与lamport的版本相比，是变得容易还是困难了呢？

*)



EXTENDS TLC,Integers,FiniteSets


CONSTANTS Node,Ballot,Value

(*  假设Ballot的最小值为0 *)

ASSUME 0 \in Ballot

CONSTANT Quorum

CONSTANT None

VARIABLES ballotStart,
          prepareMsg,
          proposeMsg,
          voteMsg,
          leftBallot,
          joinedBallot,
          decision
          
          
          
vars == <<ballotStart,prepareMsg,proposeMsg,voteMsg,leftBallot,joinedBallot,decision>>      
          
          
   
Init == /\ ballotStart = [b \in Ballot |-> FALSE]
        /\ prepareMsg = [n \in Node |-> [b \in Ballot |-> None]]
        /\ proposeMsg = [b \in Ballot |-> None]
        /\ voteMsg = [n \in Node |-> [b \in Ballot |-> None]]
        /\ leftBallot = [n \in Node |-> [b \in Ballot |-> FALSE]]
        /\ joinedBallot = [n \in Node |-> [b \in Ballot |-> FALSE]]
        /\ decision = [n \in Node |-> [b \in Ballot |-> {}]]




max(S) == IF S = {} THEN 0
          ELSE CHOOSE x \in S : \A y \in S : x \geq y

Phase1a(b) == /\ ballotStart' = [ballotStart EXCEPT ![b] = TRUE]
              /\ UNCHANGED <<prepareMsg,proposeMsg,voteMsg,leftBallot,joinedBallot,decision>>
              

Phase1b(n,b) == /\ ballotStart[b] = TRUE
                /\ leftBallot[n][b] = FALSE
                /\ LET maxBal == max({t \in Ballot : t < b /\ voteMsg[n][t] # None})
                       maxVal == IF maxBal # 0 THEN voteMsg[n][maxBal]
                                 ELSE None
                   IN
                       prepareMsg = [prepareMsg EXCEPT ![n][b] = <<maxBal,maxVal>>]
                /\  leftBallot = [leftBallot EXCEPT ![n] =
                                        [t \in Ballot |-> IF \/ t < b
                                                             \/ leftBallot[n][t] = TRUE
                                                          THEN TRUE
                                                          ELSE FALSE]]
                /\ joinedBallot' = [joinedBallot EXCEPT ![n][b] = TRUE]
                /\ UNCHANGED <<ballotStart,proposeMsg,voteMsg,decision>> 
     
Phase2a(b,Q) == /\ proposeMsg[b] = None
                /\ \A nn \in Q : joinedBallot[nn][b] = TRUE
                /\ LET maxVotedBallot == [n \in Q |-> max({t \in Ballot : /\ t < b
                                                                                /\ voteMsg[n][t] # None})]
                       maxNode == CHOOSE n \in Q : \A m \in Q : maxVotedBallot[n] >= maxVotedBallot[m]
                       maxBallot == maxVotedBallot[maxNode]
                       maxValue == IF maxBallot # 0 THEN voteMsg[maxNode][maxBallot]
                                   ELSE CHOOSE v \in Value : TRUE
                   IN 
                       proposeMsg' = [proposeMsg EXCEPT ![b] = maxValue]
                /\ UNCHANGED <<ballotStart,prepareMsg,voteMsg,leftBallot,joinedBallot,decision>>   
                                                
Phase2b(n,b) == /\ proposeMsg[b] # None
                /\ leftBallot[n][b] = FALSE
                /\ voteMsg' = [voteMsg EXCEPT ![n][b] = proposeMsg[b]]
                /\ UNCHANGED <<ballotStart,prepareMsg,proposeMsg,leftBallot,joinedBallot,decision>>     
                

Learn(n,b,v,Q) ==  /\ \A t \in Q : voteMsg[t][b] = v
                   /\  decision' = [decision EXCEPT ![n][b] = decision[n][b] \cup {v}]
                   /\ UNCHANGED <<ballotStart,prepareMsg,proposeMsg,voteMsg,leftBallot,joinedBallot>>                            

Next == \/ \E b \in Ballot : Phase1a(b)
        \/ \E n \in Node, b \in Ballot : Phase1b(n,b)
        \/ \E b \in Ballot, Q \in Quorum : Phase2a(b,Q)
        \/ \E n \in Node, b \in Ballot : Phase2b(n,b)
        
        
Spec ==  Init /\ [][Next]_vars

Inv == /\ \A n1,n2 \in Node, b1,b2 \in Ballot, v1,v2 \in Value : v1 \in decision[n1][b1] /\ v2 \in decision[n2][b2] => v1 = v2
       /\ \A b \in Ballot, v1,v2 \in Value : proposeMsg[b] = v1 /\ proposeMsg[b] = v2 => v1 = v2
       /\ \A n \in Node, b \in Ballot, v \in Value : voteMsg[n][b] = v  => proposeMsg[b] = v
       /\ \A b \in Ballot, v \in Value : (\E n \in Node : decision[n][b] = v) => 
                                           (\E Q \in Quorum : \A n \in Node : n \in Q => voteMsg[n][b] = v)
       /\ \A n \in Node, b1,b2 \in Ballot, v1,v2 \in Value : prepareMsg[n][b1] = <<0,v1>> /\ b2 < b1 => \neg (voteMsg[n][b2] = v2)
       /\ \A n \in Node, b1,b2 \in Ballot, v \in Value : proposeMsg[n][b1] = <<b2,v>> /\ b2 # 0 => b2 < b1 /\ voteMsg[n][b2] = v
       /\ \A n \in Node, b1,b2,b3 \in Ballot, v1,v2 \in Value : proposeMsg[n][b1] = <<b2,v1>> /\ b2 # 0 /\ b2 < b3 /\ b3 < b1 =>
                                                    \neg (voteMsg[n][b3] = v2)
       /\ \A n \in Node, v \in Value : \neg (voteMsg[n][0] = v)
       /\ \A b1,b2 \in Ballot, v1,v2 \in Value, Q \in Quorum : proposeMsg[b2] = v2 /\ b1 < b2 /\ v1 # v2  =>
                             \E n \in Node : n \in Q /\ \neg (voteMsg[n][b1] = v1) /\ leftBallot[n][b1] = TRUE
       /\ \A n \in Node, b1,b2 \in Ballot : b1 < b2 /\ joinedBallot[n][b2] = TRUE => leftBallot[n][b1] = TRUE
       /\ \A n \in Node, b1,b2 \in Ballot, v \in Value : proposeMsg[n][b1] = <<b2,v>> => joinedBallot[n][b1] = TRUE
       
       
        


=============================================================================
\* Modification History
\* Last modified Sun May 08 17:19:52 CST 2022 by xiaosong
\* Created Tue Apr 26 19:47:36 CST 2022 by xiaosong
