PROGRAM       := [ TOP ]
TOP           := METHOD
METHOD        := 'def' METHOD_HEAD METHOD_BODY 'end'
METHOD_HEAD   := WORD PARAMS | WORD
METHOD_BODY   := ???
PARAMS        := '(' PARAM [, PARAM] ')'
PARAM         := ':'
