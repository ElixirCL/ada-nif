with ada.characters.handling;

package examples_functions is
   pragma pure;

   function plus_one(x: integer)
            return integer is (x + 1)
      with pre => x < integer'last;

   function uppercase(s: string)
            return string is (ada.characters.handling.to_upper(s));

end examples_functions;
