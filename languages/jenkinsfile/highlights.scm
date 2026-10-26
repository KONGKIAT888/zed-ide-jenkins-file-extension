; Syntax highlighting for Groovy / Jenkinsfile
; Based on the queries shipped with murtaza64/tree-sitter-groovy, with
; Jenkins Pipeline additions at the bottom. Dotted captures are paired with
; their base capture so Zed's right-to-left fallback always finds a style.

[
  "!instanceof"
  "assert"
  "extends"
  "instanceof"
  "package"
] @keyword

[
  "class"
  "interface"
] @keyword @keyword.type

[
  "!in"
  "as"
  "in"
  "new"
] @keyword @keyword.operator

[
  "case"
  "default"
  "else"
  "if"
  "switch"
] @keyword @keyword.conditional

[
  "catch"
  "finally"
  "try"
] @keyword @keyword.exception

"def" @keyword @keyword.function

"import" @keyword @keyword.import

[
  "do"
  "for"
  "while"
  (break)
  (continue)
] @keyword @keyword.repeat

"return" @keyword @keyword.return

[
  "true"
  "false"
] @boolean

(null) @constant.builtin

"this" @variable @variable.builtin

[
  "int"
  "char"
  "short"
  "long"
  "boolean"
  "float"
  "double"
  "void"
] @type.builtin

[
  "final"
  "private"
  "protected"
  "public"
  "static"
  "synchronized"
] @keyword @keyword.modifier

(comment) @comment

(shebang) @keyword @keyword.directive

(string) @string

(string
  (escape_sequence) @string.escape)

(string
  (interpolation
    "$" @punctuation.special))

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ":"
  ","
  "."
  ";"
] @punctuation.delimiter

(number_literal) @number

(identifier) @variable

(declaration
  "_" @variable)

(access_op
  [
    "?."
    "*."
    ".@"
  ]
  (identifier) @variable @variable.member .)

((identifier) @constant
  (#match? @constant "^[A-Z][A-Z_0-9]+$"))

[
  "%"
  "*"
  "**"
  "/"
  "+"
  "-"
  "->"
  "<<"
  ">>"
  ">>>"
  ".."
  "..<"
  "<..<"
  "<.."
  "<"
  "<="
  ">"
  ">="
  "=="
  "!="
  "<=>"
  "==="
  "!=="
  "=~"
  "==~"
  "&"
  "^"
  "|"
  "&&"
  "||"
  "?:"
  ".&"
  ".@"
  "?."
  "*."
  "*:"
  "++"
  "--"
  "!"
  "~"
] @operator

(wildcard_import) @character.special @string.special

(string
  "/" @string)

(ternary_op
  ([
    "?"
    ":"
  ]) @keyword @keyword.conditional.ternary)

(map
  (map_item
    key: (identifier) @variable.parameter))

(parameter
  type: (identifier) @type)

(parameter
  name: (identifier) @variable.parameter)

(generic_param
  name: (identifier) @type)

(declaration
  type: (identifier) @type)

(function_definition
  type: (identifier) @type)

(function_declaration
  type: (identifier) @type)

(class_definition
  name: (identifier) @type)

(class_definition
  superclass: (identifier) @type)

(generic_param
  superclass: (identifier) @type)

(array_type
  (identifier) @type)

(array_type
  "[]" @punctuation.bracket)

(type_with_generics
  (identifier) @type)

(type_with_generics
  (generics
    (identifier) @type))

(generics
  [
    "<"
    ">"
  ] @punctuation.bracket)

(generic_parameters
  [
    "<"
    ">"
  ] @punctuation.bracket)

(parameter
  "=" @operator)

(declaration
  "=" @operator)

(assignment
  [
    "="
    "**="
    "*="
    "/="
    "%="
    "+="
    "-="
    "<<="
    ">>="
    ">>>="
    "&="
    "^="
    "|="
    "?="
  ] @operator)

(access_op
  ".&"
  (identifier) @function .)

(function_call
  function: (identifier) @function)

(function_call
  function: (dotted_identifier
    (identifier) @function .))

(function_call
  (argument_list
    (map_item
      key: (identifier) @variable.parameter)))

(juxt_function_call
  function: (identifier) @function)

(juxt_function_call
  function: (dotted_identifier
    (identifier) @function .))

(juxt_function_call
  (argument_list
    (map_item
      key: (identifier) @variable.parameter)))

(function_definition
  function: (identifier) @function)

(function_declaration
  function: (identifier) @function)

(annotation) @function @function.macro

(annotation
  (identifier) @function @function.macro)

"@interface" @function @function.macro

"pipeline" @keyword

(groovy_doc) @comment @comment.doc

(groovy_doc
  [
    (groovy_doc_param)
    (groovy_doc_throws)
    (groovy_doc_tag)
  ] @string.special)

(groovy_doc
  (groovy_doc_param
    (identifier) @variable.parameter))

(groovy_doc
  (groovy_doc_throws
    (identifier) @type))

; =====================================================================
; Jenkins Pipeline additions
; =====================================================================

; Special pipeline variables (env.BUILD_NUMBER, params.FOO, ...)
((identifier) @variable @variable.special
  (#match? @variable.special "^(env|params|currentBuild|scm|docker)$"))

; Declarative Pipeline section keywords and post conditions
((identifier) @keyword
  (#match? @keyword "^(agent|stages|stage|steps|environment|options|parameters|triggers|tools|libraries|when|input|post|parallel|matrix|label|always|success|failure|unstable|aborted|cleanup|changed)$"))
