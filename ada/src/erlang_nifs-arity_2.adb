package body erlang_nifs.arity_2 is

   package args1 is new get_values(argument_type1); use args1;
   package args2 is new get_values(argument_type2); use args2;
   package rets is new make_values(return_type); use rets;

   function nif_wrapper(env: not null access erl_nif_env_t;
                       argc: C.int with unreferenced;
                       argv: erl_nif_terms_t)
            return erl_nif_term_t is
   begin
      return make_value(env, ada_function(get_value(env, argv(0)), get_value(env, argv(1))));

   exception
      when error: others =>
         return raise_erlang_exception(env, error);

   end nif_wrapper;

begin
   nif_functions.append(nif_info);

end erlang_nifs.arity_2;
