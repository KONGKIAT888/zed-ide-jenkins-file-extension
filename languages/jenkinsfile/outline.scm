; Pipeline stages: stage('Name') { ... }
(function_call
  function: (identifier) @_stage
  (#eq? @_stage "stage")
  args: (argument_list
    (string) @name)) @item

; stage 'Name' { ... } (juxtaposition form)
(juxt_function_call
  function: (identifier) @_stage
  (#eq? @_stage "stage")
  args: (argument_list
    (string) @name)) @item

; Groovy functions (Jenkins shared libraries)
(function_definition
  function: (identifier) @name) @item

(function_declaration
  function: (identifier) @name) @item

; Groovy classes
(class_definition
  name: (identifier) @name) @item
