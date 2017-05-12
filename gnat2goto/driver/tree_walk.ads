with Atree;             use Atree;
with Sinfo;             use Sinfo;
with Types;             use Types;
with Symbol_Table_Info; use Symbol_Table_Info;
with Ada.Containers.Ordered_Maps;

with Ireps;                 use Ireps;

package Tree_Walk is

   Global_Symbol_Table : Symbol_Table;
   Anonymous_Type_Counter : Positive := 1;

   --  This maps syntax tree node-ids onto CBMC symbol Ireps
   --  Presently:
   --    an N_Variant_Part maps onto a union type with
   --      members for each variant
   --    an N_Variant maps onto a structure type for a particular
   --      variant.
   --  The values are all I_Symbol_Type.
   package Anonymous_Type_Maps
   is new Ada.Containers.Ordered_Maps
     (Element_Type => Irep,
      Key_Type => Node_Id);

   Anonymous_Type_Map : Anonymous_Type_Maps.Map;

   --  This maps pairs of <element_type, index_type>, each represented
   --  by their definining entity ids, onto function symbols implementing
   --  array duplication. Keys are symbol expressions.

   type Array_Dup_Key is record
      Element_Type : Entity_Id;
      Index_Type : Entity_Id;
   end record;

   function "<" (Left, Right : Array_Dup_Key) return Boolean;

   package Array_Dup_Maps
   is new Ada.Containers.Ordered_Maps
     (Element_Type => Irep,
      Key_Type => Array_Dup_Key);

   Array_Dup_Map : Array_Dup_Maps.Map;

   --  Similar, but for memcpy-style instead of dup-style functions:
   type Array_Copy_Key is record
      LHS_Element_Type : Entity_Id;
      RHS_Element_Type : Entity_Id;
      Index_Type : Entity_Id;
   end record;

   function "<" (Left, Right : Array_Copy_Key) return Boolean;

   package Array_Copy_Maps
   is new Ada.Containers.Ordered_Maps
     (Element_Type => Irep,
      Key_Type => Array_Copy_Key);

   Array_Copy_Map : Array_Copy_Maps.Map;

   Check_Function_Symbol : Irep := Ireps.Empty;

   function Do_Compilation_Unit (N : Node_Id) return Symbol
   with Pre => Nkind (N) = N_Compilation_Unit;

end Tree_Walk;
