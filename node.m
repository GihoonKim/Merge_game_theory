function node_ = node(a,b,p)

node_.child = a;
node_.parents = b;
node_.prob = p;  %   P(pi_v_t-1 | pi_c_t-2)
end