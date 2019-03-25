% Base case: there is an EC2 instance using this security group
live_security_group(X, _) :-
  type(X, security_group),
  type(E, ec2_instance),
  link(E, X).
% Recursive case: There is another group Y that uses this group
% and Y is a live security group.
live_security_group(X, Seen) :-
  link(Y, X),
  dif(Y, X),
  \+member(Y, Seen),
  type(Y, security_group),
  live_security_group(Y, [X|Seen]).

% Subnets are live if there are instances in the subnet.
live_subnet(X) :-
  type(X, subnet),
  type(E, ec2_instance),
  link(E, X).

% Network interfaces are live if they are attached to an instance.
live_network_interface(X) :-
  type(X, network_interface),
  type(E, ec2_instance),
  link(E, X).

