generic
   erlang_name: string;
   with package argument_type1 is new nif_supported_types (<>);
   with package argument_type2 is new nif_supported_types (<>);
   with package return_type is new nif_supported_types (<>);
   with function ada_function(x: in argument_type1.t; y: in argument_type2.t) return return_type.t;
package erlang_nifs.arity_2 is
   pragma elaborate_body;
   pragma Assertion_Policy(Check);

private
   function nif_wrapper(env: not null access erl_nif_env_t;
                       argc: C.int;
                       argv: erl_nif_terms_t)
            return erl_nif_term_t
      with convention => C,
                  pre => argc = 2;

   nif_info : enif_func_t := (name => C.strings.new_string(erlang_name),
                             arity => 2,
                              fptr => nif_wrapper'access,
                             flags => 0);

end erlang_nifs.arity_2;
