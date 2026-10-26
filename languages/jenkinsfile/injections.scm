; Inject bash highlighting into the strings passed to `sh` steps.

((juxt_function_call
  function: (identifier) @_step
  args: (argument_list
    (string) @injection.content)
  (#eq? @_step "sh")
  (#set! injection.language "bash")))

((function_call
  function: (identifier) @_step
  args: (argument_list
    (string) @injection.content)
  (#eq? @_step "sh")
  (#set! injection.language "bash")))
